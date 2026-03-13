**Navigation:** [AppKit](/documentation/AppKit)

**Class**

# NSVisualEffectView

**Available on:** macOS 10.10+

> A view that adds translucency and vibrancy effects to the views in your interface.

```swift
class NSVisualEffectView
```

## Overview

Use visual effect views primarily as background views for your app’s content. A visual effect view makes your foreground content more prominent by employing the following effects:

- **Translucency** and the blurring of background content adds depth to your interface.
- **Vibrancy** is a subtle blending of foreground and background colors to increase the contrast and make the foreground content stand out visually.

The material and blending mode you assign determines the exact appearance of the visual effect. Not all materials support transparency, and materials apply vibrancy in different ways. The appearance and behavior of materials can also change based on system settings, so always pick a material based on its intended use. For example, use the [sidebar](/documentation/appkit/nsvisualeffectview/material-swift.enum/sidebar) material when your view serves as the background of your window’s sidebar.  Don’t select materials based on the apparent colors they impart on your interface.

AppKit creates visual effect views automatically for window titlebars, popovers, and source list table views. You don’t need to add visual effect views to those elements of your interface.

### Choosing a Translucency Effect for Your View

For visual effect views you create yourself, use the [blending Mode-swift.property](/documentation/appkit/nsvisualeffectview/blendingmode-swift.property) property to specify how and where you want the translucency applied.

- **Behind-window blending** uses the content behind the window as the background for your visual effect view. Behind-window blending makes your entire window stand out above other windows and apps on the desktop. Sheets and popovers use behind-window blending.
- **In-window blending** uses the window’s content as the background for your visual effect view. Typically, you use in-window blending with scrolling content, so that the scrolled content remains partially visible under other parts of your window chrome. Toolbars always use in-window blending.

![An illustration of a window whose title bar and side bar use visual effect views with different blending options. The title bar uses in-window blending which blends content from the window with the bar. The side bar uses behind-window blending, which allows part of the desktop to show through. ](https://docs-assets.developer.apple.com/published/153ccb58867a13d8d8a600691c57adf7/media-3198506%402x.png)

### Enabling Vibrancy for Foreground Content

The presence of a visual effect view in your view hierarchy does not automatically add vibrancy to your content. For custom views, you must explicitly enable vibrancy by overriding the [allows Vibrancy](/documentation/appkit/nsview/allowsvibrancy) property and returning [true](/documentation/Swift/true).

> [!NOTE]
> AppKit views and controls automatically add vibrancy where appropriate. For example, [NSText Field](/documentation/appkit/nstextfield) enables vibrancy to increase the contrast between the text and background. Don’t change the vibrancy settings of standard AppKit views and controls.

It is recommended that you enable vibrancy only in the leaf views of your view hierarchy. Subviews inherit the vibrancy of their parent. Once enabled in a parent view, a subview cannot turn off vibrancy. As a result, enabling vibrancy in a parent view can lead to subviews that look incorrect if they are not designed to take advantage of the vibrancy effect.

Vibrancy works best when your custom views contain grayscale content. Combining a grayscale foreground with a color background works well, because AppKit improves the contrast while only subtly changing the foreground hue. The same isn’t always true when blending two different color values. Dramatically different foreground and background hues can cancel each other out or result in colors that don’t match your original designs.

Instead of defining custom grayscale color assets, consider using the built-in colors [label Color](/documentation/appkit/nscolor/labelcolor), [secondary Label Color](/documentation/appkit/nscolor/secondarylabelcolor), [tertiary Label Color](/documentation/appkit/nscolor/tertiarylabelcolor), and [quaternary Label Color](/documentation/appkit/nscolor/quaternarylabelcolor). While typically used with text, these colors are applicable with any app content. The built-in colors represent varying levels of contrast for your content, with [label Color](/documentation/appkit/nscolor/labelcolor) offering the most contrast, and [quaternary Label Color](/documentation/appkit/nscolor/quaternarylabelcolor) offering the least contrast.

### Subclassing Notes

If you subclass `NSVisualEffectView`:

- Always call `super` if you override [viewDidMoveToWindow()](/documentation/appkit/nsview/viewdidmovetowindow()) or [viewWillMove(toWindow:)](/documentation/appkit/nsview/viewwillmove(towindow:)).
- Do not override [draw(_:)](/documentation/appkit/nsview/draw(_:)) or [updateLayer()](/documentation/appkit/nsview/updatelayer()).

## Inherits From

- [NSView](/documentation/appkit/nsview)

## Conforms To

- [CVarArg](/documentation/Swift/CVarArg)
- [CustomDebugStringConvertible](/documentation/Swift/CustomDebugStringConvertible)
- [CustomStringConvertible](/documentation/Swift/CustomStringConvertible)
- [Equatable](/documentation/Swift/Equatable)
- [Hashable](/documentation/Swift/Hashable)
- [NSAccessibilityElementProtocol](/documentation/appkit/nsaccessibilityelementprotocol)
- [NSAccessibilityProtocol](/documentation/appkit/nsaccessibilityprotocol)
- [NSAnimatablePropertyContainer](/documentation/appkit/nsanimatablepropertycontainer)
- [NSAppearanceCustomization](/documentation/appkit/nsappearancecustomization)
- [NSCoding](/documentation/Foundation/NSCoding)
- [NSDraggingDestination](/documentation/appkit/nsdraggingdestination)
- [NSObjectProtocol](/documentation/ObjectiveC/NSObjectProtocol)
- [NSStandardKeyBindingResponding](/documentation/appkit/nsstandardkeybindingresponding)
- [NSTouchBarProvider](/documentation/appkit/nstouchbarprovider)
- [NSUserActivityRestoring](/documentation/appkit/nsuseractivityrestoring)
- [NSUserInterfaceItemIdentification](/documentation/appkit/nsuserinterfaceitemidentification)
- [Sendable](/documentation/Swift/Sendable)
- [SendableMetatype](/documentation/Swift/SendableMetatype)

## Specifying the Background Material

- [material](/documentation/appkit/nsvisualeffectview/material-swift.property) The material shown by the visual effect view.
- [NSVisualEffectView.Material](/documentation/appkit/nsvisualeffectview/material-swift.enum) Constants to specify the material shown by the visual effect view.

## Specifying the Effect Appearance

- [blendingMode](/documentation/appkit/nsvisualeffectview/blendingmode-swift.property) A value indicating how the view’s contents blend with the surrounding content.
- [NSVisualEffectView.BlendingMode](/documentation/appkit/nsvisualeffectview/blendingmode-swift.enum) Constants that specify whether the visual effect view blends with what’s either behind or within the window.
- [isEmphasized](/documentation/appkit/nsvisualeffectview/isemphasized) A Boolean value indicating whether to emphasize the look of the material.
- [interiorBackgroundStyle](/documentation/appkit/nsvisualeffectview/interiorbackgroundstyle) The view’s interior background style.

## Masking the Visual Effect

- [maskImage](/documentation/appkit/nsvisualeffectview/maskimage) An image whose alpha channel masks the visual effect view’s material.

## Enabling or Disabling the Effect

- [state](/documentation/appkit/nsvisualeffectview/state-swift.property) A value that indicates whether a view has a visual effect applied.
- [NSVisualEffectView.State](/documentation/appkit/nsvisualeffectview/state-swift.enum) Constants to specify how the material appearance should reflect window activity state.

## Handling Moves to a Different Window

- [viewDidMoveToWindow()](/documentation/appkit/nsvisualeffectview/viewdidmovetowindow()) Notifies the view that it moved to a new window.
- [viewWillMove(toWindow:)](/documentation/appkit/nsvisualeffectview/viewwillmove(towindow:)) Notifies the view immediately before it moves to a new window (which may be ).

## Visual adornments

- [NSBox](/documentation/appkit/nsbox)

---

*Extracted by [sosumi.ai](https://sosumi.ai) - Making Apple docs AI-readable.*
*This is unofficial content. All documentation belongs to Apple Inc.*
