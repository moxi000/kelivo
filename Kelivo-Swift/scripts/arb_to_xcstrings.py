#!/usr/bin/env python3
"""
Convert Flutter ARB localization files to Xcode String Catalog (.xcstrings) format.

Reads ARB files for en, zh-Hans, and zh-Hant and produces a single
Localizable.xcstrings JSON file suitable for use in an Xcode project.

Placeholder mapping:
  - ARB {name} with type "int"    -> %lld
  - ARB {name} with type "double" -> %lf
  - ARB {name} (String or other)  -> %@

Plural forms (ICU MessageFormat) are converted to Xcode .stringsdict-style
variations embedded in the xcstrings JSON.
"""

import json
import os
import re
import sys
from collections import OrderedDict
from pathlib import Path


# ---------------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------------

REPO_ROOT = Path(__file__).resolve().parent.parent.parent  # kelivo/
ARB_DIR = REPO_ROOT / "lib" / "l10n"

ARB_FILES = {
    "en": ARB_DIR / "app_en.arb",
    "zh-Hans": ARB_DIR / "app_zh_Hans.arb",
    "zh-Hant": ARB_DIR / "app_zh_Hant.arb",
}

OUTPUT_PATH = (
    REPO_ROOT
    / "Kelivo-Swift"
    / "Kelivo"
    / "Localization"
    / "Localizable.xcstrings"
)


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

def load_arb(path: Path) -> dict:
    """Load an ARB file and return the parsed JSON dict."""
    with open(path, "r", encoding="utf-8") as f:
        return json.load(f)


def get_placeholder_type(meta: dict, placeholder_name: str) -> str:
    """Return the ARB-declared type for a placeholder, defaulting to String."""
    placeholders = meta.get("placeholders", {})
    info = placeholders.get(placeholder_name, {})
    return info.get("type", "String")


def arb_type_to_format_specifier(arb_type: str) -> str:
    """Map an ARB placeholder type to a printf-style format specifier."""
    t = arb_type.lower()
    if t == "int":
        return "%lld"
    elif t in ("double", "num", "float"):
        return "%lf"
    else:
        return "%@"


def is_plural_message(value: str) -> bool:
    """Check if an ARB value contains ICU plural syntax."""
    return bool(re.search(r'\{[^}]+,\s*plural\s*,', value))


def parse_plural_message(value: str) -> dict | None:
    """
    Parse an ICU MessageFormat plural string into a dict of form:
    {
        "param": "count",
        "cases": {
            "one": "...",
            "other": "...",
            ...
        }
    }
    Returns None if not a plural message.
    """
    m = re.match(r'^\{(\w+),\s*plural\s*,\s*(.+)\}$', value.strip(), re.DOTALL)
    if not m:
        return None

    param = m.group(1)
    body = m.group(2).strip()

    cases = {}
    # Match patterns like: =0{...} one{...} other{...}
    pattern = re.compile(r'(=\d+|\w+)\s*\{([^}]*)\}')
    for case_match in pattern.finditer(body):
        case_key = case_match.group(1)
        case_value = case_match.group(2)
        # Normalize =0, =1, =2 to zero, one, two
        if case_key == "=0":
            case_key = "zero"
        elif case_key == "=1":
            case_key = "one"
        elif case_key == "=2":
            case_key = "two"
        cases[case_key] = case_value

    if not cases:
        return None

    return {"param": param, "cases": cases}


def convert_placeholders(value: str, meta: dict | None) -> str:
    """
    Replace ARB {placeholder} tokens with printf-style specifiers.

    When there are multiple placeholders, they are numbered using
    positional specifiers (%1$@, %2$lld, etc.) to preserve ordering
    across translations.
    """
    placeholder_pattern = re.compile(r'\{(\w+)\}')
    placeholders_found = placeholder_pattern.findall(value)

    if not placeholders_found:
        return value

    # Deduplicate while preserving order
    seen = set()
    unique_placeholders = []
    for p in placeholders_found:
        if p not in seen:
            seen.add(p)
            unique_placeholders.append(p)

    if len(unique_placeholders) == 1:
        # Single placeholder: use simple specifier
        name = unique_placeholders[0]
        if meta:
            arb_type = get_placeholder_type(meta, name)
            spec = arb_type_to_format_specifier(arb_type)
        else:
            spec = "%@"
        return value.replace("{" + name + "}", spec)
    else:
        # Multiple placeholders: use positional specifiers
        result = value
        for idx, name in enumerate(unique_placeholders, start=1):
            if meta:
                arb_type = get_placeholder_type(meta, name)
                spec_base = arb_type_to_format_specifier(arb_type)
            else:
                spec_base = "%@"

            # Convert %@ -> %1$@, %lld -> %1$lld, %lf -> %1$lf
            if spec_base == "%@":
                positional = f"%{idx}$@"
            elif spec_base == "%lld":
                positional = f"%{idx}$lld"
            elif spec_base == "%lf":
                positional = f"%{idx}$lf"
            else:
                positional = f"%{idx}$@"

            result = result.replace("{" + name + "}", positional)
        return result


def build_plural_localization(plural_info: dict, meta: dict | None, lang: str) -> dict:
    """Build an xcstrings 'variations' entry for a plural key."""
    param = plural_info["param"]
    cases = plural_info["cases"]

    plural_obj = {}
    for case_key, case_value in cases.items():
        converted = convert_placeholders(case_value, meta)
        plural_obj[case_key] = {
            "stringUnit": {
                "state": "translated",
                "value": converted,
            }
        }

    return {
        "variations": {
            "plural": plural_obj
        }
    }


# ---------------------------------------------------------------------------
# Main conversion
# ---------------------------------------------------------------------------

def convert_arb_to_xcstrings() -> dict:
    """Read all ARB files and produce the xcstrings JSON structure."""
    arb_data = {}
    for lang, path in ARB_FILES.items():
        if not path.exists():
            print(f"WARNING: ARB file not found: {path}", file=sys.stderr)
            continue
        arb_data[lang] = load_arb(path)

    if "en" not in arb_data:
        print("ERROR: English ARB file is required.", file=sys.stderr)
        sys.exit(1)

    en_arb = arb_data["en"]

    # Collect all translation keys (skip metadata keys starting with @)
    all_keys = [k for k in en_arb.keys() if not k.startswith("@")]

    strings = OrderedDict()

    for key in sorted(all_keys):
        localizations = {}

        for lang, arb in arb_data.items():
            value = arb.get(key)
            if value is None:
                continue

            # Get metadata from the same ARB (key prefixed with @)
            meta_key = f"@{key}"
            meta = arb.get(meta_key) or en_arb.get(meta_key)

            # Check for plural
            if is_plural_message(value):
                plural_info = parse_plural_message(value)
                if plural_info:
                    localizations[lang] = build_plural_localization(
                        plural_info, meta, lang
                    )
                    continue

            # Normal string with potential placeholders
            converted_value = convert_placeholders(value, meta)

            localizations[lang] = {
                "stringUnit": {
                    "state": "translated",
                    "value": converted_value,
                }
            }

        if localizations:
            strings[key] = {
                "extractionState": "manual",
                "localizations": localizations,
            }

    xcstrings = {
        "sourceLanguage": "en",
        "version": "1.0",
        "strings": strings,
    }

    return xcstrings


def main():
    print(f"Reading ARB files from: {ARB_DIR}")
    for lang, path in ARB_FILES.items():
        print(f"  {lang}: {path}")

    xcstrings = convert_arb_to_xcstrings()

    key_count = len(xcstrings["strings"])
    print(f"\nConverted {key_count} localization keys.")

    OUTPUT_PATH.parent.mkdir(parents=True, exist_ok=True)
    with open(OUTPUT_PATH, "w", encoding="utf-8") as f:
        json.dump(xcstrings, f, ensure_ascii=False, indent=2)

    print(f"Written to: {OUTPUT_PATH}")

    # Summary of languages
    lang_counts = {}
    for key, entry in xcstrings["strings"].items():
        for lang in entry.get("localizations", {}):
            lang_counts[lang] = lang_counts.get(lang, 0) + 1

    print("\nLanguage coverage:")
    for lang, count in sorted(lang_counts.items()):
        print(f"  {lang}: {count} keys")


if __name__ == "__main__":
    main()
