# iOS / macOS 26 Liquid Glass 完整文档归档

生成时间：2026-03-11
来源：sosumi.ai（developer.apple.com 镜像）

---



## 来源：docs/fetched/sosumi-core/liquid-glass.md


```md
---
title: Liquid Glass
description: Learn how to design and develop beautiful interfaces that leverage Liquid Glass.
source: https://developer.apple.com/documentation/technologyoverviews/liquid-glass
timestamp: 2026-03-11T11:51:34.570Z
---

**Navigation:** [Technologyoverviews](/documentation/technologyoverviews)

# Liquid Glass

> Learn how to design and develop beautiful interfaces that leverage Liquid Glass.

## Introduction to Liquid Glass

Interfaces across Apple platforms feature a new dynamic material called Liquid Glass, which combines the optical properties of glass with a sense of fluidity. Learn how to adopt this material and embrace the design principles of Apple platforms to create beautiful interfaces that establish hierarchy, create harmony, and maintain consistency across devices and platforms.

![An image of a Mac, iPad, and iPhone showing different screens in the Maps app.](https://docs-assets.developer.apple.com/published/be4f24f3e7f6aa6b3f923f10ebef3525/landing-page-intoducing-liquid-glass-hero%402x.png)

Standard components from SwiftUI, UIKit, and AppKit like controls and navigation elements pick up the appearance and behavior of this material automatically. You can also implement these effects in custom interface elements.

## Adopting Liquid Glass

If you have an existing app, adopting Liquid Glass doesn’t mean reinventing your app from the ground up. Start by building your app in the latest version of Xcode to see the changes. Then, follow best practices in your interface to help your app look right at home on Apple platforms.

## Sample code

The Landmarks app showcases how to create a beautiful and engaging user experience using SwiftUI and Liquid Glass. Explore how the Landmarks app implements the look and feel of the Liquid Glass material throughout its interface.

![A screenshot of the Landmarks app running on an iPad. The app is showing the Mount Fuji landmark with the sidebar on the leading side.](https://docs-assets.developer.apple.com/published/86bea3b2d851de88291e52e7845ef990/landing-page-sample-code-hero%402x.png)

- Configure an app icon with Icon Composer.
- Create an edge-to-edge content experience with the background extension effect.
- Enhance the edge-to-edge content experience by extending horizontal scroll views under a sidebar or inspector.
- Make your interface adaptable to changing window sizes.
- Explore search conventions across platforms.
- Apply Liquid Glass effects to custom interface elements and animations.

To learn more, see [Landmarks-Building-an-app-with-Liquid](/documentation/SwiftUI/Landmarks-Building-an-app-with-Liquid-Glass).

## Design principles

The Human Interface Guidelines contains guidance and best practices that can help you design a great experience for any Apple platform. Browse the HIG to discover more about adapting your interface for Liquid Glass.

- Define a layout and choose a navigation structure that puts the most important content in focus.
- Reimagine your app icon with simple, bold layers that offer dimensionality and consistency across devices and appearances.
- Be judicious with your use of color in controls and navigation so they stay legible and allow your content to infuse them and shine through.
- Ensure interface elements fit in with software and hardware design across devices.
- Adopt standard iconography and predictable action placement across platforms.

To learn more, read the [human-interface](/design/human-interface-guidelines).

## Videos

## Essentials

- [Adopting Liquid Glass](/documentation/technologyoverviews/adopting-liquid-glass) Find out how to bring the new material to your app.

---

*Extracted by [sosumi.ai](https://sosumi.ai) - Making Apple docs AI-readable.*
*This is unofficial content. All documentation belongs to Apple Inc.*
```


## 来源：docs/fetched/sosumi-core/adopting-liquid-glass.md


```md
---
title: Adopting Liquid Glass
description: Find out how to bring the new material to your app.
source: https://developer.apple.com/documentation/technologyoverviews/adopting-liquid-glass
timestamp: 2026-03-11T11:51:34.586Z
---

**Navigation:** [Technologyoverviews](/documentation/technologyoverviews)

# Adopting Liquid Glass

> Find out how to bring the new material to your app.

## Overview

If you have an existing app, adopting Liquid Glass doesn’t mean reinventing your app from the ground up. Start by building your app in the latest version of Xcode to see the changes. As you review your app, use the following sections to understand the scope of changes and learn how you can adopt these best practices in your interface.

![An image of a Mac, iPad, and iPhone showing the Mount Fuji landmark in the Landmarks app.](https://docs-assets.developer.apple.com/published/ce193ec494e91d4150c3356442824213/adoption-guide-intoducing-liquid-glass-hero%402x.png)

#### See your app with Liquid Glass

If your app uses standard components from SwiftUI, UIKit, or AppKit, your interface picks up the latest look and feel on the latest platform releases for iOS, iPadOS, macOS, tvOS, and watchOS. In Xcode, build your app with the latest SDKs, and run it on the latest platform releases to see the changes in your interface.

## Visual refresh

Interfaces across Apple platforms feature a new dynamic [materials](/design/Human-Interface-Guidelines/materials) called Liquid Glass, which combines the optical properties of glass with a sense of fluidity. This material forms a distinct functional layer for controls and navigation elements. It affects how the interface looks, feels, and moves, adapting in response to a variety of factors to help bring focus to the underlying content.

**Leverage system frameworks to adopt Liquid Glass automatically.** In system frameworks, standard components like bars, sheets, popovers, and controls automatically adopt this material. System frameworks also dynamically adapt these components in response to factors like element overlap and focus state. Take advantage of this material with minimal code by using standard components from SwiftUI, UIKit, and AppKit.

**Reduce your use of custom backgrounds in controls and navigation elements.** Any custom backgrounds and appearances you use in these elements might overlay or interfere with Liquid Glass or other effects that the system provides, such as the scroll edge effect. Make sure to check any custom backgrounds in elements like split views, tab bars, and toolbars. Prefer to remove custom effects and let the system determine the background appearance, especially for the following elements:

**Test your interface with a variety of display and accessibility settings.** Translucency and fluid morphing animations contribute to the look and feel of Liquid Glass, but can adapt to people’s needs. For example, people can choose a preferred look for Liquid Glass in their device’s settings, or turn on accessibility settings that reduce transparency or motion in the interface. These settings can remove or modify certain effects. If you use standard components from system frameworks, this experience adapts automatically. Ensure you test your app’s custom elements, colors, and animations with different configurations of these settings.

**Avoid overusing Liquid Glass effects.** If you apply Liquid Glass effects to a custom control, do so sparingly. Liquid Glass seeks to bring attention to the underlying content, and overusing this material in multiple custom controls can provide a subpar user experience by distracting from that content. Limit these effects to the most important functional elements in your app. To learn more, read [Applying-Liquid-Glass-to-custom](/documentation/SwiftUI/Applying-Liquid-Glass-to-custom-views).

## App icons

[app](/design/Human-Interface-Guidelines/app-icons) take on a design that’s dynamic and expressive. Updates to the icon grid result in a standardized iconography that’s visually consistent across devices and concentric with hardware and other elements across the system. App icons now contain layers, which dynamically respond to lighting and other visual effects the system provides. iOS, iPadOS, and macOS all now offer default (light), dark, clear, and tinted appearance variants, empowering people to personalize the look and feel of their Home Screen.

![A grid showing the Podcasts app icon in the six style variants: default, dark, clear (light), clear (dark), tinted (light), and tinted (dark).](https://docs-assets.developer.apple.com/published/4044e9125b89cc2a80d416b80ec5f087/adoption-guide-app-icons-render-modes%402x.png)

**Reimagine your app icon for Liquid Glass.** Apply key design principles to help your app icon shine:

- Provide a visually consistent, optically balanced design across the platforms your app supports.
- Consider a simplified design comprised of solid, filled, overlapping semi-transparent shapes.
- Let the system handle applying masking, blurring, and other visual effects, rather than factoring them into your design.

**Design using layers.** The system automatically applies effects like reflection, refraction, shadow, blur, and highlights to your icon layers. Determine which elements of your design make sense as foreground, middle, and background elements, then define separate layers for them. You can perform this task in the design app of your choice.

**Compose and preview in Icon Composer.** Drag and drop app icon layers that you export from your design app directly into the Icon Composer app. Icon Composer lets you add a background, create layer groupings, adjust layer attributes like opacity, and preview your design with system effects and appearances. Icon Composer is available in the latest version of Xcode and for download from [](https://developer.apple.com/design/resources/). To learn more, read [creating-your-app-icon-using-icon](/documentation/Xcode/creating-your-app-icon-using-icon-composer).

![A screenshot of the Icon Composer app showing the Podcasts app icon in the default style.](https://docs-assets.developer.apple.com/published/2ee579d88374d7784e3de4698c3d542e/adoption-guide-icon-composer-overview%402x.png)

**Preview against the updated grids.** The system applies masking to produce your final icon shape — rounded rectangle for iOS, iPadOS, and macOS, and circular for watchOS. Keep elements centered to avoid clipping. Irregularly shaped icons receive a system-provided background. See how your app icon looks with the updated grids to determine whether you need to make adjustments. Download these grids from [](https://developer.apple.com/design/resources/).

## Controls

Controls have a refreshed look across platforms, and come to life when a person interacts with them. For controls like sliders and toggles, the knob transforms into Liquid Glass during interaction, and [buttons](/design/Human-Interface-Guidelines/buttons) fluidly morph into menus and popovers. The shape of the hardware informs the curvature of controls, so many controls adopt rounder forms to elegantly nestle into the corners of windows and displays. Controls also feature an option for an extra-large size, allowing more space for labels and accents.

**Review updates to control appearance and dimensions.** If you use standard controls from system frameworks and don’t hard-code their layout metrics, your app adopts changes to shapes and sizes automatically when you rebuild your app with the latest version of Xcode. Review changes to the following controls and any others and make sure they continue to look at home with the rest of your interface:

**Review your use of color in controls.** Be judicious with your use of [color](/design/Human-Interface-Guidelines/color) in controls and navigation so they stay legible. If you do apply color to these elements, leverage system colors, or define a custom color with light and dark variants, and an increased contrast option for each variant.

**Check for crowding or overlapping of controls.** Prefer to use standard spacing metrics instead of overriding them, and avoid overcrowding or layering Liquid Glass elements on top of each other.

**Optimize for legibility when content scrolls beneath controls.** Scroll views offer a [scrollEdgeEffectStyle(_:for:)](/documentation/SwiftUI/View/scrollEdgeEffectStyle(_:for:)) that helps maintain sufficient legibility and contrast for controls by obscuring content that scrolls beneath them. System bars like toolbars adopt this behavior by default. If you use a custom bar with elements like controls, text, or icons that have content scrolling beneath them, you can register those views to use a scroll edge effect with these APIs:

**Consider aligning the shape of controls with other rounded elements throughout the interface.** Across Apple platforms, the shape of the hardware informs the curvature, size, and shape of nested interface elements, including controls, sheets, popovers, windows, and more. Help maintain a sense of visual continuity in your interface by using rounded shapes that are concentric to their containers using these APIs:

**Leverage new button styles**. Instead of creating buttons with custom Liquid Glass effects, you can adopt the look and feel of the material with minimal code by using one of the following button style APIs:

## Navigation

Liquid Glass applies to the topmost layer of the interface, where you define your navigation. Key navigation elements like [tab](/design/Human-Interface-Guidelines/tab-bars) and [sidebars](/design/Human-Interface-Guidelines/sidebars) float in this Liquid Glass layer to help people focus on the underlying content.

**Establish a clear navigation hierarchy.** It’s more important than ever for your app to have a clear and consistent navigation structure that’s distinct from the content you provide. Ensure that you clearly separate your content from navigation elements, like tab bars and sidebars, to establish a distinct functional layer above the content layer.

**Consider adapting your tab bar into a sidebar automatically.** If your app uses a tab-based navigation, you can allow the tab bar to adapt into a sidebar depending on the context by using the following APIs:

**Consider using split views to build sidebar layouts with an inspector panel.** [split](/design/Human-Interface-Guidelines/split-views) are optimized to create a consistent and familiar experience for sidebar and inspector layouts across platforms. You can use the following standard system APIs for split views to build these types of layouts with minimal code:

**Check content safe areas for sidebars and inspectors.** If you have these types of components in your app’s navigation structure, audit the safe area compatibility of content next to the sidebar and inspector to help make sure underlying content is peeking through appropriately.

**Extend content beneath sidebars and inspectors.** A background extension effect creates a sense of extending a background under a sidebar or inspector, without actually scrolling or placing content under it. A background extension effect mirrors the adjacent content to give the impression of stretching it under the sidebar, and applies a blur to maintain legibility of the sidebar or inspector. This effect is perfect for creating a full, edge-to-edge content experience in apps that use split views, such as for hero images on product pages.

**Choose whether to automatically minimize your tab bar in iOS.** Tab bars can help elevate the underlying content by receding when a person scrolls up or down. You can opt into this behavior and configure the tab bar to minimize when a person scrolls down or up. The tab bar expands when a person scrolls in the opposite direction.

## Menus and toolbars

[menus](/design/Human-Interface-Guidelines/menus) have a refreshed look across platforms. They adopt Liquid Glass, and menu items for common actions use icons to help people quickly scan and identify those actions. New to iPadOS, apps also have a [the-menu](/design/Human-Interface-Guidelines/the-menu-bar) for faster access to common commands.

**Adopt standard icons in menu items.** For menu items that perform standard actions like Cut, Copy, and Paste, the system uses the menu item’s selector to determine which icon to apply. To adopt icons in those menu items with minimal code, make sure to use standard selectors.

**Match top menu actions to swipe actions.** For consistency and predictability, make sure the actions you surface at the top of your contextual menu match the swipe actions you provide for the same item.

[toolbars](/design/Human-Interface-Guidelines/toolbars) take on a Liquid Glass appearance, and provide a grouping mechanism for toolbar items, letting you choose which actions to display together.

**Determine which toolbar items to group together.** Group items that perform similar actions or affect the same part of the interface, and maintain consistent groupings and placement across platforms.

You can create a fixed spacer to separate items that share a background using these APIs:

**Find icons to represent common actions.** Consider representing common actions in toolbars with [icons](/design/Human-Interface-Guidelines/icons) instead of text. This approach helps declutter the interface and increase the ease of use for common actions. For consistency, don’t mix text and icons across items that share a background.

**Provide an accessibility label for every icon.** Regardless of what you show in the interface, always specify an accessibility label for each icon. This way, people who prefer a text label can opt into this information by turning on accessibility features like VoiceOver or Voice Control.

**Audit toolbar customizations.** Review anything custom you do to display items in your toolbars, like your use of fixed spacers or custom items, as these can appear inconsistent with system behavior.

**Check how you hide toolbar items.** If you see an empty toolbar item without any content, your app might be hiding the view in the toolbar item instead of the item itself. Instead, hide the entire toolbar item, using these APIs:

## Windows and modals

[windows](/design/Human-Interface-Guidelines/windows) adopt rounder corners to fit controls and navigation elements. In iPadOS, apps show window controls and support continuous window resizing. Instead of transitioning between specific preset sizes, windows resize fluidly down to a minimum size.

**Support arbitrary window sizes.** Allow people to resize their window to the width and height that works for them, and adjust your content accordingly.

**Use split views to allow fluid resizing of columns.** To support continuous window resizing, split views automatically reflow content for every size using beautiful, fluid transitions. Make sure to use standard system APIs for split views to get these animations with minimal code:

**Use layout guides and safe areas.** Make sure you specify safe areas for your content so the system can automatically adjust the window controls and title bar in relation to your content.

Modal views like sheets and action sheets adopt Liquid Glass. [sheets](/design/Human-Interface-Guidelines/sheets) feature an increased corner radius, and half sheets are inset from the edge of the display to allow content to peek through from beneath them. When a half sheet expands to full height, it transitions to a more opaque appearance to help maintain focus on the task.

**Check the content around the edges of sheets.** Inside the sheet, check for content and controls that might appear too close to rounder sheet corners. Outside the sheet, check that any content peeking through between the inset sheet and display edge looks as you expect.

**Audit the backgrounds of sheets and popovers.** Check whether you add a visual effect view to your popover’s content view, and remove those custom background views to provide a consistent experience with other sheets across the system.

An [action](/design/Human-Interface-Guidelines/action-sheets) originates from the element that initiates the action, instead of from the bottom edge of the display. When active, an action sheet also lets people interact with other parts of the interface.

**Specify the source of an action sheet.** Position an action sheet’s anchor next to the control it originates from. Make sure to set the source view or item to indicate where to originate the action sheet and create the inline appearance.

## Organization and layout

Style updates to [lists-and](/design/Human-Interface-Guidelines/lists-and-tables) help you organize and showcase your content so it can shine through the Liquid Glass layer. To give content room to breathe, organizational components like lists, tables, and forms have a larger row height and padding. Sections have an increased corner radius to match the curvature of controls across the system.

**Check capitalization in section headers.** Lists, tables, and forms optimize for legibility by adopting title-style capitalization for [init(content:header:)](/documentation/SwiftUI/Section/init(content:header:)). This means section headers no longer render entirely in capital letters regardless of the capitalization you provide. Make sure to update your section headers to title-style capitalization to match your app’s text to this systemwide convention.

**Adopt forms to take advantage of layout metrics across platform.** Use SwiftUI forms with the [grouped](/documentation/SwiftUI/FormStyle/grouped) to automatically update your form layouts.

## Search

Platform conventions for location and behavior of search optimize the experience for each device and use case. To provide an engaging search experience in your app, review these [search](/design/Human-Interface-Guidelines/search-fields) design conventions.

**Check the keyboard layout when activating your search interface.** In iOS, when a person taps a search field to give it focus, it slides upwards as the keyboard appears. Test this experience in your app to make sure the search field moves consistently with other apps and system experiences.

**Use semantic search tabs.** If your app’s search appears as part of a tab bar, make sure to use the standard system APIs for indicating which tab is the search tab. The system automatically separates the search tab from other tabs and places it at the trailing end to make your search experience consistent with other apps and help people find content faster.

## Platform considerations

Liquid Glass can have a distinct appearance and behavior across different platforms, contexts, and input methods. Test your app across devices to understand how the material looks and feels across platforms.

**In watchOS, adopt standard button styles and toolbar APIs.** Liquid Glass changes are minimal in watchOS, so they appear automatically when you open your app on the latest release even if you don’t build against the latest SDK. However, to make sure your app picks up this appearance, adopt standard toolbar APIs and button styles from watchOS 10.

**In tvOS, adopt standard focus APIs.** Across apps and system experiences in tvOS, standard buttons and controls take on a Liquid Glass appearance when focus moves to them. For consistency with the system experience, consider applying these effects to custom controls in your app when they gain focus by adopting the standard focus APIs. Apple TV 4K (2nd generation) and newer models support Liquid Glass effects. On older devices, your app maintains its current appearance.

**Combine custom Liquid Glass effects to improve rendering performance.** If you apply these effects to custom elements, make sure to combine them using a [Glass Effect Container](/documentation/SwiftUI/GlassEffectContainer), which helps optimize performance while fluidly morphing Liquid Glass shapes into each other.

**Performance test your app across platforms.** It’s a good idea to regularly assess and improve your app’s performance, and building your app with the latest SDKs provides an opportunity to check in. Profile your app to gather information about its current performance and find any opportunities for improving the user experience. To learn more, read [improving-your-app-s](/documentation/Xcode/improving-your-app-s-performance).

To update and ship your app with the latest SDKs while keeping your app as it looks when built against previous versions of the SDKs, you can add the [UIDesign Requires Compatibility](/documentation/BundleResources/Information-Property-List/UIDesignRequiresCompatibility) key to your project’s Info pane.

---

*Extracted by [sosumi.ai](https://sosumi.ai) - Making Apple docs AI-readable.*
*This is unofficial content. All documentation belongs to Apple Inc.*
```


## 来源：docs/fetched/sosumi-core/glasseffect-in.md


```md
---
title: glassEffect(_:in:)
description: Applies the Liquid Glass effect to a view.
source: https://developer.apple.com/documentation/SwiftUI/View/glasseffect(_%3Ain%3A)
timestamp: 2026-03-11T11:51:34.261Z
---

**Navigation:** [SwiftUI](/documentation/SwiftUI) › [View](/documentation/SwiftUI/View)

**Instance Method**

# glassEffect(_:in:)

**Available on:** iOS 26.0+, iPadOS 26.0+, Mac Catalyst 26.0+, macOS 26.0+, tvOS 26.0+, watchOS 26.0+

> Applies the Liquid Glass effect to a view.

```swift
nonisolated func glassEffect(_ glass: Glass = .regular, in shape: some Shape = DefaultGlassEffectShape()) -> some View
```

## Discussion

When you use this effect, the system:

- Renders a shape anchored behind a view with the Liquid Glass material.
- Applies the foreground effects of Liquid Glass over a view.

For example, to add this effect to a [Text](/documentation/swiftui/text):

```swift
Text("Hello, World!")
    .font(.title)
    .padding()
    .glassEffect()
```

SwiftUI uses the [regular](/documentation/swiftui/glass/regular) variant by default along with a [Capsule](/documentation/swiftui/capsule) shape.

SwiftUI anchors the Liquid Glass to a view’s bounds. For the example above, the material fills the entirety of the `Text` frame, which includes the padding.

You typically use this modifier with a [Glass Effect Container](/documentation/swiftui/glasseffectcontainer) to combine multiple Liquid Glass shapes into a single shape that can morph into one another.

## Styling views with Liquid Glass

- [Applying Liquid Glass to custom views](/documentation/swiftui/applying-liquid-glass-to-custom-views)
- [Landmarks: Building an app with Liquid Glass](/documentation/swiftui/landmarks-building-an-app-with-liquid-glass)
- [interactive(_:)](/documentation/swiftui/glass/interactive(_:))
- [GlassEffectContainer](/documentation/swiftui/glasseffectcontainer)
- [GlassEffectTransition](/documentation/swiftui/glasseffecttransition)
- [GlassButtonStyle](/documentation/swiftui/glassbuttonstyle)
- [GlassProminentButtonStyle](/documentation/swiftui/glassprominentbuttonstyle)
- [DefaultGlassEffectShape](/documentation/swiftui/defaultglasseffectshape)

---

*Extracted by [sosumi.ai](https://sosumi.ai) - Making Apple docs AI-readable.*
*This is unofficial content. All documentation belongs to Apple Inc.*
```


## 来源：docs/fetched/sosumi-core/glasseffectid-in.md


```md
---
title: glassEffectID(_:in:)
description: Associates an identity value to Liquid Glass effects defined within this view.
source: https://developer.apple.com/documentation/SwiftUI/View/glasseffectid(_%3Ain%3A)
timestamp: 2026-03-11T11:51:34.482Z
---

**Navigation:** [SwiftUI](/documentation/SwiftUI) › [View](/documentation/SwiftUI/View)

**Instance Method**

# glassEffectID(_:in:)

**Available on:** iOS 26.0+, iPadOS 26.0+, Mac Catalyst 26.0+, macOS 26.0+, tvOS 26.0+, watchOS 26.0+

> Associates an identity value to Liquid Glass effects defined within this view.

```swift
nonisolated func glassEffectID(_ id: (some Hashable & Sendable)?, in namespace: Namespace.ID) -> some View
```

## Discussion

You use this modifier with the [glassEffect(_:in:)](/documentation/swiftui/view/glasseffect(_:in:)) view modifier and a [Glass Effect Container](/documentation/swiftui/glasseffectcontainer) view. When used together, SwiftUI uses the identifier to animate shapes to and from each other during transitions.

---

*Extracted by [sosumi.ai](https://sosumi.ai) - Making Apple docs AI-readable.*
*This is unofficial content. All documentation belongs to Apple Inc.*
```


## 来源：docs/fetched/sosumi-core/backgroundextensioneffect.md


```md
---
title: backgroundExtensionEffect()
description: Adds the background extension effect to the view. The view will be duplicated into mirrored copies which will be placed around the view on any edge with available safe area. Additionally, a blur effect will be applied on top to blur out the copies.
source: https://developer.apple.com/documentation/SwiftUI/View/backgroundextensioneffect()
timestamp: 2026-03-11T11:51:34.274Z
---

**Navigation:** [SwiftUI](/documentation/SwiftUI) › [View](/documentation/SwiftUI/View)

**Instance Method**

# backgroundExtensionEffect()

**Available on:** iOS 26.0+, iPadOS 26.0+, Mac Catalyst 26.0+, macOS 26.0+, tvOS 26.0+, visionOS 26.0+, watchOS 26.0+

> Adds the background extension effect to the view. The view will be duplicated into mirrored copies which will be placed around the view on any edge with available safe area. Additionally, a blur effect will be applied on top to blur out the copies.

```swift
@MainActor @preconcurrency func backgroundExtensionEffect() -> some View
```

## Discussion

Use this modifier when you want to extend the view beyond its bounds so the copies can function as backgrounds for other elements on top. The most common use case is to apply this to a view in the detail column of a navigation split view so it can extend under the sidebar or inspector region to provide seamless immersive visuals.

```swift
NavigationSplitView {
    // sidebar content
} detail: {
    ZStack {
        BannerView()
            .backgroundExtensionEffect()
    }
}
.inspector(isPresented: $showInspector) {
    // inspector content
}
```

Apply this modifier with discretion. This should often be used with only a single instance of background content with consideration of visual clarity and performance.

> [!NOTE]
> This modifier will clip the view to prevent copies from overlapping with each other.

---

*Extracted by [sosumi.ai](https://sosumi.ai) - Making Apple docs AI-readable.*
*This is unofficial content. All documentation belongs to Apple Inc.*
```


## 来源：docs/fetched/sosumi-core/scrollEdgeEffectStyle-for.md


```md
---
title: scrollEdgeEffectStyle(_:for:)
description: Configures the scroll edge effect style for scroll views within this hierarchy.
source: https://developer.apple.com/documentation/SwiftUI/View/scrollEdgeEffectStyle(_%3Afor%3A)
timestamp: 2026-03-11T11:51:34.391Z
---

**Navigation:** [SwiftUI](/documentation/SwiftUI) › [View](/documentation/SwiftUI/View)

**Instance Method**

# scrollEdgeEffectStyle(_:for:)

**Available on:** iOS 26.0+, iPadOS 26.0+, Mac Catalyst 26.0+, macOS 26.0+, tvOS 26.0+, watchOS 26.0+

> Configures the scroll edge effect style for scroll views within this hierarchy.

```swift
nonisolated func scrollEdgeEffectStyle(_ style: ScrollEdgeEffectStyle?, for edges: Edge.Set) -> some View
```

## Discussion

By default, a scroll view renders an automatic edge effect. Use this modifier to change the scroll edge effect style.

```swift
ScrollView {
    LazyVStack {
        ForEach(data) { item in
            RowView(item)
        }
    }
}
.scrollEdgeEffectStyle(.hard, for: .all)
```

## Configuring scroll edge effects

- [scrollEdgeEffectHidden(_:for:)](/documentation/swiftui/view/scrolledgeeffecthidden(_:for:))
- [ScrollEdgeEffectStyle](/documentation/swiftui/scrolledgeeffectstyle)
- [safeAreaBar(edge:alignment:spacing:content:)](/documentation/swiftui/view/safeareabar(edge:alignment:spacing:content:))

---

*Extracted by [sosumi.ai](https://sosumi.ai) - Making Apple docs AI-readable.*
*This is unofficial content. All documentation belongs to Apple Inc.*
```


## 来源：docs/fetched/sosumi-core/PrimitiveButtonStyle-glass.md


```md
---
title: glass
description: A button style that applies a Liquid Glass effect based on the button’s context.
source: https://developer.apple.com/documentation/SwiftUI/PrimitiveButtonStyle/glass
timestamp: 2026-03-11T11:51:34.281Z
---

**Navigation:** [SwiftUI](/documentation/SwiftUI) › [PrimitiveButtonStyle](/documentation/SwiftUI/PrimitiveButtonStyle)

**Type Property**

# glass

**Available on:** iOS 26.0+, iPadOS 26.0+, Mac Catalyst 26.0+, macOS 26.0+, tvOS 26.0+, watchOS 26.0+

> A button style that applies a Liquid Glass effect based on the button’s context.

```swift
@MainActor @preconcurrency static var glass: GlassButtonStyle { get }
```

## Discussion

In tvOS, this button style applies a Liquid Glass effect regardless of whether the button has focus.

To apply this style to a button, or to a view that contains buttons, use the [buttonStyle(_:)](/documentation/swiftui/view/buttonstyle(_:)-66fbx) modifier.

## Getting built-in button styles

- [automatic](/documentation/swiftui/primitivebuttonstyle/automatic)
- [accessoryBar](/documentation/swiftui/primitivebuttonstyle/accessorybar)
- [accessoryBarAction](/documentation/swiftui/primitivebuttonstyle/accessorybaraction)
- [bordered](/documentation/swiftui/primitivebuttonstyle/bordered)
- [borderedProminent](/documentation/swiftui/primitivebuttonstyle/borderedprominent)
- [borderless](/documentation/swiftui/primitivebuttonstyle/borderless)
- [card](/documentation/swiftui/primitivebuttonstyle/card)
- [glassProminent](/documentation/swiftui/primitivebuttonstyle/glassprominent)
- [glass(_:)](/documentation/swiftui/primitivebuttonstyle/glass(_:))
- [link](/documentation/swiftui/primitivebuttonstyle/link)
- [plain](/documentation/swiftui/primitivebuttonstyle/plain)

---

*Extracted by [sosumi.ai](https://sosumi.ai) - Making Apple docs AI-readable.*
*This is unofficial content. All documentation belongs to Apple Inc.*
```


## 来源：docs/fetched/sosumi-core/GlassEffectContainer.md


```md
---
title: GlassEffectContainer
description: A view that combines multiple Liquid Glass shapes into a single shape that can morph individual shapes into one another.
source: https://developer.apple.com/documentation/SwiftUI/GlassEffectContainer
timestamp: 2026-03-11T11:51:34.833Z
---

**Navigation:** [SwiftUI](/documentation/SwiftUI)

**Structure**

# GlassEffectContainer

**Available on:** iOS 26.0+, iPadOS 26.0+, Mac Catalyst 26.0+, macOS 26.0+, tvOS 26.0+, watchOS 26.0+

> A view that combines multiple Liquid Glass shapes into a single shape that can morph individual shapes into one another.

```swift
@MainActor @preconcurrency struct GlassEffectContainer<Content> where Content : View
```

## Overview

Use a container with the [glassEffect(_:in:)](/documentation/swiftui/view/glasseffect(_:in:)) modifier. Each view with a Liquid Glass effect contributes a shape rendered with the effect to a set of shapes. SwiftUI renders the effects together, improving rendering performance and allowing the effects to interact with and morph into one another.

Configure how shapes interact with one another by customizing the default spacing value of the container. As shapes near one another, their paths start to blend into one another. The higher the spacing, the sooner blending begins as the shapes approach each other.

## Conforms To

- [Sendable](/documentation/Swift/Sendable)
- [SendableMetatype](/documentation/Swift/SendableMetatype)
- [View](/documentation/swiftui/view)

## Initializers

- [init(spacing:content:)](/documentation/swiftui/glasseffectcontainer/init(spacing:content:)) Creates a glass effect container with the provided spacing, extracting glass shapes from the provided content.

## Styling views with Liquid Glass

- [Applying Liquid Glass to custom views](/documentation/swiftui/applying-liquid-glass-to-custom-views)
- [Landmarks: Building an app with Liquid Glass](/documentation/swiftui/landmarks-building-an-app-with-liquid-glass)
- [glassEffect(_:in:)](/documentation/swiftui/view/glasseffect(_:in:))
- [interactive(_:)](/documentation/swiftui/glass/interactive(_:))
- [GlassEffectTransition](/documentation/swiftui/glasseffecttransition)
- [GlassButtonStyle](/documentation/swiftui/glassbuttonstyle)
- [GlassProminentButtonStyle](/documentation/swiftui/glassprominentbuttonstyle)
- [DefaultGlassEffectShape](/documentation/swiftui/defaultglasseffectshape)

---

*Extracted by [sosumi.ai](https://sosumi.ai) - Making Apple docs AI-readable.*
*This is unofficial content. All documentation belongs to Apple Inc.*
```


## 来源：docs/fetched/sosumi-core/GlassButtonStyle.md


```md
---
title: GlassButtonStyle
description: A button style that applies glass border artwork based on the button’s context.
source: https://developer.apple.com/documentation/SwiftUI/GlassButtonStyle
timestamp: 2026-03-11T11:51:34.621Z
---

**Navigation:** [SwiftUI](/documentation/SwiftUI)

**Structure**

# GlassButtonStyle

**Available on:** iOS 26.0+, iPadOS 26.0+, Mac Catalyst 26.0+, macOS 26.0+, tvOS 26.0+, watchOS 26.0+

> A button style that applies glass border artwork based on the button’s context.

```swift
struct GlassButtonStyle
```

## Overview

You can also use [glass](/documentation/swiftui/primitivebuttonstyle/glass) to construct this style.

## Conforms To

- [PrimitiveButtonStyle](/documentation/swiftui/primitivebuttonstyle)

## Initializers

- [init()](/documentation/swiftui/glassbuttonstyle/init()) Creates a glass button style.
- [init(_:)](/documentation/swiftui/glassbuttonstyle/init(_:))

## Instance Methods

- [makeBody(configuration:)](/documentation/swiftui/glassbuttonstyle/makebody(configuration:)) Creates a view that represents the body of a button.

## Styling views with Liquid Glass

- [Applying Liquid Glass to custom views](/documentation/swiftui/applying-liquid-glass-to-custom-views)
- [Landmarks: Building an app with Liquid Glass](/documentation/swiftui/landmarks-building-an-app-with-liquid-glass)
- [glassEffect(_:in:)](/documentation/swiftui/view/glasseffect(_:in:))
- [interactive(_:)](/documentation/swiftui/glass/interactive(_:))
- [GlassEffectContainer](/documentation/swiftui/glasseffectcontainer)
- [GlassEffectTransition](/documentation/swiftui/glasseffecttransition)
- [GlassProminentButtonStyle](/documentation/swiftui/glassprominentbuttonstyle)
- [DefaultGlassEffectShape](/documentation/swiftui/defaultglasseffectshape)

---

*Extracted by [sosumi.ai](https://sosumi.ai) - Making Apple docs AI-readable.*
*This is unofficial content. All documentation belongs to Apple Inc.*
```


## 来源：docs/fetched/sosumi-core/GlassProminentButtonStyle.md


```md
---
title: GlassProminentButtonStyle
description: A button style that applies prominent glass border artwork based on the button’s context.
source: https://developer.apple.com/documentation/SwiftUI/GlassProminentButtonStyle
timestamp: 2026-03-11T11:51:34.737Z
---

**Navigation:** [SwiftUI](/documentation/SwiftUI)

**Structure**

# GlassProminentButtonStyle

**Available on:** iOS 26.0+, iPadOS 26.0+, Mac Catalyst 26.0+, macOS 26.0+, tvOS 26.0+, watchOS 26.0+

> A button style that applies prominent glass border artwork based on the button’s context.

```swift
struct GlassProminentButtonStyle
```

## Overview

You can also use [glass Prominent](/documentation/swiftui/primitivebuttonstyle/glassprominent) to construct this style.

## Conforms To

- [PrimitiveButtonStyle](/documentation/swiftui/primitivebuttonstyle)

## Initializers

- [init()](/documentation/swiftui/glassprominentbuttonstyle/init()) Creates a prominent glass button style.

## Instance Methods

- [makeBody(configuration:)](/documentation/swiftui/glassprominentbuttonstyle/makebody(configuration:)) Creates a view that represents the body of a button.

## Styling views with Liquid Glass

- [Applying Liquid Glass to custom views](/documentation/swiftui/applying-liquid-glass-to-custom-views)
- [Landmarks: Building an app with Liquid Glass](/documentation/swiftui/landmarks-building-an-app-with-liquid-glass)
- [glassEffect(_:in:)](/documentation/swiftui/view/glasseffect(_:in:))
- [interactive(_:)](/documentation/swiftui/glass/interactive(_:))
- [GlassEffectContainer](/documentation/swiftui/glasseffectcontainer)
- [GlassEffectTransition](/documentation/swiftui/glasseffecttransition)
- [GlassButtonStyle](/documentation/swiftui/glassbuttonstyle)
- [DefaultGlassEffectShape](/documentation/swiftui/defaultglasseffectshape)

---

*Extracted by [sosumi.ai](https://sosumi.ai) - Making Apple docs AI-readable.*
*This is unofficial content. All documentation belongs to Apple Inc.*
```


## 来源：docs/fetched/sosumi-core/ScrollEdgeEffectStyle.md


```md
---
title: ScrollEdgeEffectStyle
description: A structure that defines the style of pocket a scroll view will have.
source: https://developer.apple.com/documentation/SwiftUI/ScrollEdgeEffectStyle
timestamp: 2026-03-11T11:51:34.342Z
---

**Navigation:** [SwiftUI](/documentation/SwiftUI)

**Structure**

# ScrollEdgeEffectStyle

**Available on:** iOS 26.0+, iPadOS 26.0+, Mac Catalyst 26.0+, macOS 26.0+, tvOS 26.0+, visionOS 26.0+, watchOS 26.0+

> A structure that defines the style of pocket a scroll view will have.

```swift
struct ScrollEdgeEffectStyle
```

## Conforms To

- [Equatable](/documentation/Swift/Equatable)
- [Hashable](/documentation/Swift/Hashable)
- [Sendable](/documentation/Swift/Sendable)
- [SendableMetatype](/documentation/Swift/SendableMetatype)

## Type Properties

- [automatic](/documentation/swiftui/scrolledgeeffectstyle/automatic) The automatic scroll pocket style.
- [hard](/documentation/swiftui/scrolledgeeffectstyle/hard) A scroll edge effect with a hard cutoff and dividing line.
- [soft](/documentation/swiftui/scrolledgeeffectstyle/soft) A scroll edge effect with a soft edge.

## Configuring scroll edge effects

- [scrollEdgeEffectStyle(_:for:)](/documentation/swiftui/view/scrolledgeeffectstyle(_:for:))
- [scrollEdgeEffectHidden(_:for:)](/documentation/swiftui/view/scrolledgeeffecthidden(_:for:))
- [safeAreaBar(edge:alignment:spacing:content:)](/documentation/swiftui/view/safeareabar(edge:alignment:spacing:content:))

---

*Extracted by [sosumi.ai](https://sosumi.ai) - Making Apple docs AI-readable.*
*This is unofficial content. All documentation belongs to Apple Inc.*
```


## 来源：docs/fetched/sosumi-core/DefaultGlassEffectShape.md


```md
---
title: DefaultGlassEffectShape
description: The default shape applied by glass effects, a capsule.
source: https://developer.apple.com/documentation/SwiftUI/DefaultGlassEffectShape
timestamp: 2026-03-11T11:51:34.429Z
---

**Navigation:** [SwiftUI](/documentation/SwiftUI)

**Structure**

# DefaultGlassEffectShape

**Available on:** iOS 26.0+, iPadOS 26.0+, Mac Catalyst 26.0+, macOS 26.0+, tvOS 26.0+, watchOS 26.0+

> The default shape applied by glass effects, a capsule.

```swift
struct DefaultGlassEffectShape
```

## Overview

You do not use this type directly. Instead, SwiftUI creates this shape on your behalf as the default parameter of the [glassEffect(_:in:)](/documentation/swiftui/view/glasseffect(_:in:)) modifier.

## Conforms To

- [Animatable](/documentation/swiftui/animatable)
- [Sendable](/documentation/Swift/Sendable)
- [SendableMetatype](/documentation/Swift/SendableMetatype)
- [Shape](/documentation/swiftui/shape)
- [View](/documentation/swiftui/view)

## Initializers

- [init()](/documentation/swiftui/defaultglasseffectshape/init())

## Styling views with Liquid Glass

- [Applying Liquid Glass to custom views](/documentation/swiftui/applying-liquid-glass-to-custom-views)
- [Landmarks: Building an app with Liquid Glass](/documentation/swiftui/landmarks-building-an-app-with-liquid-glass)
- [glassEffect(_:in:)](/documentation/swiftui/view/glasseffect(_:in:))
- [interactive(_:)](/documentation/swiftui/glass/interactive(_:))
- [GlassEffectContainer](/documentation/swiftui/glasseffectcontainer)
- [GlassEffectTransition](/documentation/swiftui/glasseffecttransition)
- [GlassButtonStyle](/documentation/swiftui/glassbuttonstyle)
- [GlassProminentButtonStyle](/documentation/swiftui/glassprominentbuttonstyle)

---

*Extracted by [sosumi.ai](https://sosumi.ai) - Making Apple docs AI-readable.*
*This is unofficial content. All documentation belongs to Apple Inc.*
```


## 来源：docs/fetched/sosumi-landmarks/Landmarks-Building-an-app-with-Liquid-Glass.md


```md
---
title: Landmarks: Building an app with Liquid Glass
description: Enhance your app experience with system-provided and custom Liquid Glass.
source: https://developer.apple.com/documentation/SwiftUI/Landmarks-Building-an-app-with-Liquid-Glass
timestamp: 2026-03-11T11:51:33.053Z
---

**Navigation:** [SwiftUI](/documentation/SwiftUI)

**Sample Code**

# Landmarks: Building an app with Liquid Glass

**Available on:** iOS 26.0+, iPadOS 26.0+, Mac Catalyst 26.0+, macOS 26.0+, Xcode 26.0+

> Enhance your app experience with system-provided and custom Liquid Glass.

## Overview

Landmarks is a SwiftUI app that demonstrates how to use the new dynamic and expressive design feature, Liquid Glass. The Landmarks app lets people explore interesting sites around the world. Whether it’s a national park near their home or a far-flung location on a different continent, the app provides a way for people to organize and mark their adventures and receive custom activity badges along the way. Landmarks runs on iPad, iPhone, and Mac.

![An image of screenshots of the landmark detail view for Mount Fuji in the Landmarks app, in a Mac, iPad, and iPhone.](https://docs-assets.developer.apple.com/published/ce193ec494e91d4150c3356442824213/Landmarks-Building-an-app-with-Liquid-Glass-1%402x.png)

Landmarks uses a [Navigation Split View](/documentation/swiftui/navigationsplitview) to organize and navigate to content in the app, and demonstrates several key concepts to optimize the use of Liquid Glass:

- Stretching content behind the sidebar and inspector with the background extension effect.
- Extending horizontal scroll views under a sidebar or inspector.
- Leveraging the system-provided glass effect in toolbars.
- Applying Liquid Glass effects to custom interface elements and animations.
- Building a new app icon with Icon Composer.

The sample also demonstrates several techniques to use when changing window sizes, and for adding global search.

## Apply a background extension effect

The sample applies a background extension effect to the featured landmark header in the top view, and the main image in the landmark detail view. This effect extends and blurs the image under the sidebar and inspector when they’re open, creating a full edge-to-edge experience.

![An image of the landmark detail view for Mount Fuji in the Landmarks app on an iPad, with the sidebar visible.](https://docs-assets.developer.apple.com/published/32d9f0bd8395e9cbd92e197c7aa2b4b3/Landmarks-Building-an-app-with-Liquid-Glass-2%402x.png)

To achieve this effect, the sample creates and configures an [Image](/documentation/swiftui/image) that extends to both the leading and trailing edges of the containing view, and applies the [backgroundExtensionEffect()](/documentation/swiftui/view/backgroundextensioneffect()) modifier to the image. For the featured image, the sample adds an overlay with a headline and button after the modifier, so that only the image extends under the sidebar and inspector.

> [!NOTE]
> The sample also extends the image beyond the top safe area, and adds logic to interactively extend the image when you scroll down beyond the view’s bounds. While this improves the experience of the image in the app, it isn’t required to implement the background extension effect.

For more information, see [Landmarks-Applying-a-background-extension](/documentation/swiftui/landmarks-applying-a-background-extension-effect).

## Extend horizontal scrolling under the sidebar

Within each continent section in `LandmarksView`, an instance of `LandmarkHorizontalListView` shows a horizontally scrolling list of landmark views. When open, the landmark views can scroll underneath the sidebar or inspector.

To achieve this effect, the app aligns the scroll views next to the leading and trailing edges of the containing view.

![An image of the landmarks view on an iPad, with the sidebar visible and some landmarks visible under the sidebar.](https://docs-assets.developer.apple.com/published/709551ab6017da3888bbb3b9b1620fed/Landmarks-Building-an-app-with-Liquid-Glass-3%402x.png)

For more information, see [Landmarks-Extending-horizontal-scrolling-under-a-sidebar-or](/documentation/swiftui/landmarks-extending-horizontal-scrolling-under-a-sidebar-or-inspector).

## Refine the Liquid Glass in the toolbar

In `LandmarkDetailView`, the sample adds toolbar items for:

- sharing a landmark
- adding or removing a landmark from a list of Favorites
- adding or removing a landmark from Collections
- showing or hiding the inspector

The system applies Liquid Glass to toolbar items automatically:

![An image of the landmark detail view for Mount Fuji on an iPad, with the toolbar and a portion of the sidebar visible. The toolbar items show the Liquid Glass effect. From the leading to trailing edge, there is a back button, share button, favorite button, collections button, info button, and a search bar.](https://docs-assets.developer.apple.com/published/5074257308473e4332f64b4f188098de/Landmarks-Building-an-app-with-Liquid-Glass-4%402x.png)

The sample also organizes the toolbar into related groups, instead of having all the buttons in one group. For more information, see [Landmarks-Refining-the-system-provided-glass-effect-in](/documentation/swiftui/landmarks-refining-the-system-provided-glass-effect-in-toolbars).

## Display badges with Liquid Glass

Badges provide people with a visual indicator of the activities they’ve recorded in the Landmarks app. When a person completes all four activities for a landmark, they earn that landmark’s badge. The sample uses custom Liquid Glass elements with badges, and shows how to coordinate animations with Liquid Glass.

![An image of the landmarks view on an iPhone, with the badges view visible over some landmarks.](https://docs-assets.developer.apple.com/published/0906c5ecab4688f18b19faf293acb363/Landmarks-Building-an-app-with-Liquid-Glass-5%402x.png)

To create a custom Liquid Glass badge, Landmarks uses a view with an `Image` to display a system symbol image for the badge. The badge has a background hexagon `Image` filled with a custom color. The badge view uses the [glassEffect(_:in:)](/documentation/swiftui/view/glasseffect(_:in:)) modifier to apply Liquid Glass to the badge.

To demonstrate the morphing effect that the system provides with Liquid Glass animations, the sample organizes the badges and the toggle button into a [Glass Effect Container](/documentation/swiftui/glasseffectcontainer), and assigns each badge a unique [glassEffectID(_:in:)](/documentation/swiftui/view/glasseffectid(_:in:)).

For more information, see [Landmarks-Displaying-custom-activity](/documentation/swiftui/landmarks-displaying-custom-activity-badges). For information about building custom views with Liquid Glass, see [Applying-Liquid-Glass-to-custom](/documentation/swiftui/applying-liquid-glass-to-custom-views).

## Create the app icon with Icon Composer

Landmarks includes a dynamic and expressive app icon composed in Icon Composer. You build app icons with four layers that the system uses to produce specular highlights when a person moves their device, so that the icon responds as if light was reflecting off the glass. The Settings app allows people to personalize the icon by selecting light, dark, clear, or tinted variants of your app icon as well.

For more information on creating a new app icon, see [creating-your-app-icon-using-icon](/documentation/Xcode/creating-your-app-icon-using-icon-composer).

For design guidance, see Human Interface Guidelines >  [app](/design/Human-Interface-Guidelines/app-icons).

## App features

- [Landmarks: Applying a background extension effect](/documentation/swiftui/landmarks-applying-a-background-extension-effect) Configure an image to blur and extend under a sidebar or inspector panel.
- [Landmarks: Extending horizontal scrolling under a sidebar or inspector](/documentation/swiftui/landmarks-extending-horizontal-scrolling-under-a-sidebar-or-inspector) Improve your horizontal scrollbar’s appearance by extending it under a sidebar or inspector.
- [Landmarks: Refining the system provided Liquid Glass effect in toolbars](/documentation/swiftui/landmarks-refining-the-system-provided-glass-effect-in-toolbars) Organize toolbars into related groupings to improve their appearance and utility.
- [Landmarks: Displaying custom activity badges](/documentation/swiftui/landmarks-displaying-custom-activity-badges) Provide people with a way to mark their adventures by displaying animated custom activity badges.

## Essentials

- [Adopting Liquid Glass](/documentation/TechnologyOverviews/adopting-liquid-glass)
- [Develop in Swift](/tutorials/Develop-in-Swift#explore-xcode)
- [SwiftUI updates](/documentation/Updates/SwiftUI)

---

*Extracted by [sosumi.ai](https://sosumi.ai) - Making Apple docs AI-readable.*
*This is unofficial content. All documentation belongs to Apple Inc.*
```


## 来源：docs/fetched/sosumi-landmarks/Landmarks-Applying-a-background-extension-effect.md


```md
---
title: Landmarks: Applying a background extension effect
description: Configure an image to blur and extend under a sidebar or inspector panel.
source: https://developer.apple.com/documentation/SwiftUI/Landmarks-Applying-a-background-extension-effect
timestamp: 2026-03-11T11:51:33.150Z
---

**Navigation:** [SwiftUI](/documentation/SwiftUI)

**Sample Code**

# Landmarks: Applying a background extension effect

**Available on:** iOS 26.0+, iPadOS 26.0+, Mac Catalyst 26.0+, macOS 26.0+, Xcode 26.0+

> Configure an image to blur and extend under a sidebar or inspector panel.

## Overview

The Landmarks app lets people explore interesting sites around the world. Whether it’s a national park near their home or a far-flung location on a different continent, the app provides a way for people to organize and mark their adventures and receive custom activity badges along the way.

This sample demonstrates how to apply a background extension effect. In the top Landmarks view, the sample applies a background extension effect to the featured image in `LandmarksView`, and to the main image in `LandmarkDetailView`. The background extension effect blurs and extends the image under the sidebar or inspector panel when open. The following images show the main image in `LandmarkDetailView` both with and without the background extension effect.

To apply the background extension effect, the sample:

1. Aligns the view to the leading and trailing edges of the containing view.
2. Applies the [backgroundExtensionEffect()](/documentation/swiftui/view/backgroundextensioneffect()) modifier to the view.
3. Configures only the image in the background extension, and avoids applying the effect to the title and button in the overlay.

### Align the view to the leading and trailing edges

To apply the [backgroundExtensionEffect()](/documentation/swiftui/view/backgroundextensioneffect()) to a view, align the leading edge of the view next to the sidebar, and align the trailing edge of the view to the trailing edge of the containing view.

In `LandmarksView`, the `LandmarkFeaturedItemView` and the containing [Lazy VStack](/documentation/swiftui/lazyvstack) and [Scroll View](/documentation/swiftui/scrollview) don’t have padding. This allows the `LandmarkFeaturedItemView` to align with the leading edge of the view next to the sidebar.

```swift
ScrollView(showsIndicators: false) {
    LazyVStack(alignment: .leading, spacing: Constants.standardPadding) {
        LandmarkFeaturedItemView(landmark: modelData.featuredLandmark!)
            .flexibleHeaderContent()
        //...
    }
}
```

In `LandmarkDetailView`, the [Scroll View](/documentation/swiftui/scrollview) and [VStack](/documentation/swiftui/vstack) that contain the main image also don’t have any padding. This allows the main image to align against the leading edge of the containing view.

### Apply the background extension effect to the image

In `LandmarkDetailView`, the sample applies the background extension effect to the main image by adding the [backgroundExtensionEffect()](/documentation/swiftui/view/backgroundextensioneffect()) modifier:

```swift
Image(landmark.backgroundImageName)
    //...
    .backgroundExtensionEffect()
```

When the sidebar is open, the system extends the image in the leading direction as follows:

- The system takes a section of the leading end of the image that matches the width of the sidebar.
- The system flips that portion of the image horizontally toward the leading edge and applies a blur to the flipped section.
- The system places the modified section of the image under the sidebar, immediately before the leading edge of the image.

When the inspector is open, the system extends the image in the trailing direction as follows:

- The system takes a section of the trailing end of the image that matches the width of the sidebar.
- The system flips that portion of the image horizontally toward the trailing edge and applies a blur to the flipped section.
- The system places the modified section of the image under the inspector, immediately after the trailing edge of the image.

### Configure only the image

In `LandmarksView`, the `LandmarkFeaturedItemView` has an image from the featured landmark, and includes a title for the landmark and a button you can click or tap to learn more about that location.

To avoid having the landmark’s title and button appear under the sidebar in macOS, the sample applies the [backgroundExtensionEffect()](/documentation/swiftui/view/backgroundextensioneffect()) modifier to the image before adding the overlay that includes the title and button:

```swift
Image(decorative: landmark.backgroundImageName)
    //...
    .backgroundExtensionEffect()
    .overlay(alignment: .bottom) {
        VStack {
            Text("Featured Landmark", comment: "Big headline in the main image of featured landmarks.")
                //...
            Text(landmark.name)
                //...
            Button("Learn More") {
                modelData.path.append(landmark)
            }
            //...
        }
        .padding([.bottom], Constants.learnMoreBottomPadding)
    }

```

## App features

- [Landmarks: Extending horizontal scrolling under a sidebar or inspector](/documentation/swiftui/landmarks-extending-horizontal-scrolling-under-a-sidebar-or-inspector)
- [Landmarks: Refining the system provided Liquid Glass effect in toolbars](/documentation/swiftui/landmarks-refining-the-system-provided-glass-effect-in-toolbars)
- [Landmarks: Displaying custom activity badges](/documentation/swiftui/landmarks-displaying-custom-activity-badges)

---

*Extracted by [sosumi.ai](https://sosumi.ai) - Making Apple docs AI-readable.*
*This is unofficial content. All documentation belongs to Apple Inc.*
```


## 来源：docs/fetched/sosumi-landmarks/Landmarks-Extending-horizontal-scrolling-under-a-sidebar-or-inspector.md


```md
---
title: Landmarks: Extending horizontal scrolling under a sidebar or inspector
description: Improve your horizontal scrollbar’s appearance by extending it under a sidebar or inspector.
source: https://developer.apple.com/documentation/SwiftUI/Landmarks-Extending-horizontal-scrolling-under-a-sidebar-or-inspector
timestamp: 2026-03-11T11:51:33.399Z
---

**Navigation:** [SwiftUI](/documentation/SwiftUI)

**Sample Code**

# Landmarks: Extending horizontal scrolling under a sidebar or inspector

**Available on:** iOS 26.0+, iPadOS 26.0+, Mac Catalyst 26.0+, macOS 26.0+, Xcode 26.0+

> Improve your horizontal scrollbar’s appearance by extending it under a sidebar or inspector.

## Overview

The Landmarks app lets people explore interesting sites around the world. Whether it’s a national park near their home or a far-flung location on a different continent, the app provides a way for people to organize and mark their adventures and receive custom activity badges along the way.

This sample demonstrates how to extend horizontal scrolling under a sidebar or inspector. Within each continent section in `LandmarksView`, an instance of `LandmarkHorizontalListView` shows a horizontally scrolling list of landmark views. When open, the landmark views can scroll underneath the sidebar or inspector.

![An image of the landmarks view on an iPad, with the sidebar visible and some landmarks visible under the sidebar.](https://docs-assets.developer.apple.com/published/709551ab6017da3888bbb3b9b1620fed/Landmarks-Building-an-app-with-Liquid-Glass-3%402x.png)

## Configure the scroll view

To achieve this effect, the sample configures the `LandmarkHorizontalListView` so it touches the leading and trailing edges. When a scroll view touches the sidebar or inspector, the system automatically adjusts it to scroll under the sidebar or inspector and then off the edge of the screen.

The sample adds a [Spacer](/documentation/swiftui/spacer) at the beginning of the [Scroll View](/documentation/swiftui/scrollview) to inset the content so it aligns with the title padding:

```swift
ScrollView(.horizontal, showsIndicators: false) {
    LazyHStack(spacing: Constants.standardPadding) {
        Spacer()
            .frame(width: Constants.standardPadding)
        ForEach(landmarkList) { landmark in
            //...
        }
    }
}
```

## App features

- [Landmarks: Applying a background extension effect](/documentation/swiftui/landmarks-applying-a-background-extension-effect)
- [Landmarks: Refining the system provided Liquid Glass effect in toolbars](/documentation/swiftui/landmarks-refining-the-system-provided-glass-effect-in-toolbars)
- [Landmarks: Displaying custom activity badges](/documentation/swiftui/landmarks-displaying-custom-activity-badges)

---

*Extracted by [sosumi.ai](https://sosumi.ai) - Making Apple docs AI-readable.*
*This is unofficial content. All documentation belongs to Apple Inc.*
```


## 来源：docs/fetched/sosumi-landmarks/Landmarks-Refining-the-system-provided-glass-effect-in-toolbars.md


```md
---
title: Landmarks: Refining the system provided Liquid Glass effect in toolbars
description: Organize toolbars into related groupings to improve their appearance and utility.
source: https://developer.apple.com/documentation/SwiftUI/Landmarks-Refining-the-system-provided-glass-effect-in-toolbars
timestamp: 2026-03-11T11:51:34.197Z
---

**Navigation:** [SwiftUI](/documentation/SwiftUI)

**Sample Code**

# Landmarks: Refining the system provided Liquid Glass effect in toolbars

**Available on:** iOS 26.0+, iPadOS 26.0+, Mac Catalyst 26.0+, macOS 26.0+, Xcode 26.0+

> Organize toolbars into related groupings to improve their appearance and utility.

## Overview

The Landmarks app lets people explore interesting sites around the world. Whether it’s a national park near their home or a far-flung location on a different continent, the app provides a way for people to organize and mark their adventures and receive custom activity badges along the way.

This sample demonstrates how to refine the system provided glass effect in toolbars. In `LandmarkDetailView`, the sample adds toolbar items for:

- sharing a landmark
- adding or removing a landmark from a list of Favorites
- adding or removing a landmark from Collections
- showing or hiding the inspector

The system applies Liquid Glass to the toolbar items automatically.

![An image of the landmark detail view for Mount Fuji on an iPad, with the toolbar and a portion of the sidebar visible. The toolbar items show the Liquid Glass effect. From the leading to trailing edge, there is a back button, share button, favorite button, collections button, info button, and a search bar.](https://docs-assets.developer.apple.com/published/5074257308473e4332f64b4f188098de/Landmarks-Building-an-app-with-Liquid-Glass-4%402x.png)

## Organize the toolbar items into logical groupings

To organize the toolbar items into logical groupings, the sample adds [Toolbar Spacer](/documentation/swiftui/toolbarspacer) items and passes [fixed](/documentation/swiftui/spacersizing/fixed) as the `sizing` parameter to divide the toolbar into sections:

```swift
.toolbar {
    ToolbarSpacer(.flexible)

    ToolbarItem {
        ShareLink(item: landmark, preview: landmark.sharePreview)
    }

    ToolbarSpacer(.fixed)
    
    ToolbarItemGroup {
        LandmarkFavoriteButton(landmark: landmark)
        LandmarkCollectionsMenu(landmark: landmark)
    }
    
    ToolbarSpacer(.fixed)

    ToolbarItem {
        Button("Info", systemImage: "info") {
            modelData.selectedLandmark = landmark
            modelData.isLandmarkInspectorPresented.toggle()
        }
    }
}
```

## App features

- [Landmarks: Applying a background extension effect](/documentation/swiftui/landmarks-applying-a-background-extension-effect)
- [Landmarks: Extending horizontal scrolling under a sidebar or inspector](/documentation/swiftui/landmarks-extending-horizontal-scrolling-under-a-sidebar-or-inspector)
- [Landmarks: Displaying custom activity badges](/documentation/swiftui/landmarks-displaying-custom-activity-badges)

---

*Extracted by [sosumi.ai](https://sosumi.ai) - Making Apple docs AI-readable.*
*This is unofficial content. All documentation belongs to Apple Inc.*
```


## 来源：docs/fetched/sosumi-landmarks/Landmarks-Displaying-custom-activity-badges.md


```md
---
title: Landmarks: Displaying custom activity badges
description: Provide people with a way to mark their adventures by displaying animated custom activity badges.
source: https://developer.apple.com/documentation/SwiftUI/Landmarks-Displaying-custom-activity-badges
timestamp: 2026-03-11T11:51:32.949Z
---

**Navigation:** [SwiftUI](/documentation/SwiftUI)

**Sample Code**

# Landmarks: Displaying custom activity badges

**Available on:** iOS 26.0+, iPadOS 26.0+, Mac Catalyst 26.0+, macOS 26.0+, Xcode 26.0+

> Provide people with a way to mark their adventures by displaying animated custom activity badges.

## Overview

The Landmarks app lets people track their adventures as they explore sites around the world. Whether it’s a national park near their home or a far-flung location on a different continent, the app provides a way for people to mark their adventures and receive custom activity badges along the way.

![An image of the landmarks view on an iPhone, with the badges view visible over some landmarks.](https://docs-assets.developer.apple.com/published/0906c5ecab4688f18b19faf293acb363/Landmarks-Building-an-app-with-Liquid-Glass-5%402x.png)

This sample displays the badges in a vertical view that includes a toggle button for showing or hiding the badges. The Landmarks app includes a custom modifier that makes it easier for other views to adopt the badge view. By configuring the badges to use Liquid Glass, the badges gain the advantage of using the morphing animation when you show or hide the badges.

## Add a modifier to show badges in other views

To make the badges available in other views, like `CollectionsView`, the sample uses a custom modifier, `ShowBadgesViewModifier`, as a [View Modifier](/documentation/swiftui/viewmodifier). The sample layers the badges over another view using a [ZStack](/documentation/swiftui/zstack), and positions the badge view in the lower trailing corner:

```swift
private struct ShowsBadgesViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            content
            HStack {
                Spacer()
                VStack {
                    Spacer()
                    BadgesView()
                        .padding()
                }
            }
        }
    }
}
```

The sample extends [View](/documentation/swiftui/view) by adding the `showBadges` modifier:

```swift
extension View {
    func showsBadges() -> some View {
        modifier(ShowsBadgesViewModifier())
    }
}
```

## Apply Liquid Glass to the toggle button

To create the toggle button, the sample configures a [Button](/documentation/swiftui/button) using `ToggleBadgesLabel` which has different system images for the Show and Hide toggle states. To apply Liquid Glass, style the button with the [glass](/documentation/swiftui/primitivebuttonstyle/glass) modifier:

```swift
Button {
    //...
} label: {
    //...
}
.buttonStyle(.glass)

```

## Add Liquid Glass to the badges

To add Liquid Glass to each badge, the sample uses the [glassEffect(_:in:)](/documentation/swiftui/view/glasseffect(_:in:)) modifier. To make a custom glass view appearance, the sample specifies a rectangular option with a corner radius:

```swift
BadgeLabel(badge: $0)
    .glassEffect(.regular, in: .rect(cornerRadius: Constants.badgeCornerRadius))
```

## Animate the badges using the morph effect

The morph effect is an animation for Liquid Glass views. During this animation, the toggle button and each badge start as a combined view. Then, the button and badges change shape like a liquid as they separate and move from one location to another. In reverse, the toggle button and badges change shape and combine back into one view.

To achieve the Liquid Glass morph effect, the app:

- organizes the badges and toggle button into a [Glass Effect Container](/documentation/swiftui/glasseffectcontainer)
- adds [glassEffectID(_:in:)](/documentation/swiftui/view/glasseffectid(_:in:)) to each badge
- adds [glassEffectID(_:in:)](/documentation/swiftui/view/glasseffectid(_:in:)) to the toggle button
- wraps the command that toggles the `isExpanded` property in [withAnimation(_:_:)](/documentation/swiftui/withanimation(_:_:))

```swift
// Organizes the badges and toggle button to animate together.
GlassEffectContainer(spacing: Constants.badgeGlassSpacing) {
    VStack(alignment: .center, spacing: Constants.badgeButtonTopSpacing) {
        if isExpanded {
            VStack(spacing: Constants.badgeSpacing) {
                ForEach(modelData.earnedBadges) {
                    BadgeLabel(badge: $0)
                        // Adds Liquid Glass to the badge.
                        .glassEffect(.regular, in: .rect(cornerRadius: Constants.badgeCornerRadius))
                        // Adds an identifier to the badge for animation.
                        .glassEffectID($0.id, in: namespace)
                }
            }
        }

        Button {
            // Animates this button and badges when `isExpanded` changes values.
            withAnimation {
                isExpanded.toggle()
            }
        } label: {
            ToggleBadgesLabel(isExpanded: isExpanded)
                .frame(width: Constants.badgeShowHideButtonWidth,
                       height: Constants.badgeShowHideButtonHeight)
        }
        // Adds Liquid Glass to the button.
        .buttonStyle(.glass)
        #if os(macOS)
        .tint(.clear)
        #endif
        // Adds an identifier to the button for animation.
        .glassEffectID("togglebutton", in: namespace)
    }
    .frame(width: Constants.badgeFrameWidth)
}
```

## App features

- [Landmarks: Applying a background extension effect](/documentation/swiftui/landmarks-applying-a-background-extension-effect)
- [Landmarks: Extending horizontal scrolling under a sidebar or inspector](/documentation/swiftui/landmarks-extending-horizontal-scrolling-under-a-sidebar-or-inspector)
- [Landmarks: Refining the system provided Liquid Glass effect in toolbars](/documentation/swiftui/landmarks-refining-the-system-provided-glass-effect-in-toolbars)

---

*Extracted by [sosumi.ai](https://sosumi.ai) - Making Apple docs AI-readable.*
*This is unofficial content. All documentation belongs to Apple Inc.*
```


## 来源：docs/fetched/sosumi-landmarks/Applying-Liquid-Glass-to-custom-views.md


```md
---
title: Applying Liquid Glass to custom views
description: Configure, combine, and morph views using Liquid Glass effects.
source: https://developer.apple.com/documentation/SwiftUI/Applying-Liquid-Glass-to-custom-views
timestamp: 2026-03-11T11:51:33.047Z
---

**Navigation:** [SwiftUI](/documentation/SwiftUI)

**Article**

# Applying Liquid Glass to custom views

> Configure, combine, and morph views using Liquid Glass effects.

## Overview

Interfaces across Apple platforms feature a new dynamic material called Liquid Glass, which combines the optical properties of glass with a sense of fluidity. Liquid Glass is a material that blurs content behind it, reflects color and light of surrounding content, and reacts to touch and pointer interactions in real time. Standard components in SwiftUI use Liquid Glass. Adopt Liquid Glass on custom components to move, combine, and morph them into one another with unique animations and transitions.

![An image of the Landmarks sample code on iPad, in landscape, showing the Mount Fuji landmark.](https://docs-assets.developer.apple.com/published/86bea3b2d851de88291e52e7845ef990/liquid-glass-landmarks-hero%402x.png)

To learn about Liquid Glass and more, see [Landmarks-Building-an-app-with-Liquid](/documentation/swiftui/landmarks-building-an-app-with-liquid-glass).

## Apply and configure Liquid Glass effects

Use the [glassEffect(_:in:)](/documentation/swiftui/view/glasseffect(_:in:)) modifier to add Liquid Glass effects to a view. By default, the modifier uses the [regular](/documentation/swiftui/glass/regular) variant of [Glass](/documentation/swiftui/glass) and applies the given effect within a [Capsule](/documentation/swiftui/capsule) shape behind the view’s content.

Configure the effect to customize your components in a variety of ways:

- Use different shapes to have a consistent look and feel across custom components in your app. For example, use a rounded rectangle if you’re applying the effect to larger components that would look odd as a `Capsule` or [Circle](/documentation/swiftui/circle).
- Assign a tint color to suggest prominence.
- Add [interactive(_:)](/documentation/swiftui/glass/interactive(_:)) to custom components to make them react to touch and pointer interactions. This applies the same responsive and fluid reactions that [glass](/documentation/swiftui/primitivebuttonstyle/glass) provides to standard buttons.

In the examples below, observe how to apply Liquid Glass effects to a view, use an alternate shape with a specific corner radius, and create a tinted view that responds to interactivity:

```swift
Text("Hello, World!")
    .font(.title)
    .padding()
    .glassEffect()

Text("Hello, World!")
    .font(.title)
    .padding()
    .glassEffect(in: .rect(cornerRadius: 16.0))

Text("Hello, World!")
    .font(.title)
    .padding()
    .glassEffect(.regular.tint(.orange).interactive())
```

## Combine multiple views with Liquid Glass containers

Use [Glass Effect Container](/documentation/swiftui/glasseffectcontainer) when applying Liquid Glass effects on multiple views to achieve the best rendering performance. A container also allows views with Liquid Glass effects to blend their shapes together and to morph in and out of each other during transitions. Inside a container, each view with the [glassEffect(_:in:)](/documentation/swiftui/view/glasseffect(_:in:)) modifier renders with the effects behind it.

Customize the spacing on the container to control how the Liquid Glass effects behind views interact with one another. The larger the spacing value on the container, the sooner the Liquid Glass effects behind views blend together and merge the shapes during a transition. A spacing value on the container that’s larger than the spacing of an interior [HStack](/documentation/swiftui/hstack), [VStack](/documentation/swiftui/vstack), or other layout container causes Liquid Glass effects to blend together at rest because the views are too close to each other. Animating views in or out causes the shapes to morph apart or together as the space in the container changes.

The `glassEffect(_:in:)` modifier captures the content to send to the container to render. Apply the `glassEffect(_:in:)` modifier after other modifiers that affect the appearance of the view.

In the example below, two images are placed close to each other and the Liquid Glass effects begin to blend their shapes together. This creates a fluid animation as components move around each other within a container:

![Two Image views representing a scribble symbol on the left, and an eraser symbol on the right. The views are close to each other, which causes the Liquid Glass effects to merge the views.](https://docs-assets.developer.apple.com/published/1a45d9481869becc2c40374ece262425/liquid-glass-joined-view%402x.png)

```swift
GlassEffectContainer(spacing: 40.0) {
    HStack(spacing: 40.0) {
        Image(systemName: "scribble.variable")
            .frame(width: 80.0, height: 80.0)
            .font(.system(size: 36))
            .glassEffect()

        Image(systemName: "eraser.fill")
            .frame(width: 80.0, height: 80.0)
            .font(.system(size: 36))
            .glassEffect()

            // An `offset` shows how Liquid Glass effects react to each other in a container.
            // Use animations and components appearing and disappearing to obtain effects that look purposeful.
            .offset(x: -40.0, y: 0.0)
    }
}
```

In some cases, you want the geometries of multiple views to contribute to a single Liquid Glass effect capsule, even when your content is at rest. Use the [glassEffectUnion(id:namespace:)](/documentation/swiftui/view/glasseffectunion(id:namespace:)) modifier to specify that a view contributes to a unified effect with a particular ID. This combines all effects with a similar shape, Liquid Glass effect, and ID into a single shape with the applied Liquid Glass material. This is especially useful when creating views dynamically, or with views that live outside of a layout container, like an `HStack` or `VStack`.

![Four Image views that have Liquid Glass effects applied. A rain cloud with lightning symbol and a sun with rain symbol have a unified Liquid Glass effect encapsulating both of them, followed by a unified Liquid Glass effect of a moon with stars symbol and a moon symbol.](https://docs-assets.developer.apple.com/published/4426e68642783951fe56b1d7485825cc/liquid-glass-unioned-views%402x.png)

```swift
let symbolSet: [String] = ["cloud.bolt.rain.fill", "sun.rain.fill", "moon.stars.fill", "moon.fill"]

GlassEffectContainer(spacing: 20.0) {
    HStack(spacing: 20.0) {
        ForEach(symbolSet.indices, id: \.self) { item in
            Image(systemName: symbolSet[item])
                .frame(width: 80.0, height: 80.0)
                .font(.system(size: 36))
                .glassEffect()
                .glassEffectUnion(id: item < 2 ? "1" : "2", namespace: namespace)
        }
    }
}
```

## Morph Liquid Glass effects during transitions

Morphing effects occur during transitions or animations between views with Liquid Glass effects. Coordinate transitions between views with effects in a container by using the [glassEffectID(_:in:)](/documentation/swiftui/view/glasseffectid(_:in:)) modifier. [Glass Effect Transition](/documentation/swiftui/glasseffecttransition) allows you to specify the type of transition to use when you want to add or remove effects within a container. For effects you want to add or remove that are positioned within the container’s assigned spacing, the default transition type is [matched Geometry](/documentation/swiftui/glasseffecttransition/matchedgeometry).

If you prefer to have a simpler transition or to create a custom transition, use the [materialize](/documentation/swiftui/glasseffecttransition/materialize) transition and [withAnimation(_:_:)](/documentation/swiftui/withanimation(_:_:)). Use the `materialize` transition for effects you want to add or remove that are farther from each other than the container’s assigned spacing. To provide people with a consistent experience, use `matchedGeometry` and `materialize` transitions across your apps. The system applies more than opacity changes with the available transition types.

Associate each Liquid Glass effect with a unique identifier within a namespace that the [Namespace](/documentation/swiftui/namespace) property wrapper provides. These IDs ensure SwiftUI animates the same shapes correctly when a shape appears or disappears due to view hierarchy changes. SwiftUI uses the spacing provided to the effect container along with the geometry of the shapes themselves to determine when and which appropriate shapes to morph into and out of.

The `glassEffectID(_:in:)` and `glassEffectTransition(_:)` modifiers only affect their content during view hierarchy transitions or animations.

In the example below, the eraser image transitions into and out of the pencil image when the `isExpanded` variable changes. The `GlassEffectContainer` has a spacing value of `40.0`, and the `HStack` within it has a spacing of `40.0`. This morphs the eraser image into the pencil image when the eraser’s nearest edge is less than or equal to the container’s spacing.

```swift
@State private var isExpanded: Bool = false
@Namespace private var namespace

var body: some View {
    GlassEffectContainer(spacing: 40.0) {
        HStack(spacing: 40.0) {
            Image(systemName: "scribble.variable")
                .frame(width: 80.0, height: 80.0)
                .font(.system(size: 36))
                .glassEffect()
                .glassEffectID("pencil", in: namespace)

            if isExpanded {
                Image(systemName: "eraser.fill")
                    .frame(width: 80.0, height: 80.0)
                    .font(.system(size: 36))
                    .glassEffect()
                    .glassEffectID("eraser", in: namespace)
            }
        }
    }

    Button("Toggle") {
        withAnimation {
            isExpanded.toggle()
        }
    }
    .buttonStyle(.glass)
}
```

## Optimize performance when using Liquid Glass effects

Creating too many Liquid Glass effect containers and applying too many effects to views outside of containers can degrade performance. Limit the use of Liquid Glass effects onscreen at the same time. Additionally, optimize how your app spends rendering time as people use it. To learn how to improve the performance of your UI, see [](https://developer.apple.com/videos/play/tech-talks/10855/) and [](https://developer.apple.com/videos/play/wwdc2025/306/).

## Styling views with Liquid Glass

- [Landmarks: Building an app with Liquid Glass](/documentation/swiftui/landmarks-building-an-app-with-liquid-glass)
- [glassEffect(_:in:)](/documentation/swiftui/view/glasseffect(_:in:))
- [interactive(_:)](/documentation/swiftui/glass/interactive(_:))
- [GlassEffectContainer](/documentation/swiftui/glasseffectcontainer)
- [GlassEffectTransition](/documentation/swiftui/glasseffecttransition)
- [GlassButtonStyle](/documentation/swiftui/glassbuttonstyle)
- [GlassProminentButtonStyle](/documentation/swiftui/glassprominentbuttonstyle)
- [DefaultGlassEffectShape](/documentation/swiftui/defaultglasseffectshape)

---

*Extracted by [sosumi.ai](https://sosumi.ai) - Making Apple docs AI-readable.*
*This is unofficial content. All documentation belongs to Apple Inc.*
```


## 来源：docs/fetched/sosumi-landmarks/GlassEffectTransition.md


```md
---
title: GlassEffectTransition
description: A structure that describes changes to apply when a glass effect is added or removed from the view hierarchy.
source: https://developer.apple.com/documentation/SwiftUI/GlassEffectTransition
timestamp: 2026-03-11T11:51:34.129Z
---

**Navigation:** [SwiftUI](/documentation/SwiftUI)

**Structure**

# GlassEffectTransition

**Available on:** iOS 26.0+, iPadOS 26.0+, Mac Catalyst 26.0+, macOS 26.0+, tvOS 26.0+, watchOS 26.0+

> A structure that describes changes to apply when a glass effect is added or removed from the view hierarchy.

```swift
struct GlassEffectTransition
```

## Conforms To

- [Sendable](/documentation/Swift/Sendable)
- [SendableMetatype](/documentation/Swift/SendableMetatype)

## Type Properties

- [identity](/documentation/swiftui/glasseffecttransition/identity) The identity transition specifying no changes.
- [matchedGeometry](/documentation/swiftui/glasseffecttransition/matchedgeometry) Returns the matched geometry glass effect transition.
- [materialize](/documentation/swiftui/glasseffecttransition/materialize) The materialize glass effect transition which will fade in content and animate in or out the glass material but will not attempt to match the geometry of any other glass effects.

## Styling views with Liquid Glass

- [Applying Liquid Glass to custom views](/documentation/swiftui/applying-liquid-glass-to-custom-views)
- [Landmarks: Building an app with Liquid Glass](/documentation/swiftui/landmarks-building-an-app-with-liquid-glass)
- [glassEffect(_:in:)](/documentation/swiftui/view/glasseffect(_:in:))
- [interactive(_:)](/documentation/swiftui/glass/interactive(_:))
- [GlassEffectContainer](/documentation/swiftui/glasseffectcontainer)
- [GlassButtonStyle](/documentation/swiftui/glassbuttonstyle)
- [GlassProminentButtonStyle](/documentation/swiftui/glassprominentbuttonstyle)
- [DefaultGlassEffectShape](/documentation/swiftui/defaultglasseffectshape)

---

*Extracted by [sosumi.ai](https://sosumi.ai) - Making Apple docs AI-readable.*
*This is unofficial content. All documentation belongs to Apple Inc.*
```


## 来源：docs/fetched/sosumi-landmarks/Glass.md


```md
---
title: Glass
description: A structure that defines the configuration of the Liquid Glass material.
source: https://developer.apple.com/documentation/SwiftUI/Glass
timestamp: 2026-03-11T11:51:32.915Z
---

**Navigation:** [SwiftUI](/documentation/SwiftUI)

**Structure**

# Glass

**Available on:** iOS 26.0+, iPadOS 26.0+, Mac Catalyst 26.0+, macOS 26.0+, tvOS 26.0+, watchOS 26.0+

> A structure that defines the configuration of the Liquid Glass material.

```swift
struct Glass
```

## Overview

You provide instances of a variant of Liquid Glass to the [glassEffect(_:in:)](/documentation/swiftui/view/glasseffect(_:in:)) view modifier:

```swift
Text("Hello, World!")
    .font(.title)
    .padding()
    .glassEffect()
```

You can combine Liquid Glass effects using a [Glass Effect Container](/documentation/swiftui/glasseffectcontainer), which supports morphing views with this effect into each other based on the geometry of their associated views.

## Conforms To

- [Equatable](/documentation/Swift/Equatable)
- [Sendable](/documentation/Swift/Sendable)
- [SendableMetatype](/documentation/Swift/SendableMetatype)

## Instance Methods

- [interactive(_:)](/documentation/swiftui/glass/interactive(_:)) Returns a copy of the structure configured to be interactive.
- [tint(_:)](/documentation/swiftui/glass/tint(_:)) Returns a copy of the structure with a configured tint color.

## Type Properties

- [clear](/documentation/swiftui/glass/clear) The clear variant of glass.
- [identity](/documentation/swiftui/glass/identity) The identity variant of glass. When applied, your content remains unaffected as if no glass effect was applied.
- [regular](/documentation/swiftui/glass/regular) The regular variant of the Liquid Glass material.

## Styling content

- [border(_:width:)](/documentation/swiftui/view/border(_:width:))
- [foregroundStyle(_:)](/documentation/swiftui/view/foregroundstyle(_:))
- [foregroundStyle(_:_:)](/documentation/swiftui/view/foregroundstyle(_:_:))
- [foregroundStyle(_:_:_:)](/documentation/swiftui/view/foregroundstyle(_:_:_:))
- [backgroundStyle(_:)](/documentation/swiftui/view/backgroundstyle(_:))
- [backgroundStyle](/documentation/swiftui/environmentvalues/backgroundstyle)
- [ShapeStyle](/documentation/swiftui/shapestyle)
- [AnyShapeStyle](/documentation/swiftui/anyshapestyle)
- [Gradient](/documentation/swiftui/gradient)
- [MeshGradient](/documentation/swiftui/meshgradient)
- [AnyGradient](/documentation/swiftui/anygradient)
- [ShadowStyle](/documentation/swiftui/shadowstyle)

---

*Extracted by [sosumi.ai](https://sosumi.ai) - Making Apple docs AI-readable.*
*This is unofficial content. All documentation belongs to Apple Inc.*
```


## 来源：docs/fetched/sosumi-uikit/fetch-manifest.md


```md
# sosumi UIKit 文档抓取清单

- 抓取时间: 2026-03-11T11:51:53Z（执行时会更新）
- 抓取来源: https://sosumi.ai/
- 保存目录: `docs/fetched/sosumi-uikit/`
- 格式: 每个页面保留两份文件
  - `<slug>.html`：原始完整 HTML
  - `<slug>.md`：从 HTML 提取的 markdown（带 frontmatter）

| 页面 | URL | HTML | Markdown |
|---|---|---|---|
| UIGlassEffect | https://sosumi.ai/documentation/uikit/uiglasseffect | [uiglasseffect.html](./uiglasseffect.html) | [uiglasseffect.md](./uiglasseffect.md) |
| UIGlassContainerEffect | https://sosumi.ai/documentation/uikit/uiglasscontainereffect | [uiglasscontainereffect.html](./uiglasscontainereffect.html) | [uiglasscontainereffect.md](./uiglasscontainereffect.md) |
| UIBackgroundExtensionView | https://sosumi.ai/documentation/uikit/uibackgroundextensionview | [uibackgroundextensionview.html](./uibackgroundextensionview.html) | [uibackgroundextensionview.md](./uibackgroundextensionview.md) |
| UIScrollEdgeEffect | https://sosumi.ai/documentation/uikit/uiscrolledgeeffect | [uiscrolledgeeffect.html](./uiscrolledgeeffect.html) | [uiscrolledgeeffect.md](./uiscrolledgeeffect.md) |
| UIButton.Configuration.glass | https://sosumi.ai/documentation/uikit/uibutton/configuration-swift.struct/glass%28%29 | [uibutton-config-glass.html](./uibutton-config-glass.html) | [uibutton-config-glass.md](./uibutton-config-glass.md) |
| UIButton.Configuration.prominentGlass | https://sosumi.ai/documentation/uikit/uibutton/configuration-swift.struct/prominentglass%28%29 | [uibutton-config-prominentglass.html](./uibutton-config-prominentglass.html) | [uibutton-config-prominentglass.md](./uibutton-config-prominentglass.md) |
| UIButton.Configuration.clearGlass | https://sosumi.ai/documentation/uikit/uibutton/configuration-swift.struct/clearglass%28%29 | [uibutton-config-clearglass.html](./uibutton-config-clearglass.html) | [uibutton-config-clearglass.md](./uibutton-config-clearglass.md) |
| UIButton.Configuration.prominentClearGlass | https://sosumi.ai/documentation/uikit/uibutton/configuration-swift.struct/prominentclearglass%28%29 | [uibutton-config-prominentclearglass.html](./uibutton-config-prominentclearglass.html) | [uibutton-config-prominentclearglass.md](./uibutton-config-prominentclearglass.md) |
| UIKit updates | https://sosumi.ai/documentation/updates/uikit | [uikit-updates.html](./uikit-updates.html) | [uikit-updates.md](./uikit-updates.md) |
```


## 来源：docs/fetched/sosumi-uikit/uiglasseffect.md


```md
---
url: https://sosumi.ai/documentation/uikit/uiglasseffect
slug: uiglasseffect
title: uiglasseffect
fetched_at: 2026-03-11T11:51:53Z
source: sosumi.ai
status: fetched
format: markdown
---

--- title: UIGlassEffect description: A visual effect that renders a glass material. source: https://developer.apple.com/documentation/uikit/uiglasseffect timestamp: 2026-03-11T11:51:53.726Z --- \*\*Navigation:\*\* \[Uikit\](/documentation/uikit) \*\*Class\*\* \# UIGlassEffect \*\*Available on:\*\* iOS 26.0+, iPadOS 26.0+, Mac Catalyst 26.0+, tvOS 26.0+ \> A visual effect that renders a glass material. \`\`\`swift @MainActor class UIGlassEffect \`\`\` \## Inherits From - \[UIVisualEffect\](/documentation/uikit/uivisualeffect) \## Conforms To - \[CVarArg\](/documentation/Swift/CVarArg) - \[CustomDebugStringConvertible\](/documentation/Swift/CustomDebugStringConvertible) - \[CustomStringConvertible\](/documentation/Swift/CustomStringConvertible) - \[Equatable\](/documentation/Swift/Equatable) - \[Hashable\](/documentation/Swift/Hashable) - \[NSCoding\](/documentation/Foundation/NSCoding) - \[NSCopying\](/documentation/Foundation/NSCopying) - \[NSObjectProtocol\](/documentation/ObjectiveC/NSObjectProtocol) - \[NSSecureCoding\](/documentation/Foundation/NSSecureCoding) - \[Sendable\](/documentation/Swift/Sendable) - \[SendableMetatype\](/documentation/Swift/SendableMetatype) \## Initializers - \[init(style:)\](/documentation/uikit/uiglasseffect/init(style:)) Creates a glass effect with the specified style. \## Instance Properties - \[isInteractive\](/documentation/uikit/uiglasseffect/isinteractive) Enables interactive behavior for the glass effect. - \[tintColor\](/documentation/uikit/uiglasseffect/tintcolor) A tint color applied to the glass. \## Enumerations - \[UIGlassEffect.Style\](/documentation/uikit/uiglasseffect/style) \## Liquid Glass effects - \[UIGlassContainerEffect\](/documentation/uikit/uiglasscontainereffect) --- \*Extracted by \[sosumi.ai\](https://sosumi.ai) - Making Apple docs AI-readable.\* \*This is unofficial content. All documentation belongs to Apple Inc.\*
```


## 来源：docs/fetched/sosumi-uikit/uiglasscontainereffect.md


```md
---
url: https://sosumi.ai/documentation/uikit/uiglasscontainereffect
slug: uiglasscontainereffect
title: uiglasscontainereffect
fetched_at: 2026-03-11T11:51:53Z
source: sosumi.ai
status: fetched
format: markdown
---

--- title: UIGlassContainerEffect description: A renders multiple glass elements into a combined effect. source: https://developer.apple.com/documentation/uikit/uiglasscontainereffect timestamp: 2026-03-11T11:51:53.688Z --- \*\*Navigation:\*\* \[Uikit\](/documentation/uikit) \*\*Class\*\* \# UIGlassContainerEffect \*\*Available on:\*\* iOS 26.0+, iPadOS 26.0+, Mac Catalyst 26.0+, tvOS 26.0+ \> A renders multiple glass elements into a combined effect. \`\`\`swift @MainActor class UIGlassContainerEffect \`\`\` \## Overview When using \`UIGlassContainerEffect\` with a \`UIVisualEffectView\` you can add individual glass elements to the visual effect view’s contentView by nesting \`UIVisualEffectView\`‘s configured with \`UIGlassEffect\`. In that configuration, the glass container will render all glass elements in one combined view, behind the visual effect view’s \`contentView\`. \## Inherits From - \[UIVisualEffect\](/documentation/uikit/uivisualeffect) \## Conforms To - \[CVarArg\](/documentation/Swift/CVarArg) - \[CustomDebugStringConvertible\](/documentation/Swift/CustomDebugStringConvertible) - \[CustomStringConvertible\](/documentation/Swift/CustomStringConvertible) - \[Equatable\](/documentation/Swift/Equatable) - \[Hashable\](/documentation/Swift/Hashable) - \[NSCoding\](/documentation/Foundation/NSCoding) - \[NSCopying\](/documentation/Foundation/NSCopying) - \[NSObjectProtocol\](/documentation/ObjectiveC/NSObjectProtocol) - \[NSSecureCoding\](/documentation/Foundation/NSSecureCoding) - \[Sendable\](/documentation/Swift/Sendable) - \[SendableMetatype\](/documentation/Swift/SendableMetatype) \## Instance Properties - \[spacing\](/documentation/uikit/uiglasscontainereffect/spacing) The spacing specifies the distance between elements at which they begin to merge. \## Liquid Glass effects - \[UIGlassEffect\](/documentation/uikit/uiglasseffect) --- \*Extracted by \[sosumi.ai\](https://sosumi.ai) - Making Apple docs AI-readable.\* \*This is unofficial content. All documentation belongs to Apple Inc.\*
```


## 来源：docs/fetched/sosumi-uikit/uibackgroundextensionview.md


```md
---
url: https://sosumi.ai/documentation/uikit/uibackgroundextensionview
slug: uibackgroundextensionview
title: uibackgroundextensionview
fetched_at: 2026-03-11T11:51:53Z
source: sosumi.ai
status: fetched
format: markdown
---

--- title: UIBackgroundExtensionView description: A view that extends content to fill its own bounds. source: https://developer.apple.com/documentation/uikit/uibackgroundextensionview timestamp: 2026-03-11T11:51:53.485Z --- \*\*Navigation:\*\* \[Uikit\](/documentation/uikit) \*\*Class\*\* \# UIBackgroundExtensionView \*\*Available on:\*\* iOS 26.0+, iPadOS 26.0+, Mac Catalyst 26.0+, tvOS 26.0+, visionOS 26.0+ \> A view that extends content to fill its own bounds. \`\`\`swift class UIBackgroundExtensionView \`\`\` \## Overview A background extension view can be laid out to extend outside the safe area, such as under a sidebar or an inspector. By default, the view lays out its content to stay within the safe area, and uses modifications of the content along the edges to fill the container view. \## Inherits From - \[UIView\](/documentation/uikit/uiview) \## Conforms To - \[CALayerDelegate\](/documentation/QuartzCore/CALayerDelegate) - \[CVarArg\](/documentation/Swift/CVarArg) - \[CustomDebugStringConvertible\](/documentation/Swift/CustomDebugStringConvertible) - \[CustomStringConvertible\](/documentation/Swift/CustomStringConvertible) - \[Equatable\](/documentation/Swift/Equatable) - \[Hashable\](/documentation/Swift/Hashable) - \[NSCoding\](/documentation/Foundation/NSCoding) - \[NSObjectProtocol\](/documentation/ObjectiveC/NSObjectProtocol) - \[NSTouchBarProvider\](/documentation/AppKit/NSTouchBarProvider) - \[Sendable\](/documentation/Swift/Sendable) - \[SendableMetatype\](/documentation/Swift/SendableMetatype) - \[UIAccessibilityIdentification\](/documentation/uikit/uiaccessibilityidentification) - \[UIActivityItemsConfigurationProviding\](/documentation/uikit/uiactivityitemsconfigurationproviding) - \[UIAppearance\](/documentation/uikit/uiappearance) - \[UIAppearanceContainer\](/documentation/uikit/uiappearancecontainer) - \[UICoordinateSpace\](/documentation/uikit/uicoordinatespace) - \[UIDynamicItem\](/documentation/uikit/uidynamicitem) - \[UIFocusEnvironment\](/documentation/uikit/uifocusenvironment) - \[UIFocusItem\](/documentation/uikit/uifocusitem) - \[UIFocusItemContainer\](/documentation/uikit/uifocusitemcontainer) - \[UILargeContentViewerItem\](/documentation/uikit/uilargecontentvieweritem) - \[UIPasteConfigurationSupporting\](/documentation/uikit/uipasteconfigurationsupporting) - \[UIPopoverPresentationControllerSourceItem\](/documentation/uikit/uipopoverpresentationcontrollersourceitem) - \[UIResponderStandardEditActions\](/documentation/uikit/uiresponderstandardeditactions) - \[UITraitChangeObservable\](/documentation/uikit/uitraitchangeobservable-67e94) - \[UITraitEnvironment\](/documentation/uikit/uitraitenvironment) - \[UIUserActivityRestoring\](/documentation/uikit/uiuseractivityrestoring) \## Instance Properties - \[automaticallyPlacesContentView\](/documentation/uikit/uibackgroundextensionview/automaticallyplacescontentview) Controls the automatic safe area placement of the within the container. - \[contentView\](/documentation/uikit/uibackgroundextensionview/contentview) The content view to extend to fill the . \## Interacting with adjacent views - \[UIScrollEdgeElementContainerInteraction\](/documentation/uikit/uiscrolledgeelementcontainerinteraction) --- \*Extracted by \[sosumi.ai\](https://sosumi.ai) - Making Apple docs AI-readable.\* \*This is unofficial content. All documentation belongs to Apple Inc.\*
```


## 来源：docs/fetched/sosumi-uikit/uiscrolledgeeffect.md


```md
---
url: https://sosumi.ai/documentation/uikit/uiscrolledgeeffect
slug: uiscrolledgeeffect
title: uiscrolledgeeffect
fetched_at: 2026-03-11T11:51:53Z
source: sosumi.ai
status: fetched
format: markdown
---

--- title: UIScrollEdgeEffect description: Properties of the effect on a particular edge of the scroll view. source: https://developer.apple.com/documentation/uikit/uiscrolledgeeffect timestamp: 2026-03-11T11:51:53.317Z --- \*\*Navigation:\*\* \[Uikit\](/documentation/uikit) \*\*Class\*\* \# UIScrollEdgeEffect \*\*Available on:\*\* iOS 26.0+, iPadOS 26.0+, Mac Catalyst 26.0+, tvOS 26.0+, visionOS 26.0+ \> Properties of the effect on a particular edge of the scroll view. \`\`\`swift @MainActor class UIScrollEdgeEffect \`\`\` \## Inherits From - \[NSObject\](/documentation/ObjectiveC/NSObject-swift.class) \## Conforms To - \[CVarArg\](/documentation/Swift/CVarArg) - \[CustomDebugStringConvertible\](/documentation/Swift/CustomDebugStringConvertible) - \[CustomStringConvertible\](/documentation/Swift/CustomStringConvertible) - \[Equatable\](/documentation/Swift/Equatable) - \[Hashable\](/documentation/Swift/Hashable) - \[NSObjectProtocol\](/documentation/ObjectiveC/NSObjectProtocol) - \[Sendable\](/documentation/Swift/Sendable) \## Instance Properties - \[isHidden\](/documentation/uikit/uiscrolledgeeffect/ishidden) Whether this edge effect is hidden. Default: false - \[style\](/documentation/uikit/uiscrolledgeeffect/style-swift.property) The style of this edge effect. \## Applying edge effects - \[bottomEdgeEffect\](/documentation/uikit/uiscrollview/bottomedgeeffect) - \[leftEdgeEffect\](/documentation/uikit/uiscrollview/leftedgeeffect) - \[rightEdgeEffect\](/documentation/uikit/uiscrollview/rightedgeeffect) - \[topEdgeEffect\](/documentation/uikit/uiscrollview/topedgeeffect) - \[UIScrollEdgeEffect.Style\](/documentation/uikit/uiscrolledgeeffect/style-swift.class) --- \*Extracted by \[sosumi.ai\](https://sosumi.ai) - Making Apple docs AI-readable.\* \*This is unofficial content. All documentation belongs to Apple Inc.\*
```


## 来源：docs/fetched/sosumi-uikit/uibutton-config-glass.md


```md
---
url: https://sosumi.ai/documentation/uikit/uibutton/configuration-swift.struct/glass%28%29
slug: uibutton-config-glass
title: uibutton-config-glass
fetched_at: 2026-03-11T11:51:54Z
source: sosumi.ai
status: fetched
format: markdown
---

--- title: glass() description: Creates a configuration for a button that has a Liquid Glass style. source: https://developer.apple.com/documentation/uikit/uibutton/configuration-swift.struct/glass() timestamp: 2026-03-11T11:51:54.360Z --- \*\*Navigation:\*\* \[Uikit\](/documentation/uikit) › \[uibutton\](/documentation/uikit/uibutton) › \[configuration-swift.struct\](/documentation/uikit/uibutton/configuration-swift.struct) \*\*Type Method\*\* \# glass() \*\*Available on:\*\* iOS 26.0+, iPadOS 26.0+, Mac Catalyst undefined+, tvOS 26.0+ \> Creates a configuration for a button that has a Liquid Glass style. \`\`\`swift static func glass() -\> UIButton.Configuration \`\`\` \## Discussion In tvOS, this button style applies a Liquid Glass effect regardless of whether the button has focus. \## Creating configurations - \[plain()\](/documentation/uikit/uibutton/configuration-swift.struct/plain()) - \[gray()\](/documentation/uikit/uibutton/configuration-swift.struct/gray()) - \[tinted()\](/documentation/uikit/uibutton/configuration-swift.struct/tinted()) - \[filled()\](/documentation/uikit/uibutton/configuration-swift.struct/filled()) - \[borderless()\](/documentation/uikit/uibutton/configuration-swift.struct/borderless()) - \[bordered()\](/documentation/uikit/uibutton/configuration-swift.struct/bordered()) - \[borderedTinted()\](/documentation/uikit/uibutton/configuration-swift.struct/borderedtinted()) - \[borderedProminent()\](/documentation/uikit/uibutton/configuration-swift.struct/borderedprominent()) - \[prominentGlass()\](/documentation/uikit/uibutton/configuration-swift.struct/prominentglass()) - \[clearGlass()\](/documentation/uikit/uibutton/configuration-swift.struct/clearglass()) - \[prominentClearGlass()\](/documentation/uikit/uibutton/configuration-swift.struct/prominentclearglass()) - \[updated(for:)\](/documentation/uikit/uibutton/configuration-swift.struct/updated(for:)) --- \*Extracted by \[sosumi.ai\](https://sosumi.ai) - Making Apple docs AI-readable.\* \*This is unofficial content. All documentation belongs to Apple Inc.\*
```


## 来源：docs/fetched/sosumi-uikit/uibutton-config-prominentglass.md


```md
---
url: https://sosumi.ai/documentation/uikit/uibutton/configuration-swift.struct/prominentglass%28%29
slug: uibutton-config-prominentglass
title: uibutton-config-prominentglass
fetched_at: 2026-03-11T11:51:54Z
source: sosumi.ai
status: fetched
format: markdown
---

--- title: prominentGlass() description: Creates a configuration for a button that has a prominent Liquid Glass style. source: https://developer.apple.com/documentation/uikit/uibutton/configuration-swift.struct/prominentglass() timestamp: 2026-03-11T11:51:54.124Z --- \*\*Navigation:\*\* \[Uikit\](/documentation/uikit) › \[uibutton\](/documentation/uikit/uibutton) › \[configuration-swift.struct\](/documentation/uikit/uibutton/configuration-swift.struct) \*\*Type Method\*\* \# prominentGlass() \*\*Available on:\*\* iOS 26.0+, iPadOS 26.0+, Mac Catalyst undefined+, tvOS 26.0+ \> Creates a configuration for a button that has a prominent Liquid Glass style. \`\`\`swift static func prominentGlass() -\> UIButton.Configuration \`\`\` \## Discussion In tvOS, this button style applies a Liquid Glass effect regardless of whether the button has focus. \## Creating configurations - \[plain()\](/documentation/uikit/uibutton/configuration-swift.struct/plain()) - \[gray()\](/documentation/uikit/uibutton/configuration-swift.struct/gray()) - \[tinted()\](/documentation/uikit/uibutton/configuration-swift.struct/tinted()) - \[filled()\](/documentation/uikit/uibutton/configuration-swift.struct/filled()) - \[borderless()\](/documentation/uikit/uibutton/configuration-swift.struct/borderless()) - \[bordered()\](/documentation/uikit/uibutton/configuration-swift.struct/bordered()) - \[borderedTinted()\](/documentation/uikit/uibutton/configuration-swift.struct/borderedtinted()) - \[borderedProminent()\](/documentation/uikit/uibutton/configuration-swift.struct/borderedprominent()) - \[glass()\](/documentation/uikit/uibutton/configuration-swift.struct/glass()) - \[clearGlass()\](/documentation/uikit/uibutton/configuration-swift.struct/clearglass()) - \[prominentClearGlass()\](/documentation/uikit/uibutton/configuration-swift.struct/prominentclearglass()) - \[updated(for:)\](/documentation/uikit/uibutton/configuration-swift.struct/updated(for:)) --- \*Extracted by \[sosumi.ai\](https://sosumi.ai) - Making Apple docs AI-readable.\* \*This is unofficial content. All documentation belongs to Apple Inc.\*
```


## 来源：docs/fetched/sosumi-uikit/uibutton-config-clearglass.md


```md
---
url: https://sosumi.ai/documentation/uikit/uibutton/configuration-swift.struct/clearglass%28%29
slug: uibutton-config-clearglass
title: uibutton-config-clearglass
fetched_at: 2026-03-11T11:51:54Z
source: sosumi.ai
status: fetched
format: markdown
---

--- title: clearGlass() description: Creates a configuration for a button that has a clear Liquid Glass style. source: https://developer.apple.com/documentation/uikit/uibutton/configuration-swift.struct/clearglass() timestamp: 2026-03-11T11:51:54.544Z --- \*\*Navigation:\*\* \[Uikit\](/documentation/uikit) › \[uibutton\](/documentation/uikit/uibutton) › \[configuration-swift.struct\](/documentation/uikit/uibutton/configuration-swift.struct) \*\*Type Method\*\* \# clearGlass() \*\*Available on:\*\* iOS 26.0+, iPadOS 26.0+, Mac Catalyst undefined+, tvOS 26.0+ \> Creates a configuration for a button that has a clear Liquid Glass style. \`\`\`swift static func clearGlass() -\> UIButton.Configuration \`\`\` \## Discussion In tvOS, this button style applies a Liquid Glass effect regardless of whether the button has focus. \## Creating configurations - \[plain()\](/documentation/uikit/uibutton/configuration-swift.struct/plain()) - \[gray()\](/documentation/uikit/uibutton/configuration-swift.struct/gray()) - \[tinted()\](/documentation/uikit/uibutton/configuration-swift.struct/tinted()) - \[filled()\](/documentation/uikit/uibutton/configuration-swift.struct/filled()) - \[borderless()\](/documentation/uikit/uibutton/configuration-swift.struct/borderless()) - \[bordered()\](/documentation/uikit/uibutton/configuration-swift.struct/bordered()) - \[borderedTinted()\](/documentation/uikit/uibutton/configuration-swift.struct/borderedtinted()) - \[borderedProminent()\](/documentation/uikit/uibutton/configuration-swift.struct/borderedprominent()) - \[glass()\](/documentation/uikit/uibutton/configuration-swift.struct/glass()) - \[prominentGlass()\](/documentation/uikit/uibutton/configuration-swift.struct/prominentglass()) - \[prominentClearGlass()\](/documentation/uikit/uibutton/configuration-swift.struct/prominentclearglass()) - \[updated(for:)\](/documentation/uikit/uibutton/configuration-swift.struct/updated(for:)) --- \*Extracted by \[sosumi.ai\](https://sosumi.ai) - Making Apple docs AI-readable.\* \*This is unofficial content. All documentation belongs to Apple Inc.\*
```


## 来源：docs/fetched/sosumi-uikit/uibutton-config-prominentclearglass.md


```md
---
url: https://sosumi.ai/documentation/uikit/uibutton/configuration-swift.struct/prominentclearglass%28%29
slug: uibutton-config-prominentclearglass
title: uibutton-config-prominentclearglass
fetched_at: 2026-03-11T11:51:54Z
source: sosumi.ai
status: fetched
format: markdown
---

--- title: prominentClearGlass() description: Creates a configuration for a button that has a prominent, clear Liquid Glass style. source: https://developer.apple.com/documentation/uikit/uibutton/configuration-swift.struct/prominentclearglass() timestamp: 2026-03-11T11:51:54.067Z --- \*\*Navigation:\*\* \[Uikit\](/documentation/uikit) › \[uibutton\](/documentation/uikit/uibutton) › \[configuration-swift.struct\](/documentation/uikit/uibutton/configuration-swift.struct) \*\*Type Method\*\* \# prominentClearGlass() \*\*Available on:\*\* iOS 26.0+, iPadOS 26.0+, Mac Catalyst undefined+, tvOS 26.0+ \> Creates a configuration for a button that has a prominent, clear Liquid Glass style. \`\`\`swift static func prominentClearGlass() -\> UIButton.Configuration \`\`\` \## Discussion In tvOS, this button style applies a Liquid Glass effect regardless of whether the button has focus. \## Creating configurations - \[plain()\](/documentation/uikit/uibutton/configuration-swift.struct/plain()) - \[gray()\](/documentation/uikit/uibutton/configuration-swift.struct/gray()) - \[tinted()\](/documentation/uikit/uibutton/configuration-swift.struct/tinted()) - \[filled()\](/documentation/uikit/uibutton/configuration-swift.struct/filled()) - \[borderless()\](/documentation/uikit/uibutton/configuration-swift.struct/borderless()) - \[bordered()\](/documentation/uikit/uibutton/configuration-swift.struct/bordered()) - \[borderedTinted()\](/documentation/uikit/uibutton/configuration-swift.struct/borderedtinted()) - \[borderedProminent()\](/documentation/uikit/uibutton/configuration-swift.struct/borderedprominent()) - \[glass()\](/documentation/uikit/uibutton/configuration-swift.struct/glass()) - \[prominentGlass()\](/documentation/uikit/uibutton/configuration-swift.struct/prominentglass()) - \[clearGlass()\](/documentation/uikit/uibutton/configuration-swift.struct/clearglass()) - \[updated(for:)\](/documentation/uikit/uibutton/configuration-swift.struct/updated(for:)) --- \*Extracted by \[sosumi.ai\](https://sosumi.ai) - Making Apple docs AI-readable.\* \*This is unofficial content. All documentation belongs to Apple Inc.\*
```


## 来源：docs/fetched/sosumi-uikit/uikit-updates.md


```md
---
url: https://sosumi.ai/documentation/updates/uikit
slug: uikit-updates
title: uikit-updates
fetched_at: 2026-03-11T11:51:55Z
source: sosumi.ai
status: fetched
format: markdown
---

--- title: UIKit updates description: Learn about important changes to UIKit. source: https://developer.apple.com/documentation/updates/uikit timestamp: 2026-03-11T11:51:55.557Z --- \*\*Navigation:\*\* \[Updates\](/documentation/updates) \*\*Article\*\* \# UIKit updates \> Learn about important changes to UIKit. \## Overview Browse notable changes in \[UIKit\](/documentation/UIKit). \## June 2025 \### General - Provide seamless immersive visuals by using \[UIBackground Extension View\](/documentation/UIKit/UIBackgroundExtensionView) to extend a view’s content under sidebars and inspectors. - Apply Liquid Glass effects to views using \[UIGlass Effect\](/documentation/UIKit/UIGlassEffect). - Organize views together for morph animations in \[UIGlass Container Effect\](/documentation/UIKit/UIGlassContainerEffect). - Add or adjust effects at the edge of a scroll view with \[UIScroll Edge Effect\](/documentation/UIKit/UIScrollEdgeEffect). - Apply Liquid Glass effects to buttons with \[glass()\](/documentation/UIKit/UIButton/Configuration-swift.struct/glass()) and \[prominentGlass()\](/documentation/UIKit/UIButton/Configuration-swift.struct/prominentGlass()). - UIKit now supports Swift Observable objects. Use observable objects in \[layoutSubviews()\](/documentation/UIKit/UIView/layoutSubviews()); then UIKit automatically invalidates and updates the UI when those objects change. - Add a badge to a \[UIBar Button Item\](/documentation/UIKit/UIBarButtonItem) with \[badge\](/documentation/UIKit/UIBarButtonItem/badge-4sz3f). - Notification payloads are now strongly typed: \[Message Identifier\](/documentation/Foundation/NotificationCenter/MessageIdentifier). \### Menu bar in iPadOS - Swipe from the top to reveal an iPad app’s full menu. Menus on iPad support images, submenus, inline sections, checkmarks, and more. - Configure main menus with \[UIMain Menu System\](/documentation/UIKit/UIMainMenuSystem). \### High dynamic range (HDR) - \[UIColor Picker View Controller\](/documentation/UIKit/UIColorPickerViewController) supports picking HDR colors, with a maximum supported exposure value. - Observe \[UITrait HDRHeadroom Usage Limit-swift.struct\](/documentation/UIKit/UITraitHDRHeadroomUsageLimit-swift.struct) to automatically adjust HDR usage when a view with HDR content is not in focus. \## June 2024 \### General - Leverage automatic trait usage tracking inside key update methods such as \[layoutSubviews()\](/documentation/UIKit/UIView/layoutSubviews()), eliminating the need for manual trait change registration and invalidation. - Add repeat, wiggle, breathe, and rotate effects to \[\](https://developer.apple.com/sf-symbols/). - Take advantage of enhancements to \[UIList Content Configuration-swift.struct\](/documentation/UIKit/UIListContentConfiguration-swift.struct), which now automatically updates to match the style of the containing list by using the new \[UIList Environment\](/documentation/UIKit/UIListEnvironment) trait from the trait collection, removing the need to instantiate a configuration for a specific list style yourself. - Opt out or restrict collaboration on certain types of data through the share sheet using \[UIActivity Collaboration Mode\](/documentation/UIKit/UIActivityCollaborationMode). - Select a specific week of the year in \[UICalendar View\](/documentation/UIKit/UICalendarView) using the new \[UICalendar Selection Week Of Year\](/documentation/UIKit/UICalendarSelectionWeekOfYear) selection option. - Observe, participate in, and affect the UI update process using \[UIUpdate Link\](/documentation/UIKit/UIUpdateLink). \### Navigation - Showcase your app and its unique identity with a new, customizable launch design for document-based apps. In UIKit, define \[launch Options-swift.property\](/documentation/UIKit/UIDocumentViewController/launchOptions-swift.property) on your \[UIDocument View Controller\](/documentation/UIKit/UIDocumentViewController). - Make your app’s navigation more immersive by adopting the new tab bar on iPad. If your app presents a rich hierarchy of tab items, set the \[mode-swift.property\](/documentation/UIKit/UITabBarController/mode-swift.property) to \[tab Sidebar\](/documentation/UIKit/UITabBarController/Mode-swift.enum/tabSidebar) to automatically switch between the tab bar and sidebar representations. In SwiftUI, use \[sidebar Adaptable\](/documentation/SwiftUI/TabViewStyle/sidebarAdaptable). - Transition between views in a way that feels fluid and consistent using a systemwide zoom transition. In UIKit, configure your view controller’s \[preferred Transition\](/documentation/UIKit/UIViewController/preferredTransition) to \[zoom(options:sourceViewProvider:)\](/documentation/UIKit/UIViewController/Transition/zoom(options:sourceViewProvider:)). In SwiftUI, use \[zoom(sourceID:in:)\](/documentation/SwiftUI/NavigationTransition/zoom(sourceID:in:)). \### Framework interoperability - Reuse existing UIKit gesture recognizer code in SwiftUI. In SwiftUI, create UIKit gesture recognizers using \[UIGesture Recognizer Representable\](/documentation/SwiftUI/UIGestureRecognizerRepresentable). In UIKit, refer to SwiftUI gestures by name using \[name\](/documentation/UIKit/UIGestureRecognizer/name). \### visionOS - Support more varieties of list layouts by configuring whether section headers stretch to fill the entire width of the list or shrink to tightly hug their content. For collection views, use \[content Hugging Elements-swift.property\](/documentation/UIKit/UICollectionLayoutListConfiguration-swift.struct/contentHuggingElements-swift.property) on \[UICollection Layout List Configuration-swift.struct\](/documentation/UIKit/UICollectionLayoutListConfiguration-swift.struct). For table views, use \[content Hugging Elements\](/documentation/UIKit/UITableView/contentHuggingElements) on \[UITable View\](/documentation/UIKit/UITableView). - Animate SF Symbols on visionOS using the symbol effects API and \[UIImage View\](/documentation/UIKit/UIImageView). - Apply hierarchical vibrant text color to labels using \[Prominence-swift.enum\](/documentation/UIKit/UIColor/Prominence-swift.enum). - Specify an action to perform without shifting the focus away from the keyboard using \[keyboard Action\](/documentation/UIKit/UITextInputAssistantItem/keyboardAction). - Push a new scene in place of an existing scene using \[UIWindow Scene Push Placement-swift.struct\](/documentation/UIKit/UIWindowScenePushPlacement-swift.struct). The new scene appears in the same position as the original scene, hiding it. Closing the new scene makes the original scene reappear. \### tvOS - Create a unifying color theme in your app by specifying an accent color in your app’s asset catalog, which is now supported in tvOS. \## June 2023 \### General - Preview your views and view controllers alongside your code using the new \`#Preview\` Swift macro. - Take advantage of a new view controller appearance callback, \[viewIsAppearing(\_:)\](/documentation/UIKit/UIViewController/viewIsAppearing(\_:)), to run code that depends on the view’s initial geometry. The system calls this method when both the view and view controller have an up-to-date trait collection, and after the superview adds the view to the hierarchy and lays it out. This method deploys back to iOS 13. - Learn about enhancements to the trait system, which let you define custom traits for your own data, quickly change trait values throughout the view hierarchy, and register for trait changes in more flexible ways. For more information, see WWDC23 session 10057: \[\](https://developer.apple.com/videos/play/wwdc2023/10057/). - Display and manage empty state consistently in your app with \[UIContent Unavailable Configuration-swift.struct\](/documentation/UIKit/UIContentUnavailableConfiguration-swift.struct), which provides new system standard styles and layouts for common empty states. Help people understand why no content is present, and when possible, provide guidance on how to add content. - Create a powerful text experience in your app. Define richer interactions by changing the default tap or menu behavior when interacting with a text item. If you implement a custom UI for displaying text, support the redesigned text cursor by adopting the new text selection UI. Mark up text fields with additional text content types to help people fill out forms even faster. For more information, see WWDC23 session 10058: \[\](https://developer.apple.com/videos/play/wwdc2023/10058/). - Let people drop supported files and content onto your app icon on the Home Screen to open them in your app. To make sure your app is properly configured, verify that your \`Info.plist\` file specifies the file types your app supports using \[CFBundle Document Types\](/documentation/BundleResources/Information-Property-List/CFBundleDocumentTypes). \### Accessibility and internationalization - Simplify how you maintain your accessibility code with block-based setters for accessibility attributes. Make sure people receive the most important information first by specifying a default, low, or high priority for announcements. Enhance custom accessibility elements with the new toggle and zoom accessibility traits. - Create a great text experience for international users by testing your UI in all languages. Adopt text styles to take advantage of enhancements to the font system, like improved wrapping and hyphenation for Chinese, German, Japanese, and Korean, as well as enhancements for variable line heights that improve legibility in several languages, including Arabic, Hindi, Thai, and Vietnamese. Access localized variants of symbol images by specifying a locale. \### iPadOS - Help people customize their Stage Manager configuration by including a larger target area for dragging windows. Leverage new resizing behavior for split view controllers to get the most out of your UI in Stage Manager. - Support scrolling of your scroll view content with hardware keyboard shortcuts. This behavior is enabled by default, which you can override using \[allows Keyboard Scrolling\](/documentation/UIKit/UIScrollView/allowsKeyboardScrolling). - Simplify document management in your document-centric apps. Set your \`UIDocument\` subclass as the rename delegate of a navigation item to handle file renaming automatically. Build your content view controller from \`UIDocumentViewController\`, which provides a system default experience for managing documents: automatically configuring the title menu, sharing, drag and drop, key commands, and more. For more information, see WWDC23 session 10056: \[\](https://developer.apple.com/videos/play/wwdc2023/10056/). - Enhance the Apple Pencil experience in your iPadOS app. Give your app a sense of depth by using \[UIHover Gesture Recognizer\](/documentation/UIKit/UIHoverGestureRecognizer) to draw a preview of the stroke. Support the beautiful new inks in PencilKit, including monoline, fountain pen, watercolor, and crayon. \### Views and controls - Animate symbol images with new symbol effects, including bounce, pulse, variable color, scale, appear, disappear, and replace. - Build even more performant apps with flexible layouts using collection views. Apply diffable data source snapshots and perform batch updates with even better performance. Use the \[uniformAcrossSiblings(estimate:)\](/documentation/UIKit/NSCollectionLayoutDimension/uniformAcrossSiblings(estimate:)) dimension for compositional layouts to specify uniform size across sibling items, with smaller items increasing in size to match their largest sibling. - Simplify spring animations by providing duration and bounce parameters for the new view animation method, \[animate(springDuration:bounce:initialSpringVelocity:delay:options:animations:completion:)\](/documentation/UIKit/UIView/animate(springDuration:bounce:initialSpringVelocity:delay:options:animations:completion:)). - Represent fractional progress through a page of content with page controls. - Display and manipulate high dynamic range (HDR) images. - Display your menu as a palette with \[display As Palette\](/documentation/UIKit/UIMenu/Options-swift.struct/displayAsPalette) for it to appear as a row of menu elements for choosing from a collection of items. - Take advantage of the \[default\](/documentation/UIKit/UIStatusBarStyle/default) status bar style, which now automatically chooses a light or dark appearance that maintains contrast with the content underneath it. \## Technology updates - \[Accelerate updates\](/documentation/updates/accelerate) - \[Accessibility updates\](/documentation/updates/accessibility) - \[ActivityKit updates\](/documentation/updates/activitykit) - \[AdAttributionKit Updates\](/documentation/updates/adattributionkit) - \[App Clips updates\](/documentation/updates/appclips) - \[App Intents updates\](/documentation/updates/appintents) - \[AppKit updates\](/documentation/updates/appkit) - \[Apple Intelligence updates\](/documentation/updates/apple-intelligence) - \[AppleMapsServerAPI Updates\](/documentation/updates/applemapsserverapi) - \[Apple Pencil updates\](/documentation/updates/applepencil) - \[ARKit updates\](/documentation/updates/arkit) - \[Audio Toolbox updates\](/documentation/updates/audiotoolbox) - \[AuthenticationServices updates\](/documentation/updates/authenticationservices) - \[AVFAudio updates\](/documentation/updates/avfaudio) - \[AVFoundation updates\](/documentation/updates/avfoundation) --- \*Extracted by \[sosumi.ai\](https://sosumi.ai) - Making Apple docs AI-readable.\* \*This is unofficial content. All documentation belongs to Apple Inc.\*
```


## 来源：docs/fetched/sosumi-appkit/fetch-manifest.md


```md
# sosumi AppKit 文档抓取清单

抓取时间：2026-03-11  
抓取源：`https://sosumi.ai`  
保存目录：`docs/fetched/sosumi-appkit/`

说明：

- `.md` 为抓取到的可读文本内容
- `.html` 为原始抓取文件（本案例中已是 markdown 文本导出格式）

| 页面 | URL | 文件 |
|---|---|---|
| NSGlassEffectView | https://sosumi.ai/documentation/AppKit/NSGlassEffectView | [NSGlassEffectView.md](./NSGlassEffectView.md)、[NSGlassEffectView.html](./NSGlassEffectView.html) |
| NSGlassEffectContainerView | https://sosumi.ai/documentation/AppKit/NSGlassEffectContainerView | [NSGlassEffectContainerView.md](./NSGlassEffectContainerView.md)、[NSGlassEffectContainerView.html](./NSGlassEffectContainerView.html) |
| NSGlassEffectView.Style | https://sosumi.ai/documentation/AppKit/NSGlassEffectView/Style-swift.enum | [NSGlassEffectView-Style.md](./NSGlassEffectView-Style.md)、[NSGlassEffectView-Style.html](./NSGlassEffectView-Style.html) |
| NSButton.BezelStyle.glass | https://sosumi.ai/documentation/AppKit/NSButton/BezelStyle-swift.enum/Glass | [NSButton-BezelStyle-Glass.md](./NSButton-BezelStyle-Glass.md)、[NSButton-BezelStyle-Glass.html](./NSButton-BezelStyle-Glass.html) |
| NSBackgroundExtensionView | https://sosumi.ai/documentation/AppKit/NSBackgroundExtensionView | [NSBackgroundExtensionView.md](./NSBackgroundExtensionView.md)、[NSBackgroundExtensionView.html](./NSBackgroundExtensionView.html) |
| NSVisualEffectView | https://sosumi.ai/documentation/AppKit/NSVisualEffectView | [NSVisualEffectView.md](./NSVisualEffectView.md)、[NSVisualEffectView.html](./NSVisualEffectView.html) |
| AppKit updates | https://sosumi.ai/documentation/updates/appkit | [AppKit-updates.md](./AppKit-updates.md)、[AppKit-updates.html](./AppKit-updates.html) |
```


## 来源：docs/fetched/sosumi-appkit/NSGlassEffectView.md


```md
**Navigation:** [AppKit](/documentation/AppKit)

**Class**

# NSGlassEffectView

**Available on:** macOS 26.0+

> A view that embeds its content view in a dynamic glass effect.

```swift
class NSGlassEffectView
```

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

## Instance Properties

- [contentView](/documentation/appkit/nsglasseffectview/contentview) The view to embed in glass.
- [cornerRadius](/documentation/appkit/nsglasseffectview/cornerradius) The amount of curvature for all corners of the glass.
- [style](/documentation/appkit/nsglasseffectview/style-swift.property) The style of glass this view uses.
- [tintColor](/documentation/appkit/nsglasseffectview/tintcolor) The color the glass effect view uses to tint the background and glass effect toward.

## Liquid Glass effects

- [NSGlassEffectView.Style](/documentation/appkit/nsglasseffectview/style-swift.enum)
- [NSGlassEffectContainerView](/documentation/appkit/nsglasseffectcontainerview)

---

*Extracted by [sosumi.ai](https://sosumi.ai) - Making Apple docs AI-readable.*
*This is unofficial content. All documentation belongs to Apple Inc.*
```


## 来源：docs/fetched/sosumi-appkit/NSGlassEffectContainerView.md


```md
**Navigation:** [AppKit](/documentation/AppKit)

**Class**

# NSGlassEffectContainerView

**Available on:** macOS 26.0+

> A view that efficiently merges descendant glass effect views together when they are within a specified proximity to each other.

```swift
class NSGlassEffectContainerView
```

## Overview

> [!TIP]
> Using a glass effect container view can improve performance by reducing the number of passes required to render similar glass effect views.

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

## Instance Properties

- [contentView](/documentation/appkit/nsglasseffectcontainerview/contentview) The view that contains descendant views to merge together when in proximity to each other.
- [spacing](/documentation/appkit/nsglasseffectcontainerview/spacing) The proximity at which the glass effect container view begins merging eligible descendent glass effect views.

## Liquid Glass effects

- [NSGlassEffectView](/documentation/appkit/nsglasseffectview)
- [NSGlassEffectView.Style](/documentation/appkit/nsglasseffectview/style-swift.enum)

---

*Extracted by [sosumi.ai](https://sosumi.ai) - Making Apple docs AI-readable.*
*This is unofficial content. All documentation belongs to Apple Inc.*
```


## 来源：docs/fetched/sosumi-appkit/NSGlassEffectView-Style.md


```md
**Navigation:** [AppKit](/documentation/AppKit) › [NSGlassEffectView](/documentation/AppKit/NSGlassEffectView)

**Enumeration**

# NSGlassEffectView.Style

**Available on:** macOS 26.0+

```swift
enum Style
```

## Conforms To

- [BitwiseCopyable](/documentation/Swift/BitwiseCopyable)
- [Equatable](/documentation/Swift/Equatable)
- [Hashable](/documentation/Swift/Hashable)
- [RawRepresentable](/documentation/Swift/RawRepresentable)
- [Sendable](/documentation/Swift/Sendable)
- [SendableMetatype](/documentation/Swift/SendableMetatype)

## Enumeration Cases

- [NSGlassEffectView.Style.clear](/documentation/appkit/nsglasseffectview/style-swift.enum/clear) Clear glass effect style.
- [NSGlassEffectView.Style.regular](/documentation/appkit/nsglasseffectview/style-swift.enum/regular) Standard glass effect style.

## Initializers

- [init(rawValue:)](/documentation/appkit/nsglasseffectview/style-swift.enum/init(rawvalue:))

## Liquid Glass effects

- [NSGlassEffectView](/documentation/appkit/nsglasseffectview)
- [NSGlassEffectContainerView](/documentation/appkit/nsglasseffectcontainerview)

---

*Extracted by [sosumi.ai](https://sosumi.ai) - Making Apple docs AI-readable.*
*This is unofficial content. All documentation belongs to Apple Inc.*
```


## 来源：docs/fetched/sosumi-appkit/NSButton-BezelStyle-Glass.md


```md
**Navigation:** [AppKit](/documentation/AppKit) › [NSButton](/documentation/AppKit/NSButton) › [BezelStyle-swift.enum](/documentation/AppKit/NSButton/BezelStyle-swift.enum)

**Case**

# NSButton.BezelStyle.glass

**Available on:** macOS 26.0+

> A bezel style with a glass effect

```swift
case glass
```

---

*Extracted by [sosumi.ai](https://sosumi.ai) - Making Apple docs AI-readable.*
*This is unofficial content. All documentation belongs to Apple Inc.*
```


## 来源：docs/fetched/sosumi-appkit/NSBackgroundExtensionView.md


```md
**Navigation:** [AppKit](/documentation/AppKit)

**Class**

# NSBackgroundExtensionView

**Available on:** macOS 26.0+

> A view that extends content to fill its own bounds.

```swift
class NSBackgroundExtensionView
```

## Overview

A background extension view can be laid out to extend outside the safe area, such as under the titlebar, sidebar, or inspector. By default it lays out its content to stay within the safe area, and uses modifications of the content along the edges to fill the container view.

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

## Instance Properties

- [automaticallyPlacesContentView](/documentation/appkit/nsbackgroundextensionview/automaticallyplacescontentview) Controls the automatic safe area placement of the  within the container.
- [contentView](/documentation/appkit/nsbackgroundextensionview/contentview) The content view to extend to fill the .

---

*Extracted by [sosumi.ai](https://sosumi.ai) - Making Apple docs AI-readable.*
*This is unofficial content. All documentation belongs to Apple Inc.*
```


## 来源：docs/fetched/sosumi-appkit/NSVisualEffectView.md


```md
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
```


## 来源：docs/fetched/sosumi-appkit/AppKit-updates.md


```md
**Navigation:** [Updates](/documentation/updates)

**Article**

# AppKit updates

> Learn about important changes to AppKit.

## Overview

Browse notable changes in [appkit](https://developer.apple.com/documentation/appkit).

## June 2025

### General

- To use control metrics consistent with macOS 15 and earlier, use [prefers Compact Control Size Metrics](/documentation/AppKit/NSView/prefersCompactControlSizeMetrics).
- [Control Size-swift.enum](/documentation/AppKit/NSControl/ControlSize-swift.enum) includes a new extra large size, [extra Large](/documentation/AppKit/NSControl/ControlSize-swift.enum/extraLarge).
- Provide seamless immersive visuals by using [NSBackground Extension View](/documentation/AppKit/NSBackgroundExtensionView) to extend a view’s content under sidebars and inspectors.
- Apply Liquid Glass effects to your custom views using [NSGlass Effect View](/documentation/AppKit/NSGlassEffectView). Use [NSGlass Effect Container View](/documentation/AppKit/NSGlassEffectContainerView) to efficiently merge these views when they’re in proximity to one other.
- Configure buttons for Liquid Glass by setting `NSButton.BezelStyle` to [glass](/documentation/AppKit/NSButton/BezelStyle-swift.enum/glass).

### Split views

- Add top and bottom accessory views in split views by adding one or more [NSSplit View Item Accessory View Controller](/documentation/AppKit/NSSplitViewItemAccessoryViewController) objects to the [top Aligned Accessory View Controllers](/documentation/AppKit/NSSplitViewItem/topAlignedAccessoryViewControllers) and [bottom Aligned Accessory View Controllers](/documentation/AppKit/NSSplitViewItem/bottomAlignedAccessoryViewControllers) properties.

### Toolbars

- Tint toolbar items to make them stand out and stand apart from other toolbar items by setting [Style-swift.enum](/documentation/AppKit/NSToolbarItem/Style-swift.enum) to [prominent](/documentation/AppKit/NSToolbarItem/Style-swift.enum/prominent), and setting [background Tint Color](/documentation/AppKit/NSToolbarItem/backgroundTintColor).

## April 2025

### macOS pasteboard privacy

- Prepare your app for an upcoming feature in macOS that alerts a person using a device when your app programmatically reads the general pasteboard. The system shows the alert only if the pasteboard access wasn’t a result of someone’s input on a UI element that the system considers paste-related. This behavior is similar to how [UIPasteboard](/documentation/UIKit/UIPasteboard) behaves in iOS. New `detect` methods in [NSPasteboard](/documentation/AppKit/NSPasteboard) and [NSPasteboard Item](/documentation/AppKit/NSPasteboardItem) make it possible for an app to examine the kinds of data on the pasteboard without actually reading them and showing the alert. [NSPasteboard](/documentation/AppKit/NSPasteboard) also adds an [access Behavior](/documentation/AppKit/NSPasteboard/accessBehavior-86972) property to determine if programmatic pasteboard access is always allowed, never allowed, or if it prompts an alert requesting permission. You can adopt these APIs ahead of the change, and set a user default to test the new behavior on your Mac. To do so, launch Terminal and enter the command `defaults write <your_app_bundle_id> EnablePasteboardPrivacyDeveloperPreview -bool yes` to enable the behavior for your app.

## June 2024

### General

- Organize your windows’ display and layout with window tiling.

### Swift and SwiftUI

- Use SwiftUI menus in AppKit with the [NSHosting Menu](/documentation/SwiftUI/NSHostingMenu).
- Animate AppKit views using SwiftUI animations using [animate(_:changes:completion:)](/documentation/AppKit/NSAnimationContext/animate(_:changes:completion:)).

### API refinements

- Use the keyboard to open context menus for UI elements on which you are focused currently.
- Add repeat, wiggle, bounce, and rotate effects to [](https://developer.apple.com/sf-symbols/).
- Leverage predefined content types when saving files using the new format picker on `NSPanel`.
- Resize frames and zoom in and out with new `NSCursor` APIs such as [Frame Resize Direction](/documentation/AppKit/NSCursor/FrameResizeDirection) and [Frame Resize Position](/documentation/AppKit/NSCursor/FrameResizePosition).
- Control whether your toolbars display text as well as icons using the [allows Display Mode Customization](/documentation/AppKit/NSToolbar/allowsDisplayModeCustomization) property.
- Offer customized type-ahead suggestions in NSTextField using the [suggestions Delegate](/documentation/AppKit/NSTextField/suggestionsDelegate).

## June 2023

### Views and controls

- Use the new `userCanChangeVisibilityOf` delegate method on `NSTableView` to toggle the visibility of table columns.
- Use a new `NSProgressIndicator` property to observe progress of an ongoing task.
- Simplify how you display and style buttons with the new `.automatic` bezel style. This bezel style adapts to the most appropriate style based on the contents of the button, as well as its location in the view hierarchy.
- Display additional contextual information about currently selected documents with `NSSplitView` inspectors.
- New improvements to `NSPopover` enable you to anchor popovers from toolbar items, as well as support full-size popovers.
- Explore new UI elements in `NSMenu`. Group information more easily in section headers, lay out menu items in horizontal palettes, as well as display badge counts on menu items.

### Cooperative app activation

- App activation is now driven by the user, preventing unexpected switches between apps.
- Take advantage of Cooperative Activation, where your apps can yield and accept activation from other apps on the system without interrupting the user’s workflows. For more information, see the `activate()` function on `NSApp` and `NSRunningApplication`.

### Graphics

- `CGPath` and `NSBezierPath` are now interoperable. You can create a `CGPath` from a `NSBezierPath` and vice versa.
- Leverage `CADisplayLink` to synchronize your app’s ability to draw to the refresh of the display.
- Create consistent, great visuals for your controls by taking advantage of standard system fill `NSColor` (`.systemFill`, `.secondarySystemFill`, `.tertiarySystemFill`, `.quaternarySystemFill`, and `.quinarySystemFill`).
- Views no longer clip their contents by default. This includes any drawing done by the view and its subviews. For more information, see the `clipsToBounds` property on `NSView`.
- Animate symbol images with the new `addSymbolEffect` function on ` NSImageView`. Symbol effects include: bounce, pulse, variable color, scale, appear, disappear, and replace.
- Display and manipulate high dynamic range (HDR) images.

### Swift and SwiftUI

- AppKit more fully integrates with Swift and SwiftUI with Sendable (`NSColor`, `NSColorSpace`, `NSGradient`, `NSShadow`, `NSTouch`) and Transferable (`NSImage`, `NSColor`, `NSSound`) types.
- Preview your views and view controllers alongside your code using the new `#Preview` Swift macro. Incrementally adopt SwiftUI into your AppKit life cycle by leveraging modifiers like toolbar and navigation title on `NSWindows`.
- Simplify your code with new attributes, `@ViewLoading` and `@WindowLoading`, to help with view and window loading.

### Text improvements

- Help people enter text more effectively with the `NSTextInsertionIndicator` that adapts to the current accent color of the app. Cursor accessories also help users visualize where and how to enter text.
- Simplify `NSTextField` entry by leveraging the new `.contentType` AutoFill feature, making it more convenient to enter types such as contact information, birthdays, names, credit cards, and street addresses.
- Adopt text styles like `.body`, `largeTitle`, and `headline` on `NSFont.preferredFont`  to take advantage of enhancements to the font system, like improved hyphenation for non-English languages and dynamic line-height adjustments for languages that require more vertical space. Access localized variants of symbol images by specifying a locale.

> [!NOTE]
> Session 10054: [](https://developer.apple.com/videos/play/wwdc2023/10054/)

## Technology updates

- [Accelerate updates](/documentation/updates/accelerate)
- [Accessibility updates](/documentation/updates/accessibility)
- [ActivityKit updates](/documentation/updates/activitykit)
- [AdAttributionKit Updates](/documentation/updates/adattributionkit)
- [App Clips updates](/documentation/updates/appclips)
- [App Intents updates](/documentation/updates/appintents)
- [Apple Intelligence updates](/documentation/updates/apple-intelligence)
- [AppleMapsServerAPI Updates](/documentation/updates/applemapsserverapi)
- [Apple Pencil updates](/documentation/updates/applepencil)
- [ARKit updates](/documentation/updates/arkit)
- [Audio Toolbox updates](/documentation/updates/audiotoolbox)
- [AuthenticationServices updates](/documentation/updates/authenticationservices)
- [AVFAudio updates](/documentation/updates/avfaudio)
- [AVFoundation updates](/documentation/updates/avfoundation)
- [Background Tasks updates](/documentation/updates/backgroundtasks)

---

*Extracted by [sosumi.ai](https://sosumi.ai) - Making Apple docs AI-readable.*
*This is unofficial content. All documentation belongs to Apple Inc.*
```


## 来源：docs/fetched/sosumi-hig/fetch-manifest.md


```md
# sosumi HIG 文档抓取清单

抓取时间：2026-03-11  
抓取源：`https://sosumi.ai`  
保存目录：`docs/fetched/sosumi-hig/`

说明：

- `.md` 为抓取到的可读文本内容
- `.html` 为原始抓取文件（本案例中已是 markdown 文本导出格式）

| 页面 | URL | 文件 |
|---|---|---|
| Materials | https://sosumi.ai/design/human-interface-guidelines/materials | [materials.md](./materials.md)、[materials.html](./materials.html) |
| App Icons | https://sosumi.ai/design/human-interface-guidelines/app-icons | [app-icons.md](./app-icons.md)、[app-icons.html](./app-icons.html) |
| Buttons | https://sosumi.ai/design/human-interface-guidelines/buttons | [buttons.md](./buttons.md)、[buttons.html](./buttons.html) |
| Tab Bars | https://sosumi.ai/design/human-interface-guidelines/tab-bars | [tab-bars.md](./tab-bars.md)、[tab-bars.html](./tab-bars.html) |
| Sidebars | https://sosumi.ai/design/human-interface-guidelines/sidebars | [sidebars.md](./sidebars.md)、[sidebars.html](./sidebars.html) |
| Toolbars | https://sosumi.ai/design/human-interface-guidelines/toolbars | [toolbars.md](./toolbars.md)、[toolbars.html](./toolbars.html) |
| Search Fields | https://sosumi.ai/design/human-interface-guidelines/search-fields | [search-fields.md](./search-fields.md)、[search-fields.html](./search-fields.html) |
| Action Sheets | https://sosumi.ai/design/human-interface-guidelines/action-sheets | [action-sheets.md](./action-sheets.md)、[action-sheets.html](./action-sheets.html) |
| Sheets | https://sosumi.ai/design/human-interface-guidelines/sheets | [sheets.md](./sheets.md)、[sheets.html](./sheets.html) |
| Windows | https://sosumi.ai/design/human-interface-guidelines/windows | [windows.md](./windows.md)、[windows.html](./windows.html) |
| Lists and Tables | https://sosumi.ai/design/human-interface-guidelines/lists-and-tables | [lists-and-tables.md](./lists-and-tables.md)、[lists-and-tables.html](./lists-and-tables.html) |
| Menus | https://sosumi.ai/design/human-interface-guidelines/menus | [menus.md](./menus.md)、[menus.html](./menus.html) |
| Menu Bar | https://sosumi.ai/design/human-interface-guidelines/the-menu-bar | [the-menu-bar.md](./the-menu-bar.md)、[the-menu-bar.html](./the-menu-bar.html) |
| Icons | https://sosumi.ai/design/human-interface-guidelines/icons | [icons.md](./icons.md)、[icons.html](./icons.html) |
| Color | https://sosumi.ai/design/human-interface-guidelines/color | [color.md](./color.md)、[color.html](./color.html) |
| Split Views | https://sosumi.ai/design/human-interface-guidelines/split-views | [split-views.md](./split-views.md)、[split-views.html](./split-views.html) |
```


## 来源：docs/fetched/sosumi-hig/materials.md


```md
---
title: Materials
description: A material is a visual effect that creates a sense of depth, layering, and hierarchy between foreground and background elements.
source: https://developer.apple.com/design/human-interface-guidelines/materials
timestamp: 2026-03-11T11:52:45.150Z
---

**Navigation:** [Human Interface Guidelines](/design/human-interface-guidelines)

**article**

# Materials

> A material is a visual effect that creates a sense of depth, layering, and hierarchy between foreground and background elements.

![A sketch of overlapping squares, suggesting the use of transparency to hint at background content. The image is overlaid with rectangular and circular grid lines and is tinted yellow to subtly reflect the yellow in the original six-color Apple logo.](https://docs-assets.developer.apple.com/published/7dbd8b65138bed71acdeb36135193681/foundations-materials-intro%402x.png)

Materials help visually separate foreground elements, such as text and controls, from background elements, such as content and solid colors. By allowing color to pass through from background to foreground, a material establishes visual hierarchy to help people more easily retain a sense of place.

Apple platforms feature two types of materials: Liquid Glass, and standard materials. [Liquid Glass](/design/human-interface-guidelines/materials#Liquid-Glass) is a dynamic material that unifies the design language across Apple platforms, allowing you to present controls and navigation without obscuring underlying content. In contrast to Liquid Glass, the [Standard materials](/design/human-interface-guidelines/materials#Standard-materials) help with visual differentiation within the content layer.

## Liquid Glass

Liquid Glass forms a distinct functional layer for controls and navigation elements — like tab bars and sidebars — that floats above the content layer, establishing a clear visual hierarchy between functional elements and content. Liquid Glass allows content to scroll and peek through from beneath these elements to give the interface a sense of dynamism and depth, all while maintaining legibility for controls and navigation.

**Don’t use Liquid Glass in the content layer.** Liquid Glass works best when it provides a clear distinction between interactive elements and content, and including it in the content layer can result in unnecessary complexity and a confusing visual hierarchy. Instead, use [Standard materials](/design/human-interface-guidelines/materials#Standard-materials) for elements in the content layer, such as app backgrounds. An exception to this is for controls in the content layer with a transient interactive element like [Sliders](/design/human-interface-guidelines/sliders) and [Toggles](/design/human-interface-guidelines/toggles); in these cases, the element takes on a Liquid Glass appearance to emphasize its interactivity when a person activates it.

**Use Liquid Glass effects sparingly.** Standard components from system frameworks pick up the appearance and behavior of this material automatically. If you apply Liquid Glass effects to a custom control, do so sparingly. Liquid Glass seeks to bring attention to the underlying content, and overusing this material in multiple custom controls can provide a subpar user experience by distracting from that content. Limit these effects to the most important functional elements in your app. For developer guidance, see [Applying Liquid Glass to custom views](/documentation/SwiftUI/Applying-Liquid-Glass-to-custom-views).

**Only use clear Liquid Glass for components that appear over visually rich backgrounds.** Liquid Glass provides two variants — [regular](/documentation/SwiftUI/Glass/regular) and [clear](/documentation/SwiftUI/Glass/clear) — that you can choose when building custom components or styling some system components. The appearance of these variants can differ in response to certain system settings, like if people choose a preferred look for Liquid Glass in their device’s display settings, or turn on accessibility settings that reduce transparency or increase contrast in the interface.

The *regular* variant blurs and adjusts the luminosity of background content to maintain legibility of text and other foreground elements. Scroll edge effects further enhance legibility by blurring and reducing the opacity of background content. Most system components use this variant. Use the regular variant when background content might create legibility issues, or when components have a significant amount of text, such as alerts, sidebars, or popovers.

![A visual example of the regular variant of Liquid Glass, which appears darker when there is a dark background beneath it.](https://docs-assets.developer.apple.com/published/91bd48556358ab3deb6720c982aa8503/materials-ios-liquid-glass-regular-on-dark%402x.png)

![A visual example of the regular variant of Liquid Glass, which appears lighter when there is a light background beneath it.](https://docs-assets.developer.apple.com/published/07aee30876315c8b2985a59a3ac1df31/materials-ios-liquid-glass-regular-on-light%402x.png)

The *clear* variant is highly translucent, which is ideal for prioritizing the visibility of the underlying content and ensuring visually rich background elements remain prominent. Use this variant for components that float above media backgrounds — such as photos and videos — to create a more immersive content experience.

![A visual example of the clear variant of Liquid Glass, which allows the visual detail of the background beneath it to show through.](https://docs-assets.developer.apple.com/published/fe0cd9171626ada19f9ea7343f60a426/materials-ios-liquid-glass-clear%402x.png)

For optimal contrast and legibility, determine whether to add a dimming layer behind components with clear Liquid Glass:

- If the underlying content is bright, consider adding a dark dimming layer of 35% opacity. For developer guidance, see [clear](/documentation/SwiftUI/Glass/clear).
- If the underlying content is sufficiently dark, or if you use standard media playback controls from AVKit that provide their own dimming layer, you don’t need to apply a dimming layer.

For guidance about the use of color, see [Liquid Glass color](/design/human-interface-guidelines/color#Liquid-Glass-color).

## Standard materials

Use standard materials and effects — such as [UIBlurEffect](/documentation/UIKit/UIBlurEffect), [UIVibrancyEffect](/documentation/UIKit/UIVibrancyEffect), and [NSVisualEffectView.BlendingMode](/documentation/AppKit/NSVisualEffectView/BlendingMode-swift.enum) — to convey a sense of structure in the content beneath Liquid Glass.

**Choose materials and effects based on semantic meaning and recommended usage.** Avoid selecting a material or effect based on the apparent color it imparts to your interface, because system settings can change its appearance and behavior. Instead, match the material or vibrancy style to your specific use case.

**Help ensure legibility by using vibrant colors on top of materials.** When you use system-defined vibrant colors, you don’t need to worry about colors seeming too dark, bright, saturated, or low contrast in different contexts. Regardless of the material you choose, use vibrant colors on top of it. For guidance, see [System colors](/design/human-interface-guidelines/color#System-colors).

![An illustration of a Share button with a translucent background material and a symbol. The symbol uses the systemGray3 color and is difficult to see against the background material.](https://docs-assets.developer.apple.com/published/8a395765f911660a5e16b3bdb30ddd2f/materials-legibility-non-vibrant-label%402x.png)

![An X in a circle to indicate incorrect usage](https://docs-assets.developer.apple.com/published/209f6f0fc8ad99d9bf59e12d82d06584/crossout%402x.png)

![An illustration of a Share button with a translucent background material and a symbol. The symbol uses vibrant color and is clearly visible against the background material.](https://docs-assets.developer.apple.com/published/7495cfbce7d79a1f5635ea2a729dfc24/materials-legibility-primary-label%402x.png)

![A checkmark in a circle to indicate correct usage](https://docs-assets.developer.apple.com/published/88662da92338267bb64cd2275c84e484/checkmark%402x.png)

**Consider contrast and visual separation when choosing a material to combine with blur and vibrancy effects.** For example, consider that:

- Thicker materials, which are more opaque, can provide better contrast for text and other elements with fine features.
- Thinner materials, which are more translucent, can help people retain their context by providing a visible reminder of the content that’s in the background.

For developer guidance, see [Material](/documentation/SwiftUI/Material).

## Platform considerations

### iOS, iPadOS

In addition to Liquid Glass, iOS and iPadOS continue to provide four standard materials — ultra-thin, thin, regular (default), and thick — which you can use in the content layer to help create visual distinction.

![An illustration of the iOS and iPadOS ultraThin material above a colorful background. Where the material overlaps the background, it provides a diffuse gradient of the background colors.](https://docs-assets.developer.apple.com/published/2ad0598be0bf67fb23e479f102e16b59/materials-ios-material-background-ultrathin%402x.png)

![An illustration of the iOS and iPadOS thin material above a colorful background. Where the material overlaps the background, it provides a diffuse and slightly darkened gradient of the background colors.](https://docs-assets.developer.apple.com/published/d298de701d98a146b1436fdf21d0b7ce/materials-ios-material-background-thin%402x.png)

![An illustration of the iOS and iPadOS regular material above a colorful background. Where the material overlaps the background, it provides a diffuse and darkened gradient of the background colors.](https://docs-assets.developer.apple.com/published/93a77ac4cfc0786664563a0691498b05/materials-ios-material-background-regular%402x.png)

![An illustration of the iOS and iPadOS thick material above a colorful background. Where the material overlaps the background, it provides a dark, muted gradient of the background colors.](https://docs-assets.developer.apple.com/published/2532ddf965d0effa12f528ac10b5a0b3/materials-ios-material-background-thick%402x.png)

iOS and iPadOS also define vibrant colors for labels, fills, and separators that are specifically designed to work with each material. Labels and fills both have several levels of vibrancy; separators have one level. The name of a level indicates the relative amount of contrast between an element and the background: The default level has the highest contrast, whereas quaternary (when it exists) has the lowest contrast.

Except for quaternary, you can use the following vibrancy values for labels on any material. In general, avoid using quaternary on top of the [thin](/documentation/SwiftUI/Material/thin) and [ultraThin](/documentation/SwiftUI/Material/ultraThin) materials, because the contrast is too low.

- [UIVibrancyEffectStyle.label](/documentation/UIKit/UIVibrancyEffectStyle/label) (default)
- [UIVibrancyEffectStyle.secondaryLabel](/documentation/UIKit/UIVibrancyEffectStyle/secondaryLabel)
- [UIVibrancyEffectStyle.tertiaryLabel](/documentation/UIKit/UIVibrancyEffectStyle/tertiaryLabel)
- [UIVibrancyEffectStyle.quaternaryLabel](/documentation/UIKit/UIVibrancyEffectStyle/quaternaryLabel)

You can use the following vibrancy values for fills on all materials.

- [UIVibrancyEffectStyle.fill](/documentation/UIKit/UIVibrancyEffectStyle/fill) (default)
- [UIVibrancyEffectStyle.secondaryFill](/documentation/UIKit/UIVibrancyEffectStyle/secondaryFill)
- [UIVibrancyEffectStyle.tertiaryFill](/documentation/UIKit/UIVibrancyEffectStyle/tertiaryFill)

The system provides a single, default vibrancy value for a [UIVibrancyEffectStyle.separator](/documentation/UIKit/UIVibrancyEffectStyle/separator), which works well on all materials.

### macOS

macOS provides several standard materials with designated purposes, and vibrant versions of all [Specifications](/design/human-interface-guidelines/color#Specifications). For developer guidance, see [NSVisualEffectView.Material](/documentation/AppKit/NSVisualEffectView/Material-swift.enum).

**Choose when to allow vibrancy in custom views and controls.** Depending on configuration and system settings, system views and controls use vibrancy to make foreground content stand out against any background. Test your interface in a variety of contexts to discover when vibrancy enhances the appearance and improves communication.

**Choose a background blending mode that complements your interface design.** macOS defines two modes that blend background content: behind window and within window. For developer guidance, see [NSVisualEffectView.BlendingMode](/documentation/AppKit/NSVisualEffectView/BlendingMode-swift.enum).

### tvOS

In tvOS, Liquid Glass appears throughout navigation elements and system experiences such as Top Shelf and Control Center. Certain interface elements, like image views and buttons, adopt Liquid Glass when they gain focus.

![A screenshot of the Destination Video app running in tvOS. The app shows a screen with details about a video called A BOT-anist Adventure. The background is a colorful image of the main character in a scene from the video. The interface elements floating above the background adopt a Liquid Glass appearance to allow background color to show through and create a more immersive media experience.](https://docs-assets.developer.apple.com/published/fd83bb7f079cac7b59cb692d8e1c6707/materials-tvos-media-player%402x.png)

In addition to Liquid Glass, tvOS continues to provide standard materials, which you can use to help define structure in the content layer. The thickness of a standard material affects how prominently the underlying content shows through. For example, consider using standard materials in the following ways:

| Material | Recommended for |
| --- | --- |
| [ultraThin](/documentation/SwiftUI/Material/ultraThin) | Full-screen views that require a light color scheme |
| [thin](/documentation/SwiftUI/Material/thin) | Overlay views that partially obscure onscreen content and require a light color scheme |
| [regular](/documentation/SwiftUI/Material/regular) | Overlay views that partially obscure onscreen content |
| [thick](/documentation/SwiftUI/Material/thick) | Overlay views that partially obscure onscreen content and require a dark color scheme |

### visionOS

In visionOS, windows generally use an unmodifiable system-defined material called *glass* that helps people stay grounded by letting light, the current Environment, virtual content, and objects in people’s surroundings show through. Glass is an adaptive material that limits the range of background color information so a window can continue to provide contrast for app content while becoming brighter or darker depending on people’s physical surroundings and other virtual content.

[A recording of the Music app window in visionOS. The window uses the glass material and adapts as the viewing angle and lighting change.](https://docs-assets.developer.apple.com/published/867bebad45a7ed782893751ddcc6a83d/visionos-glass-material-transition.mp4)

> [!NOTE]
> visionOS doesn’t have a distinct Dark Mode setting. Instead, glass automatically adapts to the luminance of the objects and colors behind it.

**Prefer translucency to opaque colors in windows.** Areas of opacity can block people’s view, making them feel constricted and reducing their awareness of the virtual and physical objects around them.

![An illustration of a field of view in visionOS with a window in the center. The window has an opaque background that obstructs its surroundings.](https://docs-assets.developer.apple.com/published/137ceb38a96227aa8a9d2021ee82a8e2/materials-visionos-opaque-window-incorrect%402x.png)

![An X in a circle to indicate incorrect usage](https://docs-assets.developer.apple.com/published/209f6f0fc8ad99d9bf59e12d82d06584/crossout%402x.png)

![An illustration of a field of view in visionOS with a window in the center. The window has a translucent material background that allows its surroundings to pass through.](https://docs-assets.developer.apple.com/published/3f23b3476f6cf8cc77fdcb91a0c15063/materials-visionos-glass-window%402x.png)

![A checkmark in a circle to indicate correct usage](https://docs-assets.developer.apple.com/published/88662da92338267bb64cd2275c84e484/checkmark%402x.png)

**If necessary, choose materials that help you create visual separations or indicate interactivity in your app.** If you need to create a custom component, you may need to specify a system material for it. Use the following examples for guidance.

- The [thin](/documentation/SwiftUI/Material/thin) material brings attention to interactive elements like buttons and selected items.
- The [regular](/documentation/SwiftUI/Material/regular) material can help you visually separate sections of your app, like a sidebar or a grouped table view.
- The [thick](/documentation/SwiftUI/Material/thick) material lets you create a dark element that remains visually distinct when it’s on top of an area that uses a `regular` background.

![An illustration of a field of view in visionOS with a window in the center. The window is composed of a sidebar on the left and a content area on the right, with a text field at the top and a button in the lower-right corner. The sidebar uses regular material, while the text field uses thick material and the button uses thin material.](https://docs-assets.developer.apple.com/published/c3577aa1e00689431e49973173a151f9/visionos-materials-window-example%402x.png)

To ensure foreground content remains legible when it displays on top of a material, visionOS applies vibrancy to text, symbols, and fills. Vibrancy enhances the sense of depth by pulling light and color forward from both virtual and physical surroundings.

visionOS defines three vibrancy values that help you communicate a hierarchy of text, symbols, and fills.

- Use [UIVibrancyEffectStyle.label](/documentation/UIKit/UIVibrancyEffectStyle/label) for standard text.
- Use [UIVibrancyEffectStyle.secondaryLabel](/documentation/UIKit/UIVibrancyEffectStyle/secondaryLabel) for descriptive text like footnotes and subtitles.
- Use [UIVibrancyEffectStyle.tertiaryLabel](/documentation/UIKit/UIVibrancyEffectStyle/tertiaryLabel) for inactive elements, and only when text doesn’t need high legibility.

![An illustration of a Share button with a translucent background material and a symbol. The symbol uses the default vibrant label color and has very high contrast against the background material.](https://docs-assets.developer.apple.com/published/8f850521ecc2e3953e8e693fe7b4887b/materials-visionos-label-vibrant-primary%402x.png)

![An illustration of a Share button with a translucent background material and a symbol. The symbol uses the secondary vibrant label color and has high contrast against the background material.](https://docs-assets.developer.apple.com/published/876503f2b2b5fd1783e359128ffd2482/materials-visionos-label-vibrant-secondary%402x.png)

![An illustration of a Share button with a translucent background material and a symbol. The symbol uses the tertiary vibrant label color and has muted contrast against the background material.](https://docs-assets.developer.apple.com/published/b3b80e5f23b286f6c7897780676e6dfe/materials-visionos-label-vibrant-tertiary%402x.png)

### watchOS

**Use materials to provide context in a full-screen modal view.** Because full-screen modal views are common in watchOS, the contrast provided by material layers can help orient people in your app and distinguish controls and system elements from other content. Avoid removing or replacing material backgrounds for modal sheets when they’re provided by default.

![An illustration of a modal view in watchOS with an example title, descriptive text, and a single action button. The modal completely covers the screen with a transparent material, and uses a thinner material for the button along with vibrant label text.](https://docs-assets.developer.apple.com/published/b9bdbaa947d461e98681c9fbb87a7052/watchos-modal-view-material-background%402x.png)

## Resources

#### Related

[Color](/design/human-interface-guidelines/color)

[Accessibility](/design/human-interface-guidelines/accessibility)

[Dark Mode](/design/human-interface-guidelines/dark-mode)

#### Developer documentation

[Adopting Liquid Glass](/documentation/TechnologyOverviews/adopting-liquid-glass)

[glassEffect(_:in:)](/documentation/SwiftUI/View/glassEffect(_:in:)) — SwiftUI

[Material](/documentation/SwiftUI/Material) — SwiftUI

[UIVisualEffectView](/documentation/UIKit/UIVisualEffectView) — UIKit

[NSVisualEffectView](/documentation/AppKit/NSVisualEffectView) — AppKit

#### Videos

- [Meet Liquid Glass](https://developer.apple.com/videos/play/wwdc2025/219) - Liquid Glass unifies Apple platform design language while providing a more dynamic and expressive user experience. Get to know the design principles of Liquid Glass, explore its core optical and physical properties, and learn where to use it and why.
- [Get to know the new design system](https://developer.apple.com/videos/play/wwdc2025/356) - Dive deeper into the new design system to explore key changes to visual design, information architecture, and core system components. Learn how the system reshapes the relationship between interface and content, enabling you to create designs that are dynamic, harmonious, and consistent across devices, screen sizes, and input modes.

## Change log

| Date | Changes |
| --- | --- |
| September 9, 2025 | Updated guidance for Liquid Glass. |
| June 9, 2025 | Added guidance for Liquid Glass. |
| August 6, 2024 | Added platform-specific art. |
| December 5, 2023 | Updated descriptions of the various material types, and clarified terms related to vibrancy and material thickness. |
| June 21, 2023 | Updated to include guidance for visionOS. |
| June 5, 2023 | Added guidance on using materials to provide context and orientation in watchOS apps. |

---

*Extracted by [sosumi.ai](https://sosumi.ai) - Making Apple docs AI-readable.*
*This is unofficial content. All Human Interface Guidelines belong to Apple Inc.*
```


## 来源：docs/fetched/sosumi-hig/app-icons.md


```md
**Navigation:** [Human Interface Guidelines](/design/human-interface-guidelines)

**article**

# App icons

> A unique, memorable icon expresses your app’s or game’s purpose and personality and helps people recognize it at a glance.

![A sketch of the App Store icon. The image is overlaid with rectangular and circular grid lines and is tinted yellow to subtly reflect the yellow in the original six-color Apple logo.](https://docs-assets.developer.apple.com/published/05b8bbb4aac9f98ba8c77876fe5068b7/foundations-app-icons-intro%402x.png)

Your app icon is a crucial aspect of your app’s or game’s branding and user experience. It appears on the Home Screen and in key locations throughout the system, including search results, notifications, system settings, and share sheets. A well-designed app icon conveys your app’s or game’s identity clearly and consistently across all Apple platforms.

![An image that shows three variations of the Photos app's app icon as it appears on different platforms. The first variation is a rounded rectangle shape, and represents the iOS, iPadOS, and macOS icons. The second variation is an elongated, rounded rectangular shape, and represents the tvOS icon. The third variation is a circular shape, and represents the visionOS and watchOS icons. All variations have the same overall design over different background shapes.](https://docs-assets.developer.apple.com/published/298204fa29c2dc771deb8651963ce75a/app-icons-platform-appearance-overview%402x.png)

## Layer design

Although you can provide a flattened image for your icon, layers give you the most control over how your icon design is represented. A layered app icon comes together to produce a sense of depth and vitality. On each platform, the system applies visual effects that respond to the environment and people’s interactions.

iOS, iPadOS, macOS, and watchOS app icons include a background layer and one or more foreground layers that coalesce to create dimensionality. These icons take on Liquid Glass attributes like specular highlights, frostiness, and translucency, which respond to changes in lighting and, in iOS and iPadOS, device movement.

[iOS app icon](https://docs-assets.developer.apple.com/published/35ad210125298fe080016a9ed31904eb/app-icons-podcasts-ios-layers-animation.mp4)

tvOS app icons use between two and five layers to create a sense of dynamism as people bring them into focus. When focused, the app icon elevates to the foreground in response to someone’s finger movement on their remote, and gently sways while the surface illuminates. The separation between layers and the use of transparency produce a feeling of depth during the parallax effect.

[tvOS app icon](https://docs-assets.developer.apple.com/published/9b373f797757be47695d8a7a089b7bdc/app-icons-tvos-parallax-photos-icon.mp4)

A visionOS app icon includes a background layer and one or two layers on top, producing a three-dimensional object that subtly expands when people view it. The system enhances the icon’s visual dimensionality by adding shadows that convey a sense of depth between layers and by using the alpha channel of the upper layers to create an embossed appearance.

[visionOS app icon](https://docs-assets.developer.apple.com/published/bab0ee20b58150127a28d50aa69d13dd/visionos-app-icon-showcase.mp4)

You use your favorite design tool to craft the individual foreground layers of your app icon. For iOS, iPadOS, macOS, and watchOS icons, you then import your icon layers into Icon Composer, a design tool included with Xcode and available from the [Apple Developer website](https://developer.apple.com/icon-composer). In Icon Composer, you define the background layer for your icon, adjust your foreground layer placement, apply visual effects like transparency, define default, dark, clear, and tinted appearance variants, and export your icon for use in Xcode. For additional guidance, see [Creating your app icon using Icon Composer](/documentation/Xcode/creating-your-app-icon-using-icon-composer).

![A screenshot of the Photos app icon in Icon Composer.](https://docs-assets.developer.apple.com/published/3d4f8c4c6b744e77f32802201fb48fb7/app-icons-icon-composer-overview-photos%402x.png)

For tvOS and visionOS app icons, you add your icon layers directly to an image stack in Xcode to form your complete icon. For developer guidance, see [Configuring your app icon using an asset catalog](/documentation/Xcode/configuring-your-app-icon).

**Prefer clearly defined edges in foreground layers.** To ensure system-drawn highlights and shadows look best, avoid soft and feathered edges on foreground layer shapes.

**Vary opacity in foreground layers to increase the sense of depth and liveliness.** For example, the Photos icon separates its centerpiece into multiple layers that contain translucent pieces, bringing greater dynamism to the design. Importing fully opaque layers and adjusting transparency in Icon Composer lets you preview and make adjustments to your design based on how transparency and system effects impact one another.

**Design a background that both stands out and emphasizes foreground content.** Subtle top-to-bottom, light-to-dark gradients tend to respond well to system lighting effects. Icon Composer supports solid colors and gradients for background layers, making it unnecessary to import custom background images in most cases. If you do import a background layer, make sure it’s full-bleed and opaque.

**Prefer vector graphics when bringing layers into Icon Composer.** Unlike raster images, vector graphics (such as SVG or PDF) scale gracefully and appear crisp at any size. Outline artwork and convert text to outline in your design. For mesh gradients and raster artwork, prefer PNG format because it’s a lossless image format.

## Icon shape

An app icon’s shape varies based on a platform’s visual language. In iOS, iPadOS, and macOS, icons are square, and the system applies masking to produce rounded corners that precisely match the curvature of other rounded interface elements throughout the system and the bezel of the physical device itself. In tvOS, icons are rectangular, also with concentric edges. In visionOS and watchOS, icons are square and the system applies circular masking.

**Produce appropriately shaped, unmasked layers.** The system masks all layer edges to produce an icon’s final shape. For iOS, iPadOS, and macOS icons, provide square layers so the system can apply rounded corners. For visionOS and watchOS, provide square layers so the system can create the circular icon shape. For tvOS, provide rectangular layers so the system can apply rounded corners. Providing layers with pre-defined masking negatively impacts specular highlight effects and makes edges look jagged.

**Keep primary content centered to avoid truncation when the system adjusts corners or applies masking.** Pay particular attention to centering content in visionOS and watchOS icons. To help with icon placement, use the grids in the app icon production templates, which you can find in [Apple Design Resources](https://developer.apple.com/design/resources/).

## Design

Embrace simplicity in your icon design. Simple icons tend to be easiest for people to understand and recognize. An icon with fine visual features might look busy when rendered with system-provided shadows and highlights, and details may be hard to discern at smaller sizes. Find a concept or element that captures the essence of your app or game, make it the core idea of your icon, and express it in a simple, unique way with a minimal number of shapes. Prefer a simple background, such as a solid color or gradient, that puts the emphasis on your primary design — you don’t need to fill the entire icon canvas with content.

![An image of the Podcasts app icon.](https://docs-assets.developer.apple.com/published/58a62b07273dbbc302df7a428103a16e/app-icons-embrace-simplicity-podcasts%402x.png)

![An image of the Home app icon.](https://docs-assets.developer.apple.com/published/4932ee4d526fc1b112e611f610a18b08/app-icons-embrace-simplicity-home%402x.png)

**Provide a visually consistent icon design across all the platforms your app supports.** A consistent design helps people quickly find your app wherever it appears and prevents people from mistaking your app for multiple apps.

**Consider basing your icon design around filled, overlapping shapes.** Overlapping solid shapes in the foreground, particularly when paired with transparency and blurring, can give an icon a sense of depth.

![An illustration of two circles centered above a grid. One circle encloses the other. The inner circle has a solid fill. The outer circle is larger than the inner circle, allowing some space between them. The outer circle has no fill and shows just an outline.](https://docs-assets.developer.apple.com/published/6b02e91996a97adb2dbe53a8131cc380/app-icons-element-outline-shape%402x.png)

![An X in a circle to indicate incorrect usage.](https://docs-assets.developer.apple.com/published/209f6f0fc8ad99d9bf59e12d82d06584/crossout%402x.png)

![An illustration of two circles centered above a grid. One circle encloses the other. The inner circle has a solid fill. The outer circle is larger than the inner circle, has no outline, and has a semi-transparent fill that allows the background grid to show through. Together, the two circles give the impression that the inner circle is resting upon the outer circle.](https://docs-assets.developer.apple.com/published/a8d0e9d7b802123c594cf9910fb44a50/app-icons-element-filled-shape%402x.png)

![A checkmark in a circle to indicate correct usage.](https://docs-assets.developer.apple.com/published/88662da92338267bb64cd2275c84e484/checkmark%402x.png)

**Include text only when it’s essential to your experience or brand.** Text in icons doesn’t support accessibility or localization, is often too small to read easily, and can make an icon appear cluttered. In some contexts, your app name already appears nearby, making it redundant to display the name within the icon itself. Although displaying a mnemonic like the first letter of your app’s name can help people recognize your app or game, avoid including nonessential words that tell people what to do with it — like “Watch” or “Play” — or context-specific terms like “New” or “For visionOS.” If you include text in a tvOS app icon, make sure it’s above other layers so it’s not cropped by the parallax effect.

**Prefer illustrations to photos and avoid replicating UI components.** Photos are full of details that don’t work well when displayed in different appearances, viewed at small sizes, or split into layers. Instead of using photos, create a graphic representation of the content that emphasizes the features you want people to notice. Similarly, if your app has an interface that people recognize, don’t just replicate standard UI components or use app screenshots in your icon.

**Don’t use replicas of Apple hardware products.** Apple products are copyrighted and can’t be reproduced in your app icons.

## Visual effects

**Let the system handle blurring and other visual effects.** The system dynamically applies visual effects to your app icon layers, so there’s no need to include specular highlights, drop shadows between layers, beveled edges, blurs, glows, and other effects. In addition to interfering with system-provided effects, custom effects are static, whereas the system supplies dynamic ones. If you do include custom visual effects on your icon layers, use them intentionally and test carefully with Icon Composer, in Simulator, or on device to make sure they appear as expected and don’t conflict with system effects.

**Create layer groupings to apply effects to multiple layers at once.** System effects typically occur on individual layers. If it makes sense for your design, however, you can group several layers together in Icon Composer or your design tool so effects occur at the group level.

## Appearances

In iOS, iPadOS, and macOS, people can choose whether their Home Screen app icons are default, dark, clear, or tinted in appearance. For example, someone may want to personalize their app icon appearance to complement their wallpaper. You can design app icon variants for every appearance variant, and the system automatically generates variants you don’t provide.

![A grid showing the six different appearances of the Photos app icon in iOS. The top row shows the default, clear light, and tinted light icon variants. The bottom row shows the dark, clear dark, and tinted dark variants.](https://docs-assets.developer.apple.com/published/a91b68946df73b81596a9a29b0356a4a/app-icons-rendering-modes%402x.png)

**Keep your icon’s features consistent across appearances.** To create a seamless experience, keep your icon’s core visual features the same in the default, dark, clear, and tinted appearances. Avoid creating custom icon variants that swap elements in and out with each variant, which may make it harder for people to find your app when they switch appearances.

**Design dark and tinted icons that feel at home beside system app icons and widgets.** You can preserve the color palette of your default icon, but be mindful that dark icons are more subdued, and clear and tinted icons are even more so. A great app icon is visible, legible, and recognizable, regardless of its appearance variant.

**Use your light app icon as the basis for your dark icon.** Choose complementary colors that reflect the default design, and avoid excessively bright images. Color backgrounds generally offer the greatest contrast in dark icons. For guidance, see [Dark Mode](/design/human-interface-guidelines/dark-mode).

**Consider offering alternate app icons.** In iOS, iPadOS, tvOS, and compatible apps running in visionOS, it’s possible to let people visit your app’s settings to choose an alternate version of your app icon. For example, a sports app might offer icons for different teams, letting someone choose their favorite. If you offer this capability, make sure each icon you design remains closely related to your content and experience. Avoid creating one someone might mistake for another app.

> [!NOTE]
> Alternate app icons in iOS and iPadOS require their own dark, clear, and tinted variants. As with your default app icon, all alternate and variant icons are subject to app review and must adhere to the [App Review Guidelines](https://developer.apple.com/app-store/review/guidelines/#design).

## Platform considerations

*No additional considerations for iOS, iPadOS, or macOS.*

### tvOS

**Include a safe zone to ensure the system doesn’t crop your content.** When someone focuses your app icon, the system may crop content around the edges as the icon scales and moves. To ensure that your icon’s content is always visible, keep a safe zone around it. Be aware that the safe zone can vary, depending on the image size, layer depth, and motion, and the system crops foreground layers more than background layers.

![A diagram of the Photos app icon in tvOS with a white dotted line inside the outer border, which indicates the safe zone.](https://docs-assets.developer.apple.com/published/f2f3bf70c87e53889768b64a2faf5cf5/tvos-app-icon-safe-zone%402x.png)

### visionOS

**Avoid adding a shape that’s intended to look like a hole or concave area to the background layer.** The system-added shadow and specular highlights can make such a shape stand out instead of recede.

### watchOS

**Avoid using black for your icon’s background.** Lighten a black background so the icon doesn’t blend into the display background.

## Specifications

The layout, size, style, and appearances of app icons vary by platform.

| Platform | Layout shape | Icon shape after system masking | Layout size | Style | Appearances |
| --- | --- | --- | --- | --- | --- |
| iOS, iPadOS, macOS | Square | Rounded rectangle (square) | 1024x1024 px | Layered | Default, dark, clear light, clear dark, tinted light, tinted dark |
| tvOS | Rectangle (landscape) | Rounded rectangle (rectangular) | 800x480 px | Layered (Parallax) | N/A |
| visionOS | Square | Circular | 1024x1024 px | Layered (3D) | N/A |
| watchOS | Square | Circular | 1088x1088 px | Layered | N/A |

The system automatically scales your icon to produce smaller variants that appear in certain locations, such as Settings and notifications.

App icons support the following color spaces:

- sRGB (color)
- Gray Gamma 2.2 (grayscale)
- Display P3 (wide-gamut color in iOS, iPadOS, macOS, tvOS, and watchOS only)

## Resources

#### Related

[Apple Design Resources](https://developer.apple.com/design/resources/)

[Icon Composer](https://developer.apple.com/icon-composer/)

[Icons](/design/human-interface-guidelines/icons)

[Images](/design/human-interface-guidelines/images)

[Dark Mode](/design/human-interface-guidelines/dark-mode)

#### Developer documentation

[Creating your app icon using Icon Composer](/documentation/Xcode/creating-your-app-icon-using-icon-composer)

[Configuring your app icon using an asset catalog](/documentation/Xcode/configuring-your-app-icon)

#### Videos

- [Say hello to the new look of app icons](https://developer.apple.com/videos/play/wwdc2025/220) - Get an overview of the new app icon appearances for iOS, iPadOS, and macOS, including light and dark tints, and clear options. Learn how to use frostiness and translucency to make your app icon more vibrant, dynamic, and expressive, and find out how to ensure your icon works well with specular highlights.
- [Create icons with Icon Composer](https://developer.apple.com/videos/play/wwdc2025/361) - Learn how to use Icon Composer to make updated app icons for iOS, iPadOS, macOS, and watchOS. Find out how to export assets from your design tool of choice, add them to Icon Composer, apply real-time glass properties and other effects, and preview and adjust for different platforms and appearance modes.

## Change log

| Date | Changes |
| --- | --- |
| June 9, 2025 | Updated guidance to reflect layered icons, consistency across platforms, and best practices for Liquid Glass. |
| June 10, 2024 | Added guidance for creating dark and tinted app icon variants for iOS and iPadOS. |
| January 31, 2024 | Clarified platform availability for alternate app icons. |
| June 21, 2023 | Updated to include guidance for visionOS. |
| September 14, 2022 | Added specifications for Apple Watch Ultra. |

---

*Extracted by [sosumi.ai](https://sosumi.ai) - Making Apple docs AI-readable.*
*This is unofficial content. All Human Interface Guidelines belong to Apple Inc.*
```


## 来源：docs/fetched/sosumi-hig/buttons.md


```md
**Navigation:** [Human Interface Guidelines](/design/human-interface-guidelines)

**article**

# Buttons

> A button initiates an instantaneous action.

![A stylized representation of two horizontally aligned buttons. The image is tinted red to subtly reflect the red in the original six-color Apple logo.](https://docs-assets.developer.apple.com/published/15781cd4e57f0e78b7a388a3fa009fa8/components-buttons-intro%402x.png)

Versatile and highly customizable, buttons give people simple, familiar ways to do tasks in your app. In general, a button combines three attributes to clearly communicate its function:

- **Style.** A visual style based on size, color, and shape.
- **Content.** A symbol (or icon), text label, or both that a button displays to convey its purpose.
- **Role.** A system-defined role that identifies a button’s semantic meaning and can affect its appearance.

There are also many button-like components that have distinct appearances and behaviors for specific use cases, like [Toggles](/design/human-interface-guidelines/toggles), [Pop-up buttons](/design/human-interface-guidelines/pop-up-buttons), and [Segmented controls](/design/human-interface-guidelines/segmented-controls).

## Best practices

When buttons are instantly recognizable and easy to understand, an app tends to feel intuitive and well designed.

**Make buttons easy for people to use.** It’s essential to include enough space around a button so that people can visually distinguish it from surrounding components and content. Giving a button enough space is also critical for helping people select or activate it, regardless of the method of input they use. As a general rule, a button needs a hit region of at least 44x44 pt — in visionOS, 60x60 pt — to ensure that people can select it easily, whether they use a fingertip, a pointer, their eyes, or a remote.

**Always include a press state for a custom button.** Without a press state, a button can feel unresponsive, making people wonder if it’s accepting their input.

## Style

System buttons offer a range of styles that support customization while providing built-in interaction states, accessibility support, and appearance adaptation. Different platforms define different styles that help you communicate hierarchies of actions in your app.

**In general, use a button that has a prominent visual style for the most likely action in a view.** To draw people’s attention to a specific button, use a prominent button style so the system can apply an accent color to the button’s background. Buttons that use color tend to be the most visually distinctive, helping people quickly identify the actions they’re most likely to use. Keep the number of prominent buttons to one or two per view. Presenting too many prominent buttons increases cognitive load, requiring people to spend more time considering options before making a choice.

**Use style — not size — to visually distinguish the preferred choice among multiple options.** When you use buttons of the same size to offer two or more options, you signal that the options form a coherent set of choices. By contrast, placing two buttons of different sizes near each other can make the interface look confusing and inconsistent. If you want to highlight the preferred or most likely option in a set, use a more prominent button style for that option and a less prominent style for the remaining ones.

**Avoid applying a similar color to button labels and content layer backgrounds.** If your app already has bright, colorful content in the content layer, prefer using the default monochromatic appearance of button labels. For more guidance, see [Liquid Glass color](/design/human-interface-guidelines/color#Liquid-Glass-color).

## Content

**Ensure that each button clearly communicates its purpose.** Depending on the platform, a button can contain a symbol (or icon), a text label, or both to help people understand what it does.

> [!NOTE]
> In macOS and visionOS, the system displays a tooltip after people hover over a button for a moment. A tooltip displays a brief phrase that explains what a button does; for guidance, see [Offering help](/design/human-interface-guidelines/offering-help).

**Try to associate familiar actions with familiar icons.** For example, people can predict that a button containing the `square.and.arrow.up` symbol will help them perform share-related activities. If it makes sense to use an icon in your button, consider using an existing or customized [SF Symbols](/design/human-interface-guidelines/sf-symbols). For a list of symbols that represent common actions, see [Standard icons](/design/human-interface-guidelines/icons#Standard-icons).

**Consider using text when a short label communicates more clearly than an icon.** To use text, write a few words that succinctly describe what the button does. Using [title-style capitalization](https://help.apple.com/applestyleguide/#/apsgb744e4a3?sub=apdca93e113f1d64), consider starting the label with a verb to help convey the button’s action — for example, a button that lets people add items to their shopping cart might use the label “Add to Cart.”

## Role

A system button can have one of the following roles:

- **Normal.** No specific meaning.
- **Primary.** The button is the default button — the button people are most likely to choose.
- **Cancel.** The button cancels the current action.
- **Destructive.** The button performs an action that can result in data destruction.

A button’s role can have additional effects on its appearance. For example, a primary button uses an app’s accent color, whereas a destructive button uses the system red color.

![An example alert with three system buttons, labeled Primary, Destructive, and Cancel. The primary button uses a blue accent color, the destructive button uses text in the system red color, and the cancel button appears as a standard button.](https://docs-assets.developer.apple.com/published/ffa011d457181b94f56257d7d59f71aa/buttons-roles-alert%402x.png)

**Assign the primary role to the button people are most likely to choose.** When a primary button responds to the Return key, it makes it easy for people to quickly confirm their choice. In addition, when the button is in a temporary view — like a [Sheets](/design/human-interface-guidelines/sheets), an editable view, or an [Alerts](/design/human-interface-guidelines/alerts) — assigning it the primary role means that the view can automatically close when people press Return.

**Don’t assign the primary role to a button that performs a destructive action, even if that action is the most likely choice.** Because of its visual prominence, people sometimes choose a primary button without reading it first. Help people avoid losing content by assigning the primary role to nondestructive buttons.

## Platform considerations

*No additional considerations for tvOS.*

### iOS, iPadOS

**Configure a button to display an activity indicator when you need to provide feedback about an action that doesn’t instantly complete.** Displaying an activity indicator within a button can save space in your user interface while clearly communicating the reason for the delay. To help clarify what’s happening, you can also configure the button to display a different label alongside the activity indicator. For example, the label “Checkout” could change to “Checking out…” while the activity indicator is visible. When a delay occurs after people click or tap your configured button, the system displays the activity indicator next to the original or alternative label, hiding the button image, if there is one.

![An illustration of a button labeled Checkout.](https://docs-assets.developer.apple.com/published/f7a2f53cdd4755b1121c34f1df0e94ae/button-activity-indicator-hidden%402x.png)

![An illustration of a button labeled Checking out, with an activity indicator on the leading side of the label.](https://docs-assets.developer.apple.com/published/f2d6023f16eed80487f72b630903d220/button-activity-indicator-visible%402x.png)

### macOS

Several specific button types are unique to macOS.

#### Push buttons

The standard button type in macOS is known as a *push button*. You can configure a push button to display text, a symbol, an icon, or an image, or a combination of text and image content. Push buttons can act as the default button in a view and you can tint them.

**Use a flexible-height push button only when you need to display tall or variable height content.** Flexible-height buttons support the same configurations as regular push buttons — and they use the same corner radius and content padding — so they look consistent with other buttons in your interface. If you need to present a button that contains two lines of text or a tall icon, use a flexible-height button; otherwise, use a standard push button. For developer guidance, see [NSButton.BezelStyle.flexiblePush](/documentation/AppKit/NSButton/BezelStyle-swift.enum/flexiblePush).

**Append a trailing ellipsis to the title when a push button opens another window, view, or app.** Throughout the system, an ellipsis in a control title signals that people can provide additional input. For example, the Edit buttons in the AutoFill pane of Safari Settings include ellipses because they open other views that let people modify autofill values.

**Consider supporting spring loading.** On systems with a Magic Trackpad, *spring loading* lets people activate a button by dragging selected items over it and force clicking — that is, pressing harder — without dropping the selected items. After force clicking, people can continue dragging the items, possibly to perform additional actions.

#### Square buttons

A *square button* (also known as a *gradient button*) initiates an action related to a view, like adding or removing rows in a table.

Square buttons contain symbols or icons — not text — and you can configure them to behave like push buttons, toggles, or pop-up buttons. The buttons appear in close proximity to their associated view — usually within or beneath it — so people know which view the buttons affect.

**Use square buttons in a view, not in the window frame.** Square buttons aren’t intended for use in toolbars or status bars. If you need a button in a [toolbar](https://developer.apple.com/design/human-interface-guidelines/toolbars), use a toolbar item.

**Prefer using a symbol in a square button.** [SF Symbols](/design/human-interface-guidelines/sf-symbols) provides a wide range of symbols that automatically receive appropriate coloring in their default state and in response to user interaction.

**Avoid using labels to introduce square buttons.** Because square buttons are closely connected with a specific view, their purpose is generally clear without the need for descriptive text.

For developer guidance, see [NSButton.BezelStyle.smallSquare](/documentation/AppKit/NSButton/BezelStyle-swift.enum/smallSquare).

#### Help buttons

A *help button* appears within a view and opens app-specific help documentation.

Help buttons are circular, consistently sized buttons that contain a question mark. For guidance on creating help documentation, see [Offering help](/design/human-interface-guidelines/offering-help).

**Use the system-provided help button to display your help documentation.** People are familiar with the appearance of the standard help button and know that choosing it opens help content.

**When possible, open the help topic that’s related to the current context.** For example, the help button in the Rules pane of Mail settings opens the Mail User Guide to a help topic that explains how to change these settings. If no specific help topic applies directly to the current context, open the top level of your app’s help documentation when people choose a help button.

**Include no more than one help button per window.** Multiple help buttons in the same context make it hard for people to predict the result of clicking one.

**Position help buttons where people expect to find them.** Use the following locations for guidance.

| View style | Help button location |
| --- | --- |
| Dialog with dismissal buttons (like OK and Cancel) | Lower corner, opposite to the dismissal buttons and vertically aligned with them |
| Dialog without dismissal buttons | Lower-left or lower-right corner |
| Settings window or pane | Lower-left or lower-right corner |

**Use a help button within a view, not in the window frame.** For example, avoid placing a help button in a toolbar or status bar.

**Avoid displaying text that introduces a help button.** People know what a help button does, so they don’t need additional descriptive text.

#### Image buttons

An *image button* appears in a view and displays an image, symbol, or icon. You can configure an image button to behave like a push button, toggle, or pop-up button.

**Use an image button in a view, not in the window frame.** For example, avoid placing an image button in a toolbar or status bar. If you need to use an image as a button in a toolbar, use a toolbar item. See [Toolbars](/design/human-interface-guidelines/toolbars).

**Include about 10 pixels of padding between the edges of the image and the button edges.** An image button’s edges define its clickable area even when they aren’t visible. Including padding ensures that a click registers correctly even if it’s not precisely within the image. In general, avoid including a system-provided border in an image button; for developer guidance, see [isBordered](/documentation/AppKit/NSButton/isBordered).

**If you need to include a label, position it below the image button.** For related guidance, see [Labels](/design/human-interface-guidelines/labels).

### visionOS

A visionOS button typically includes a visible background that can help people see it, and the button plays sound to provide feedback when people interact with it.

[A recording showing the top portion of a window in visionOS. The window contains several buttons, including a 'More' button, which receives the hover effect. The button is selected and a menu containing additional options appears.](https://docs-assets.developer.apple.com/published/903604027461d87db17614a241d220a5/visionos-button-styles-animation.mp4)

There are three standard button shapes in visionOS. Typically, an icon-only button uses a [circle](/documentation/SwiftUI/ButtonBorderShape/circle) shape, a text-only button uses a [roundedRectangle](/documentation/SwiftUI/ButtonBorderShape/roundedRectangle) or [capsule](/documentation/SwiftUI/ButtonBorderShape/capsule) shape, and a button that includes both an icon and text uses the capsule shape.

visionOS buttons use different visual styles to communicate four different interaction states.

![An image of a circular button that contains an icon of an outlined square with rounded corners. The button background is dark and the dashed outline is white.](https://docs-assets.developer.apple.com/published/aed0b1c313448f088dd1ee24663db11e/visionos-button-state-idle%402x.png)

![An image of a circular button that contains an icon of an outlined square with rounded corners. The button background is medium dark and the outline is white.](https://docs-assets.developer.apple.com/published/29d708fd7985184cbee9d90d7684da92/visionos-button-state-hover%402x.png)

![An image of a circular button that contains an icon of an outlined square with rounded corners. The button background is white and the outline is black.](https://docs-assets.developer.apple.com/published/0b94e710605235dfca19ef853499cf26/visionos-button-state-selected%402x.png)

![An image of a circular button that contains an icon of an outlined square with rounded corners. The button background is very dark and the outline is light.](https://docs-assets.developer.apple.com/published/737120252765e5427161af32bb17e7fb/visionos-button-state-unavailable%402x.png)

> [!NOTE]
> In visionOS, buttons don’t support custom hover effects.

In addition to the four states shown above, a button can also reveal a tooltip when people look at it for a brief time. In general, buttons that contain text don’t need to display a tooltip because the button’s descriptive label communicates what it does.

[An animation showing a tooltip appearing beneath a visionOS button.](https://docs-assets.developer.apple.com/published/a2ca615bed663efa69fa7747a74c2e7f/visionos-button-dwell-tooltip.mp4)

In visionOS, buttons can have the following sizes.

| Shape | Mini (28 pt) | Small (32 pt) | Regular (44 pt) | Large (52 pt) | Extra large (64 pt) |
| --- | --- | --- | --- | --- | --- |
| Circular | ![A checkmark denoting availability.](https://docs-assets.developer.apple.com/published/9c1e6292b0ff3ee8f9e10917ad97f3da/table-availability-checkmark%402x.png) | ![A checkmark denoting availability.](https://docs-assets.developer.apple.com/published/9c1e6292b0ff3ee8f9e10917ad97f3da/table-availability-checkmark%402x.png) | ![A checkmark denoting availability.](https://docs-assets.developer.apple.com/published/9c1e6292b0ff3ee8f9e10917ad97f3da/table-availability-checkmark%402x.png) | ![A checkmark denoting availability.](https://docs-assets.developer.apple.com/published/9c1e6292b0ff3ee8f9e10917ad97f3da/table-availability-checkmark%402x.png) | ![A checkmark denoting availability.](https://docs-assets.developer.apple.com/published/9c1e6292b0ff3ee8f9e10917ad97f3da/table-availability-checkmark%402x.png) |
| Capsule (text only) |  | ![A checkmark denoting availability.](https://docs-assets.developer.apple.com/published/9c1e6292b0ff3ee8f9e10917ad97f3da/table-availability-checkmark%402x.png) | ![A checkmark denoting availability.](https://docs-assets.developer.apple.com/published/9c1e6292b0ff3ee8f9e10917ad97f3da/table-availability-checkmark%402x.png) | ![A checkmark denoting availability.](https://docs-assets.developer.apple.com/published/9c1e6292b0ff3ee8f9e10917ad97f3da/table-availability-checkmark%402x.png) |  |
| Capsule (text and icon) |  |  | ![A checkmark denoting availability.](https://docs-assets.developer.apple.com/published/9c1e6292b0ff3ee8f9e10917ad97f3da/table-availability-checkmark%402x.png) | ![A checkmark denoting availability.](https://docs-assets.developer.apple.com/published/9c1e6292b0ff3ee8f9e10917ad97f3da/table-availability-checkmark%402x.png) |  |
| Rounded rectangle |  | ![A checkmark denoting availability.](https://docs-assets.developer.apple.com/published/9c1e6292b0ff3ee8f9e10917ad97f3da/table-availability-checkmark%402x.png) | ![A checkmark denoting availability.](https://docs-assets.developer.apple.com/published/9c1e6292b0ff3ee8f9e10917ad97f3da/table-availability-checkmark%402x.png) | ![A checkmark denoting availability.](https://docs-assets.developer.apple.com/published/9c1e6292b0ff3ee8f9e10917ad97f3da/table-availability-checkmark%402x.png) |  |

**Prefer buttons that have a discernible background shape and fill.** It tends to be easier for people to see a button when it’s enclosed in a shape that uses a contrasting background fill. The exception is a button in a toolbar, context menu, alert, or [Ornaments](/design/human-interface-guidelines/ornaments) where the shape and material of the larger component make the button comfortably visible. The following guidelines can help you ensure that a button looks good in different contexts:

- When a button appears on top of a glass [visionOS](/design/human-interface-guidelines/windows#visionOS), use the [thin](/documentation/SwiftUI/Material/thin) material as the button’s background.
- When a button appears floating in space, use the [visionOS](/design/human-interface-guidelines/materials#visionOS) for its background.

**Avoid creating a custom button that uses a white background fill and black text or icons.** The system reserves this visual style to convey the toggled state.

**In general, prefer circular or capsule-shape buttons.** People’s eyes tend to be drawn toward the corners in a shape, making it difficult to keep looking at the shape’s center. The more rounded a button’s shape, the easier it is for people to look steadily at it. When you need to display a button by itself, prefer a capsule-shape button.

**Provide enough space around a button to make it easy for people to look at it.** Aim to place buttons so their centers are always at least 60 pts apart. If your buttons measure 60 pts or larger, add 4 pts of padding around them to keep the hover effect from overlapping. Also, it’s usually best to avoid displaying small or mini buttons in a vertical stack or horizontal row.

**Choose the right shape if you need to display text-labeled buttons in a stack or row.** Specifically, prefer the rounded-rectangle shape in a vertical stack of buttons and prefer the capsule shape in a horizontal row of buttons.

**Use standard controls to take advantage of the audible feedback sounds people already know.** Audible feedback is especially important in visionOS, because the system doesn’t play haptics.

### watchOS

watchOS displays all inline buttons using the [capsule](/documentation/SwiftUI/ButtonBorderShape/capsule) button shape. When you place a button inline with content, it gains a material effect that contrasts with the background to ensure legibility.

![An illustration that represents a screen on Apple Watch, which includes capsule-shaped Primary and Secondary buttons.](https://docs-assets.developer.apple.com/published/79565402ab107166de9aa0fe6eab4e6d/buttons-watch-full-width%402x.png)

**Use a toolbar to place buttons in the corners.** The system automatically moves the time and title to accommodate toolbar buttons. The system also applies the [Liquid Glass](/design/human-interface-guidelines/materials#Liquid-Glass) appearance to toolbar buttons, providing a clear visual distinction from the content beneath them.

![An illustration showing toolbar buttons in the top leading and trailing corners, as well as three toolbar buttons across the bottom of the screen.](https://docs-assets.developer.apple.com/published/28835a2c6f34513eb0758beef1f6015d/buttons-watch-toolbar-corners%402x.png)

**Prefer buttons that span the width of the screen for primary actions in your app.** Full-width buttons look better and are easier for people to tap. If two buttons must share the same horizontal space, use the same height for both, and use images or short text titles for each button’s content.

**Use toolbar buttons to provide either navigation to related areas or contextual actions for the view’s content.** These buttons provide access to additional information or secondary actions for the view’s content.

**Use the same height for vertical stacks of one- and two-line text buttons.** As much as possible, use identical button heights for visual consistency.

## Resources

#### Related

[Pop-up buttons](/design/human-interface-guidelines/pop-up-buttons)

[Pull-down buttons](/design/human-interface-guidelines/pull-down-buttons)

[Toggles](/design/human-interface-guidelines/toggles)

[Segmented controls](/design/human-interface-guidelines/segmented-controls)

[Location button](/design/human-interface-guidelines/privacy#Location-button)

#### Developer documentation

[Button](/documentation/SwiftUI/Button) — SwiftUI

[UIButton](/documentation/UIKit/UIButton) — UIKit

[NSButton](/documentation/AppKit/NSButton) — AppKit

## Change log

| Date | Changes |
| --- | --- |
| December 16, 2025 | Updated guidance for Liquid Glass. |
| June 9, 2025 | Updated guidance for button styles and content. |
| February 2, 2024 | Noted that visionOS buttons don’t support custom hover effects. |
| December 5, 2023 | Clarified some terminology and guidance for buttons in visionOS. |
| June 21, 2023 | Updated to include guidance for visionOS. |
| June 5, 2023 | Updated guidance for using buttons in watchOS. |

---

*Extracted by [sosumi.ai](https://sosumi.ai) - Making Apple docs AI-readable.*
*This is unofficial content. All Human Interface Guidelines belong to Apple Inc.*
```


## 来源：docs/fetched/sosumi-hig/tab-bars.md


```md
**Navigation:** [Human Interface Guidelines](/design/human-interface-guidelines)

**article**

# Tab bars

> A tab bar lets people navigate between top-level sections of your app.

![A stylized representation of a tab bar containing four placeholder icons with names. The image is tinted red to subtly reflect the red in the original six-color Apple logo.](https://docs-assets.developer.apple.com/published/8737d6baf5cdb223521eb4dbe3cb45e5/components-tab-bar-intro%402x.png)

Tab bars help people understand the different types of information or functionality that an app provides. They also let people quickly switch between sections of the view while preserving the current navigation state within each section.

## Best practices

**Use a tab bar to support navigation, not to provide actions.** A tab bar lets people navigate among different sections of an app, like the Alarm, Stopwatch, and Timer tabs in the Clock app. If you need to provide controls that act on elements in the current view, use a [Toolbars](/design/human-interface-guidelines/toolbars) instead.

**Make sure the tab bar is visible when people navigate to different sections of your app.** If you hide the tab bar, people can forget which area of the app they’re in. The exception is when a modal view covers the tab bar, because a modal is temporary and self-contained.

**Use the appropriate number of tabs required to help people navigate your app.** As a representation of your app’s hierarchy, it’s important to weigh the complexity of additional tabs against the need for people to frequently access each section; keep in mind that it’s generally easier to navigate among fewer tabs. Where available, consider a sidebar or a tab bar that adapts to a sidebar as an alternative for an app with a complex information structure.

**Avoid overflow tabs.** Depending on device size and orientation, the number of visible tabs can be smaller than the total number of tabs. If horizontal space limits the number of visible tabs, the trailing tab becomes a More tab in iOS and iPadOS, revealing the remaining items in a separate list. The More tab makes it harder for people to reach and notice content on tabs that are hidden, so limit scenarios in your app where this can happen.

**Don’t disable or hide tab bar buttons, even when their content is unavailable.** Having tab bar buttons available in some cases but not others makes your app’s interface appear unstable and unpredictable. If a section is empty, explain why its content is unavailable.

**Include tab labels to help with navigation.** A tab label appears beneath or beside a tab bar icon, and can aid navigation by clearly describing the type of content or functionality the tab contains. Use single words whenever possible.

**Consider using SF Symbols to provide familiar, scalable tab bar icons.** When you use [SF Symbols](/design/human-interface-guidelines/sf-symbols), tab bar icons automatically adapt to different contexts. For example, the tab bar can be regular or compact, depending on the device and orientation. Tab bar icons appear above tab labels in compact views, whereas in regular views, the icons and labels appear side by side. Prefer filled symbols or icons for consistency with the platform.

![An illustration of two iPhone devices side by side. The first iPhone is in landscape orientation with a tab bar at the bottom of the screen, with tab bar icons on the leading edge of each tab and tab labels on the trailing edge. The second iPhone is in portrait orientation with a tab bar at the bottom of the screen, with tab bar icons above their respective tab labels.](https://docs-assets.developer.apple.com/published/6871e7b24b6da37f753c61deba02c8ab/tab-bar-landscape%402x.png)

If you’re creating custom tab bar icons, see [Apple Design Resources](https://developer.apple.com/design/resources/) for tab bar icon dimensions.

![A diagram of a tab bar, with callouts indicating the location of the tab bar icon and tab label.](https://docs-assets.developer.apple.com/published/eb47e442c964d54ed32f9324c71511d1/tab-bar-anatomy-callouts%402x.png)

**Use a badge to indicate that critical information is available.** You can display a badge — a red oval containing white text and either a number or an exclamation point — on a tab to indicate that there’s new or updated information in the section that warrants a person’s attention. Reserve badges for critical information so you don’t dilute their impact and meaning. For guidance, see [Notifications](/design/human-interface-guidelines/notifications).

![An illustration of the bottom half of an iPhone in portrait orientation, with a tab bar at the bottom of the screen. Two of the tabs have red circular badges attached, indicating the presence of critical information.](https://docs-assets.developer.apple.com/published/29a93bc69eaa415e2e3d5440474a8d36/tab-bar-badges-iphone%402x.png)

**Avoid applying a similar color to tab labels and content layer backgrounds.** If your app already has bright, colorful content in the content layer, prefer a monochromatic appearance for tab bars, or choose an accent color with sufficient visual differentiation. For more guidance, see [Liquid Glass color](/design/human-interface-guidelines/color#Liquid-Glass-color).

## Platform considerations

*No additional considerations for macOS. Not supported in watchOS.*

### iOS

A tab bar floats above content at the bottom of the screen. Its items rest on a [Liquid Glass](/design/human-interface-guidelines/materials#Liquid-Glass) background that allows content beneath to peek through.

For tab bars with an attached accessory, like the MiniPlayer in Music, you can choose to minimize the tab bar and move the accessory inline with it when a person scrolls down. A person can exit the minimized state by tapping a tab or scrolling to the top of the view. For developer guidance, see [TabBarMinimizeBehavior](/documentation/SwiftUI/TabBarMinimizeBehavior) and [UITabBarController.MinimizeBehavior](/documentation/UIKit/UITabBarController/MinimizeBehavior).

![An illustration of the bottom half of an iPhone in portrait orientation, with the Music app open. The MiniPlayer is open above the tab bar at the bottom of the screen.](https://docs-assets.developer.apple.com/published/1b8fb04a802aacd9c9f46ba7b16be080/tab-bar-with-accessory-expanded%402x.png)

![An illustration of the bottom half of an iPhone in portrait orientation, with the Music app open. The tab bar is minimized into the currently open tab at the leading bottom corner of the screen, with the MiniPlayer at the bottom center, and the search tab in the trailing corner.](https://docs-assets.developer.apple.com/published/d074ff4013a38155a887ceeecf2417fa/tab-bar-with-accessory-collapsed%402x.png)

A tab bar can include a distinct search item at the trailing end. For guidance, see [Search fields](/design/human-interface-guidelines/search-fields).

### iPadOS

The system displays a tab bar near the top of the screen. You can choose to have the tab bar appear as a fixed element, or with a button that converts it to a sidebar. For developer guidance, see [tabBarOnly](/documentation/SwiftUI/TabViewStyle/tabBarOnly) and [sidebarAdaptable](/documentation/SwiftUI/TabViewStyle/sidebarAdaptable).

> [!NOTE]
> To present a sidebar without the option to convert it to a tab bar, use a [navigation split view](https://developer.apple.com/documentation/swiftui/navigationsplitview) instead of a tab view. For guidance, see [Sidebars](/design/human-interface-guidelines/sidebars).

**Prefer a tab bar for navigation.** A tab bar provides access to the sections of your app that people use most. If your app is more complex, you can provide the option to convert the tab bar to a sidebar so people can access a wider set of navigation options.

**Let people customize the tab bar.** In apps with a lot of sections that people might want to access, it can be useful to let people select items that they use frequently and add them to the tab bar, or remove items that they use less frequently. For example, in the Music app, a person can choose a favorite playlist to display in the tab bar. If you let people select their own tabs, aim for a default list of five or fewer to preserve continuity between compact and regular view sizes. For developer guidance, see [TabViewCustomization](/documentation/SwiftUI/TabViewCustomization) and [UITab.Placement](/documentation/UIKit/UITab/Placement).

### tvOS

A tab bar is highly customizable. For example, you can:

- Specify a tint, color, or image for the tab bar background
- Choose a font for tab items, including a different font for the selected item
- Specify tints for selected and unselected items
- Add button icons, like settings and search

By default, a tab bar is translucent, and only the selected tab is opaque. When people use the remote to focus on the tab bar, the selected tab includes a drop shadow that emphasizes its selected state. The height of a tab bar is 68 points, and its top edge is 46 points from the top of the screen; you can’t change either of these values.

If there are more items than can fit in the tab bar, the system truncates the rightmost item by applying a fade effect that begins at the right side of the tab bar. If there are enough items to cause scrolling, the system also applies a truncating fade effect that starts from the left side.

**Be aware of tab bar scrolling behaviors.** By default, people can scroll the tab bar offscreen when the current tab contains a single main view. You can see examples of this behavior in the Watch Now, Movies, TV Show, Sports, and Kids tabs in the TV app. The exception is when a screen contains a split view, such as the TV app’s Library tab or an app’s Settings screen. In this case, the tab bar remains pinned at the top of the view while people scroll the content within the primary and secondary panes of the split view. Regardless of a tab’s contents, focus always returns to the tab bar at the top of the page when people press Menu on the remote.

**In a live-viewing app, organize tabs in a consistent way.** For the best experience, organize content in live-streaming apps with tabs in the following order:

- Live content
- Cloud DVR or other recorded content
- Other content

For additional guidance, see [Live-viewing apps](/design/human-interface-guidelines/live-viewing-apps).

### visionOS

In visionOS, a tab bar is always vertical, floating in a position that’s fixed relative to the window’s leading side. When people look at a tab bar, it automatically expands; to open a specific tab, people look at the tab and tap. While a tab bar is expanded, it can temporarily obscure the content behind it.

[A recording showing a closeup of a tab bar along the side of an app's window in visionOS. The tab bar includes only symbols. The currently selected tab receives the hover effect, showing that someone is looking at it, and the bar expands to display both symbols and labels.](https://docs-assets.developer.apple.com/published/f32ef9dc79663078639886243082e3cd/visionos-tab-bar-expanding-animation.mp4)

**Supply a symbol and a text label for each tab.** A tab’s symbol is always visible in the tab bar. When people look at the tab bar, the system reveals tab labels, too. Even though the tab bar expands, you need to keep tab labels short so people can read them at a glance.

![A screenshot showing a collapsed tab bar containing only symbols.](https://docs-assets.developer.apple.com/published/60282ea47a438f5b2bd84705212b44e4/visionos-tab-bar-collapsed%402x.png)

![A screenshot showing an expanded tab bar containing both symbols and labels.](https://docs-assets.developer.apple.com/published/df1a14ce3d5e2743bfdfb0fea47fc340/visionos-tab-bar-expanded%402x.png)

**If it makes sense in your app, consider using a sidebar within a tab.** If your app’s hierarchy is deep, you might want to use a [Sidebars](/design/human-interface-guidelines/sidebars) to support secondary navigation within a tab. If you do this, be sure to prevent selections in the sidebar from changing which tab is currently open.

## Resources

#### Related

[Tab views](/design/human-interface-guidelines/tab-views)

[Toolbars](/design/human-interface-guidelines/toolbars)

[Sidebars](/design/human-interface-guidelines/sidebars)

[Materials](/design/human-interface-guidelines/materials)

#### Developer documentation

[TabView](/documentation/SwiftUI/TabView) — SwiftUI

[TabViewBottomAccessoryPlacement](/documentation/SwiftUI/TabViewBottomAccessoryPlacement) — SwiftUI

[Enhancing your app’s content with tab navigation](/documentation/SwiftUI/Enhancing-your-app-content-with-tab-navigation) — SwiftUI

[UITabBar](/documentation/UIKit/UITabBar) — UIKit

[Elevating your iPad app with a tab bar and sidebar](/documentation/UIKit/elevating-your-ipad-app-with-a-tab-bar-and-sidebar) — UIKit

#### Videos

- [Get to know the new design system](https://developer.apple.com/videos/play/wwdc2025/356) - Dive deeper into the new design system to explore key changes to visual design, information architecture, and core system components. Learn how the system reshapes the relationship between interface and content, enabling you to create designs that are dynamic, harmonious, and consistent across devices, screen sizes, and input modes.
- [Elevate the design of your iPad app](https://developer.apple.com/videos/play/wwdc2025/208) - Make your app look and feel great on iPadOS. Learn best practices for designing a responsive layout for resizable app windows. Get familiar with window controls and explore the best ways to accommodate them. Discover the building blocks of a great menu bar. And meet the new pointer and its updated effects.

## Change log

| Date | Changes |
| --- | --- |
| December 16, 2025 | Updated guidance for Liquid Glass. |
| July 28, 2025 | Added guidance for Liquid Glass. |
| September 9, 2024 | Added art representing the tab bar in iPadOS 18. |
| August 6, 2024 | Updated with guidance for the tab bar in iPadOS 18. |
| June 21, 2023 | Updated to include guidance for visionOS. |

---

*Extracted by [sosumi.ai](https://sosumi.ai) - Making Apple docs AI-readable.*
*This is unofficial content. All Human Interface Guidelines belong to Apple Inc.*
```


## 来源：docs/fetched/sosumi-hig/sidebars.md


```md
**Navigation:** [Human Interface Guidelines](/design/human-interface-guidelines)

**article**

# Sidebars

> A sidebar appears on the leading side of a view and lets people navigate between sections in your app or game.

![A stylized representation of the top portion of a window's sidebar displaying a title, a section, and some folders. The image is tinted red to subtly reflect the red in the original six-color Apple logo.](https://docs-assets.developer.apple.com/published/d8bde769da53e8facee9d89e4362b83c/components-sidebar-intro%402x.png)

A sidebar floats above content without being anchored to the edges of the view. It provides a broad, flat view of an app’s information hierarchy, giving people access to several peer content areas or modes at the same time.

A sidebar requires a large amount of vertical and horizontal space. When space is limited or you want to devote more of the screen to other information or functionality, a more compact control such as a [Tab bars](/design/human-interface-guidelines/tab-bars) may provide a better navigation experience. For guidance, see [Layout](/design/human-interface-guidelines/layout).

## Best practices

**Extend content beneath the sidebar.** In iOS, iPadOS, and macOS, as with other controls such as toolbars and tab bars, sidebars float above content in the [Liquid Glass](/design/human-interface-guidelines/materials#Liquid-Glass) layer. To reinforce the separation and floating appearance of the sidebar, extend content beneath it either by letting it horizontally scroll or applying a background extension view, which mirrors adjacent content to give the impression of stretching it under the sidebar. For developer guidance, see [backgroundExtensionEffect()](/documentation/SwiftUI/View/backgroundExtensionEffect()).

![A screenshot of the leading side of an app on iPad. An image spans the upper part of the window, stopping at the edge of the sidebar.](https://docs-assets.developer.apple.com/published/d50ee5db90fbe0cae8f34304aa315053/sidebars-extend-content-beneath-sidebar-incorrect%402x.png)

![An X in a circle to indicate incorrect usage.](https://docs-assets.developer.apple.com/published/209f6f0fc8ad99d9bf59e12d82d06584/crossout%402x.png)

![A screenshot of the leading side of an app on iPad. An image spans the upper part of the window, and uses a background extension effect to flip, blur, and extend the image beneath the sidebar to the edge of the window.](https://docs-assets.developer.apple.com/published/5cdac1170561cddf1930b4d74325c4dd/sidebars-extend-content-beneath-sidebar-correct%402x.png)

![A checkmark in a circle to indicate correct usage.](https://docs-assets.developer.apple.com/published/88662da92338267bb64cd2275c84e484/checkmark%402x.png)

**When possible, let people customize the contents of a sidebar.** A sidebar lets people navigate to important areas in your app, so it works well when people can decide which areas are most important and in what order they appear.

**Group hierarchy with disclosure controls if your app has a lot of content.** Using [Disclosure controls](/design/human-interface-guidelines/disclosure-controls) helps keep the sidebar’s vertical space to a manageable level.

**Consider using familiar symbols to represent items in the sidebar.** [SF Symbols](/design/human-interface-guidelines/sf-symbols) provides a wide range of customizable symbols you can use to represent items in your app. If you need to use a custom icon, consider creating a [Custom symbols](/design/human-interface-guidelines/sf-symbols#Custom-symbols) rather than using a bitmap image. Download the SF Symbols app from [Apple Design Resources](https://developer.apple.com/design/resources/#sf-symbols).

**Consider letting people hide the sidebar.** People sometimes want to hide the sidebar to create more room for content details or to reduce distraction. When possible, let people hide and show the sidebar using the platform-specific interactions they already know. For example, in iPadOS, people expect to use the built-in edge swipe gesture; in macOS, you can include a show/hide button or add Show Sidebar and Hide Sidebar commands to your app’s View menu. In visionOS, a window typically expands to accommodate a sidebar, so people rarely need to hide it. Avoid hiding the sidebar by default to ensure that it remains discoverable.

**In general, show no more than two levels of hierarchy in a sidebar.** When a data hierarchy is deeper than two levels, consider using a split view interface that includes a content list between the sidebar items and detail view.

**If you need to include two levels of hierarchy in a sidebar, use succinct, descriptive labels to title each group.** To help keep labels short, omit unnecessary words.

## Platform considerations

*No additional considerations for tvOS. Not supported in watchOS.*

### iOS

**Avoid using a sidebar.** A sidebar takes up a lot of space in landscape orientation and isn’t available in portrait orientation. Instead, consider using a [Tab bars](/design/human-interface-guidelines/tab-bars), which takes less space and remains visible in both orientations.

### iPadOS

When you use the [sidebarAdaptable](/documentation/SwiftUI/TabViewStyle/sidebarAdaptable) style of tab view to present a sidebar, you choose whether to display a sidebar or a tab bar when your app opens. Both variations include a button that people can use to switch between them. This style also responds automatically to rotation and window resizing, providing a version of the control that’s appropriate to the width of the view.

> [!NOTE]
> To display a sidebar only, use [NavigationSplitView](/documentation/SwiftUI/NavigationSplitView) to present a sidebar in the primary pane of a split view, or use [UISplitViewController](/documentation/UIKit/UISplitViewController).

**Consider using a tab bar first.** A tab bar provides more space to feature content, and offers enough flexibility to navigate between many apps’ main areas. If you need to expose more areas than fit in a tab bar, the tab bar’s convertible sidebar-style appearance can provide access to content that people use less frequently. For guidance, see [Tab bars](/design/human-interface-guidelines/tab-bars).

**If necessary, apply the correct appearance to a sidebar.** If you’re not using SwiftUI to create a sidebar, you can use the [UICollectionLayoutListConfiguration.Appearance.sidebar](/documentation/UIKit/UICollectionLayoutListConfiguration-swift.struct/Appearance-swift.enum/sidebar) appearance of a collection view list layout. For developer guidance, see [UICollectionLayoutListConfiguration.Appearance](/documentation/UIKit/UICollectionLayoutListConfiguration-swift.struct/Appearance-swift.enum).

### macOS

A sidebar’s row height, text, and glyph size depend on its overall size, which can be small, medium, or large. You can set the size programmatically, but people can also change it by selecting a different sidebar icon size in General settings.

**Avoid stylizing your app by specifying a fixed color for all sidebar icons.** By default, sidebar icons use the current [accent color](https://developer.apple.com/design/human-interface-guidelines/color#App-accent-colors) and people expect to see their chosen accent color throughout all the apps they use. Although a fixed color can help clarify the meaning of an icon, you want to make sure that most sidebar icons display the color people choose.

**Consider automatically hiding and revealing a sidebar when its container window resizes.** For example, reducing the size of a Mail viewer window can automatically collapse its sidebar, making more room for message content.

**Avoid putting critical information or actions at the bottom of a sidebar.** People often relocate a window in a way that hides its bottom edge.

### visionOS

**If your app’s hierarchy is deep, consider using a sidebar within a tab in a tab bar.** In this situation, a sidebar can support secondary navigation within the tab. If you do this, be sure to prevent selections in the sidebar from changing which tab is currently open.

![A partial screenshot of the Music app in visionOS. The app's window includes a sidebar for navigating the music library, and the secondary pane includes a grid of playlists.](https://docs-assets.developer.apple.com/published/5e381525f4cccac8e9eb979fe4c984c6/visionos-sidebar-music%402x.png)

## Resources

#### Related

[Split views](/design/human-interface-guidelines/split-views)

[Tab bars](/design/human-interface-guidelines/tab-bars)

[Layout](/design/human-interface-guidelines/layout)

#### Developer documentation

[sidebarAdaptable](/documentation/SwiftUI/TabViewStyle/sidebarAdaptable) — SwiftUI

[NavigationSplitView](/documentation/SwiftUI/NavigationSplitView) — SwiftUI

[sidebar](/documentation/SwiftUI/ListStyle/sidebar) — SwiftUI

[UICollectionLayoutListConfiguration](/documentation/UIKit/UICollectionLayoutListConfiguration-swift.struct) — UIKit

[NSSplitViewController](/documentation/AppKit/NSSplitViewController) — AppKit

#### Videos

- [Elevate the design of your iPad app](https://developer.apple.com/videos/play/wwdc2025/208) - Make your app look and feel great on iPadOS. Learn best practices for designing a responsive layout for resizable app windows. Get familiar with window controls and explore the best ways to accommodate them. Discover the building blocks of a great menu bar. And meet the new pointer and its updated effects.

## Change log

| Date | Changes |
| --- | --- |
| June 9, 2025 | Added guidance for extending content beneath the sidebar. |
| August 6, 2024 | Updated guidance to include the SwiftUI adaptable sidebar style. |
| December 5, 2023 | Added artwork for iPadOS. |
| June 21, 2023 | Updated to include guidance for visionOS. |

---

*Extracted by [sosumi.ai](https://sosumi.ai) - Making Apple docs AI-readable.*
*This is unofficial content. All Human Interface Guidelines belong to Apple Inc.*
```


## 来源：docs/fetched/sosumi-hig/toolbars.md


```md
**Navigation:** [Human Interface Guidelines](/design/human-interface-guidelines)

**article**

# Toolbars

> A toolbar provides convenient access to frequently used commands, controls, navigation, and search.

![A stylized representation of a toolbar, with a Back control on the leading edge, and Compose, Share, and the More menu on the trailing edge. The image is tinted red to subtly reflect the red in the original six-color Apple logo.](https://docs-assets.developer.apple.com/published/c88cf44cf526483c94aa15bd2eb984e1/components-toolbar-intro%402x.png)

A toolbar consists of one or more sets of controls arranged horizontally along the top or bottom edge of the view, grouped into logical sections.

Toolbars act on content in the view, facilitate navigation, and help orient people in the app. They include three types of content:

- The title of the current view
- Navigation controls, like back and forward, and [Search fields](/design/human-interface-guidelines/search-fields)
- Actions, or bar items, like [Buttons](/design/human-interface-guidelines/buttons) and [Menus](/design/human-interface-guidelines/menus)

In contrast to a toolbar, a [Tab bars](/design/human-interface-guidelines/tab-bars) is specifically for navigating between areas of an app.

## Best practices

**Choose items deliberately to avoid overcrowding.** People need to be able to distinguish and activate each item, so you don’t want to put too many items in the toolbar. To accommodate variable view widths, define which items move to the overflow menu as the toolbar becomes narrower.

> [!NOTE]
> The system automatically adds an overflow menu in macOS or iPadOS when items no longer fit. Don’t add an overflow menu manually, and avoid layouts that cause toolbar items to overflow by default.

**Add a More menu to contain additional actions.** Prioritize less important actions for inclusion in the More menu. Try to include all actions in the toolbar if possible, and only add this menu if you really need it.

**In iPadOS and macOS apps, consider letting people customize the toolbar to include their most common items.** Toolbar customization is especially useful in apps that provide a lot of items — or that include advanced functionality that not everyone needs — and in apps that people tend to use for long periods of time. For example, it works well to make a range of editing actions available for toolbar customization, because people often use different types of editing commands based on their work style and their current project.

**Reduce the use of toolbar backgrounds and tinted controls.** Any custom backgrounds and appearances you use might overlay or interfere with background effects that the system provides. Instead, use the content layer to inform the color and appearance of the toolbar, and use a [ScrollEdgeEffectStyle](/documentation/SwiftUI/ScrollEdgeEffectStyle) when necessary to distinguish the toolbar area from the content area. This approach helps your app express its unique personality without distracting from content.

**Avoid applying a similar color to toolbar item labels and content layer backgrounds.** If your app already has bright, colorful content in the content layer, prefer using the default monochromatic appearance of toolbars. For more guidance, see [Liquid Glass color](/design/human-interface-guidelines/color#Liquid-Glass-color).

**Prefer using standard components in a toolbar.** By default, standard buttons, text fields, headers, and footers have corner radii that are concentric with bar corners. If you need to create a custom component, ensure that its corner radius is also concentric with the bar’s corners.

**Consider temporarily hiding toolbars for a distraction-free experience.** Sometimes people appreciate a minimal interface to reduce distractions or reveal more content. If you support this, do so contextually when it makes the most sense, and offer ways to reliably restore hidden interface elements. For guidance, see [Going full screen](/design/human-interface-guidelines/going-full-screen). For guidance specific to visionOS, see [Immersive experiences](/design/human-interface-guidelines/immersive-experiences).

## Titles

**Provide a useful title for each window.** A title helps people confirm their location as they navigate your app, and differentiates between the content of multiple open windows. If titling a toolbar seems redundant, you can leave the title area empty. For example, Notes doesn’t title the current note when a single window is open, because the first line of content typically supplies sufficient context. However, when opening notes in separate windows, the system titles them with the first line of content so people can tell them apart.

**Don’t title windows with your app name.** Your app’s name doesn’t provide useful information about your content hierarchy or any window or area in your app, so it doesn’t work well as a title.

**Write a concise title.** Aim for a word or short phrase that distills the purpose of the window or view, and keep the title under 15 characters long so you leave enough room for other controls.

## Navigation

A toolbar with navigation controls appears at the top of a window, helping people move through a hierarchy of content. A toolbar also often contains a [Search fields](/design/human-interface-guidelines/search-fields) for quick navigation between areas or pieces of content. In iOS, a navigation-specific toolbar is sometimes called a navigation bar.

**Use the standard Back and Close buttons.** People know that the standard Back button lets them retrace their steps through a hierarchy of information, and the standard Close button closes a modal view. Prefer the standard symbols for each, and don’t use a text label that says *Back* or *Close*. If you create a custom version of either, make sure it still looks the same, behaves as people expect, and matches the rest of your interface, and ensure you consistently implement it throughout your app or game. For guidance, see [Icons](/design/human-interface-guidelines/icons).

![An illustration of a capsule-shape Back button that includes the Back symbol on the leading side, grouped with Back in text on the trailing side.](https://docs-assets.developer.apple.com/published/de859b5c4d42c9df2e92c680d48a37b2/toolbars-navigation-action-back-incorrect%402x.png)

![An X in a circle to indicate incorrect usage.](https://docs-assets.developer.apple.com/published/209f6f0fc8ad99d9bf59e12d82d06584/crossout%402x.png)

![An illustration of the standard circular Back button that includes the standard Back symbol.](https://docs-assets.developer.apple.com/published/bf5f1cf48120b10f031bd9df57124f0f/toolbars-navigation-action-back-correct%402x.png)

![A checkmark in a circle to indicate correct usage.](https://docs-assets.developer.apple.com/published/88662da92338267bb64cd2275c84e484/checkmark%402x.png)

## Actions

**Provide actions that support the main tasks people perform.** In general, prioritize the commands that people are most likely to want. These commands are often the ones people use most frequently, but in some apps it might make sense to prioritize commands that map to the highest level or most important objects people work with.

**Make sure the meaning of each control is clear.** Don’t make people guess or experiment to figure out what a toolbar item does. Prefer simple, recognizable symbols for items instead of text, except for actions like *edit* that aren’t well-represented by symbols. For guidance on symbols that represent common actions, see [Standard icons](/design/human-interface-guidelines/icons#Standard-icons).

![An illustration of an item group with text button labels for Filter, Delete, and New.](https://docs-assets.developer.apple.com/published/e39b41732b2b7cf5a40c682f6ec28448/toolbars-prefer-symbols-incorrect%402x.png)

![An X in a circle to indicate incorrect usage.](https://docs-assets.developer.apple.com/published/209f6f0fc8ad99d9bf59e12d82d06584/crossout%402x.png)

![An illustration of an item group with symbol button labels for Filter, Delete, and New.](https://docs-assets.developer.apple.com/published/a90ab6d6f58aa023f4b830e4045b507b/toolbars-prefer-symbols-correct%402x.png)

![A checkmark in a circle to indicate correct usage.](https://docs-assets.developer.apple.com/published/88662da92338267bb64cd2275c84e484/checkmark%402x.png)

**Prefer system-provided symbols without borders.** System-provided symbols are familiar, automatically receive appropriate coloring and vibrancy, and respond consistently to user interactions. Borders (like outlined circle symbols) aren’t necessary because the section provides a visible container, and the system defines hover and selection state appearances automatically. For guidance, see [SF Symbols](/design/human-interface-guidelines/sf-symbols).

![An illustration of an item group with buttons for Filter and More. The buttons are labeled with symbols with circular borders.](https://docs-assets.developer.apple.com/published/90f36d797636e931c39663c146c1cb11/toolbars-icons-circle-outline-incorrect%402x.png)

![An X in a circle to indicate incorrect usage.](https://docs-assets.developer.apple.com/published/209f6f0fc8ad99d9bf59e12d82d06584/crossout%402x.png)

![An illustration of an item group with buttons for Filter and More. The buttons are labeled with symbols without borders.](https://docs-assets.developer.apple.com/published/e7b2189bb13488aab5e7eacc5eea9b1b/toolbars-icons-no-outline-correct%402x.png)

![A checkmark in a circle to indicate correct usage.](https://docs-assets.developer.apple.com/published/88662da92338267bb64cd2275c84e484/checkmark%402x.png)

**Use the `.prominent` style for key actions such as Done or Submit.** This separates and tints the action so there’s a clear focal point. Only specify one primary action, and put it on the trailing side of the toolbar.

![An illustration of two toolbar items, with a Filter button on the leading side and a Done button on the trailing side. The buttons are ungrouped, and the Done button has the prominent style applied to indicate that it's the primary action.](https://docs-assets.developer.apple.com/published/36c552c629c8a980c83501134e53d749/toolbars-prominent-action-tinted%402x.png)

## Item groupings

You can position toolbar items in three locations: the leading edge, center area, and trailing edge of the toolbar. These areas provide familiar homes for navigation controls, window or document titles, common actions, and search.

- **Leading edge.** Elements that let people return to the previous document and show or hide a sidebar appear at the far leading edge, followed by the view title. Next to the title, the toolbar can include a document menu that contains standard and app-specific commands that affect the document as a whole, such as Duplicate, Rename, Move, and Export. To ensure that these items are always available, items on the toolbar’s leading edge aren’t customizable.
- **Center area.** Common, useful controls appear in the center area, and the view title can appear here if it’s not on the leading edge. In macOS and iPadOS, people can add, remove, and rearrange items here if you let them customize the toolbar, and items in this section automatically collapse into the system-managed overflow menu when the window shrinks enough in size.
- **Trailing edge.** The trailing edge contains important items that need to remain available, buttons that open nearby inspectors, an optional search field, and the More menu that contains additional items and supports toolbar customization. It also includes a primary action like Done when one exists. Items on the trailing edge remain visible at all window sizes.

![A diagram of the top toolbar in the Freeform app on iPad. Callouts indicate the location of item groupings on the leading edge, center area, and trailing edge of the toolbar.](https://docs-assets.developer.apple.com/published/882504f8e992b3ce0e373f47523adf5e/toolbars-ipad-anatomy%402x.png)

To position items in the groupings you want, pin them to the leading edge, center, or trailing edge, and insert space between buttons or other items where appropriate.

**Group toolbar items logically by function and frequency of use.**  For example, Keynote includes several sections that are based on functionality, including one for presentation-level commands, one for playback commands, and one for object insertion.

**Group navigation controls and critical actions like Done, Close, or Save in dedicated, familiar, and visually distinct sections.** This reflects their importance and helps people discover and understand these actions.

![An illustration of a top toolbar on iPhone, with controls for back, forward, tool selection, and the More menu grouped in a single section on the trailing edge.](https://docs-assets.developer.apple.com/published/9349ac4f406f84c24e98a6b9445b9560/toolbars-layout-grouping-incorrect%402x.png)

![An X in a circle to indicate incorrect usage.](https://docs-assets.developer.apple.com/published/209f6f0fc8ad99d9bf59e12d82d06584/crossout%402x.png)

![An illustration of a top toolbar on iPhone, with controls for back and forward grouped on the leading edge, and controls for tool selection and the More menu grouped on the trailing edge.](https://docs-assets.developer.apple.com/published/2fede653e14b982c4b2c65f3ca657278/toolbars-layout-grouping-correct%402x.png)

![A checkmark in a circle to indicate correct usage.](https://docs-assets.developer.apple.com/published/88662da92338267bb64cd2275c84e484/checkmark%402x.png)

**Keep consistent groupings and placement across platforms.** This helps people develop familiarity with your app and trust that it behaves similarly regardless of where they use it.

**Minimize the number of groups.** Too many groups of controls can make a toolbar feel cluttered and confusing, even with the added space on iPad and Mac. In general, aim for a maximum of three.

**Keep actions with text labels separate.** Placing an action with a text label next to an action with a symbol can create the illusion of a single action with a combined text and symbol, leading to confusion and misinterpretation. If your toolbar includes multiple text-labeled buttons, the text of those buttons may appear to run together, making the buttons indistinguishable. Add separation by inserting fixed space between the buttons. For developer guidance, see [UIBarButtonItem.SystemItem.fixedSpace](/documentation/UIKit/UIBarButtonItem/SystemItem/fixedSpace).

![An illustration of a top toolbar on iPhone, with an Edit control with a text label and a Share control with a symbol grouped together on the trailing edge.](https://docs-assets.developer.apple.com/published/de7f7298c70900b9c2f65d5cae7c6d60/toolbars-layout-text-action-grouping-incorrect%402x.png)

![An X in a circle to indicate incorrect usage.](https://docs-assets.developer.apple.com/published/209f6f0fc8ad99d9bf59e12d82d06584/crossout%402x.png)

![An illustration of a top toolbar on iPhone, with an Edit control with a text label and a Share control with a symbol grouped into individual sections on the trailing edge.](https://docs-assets.developer.apple.com/published/c46f284f584841d7783aa2090426ca9b/toolbars-layout-text-action-grouping-correct%402x.png)

![A checkmark in a circle to indicate correct usage.](https://docs-assets.developer.apple.com/published/88662da92338267bb64cd2275c84e484/checkmark%402x.png)

## Platform considerations

*No additional considerations for tvOS.*

### iOS

**Prioritize only the most important items for inclusion in the main toolbar area.** Because space is so limited, carefully consider which actions are essential to your app and include those first. Create a More menu to include additional items.

**Use a large title to help people stay oriented as they navigate and scroll.** By default, a large title transitions to a standard title as people begin scrolling the content, and transitions back to large when people scroll to the top, reminding them of their current location. For developer guidance, see [prefersLargeTitles](/documentation/UIKit/UINavigationBar/prefersLargeTitles).

### iPadOS

**Consider combining a toolbar with a tab bar.** In iPadOS, a toolbar and a [Tab bars](/design/human-interface-guidelines/tab-bars) can coexist in the same horizontal space at the top of the view. This is particularly useful for layouts where you want to navigate between a few main app areas while keeping the full width of the window available for content. For guidance, see [Layout](/design/human-interface-guidelines/layout) and [Windows](/design/human-interface-guidelines/windows).

### macOS

In a macOS app, the toolbar resides in the frame at the top of a window, either below or integrated with the title bar. Note that window titles can display inline with controls, and toolbar items don’t include a bezel.

![A diagram of a Finder window in macOS with callouts showing the location of the toolbar and the window frame.](https://docs-assets.developer.apple.com/published/a595dda6ba3dd30cbd7c9851d941be72/toolbars-mac-window-anatomy%402x.png)

**Make every toolbar item available as a command in the menu bar.** Because people can customize the toolbar or hide it, it can’t be the only place that presents a command. In contrast, it doesn’t make sense to provide a toolbar item for every menu item, because not all menu commands are important enough or used often enough to warrant space in the toolbar.

### visionOS

In visionOS, the system-provided toolbar appears along the bottom edge of a window, above the window-management controls, and in a parallel plane that’s slightly in front of the window along the z-axis.

![A screenshot of a toolbar along the bottom of the Notes app window in visionOS.](https://docs-assets.developer.apple.com/published/47985b0aebd160790502368ff9e282a1/visionos-toolbar-notes-app%402x.png)

To maintain the legibility of toolbar items as content scrolls behind them, visionOS uses a variable blur in the bar background. The variable blur anchors the bar above the scrolling content while letting the view’s glass material remain uniform and undivided.

In visionOS, you can supply either a symbol or a text label for each toolbar item. When people look at a toolbar item that contains a symbol, visionOS reveals the text label, providing additional information.

**Prefer using a system-provided toolbar.** The standard toolbar has a consistent and familiar appearance and is optimized to work well with eye and hand input. In addition, the system automatically places a standard toolbar in the correct position in relation to its window.

![A screenshot of a toolbar in visionOS.](https://docs-assets.developer.apple.com/published/449acaaf0268d1fff08e9bf41b7c82d9/visionos-toolbar-standard-layout%402x.png)

**Avoid creating a vertical toolbar.** In visionOS, [Tab bars](/design/human-interface-guidelines/tab-bars) are vertical, so presenting a vertical toolbar could confuse people.

**Try to prevent windows from resizing below the width of the toolbar.** visionOS doesn’t include a menu bar where each app lists all its actions, so it’s important for the toolbar to provide reliable access to essential controls regardless of a window’s size.

**If your app can enter a modal state, consider offering contextually relevant toolbar controls.** For example, a photo-editing app might enter a modal state to help people perform a multistep editing task. In this scenario, the controls in the modal editing view are different from the controls in the main window. Be sure to reinstate the window’s standard toolbar controls when the app exits the modal state.

**Avoid using a pull-down menu in a toolbar.** A pull-down menu lets you offer additional actions related to a toolbar item, but can be difficult for people to discover and may clutter your interface. Because a toolbar is located at the bottom edge of a window in visionOS, a pull-down menu might obscure the standard window controls that appear below the bottom edge. For guidance, see [Pull-down buttons](/design/human-interface-guidelines/pull-down-buttons).

### watchOS

A toolbar button lets you offer important app functionality in a view that displays related content. You can place toolbar buttons in the top corners or along the bottom. If you place these buttons above scrolling content, the buttons always remain visible, as the content scrolls under them.

![A screenshot showing toolbar buttons in the top leading and trailing corners.](https://docs-assets.developer.apple.com/published/464c7be02e97dcb7470c9b8202dc2b59/toolbars-watch-top-buttons%402x.png)

![A screenshot showing two toolbar buttons in the bottom leading and trailing corners.](https://docs-assets.developer.apple.com/published/53d742601fa4b250207336099587e1d3/toolbars-watch-bottom-buttons%402x.png)

For developer guidance, see [topBarLeading](/documentation/SwiftUI/ToolbarItemPlacement/topBarLeading), [topBarTrailing](/documentation/SwiftUI/ToolbarItemPlacement/topBarTrailing), or [bottomBar](/documentation/SwiftUI/ToolbarItemPlacement/bottomBar).

You can also place a button in the scrolling view. By default, a scrolling toolbar button remains hidden until people reveal it by scrolling up. People frequently scroll to the top of a scrolling view, so discovering a toolbar button is automatic.

![A screenshot showing two toolbar buttons in the top leading and trailing corners. The toolbar also has a primary action button in the scroll view, but it's hidden.](https://docs-assets.developer.apple.com/published/027a24ac805a9e7976a1ccd1df68f0d3/toolbars-watch-primary-button-hidden%402x.png)

![A screenshot showing two toolbar buttons in the top leading and trailing corners. The toolbar also displays a primary action button in the scroll view.](https://docs-assets.developer.apple.com/published/e010a0cdf42f792ebb4715cdd5f65676/toolbars-watch-primary-button-visible%402x.png)

For developer guidance, see [primaryAction](/documentation/SwiftUI/ToolbarItemPlacement/primaryAction).

**Use a scrolling toolbar button for an important action that isn’t a primary app function.** A toolbar button gives you the flexibility to offer important functionality in a view whose primary purpose is related to that functionality, but may not be the same. For example, Mail provides the essential New Message action in a toolbar button at the top of the Inbox view. The primary purpose of the Inbox is to display a scrollable list of email messages, so it makes sense to offer the closely related compose action in a toolbar button at the top of the view.

## Resources

#### Related

[Sidebars](/design/human-interface-guidelines/sidebars)

[Tab bars](/design/human-interface-guidelines/tab-bars)

[Layout](/design/human-interface-guidelines/layout)

[Buttons](/design/human-interface-guidelines/buttons)

[Search fields](/design/human-interface-guidelines/search-fields)

[Apple Design Resources](https://developer.apple.com/design/resources/)

#### Developer documentation

[Toolbars](/documentation/SwiftUI/Toolbars) — SwiftUI

[UIToolbar](/documentation/UIKit/UIToolbar) — UIKit

[NSToolbar](/documentation/AppKit/NSToolbar) — AppKit

#### Videos

- [Get to know the new design system](https://developer.apple.com/videos/play/wwdc2025/356) - Dive deeper into the new design system to explore key changes to visual design, information architecture, and core system components. Learn how the system reshapes the relationship between interface and content, enabling you to create designs that are dynamic, harmonious, and consistent across devices, screen sizes, and input modes.

## Change log

| Date | Changes |
| --- | --- |
| December 16, 2025 | Updated guidance for Liquid Glass. |
| June 9, 2025 | Added guidance for grouping bar items, updated guidance for using symbols, and incorporated navigation bar guidance. |
| June 21, 2023 | Updated to include guidance for visionOS. |
| June 5, 2023 | Updated guidance for using toolbars in watchOS. |

---

*Extracted by [sosumi.ai](https://sosumi.ai) - Making Apple docs AI-readable.*
*This is unofficial content. All Human Interface Guidelines belong to Apple Inc.*
```


## 来源：docs/fetched/sosumi-hig/search-fields.md


```md
**Navigation:** [Human Interface Guidelines](/design/human-interface-guidelines)

**article**

# Search fields

> A search field lets people search a collection of content for specific terms they enter.

![A stylized representation of a search field containing placeholder text and a dictation icon. The image is tinted red to subtly reflect the red in the original six-color Apple logo.](https://docs-assets.developer.apple.com/published/73f9e564b79cbe48e29ae2a9f7b83682/components-search-field-intro%402x.png)

A search field is an editable text field that displays a Search icon, a Clear button, and placeholder text where people can enter what they are searching for. Search fields can use a [Scope controls and tokens](/design/human-interface-guidelines/search-fields#Scope-controls-and-tokens) as well as [Scope controls and tokens](/design/human-interface-guidelines/search-fields#Scope-controls-and-tokens) to help filter and refine the scope of their search. Across each platform, there are different patterns for accessing search based on the goals and design of your app.

For developer guidance, see [Adding a search interface to your app](/documentation/SwiftUI/Adding-a-search-interface-to-your-app); for guidance related to systemwide search, see [Searching](/design/human-interface-guidelines/searching).

## Best practices

**Display placeholder text that describes the type of information people can search for.** For example, the Apple TV app includes the placeholder text *Shows, Movies, and More*. Avoid using a term like *Search* for placeholder text because it doesn’t provide any helpful information.

**If possible, start search immediately when a person types.** Searching while someone types makes the search experience feel more responsive because it provides results that are continuously refined as the text becomes more specific.

**Consider showing suggested search terms before search begins, or as a person types.** This can help someone search faster by suggesting common searches, even when the search itself doesn’t begin immediately.

**Simplify search results.** Provide the most relevant search results first to minimize the need for someone to scroll to find what they’re looking for. In addition to prioritizing the most likely results, consider categorizing them to help people find what they want.

**Consider letting people filter search results.** For example, you can include a scope control in the search results content area to help people quickly and easily filter search results.

## Scope controls and tokens

Scope controls and tokens are components you can use to let someone narrow the parameters of a search either before or after they make it.

- A *scope control* acts like a [Segmented controls](/design/human-interface-guidelines/segmented-controls) for choosing a category for the search.
- A *token* is a visual representation of a search term that someone can select and edit, and acts as a filter for any additional terms in the search.

![A diagram of the Mail app on iPhone with the search field open above the keyboard and the word Design entered in the field. Callouts indicate a scope control at the top of the screen to switch between searching all mailboxes and the current mailbox, and a list of tokens in a Suggestions area beneath the control that represent different filters for the search.](https://docs-assets.developer.apple.com/published/c39602d60041fae736e46f91641d8373/search-fields-scope-control-tokens%402x.png)

**Use a scope control to filter among clearly defined search categories.** A scope control can help someone move from a broader scope to a narrower one. For example, in Mail on iPhone, a scope control helps people move from searching their entire mailbox to just the specific mailbox they’re viewing. For developer guidance, see [Scoping a search operation](/documentation/SwiftUI/Scoping-a-search-operation).

**Default to a broader scope and let people refine it as they need.** A broader scope provides context for the full set of available results, which helps guide people in a useful direction when they choose to narrow the scope.

**Use tokens to filter by common search terms or items.** When you define a token, the term it represents gains a visual treatment that encapsulates it, indicating that people can select and edit it as a single item. Tokens can clarify a search term, like filtering by a specific contact in Mail, or focus a search to a specific set of attributes, like filtering by photos in Messages. For the related macOS component, see [Token fields](/design/human-interface-guidelines/token-fields).

**Consider pairing tokens with search suggestions.** People may not know which tokens are available, so pairing them with search suggestions can help people learn how to use them.

## Platform considerations

*No additional considerations for visionOS*.

### iOS

There are three main places you can position the entry point for search:

- In a tab bar at the bottom of the screen
- In a toolbar at the bottom or top of the screen
- Directly inline with content

Where search makes the most sense depends on the layout, content, and navigation of your app.

#### Search in a tab bar

You can place search as a visually distinct tab on the trailing side of a tab bar, which keeps search visible and always available as people switch between the sections of your app.

![An illustration of a tab bar at the bottom of an iPhone screen. A tab for search appears on the trailing edge in a visually distinct group.](https://docs-assets.developer.apple.com/published/ca6977596a62743265fdd2132616a4c8/search-fields-search-as-tab%402x.png)

When someone navigates to the search tab, the search field that appears can start as *focused* or *unfocused*.

![An illustration of an iPhone screen with search in a tab bar at the bottom of the screen. The tab bar is hidden by the keyboard and the search field is open above the keyboard, ready for text entry.](https://docs-assets.developer.apple.com/published/cbd1eb280ecd0f8f71aab784a2bcd042/search-fields-tab-focused%402x.png)

![An illustration of an iPhone screen with search in a tab bar at the bottom of the screen. The search tab is expanded into a field that hides the tabs to its leading side. A single remaining tab on the leading edge of the screen indicates that it's possible to navigate away, and the space above the tab bar is empty and available for other content.](https://docs-assets.developer.apple.com/published/196b81213f5131b324f952180a4e9c46/search-fields-tab-unfocused%402x.png)

**Start with the search field focused to help people quickly find what they need.** When the search field starts focused, the keyboard immediately appears with the search field above it, ready to begin the search. This provides a more transient experience that brings people directly back to their previous tab after they exit search, and is ideal when you want search to resolve quickly and seamlessly.

**Start with the search field unfocused to promote discovery and exploration.** When the search field starts unfocused, the search tab expands into an unselected field at the bottom of the screen. This provides space on the rest of the screen for additional discovery or navigation before someone taps the field to begin the search. This is great for an app with a large collection of content to showcase, like Music or TV.

#### Search in a toolbar

As an alternative to search in a tab bar, you can also place search in a toolbar either at the bottom or top of the screen.

- You can include search in a bottom toolbar either as an expanded field or as a toolbar button, depending on how much space is available and how important search is to your app. When someone taps it, it animates into a search field above the keyboard so they can begin typing.
- You can include search in a top toolbar, also called a navigation bar, where it appears as a toolbar button. When someone taps it, it animates into a search field that appears either above the keyboard or inline at the top if there isn’t space at the bottom.

![An illustration of an iPhone screen with search in a bottom toolbar. The search field is positioned in an isolated group between a Filter button on the leading edge and a Compose button on the trailing edge.](https://docs-assets.developer.apple.com/published/face9eed2f9c99f2c12ca3a400919e03/search-fields-ios-toolbar-with-items%402x.png)

![An illustration of an iPhone screen with search in a top toolbar. A Back button appears on the leading edge, and an Add button appears on the trailing edge. An button group with Search and More appears next to the Add button.](https://docs-assets.developer.apple.com/published/ca4d0118cd29bd05bd2fd114163a1f64/search-fields-ios-navigation-bar-item%402x.png)

**Place search at the bottom if there’s room.** You can either add a search field to an existing toolbar, or as a new toolbar where search is the only item. Search at the bottom is useful in any situation where search is a priority, since it keeps the search experience easy to reach. Examples of apps with search at the bottom in various toolbar layouts include Settings, where it’s the only item, and Mail and Notes, where it fits alongside other important controls.

**Place search at the top when itʼs important to defer to content at the bottom of the screen, or thereʼs no bottom toolbar.** Use search at the top in cases where covering the content might interfere with a primary function of the app. The Wallet app, for example, includes event passes in a stack at the bottom of the screen for easy access and viewing at a glance.

#### Search as an inline field

In some cases you might want your app to include a search field inline with content.

**Place search as an inline field when its position alongside the content it searches strengthens that relationship.** When you need to filter or search within a single view, it can be helpful to have search appear directly next to content to illustrate that the search applies to it, rather than globally. For example, although the main search in the Music app is in the tab bar, people can navigate to their library and use an inline search field to filter their songs and albums.

**Prefer placing search at the bottom.** Generally, even for search that applies to a subset of your app’s content, it’s better to locate search where people can reach it easily. The Settings app, for example, places search at the bottom both for its top-level search and for search in the section for individual apps. If there isn’t space at the bottom (because it’s occupied by a tab bar or other important UI, for example), it’s okay to place search inline at the top.

**When at the top, position an inline search field above the list it searches, and pin it to the top toolbar when scrolling.** This helps keep it distinct from search that appears in other locations.

### iPadOS, macOS

The placement and behavior of the search field in iPadOS and macOS is similar; on both platforms, clearing the field exits search and dismisses the keyboard if present. If your app is available on both iPad and Mac, try to keep the search experience as consistent as possible across both platforms.

![An illustration of an iPad screen with a search field on the trailing edge of the top toolbar. The search field has the word Design entered into the field, and three search suggestions appear in a list beneath the field. The toolbar also includes an Inspector button, a group with New Folder and Favorite buttons, and a Share button next to the search field.](https://docs-assets.developer.apple.com/published/368ba21a44b4c65a4e53d3d2197d061b/search-fields-toolbar-search-ipad%402x.png)

![An illustration of a Mac screen with a search field on the trailing edge of the toolbar. The search field has the word Design entered into the field, and three search suggestions appear in a list beneath the field. The toolbar also includes an Inspector button, a group with New Folder and Favorite buttons, and a Share button next to the search field.](https://docs-assets.developer.apple.com/published/eb1970b09f7b35b39757201a31289bc3/search-fields-toolbar-search-mac%402x.png)

**Put a search field at the trailing side of the toolbar for many common uses.** Many apps benefit from the familiar pattern of search in the toolbar, particularly apps with split views or apps that navigate between multiple sources, like Mail, Notes, and Voice Memos. The persistent availability of search at the side of the toolbar gives it a global presence within your app, so it’s generally appropriate to start with a global scope for the initial search.

**Include search at the top of the sidebar when filtering content or navigation there.** Apps such as Settings take advantage of search to quickly filter the sidebar and expose sections that may be multiple levels deep, providing a simple way for people to search, preview, and navigate to the section or setting they’re looking for.

![An illustration of an iPad screen with a search field at the top of the sidebar on the leading edge of the screen.](https://docs-assets.developer.apple.com/published/8aed61a23fe2a9885d1a1d1da15a4b09/search-fields-ipad-search-in-sidebar%402x.png)

**Include search as an item in the sidebar or tab bar when you want an area dedicated to discovery.** If your search is paired with rich suggestions, categories, or content that needs more space, it can be helpful to have a dedicated area for it. This is particularly true for apps where browsing and search go hand in hand, like Music and TV, where it provides a unified location to highlight suggested content, categories, and recent searches. A dedicated area also ensures search is always available as people navigate and switch sections of your app.

![An illustration of an iPad screen with a tab bar at the top edge. The trailing side of the tab bar includes a Search tab with a distinct background color to differentiate it from other tab areas.](https://docs-assets.developer.apple.com/published/a2ab9bc29018fc1bbc604a91dfc905c7/search-fields-ipad-search-in-tab-bar%402x.png)

**In a search field in a dedicated area, consider immediately focusing the field when a person navigates to the section to help people search faster and locate the field itself more easily.** An exception to this is on iPad when only a virtual keyboard is available, in which case it’s better to leave the field unfocused to prevent the keyboard from unexpectedly covering the view.

**Account for window resizing with the placement of the search field.** On iPad, the search field fluidly resizes with the app window like it does on Mac. However, for compact views on iPad, itʼs important to ensure that search is available where it’s most contextually useful. For example, Notes and Mail place search above the column for the content list when they resize down to a compact view.

### tvOS

A search screen is a specialized keyboard screen that helps people enter search text, displaying search results beneath the keyboard in a fully customizable view. For developer guidance, see [UISearchController](/documentation/UIKit/UISearchController).

![An illustration of a search screen in tvOS. The screen includes a field with a keyboard input area at the top, a scope control, and a grid of top results at the bottom.](https://docs-assets.developer.apple.com/published/590a4ef7b02ccd9758f0e52e5c261574/search-fields-tvos-search%402x.png)

**Provide suggestions to make searching easier.** People typically don’t want to do a lot of typing in tvOS. To improve the search experience, provide popular and context-specific search suggestions, including recent searches when available. For developer guidance, see [Using suggested searches with a search controller](/documentation/UIKit/using-suggested-searches-with-a-search-controller).

### watchOS

When someone taps the search field, the system displays a text-input control that covers the entire screen. The app only returns to the search field after they tap the Cancel or Search button.

## Resources

#### Related

[Searching](/design/human-interface-guidelines/searching)

[Token fields](/design/human-interface-guidelines/token-fields)

#### Developer documentation

[Adding a search interface to your app](/documentation/SwiftUI/Adding-a-search-interface-to-your-app) — SwiftUI

[searchable(text:placement:prompt:)](/documentation/SwiftUI/View/searchable(text:placement:prompt:)) — SwiftUI

[UISearchBar](/documentation/UIKit/UISearchBar) — UIKit

[UISearchTextField](/documentation/UIKit/UISearchTextField) — UIKit

[NSSearchField](/documentation/AppKit/NSSearchField) — AppKit

#### Videos

- [Get to know the new design system](https://developer.apple.com/videos/play/wwdc2025/356) - Dive deeper into the new design system to explore key changes to visual design, information architecture, and core system components. Learn how the system reshapes the relationship between interface and content, enabling you to create designs that are dynamic, harmonious, and consistent across devices, screen sizes, and input modes.
- [Discoverable design](https://developer.apple.com/videos/play/wwdc2021/10126) - Discover how you can create interactive, memorable experiences to onboard people into your app. We’ll take you through discoverable design practices and learn how you can craft explorable, fun interfaces that help people grasp the possibilities of your app at a glance. We’ll also show you how to apply this methodology to personalize your content and make your app easy to customize.
- [Craft search experiences in SwiftUI](https://developer.apple.com/videos/play/wwdc2021/10176) - Discover how you can help people quickly find specific content within your apps. Learn how to use SwiftUI’s .searchable modifier in conjunction with other views to best incorporate search for your app. And we’ll show you how to elevate your implementation by providing search suggestions to help people understand the types of searches they can perform.

## Change log

| Date | Changes |
| --- | --- |
| June 9, 2025 | Updated guidance for search placement in iOS, consolidated iPadOS and macOS platform considerations, and added guidance for tokens. |
| September 12, 2023 | Combined guidance common to all platforms. |
| June 5, 2023 | Added guidance for using search fields in watchOS. |

---

*Extracted by [sosumi.ai](https://sosumi.ai) - Making Apple docs AI-readable.*
*This is unofficial content. All Human Interface Guidelines belong to Apple Inc.*
```


## 来源：docs/fetched/sosumi-hig/action-sheets.md


```md
**Navigation:** [Human Interface Guidelines](/design/human-interface-guidelines)

**article**

# Action sheets

> An action sheet is a modal view that presents choices related to an action people initiate.

![A stylized representation of a set of action sheet buttons at the bottom of an iPhone. The image is tinted red to subtly reflect the red in the original six-color Apple logo.](https://docs-assets.developer.apple.com/published/6102d0ab9e98aa9149e6a929f0576d75/components-action-sheet-intro%402x.png)

> [!NOTE]
> When you use SwiftUI, you can offer action sheet functionality in all platforms by specifying a [presentation modifier](https://developer.apple.com/documentation/swiftui/view-presentation) for a confirmation dialog. If you use UIKit, you use the [UIAlertController.Style.actionSheet](/documentation/UIKit/UIAlertController/Style/actionSheet) to display an action sheet in iOS, iPadOS, and tvOS.

## Best practices

**Use an action sheet — not an alert — to offer choices related to an intentional action.** For example, when people cancel the message they’re editing in Mail on iPhone, an action sheet provides two choices: delete the draft, or save the draft. Although an alert can also help people confirm or cancel an action that has destructive consequences, it doesn’t provide additional choices related to the action. More importantly, an alert is usually unexpected, generally telling people about a problem or a change in the current situation that might require them to act. For guidance, see [Alerts](/design/human-interface-guidelines/alerts).

![A partial screenshot of a new message being composed in Mail on iPhone.](https://docs-assets.developer.apple.com/published/d78e3a39898532655eb9155586cdc1e7/action-sheet-iphone-mail%402x.png)

![A partial screenshot of a new message being composed in Mail on iPhone, with the action sheet open after choosing to cancel the message. The action sheet presents choices to delete the draft or save the draft.](https://docs-assets.developer.apple.com/published/fedd171df9ff41645c885d3a428bc190/action-sheet-iphone-mail-delete-action%402x.png)

**Use action sheets sparingly.** Action sheets give people important information and choices, but they interrupt the current task to do so. To encourage people to pay attention to action sheets, avoid using them more than necessary.

**Aim to keep titles short enough to display on a single line.** A long title is difficult to read quickly and might get truncated or require people to scroll.

**Provide a message only if necessary.** In general, the title — combined with the context of the current action — provides enough information to help people understand their choices.

**If necessary, provide a Cancel button that lets people reject an action that might destroy data.** Place the Cancel button at the bottom of the action sheet (or in the upper-left corner of the sheet in watchOS). A SwiftUI confirmation dialog includes a Cancel button by default.

**Make destructive choices visually prominent.** Use the destructive style for buttons that perform destructive actions, and place these buttons at the top of the action sheet where they tend to be most noticeable. For developer guidance, see [destructive](/documentation/SwiftUI/ButtonRole/destructive) (SwiftUI) or [UIAlertAction.Style.destructive](/documentation/UIKit/UIAlertAction/Style-swift.enum/destructive) (UIKit).

## Platform considerations

*No additional considerations for macOS or tvOS. Not supported in visionOS.*

### iOS, iPadOS

**Use an action sheet — not a menu — to provide choices related to an action.** People are accustomed to having an action sheet appear when they perform an action that might require clarifying choices. In contrast, people expect a menu to appear when they choose to reveal it.

**Avoid letting an action sheet scroll.** The more buttons an action sheet has, the more time and effort it takes for people to make a choice. Also, scrolling an action sheet can be hard to do without inadvertently tapping a button.

### watchOS

The system-defined style for action sheets includes a title, an optional message, a Cancel button, and one or more additional buttons. The appearance of this interface is different depending on the device.

![An illustration of an action sheet on Apple Watch, showing content that represents text in the top half of the watch screen and two stacked buttons in the bottom half.](https://docs-assets.developer.apple.com/published/4ec6a46689c0ec4550d6fe48d4aa27a8/action-sheet-watch-system-defined%402x.png)

Each button has an associated style that conveys information about the button’s effect. There are three system-defined button styles:

| Style | Meaning |
| --- | --- |
| Default | The button has no special meaning. |
| Destructive | The button destroys user data or performs a destructive action in the app. |
| Cancel | The button dismisses the view without taking any action. |

**Avoid displaying more than four buttons in an action sheet, including the Cancel button.** When there are fewer buttons onscreen, it’s easier for people to view all their options at once. Because the Cancel button is required, aim to provide no more than three additional choices.

## Resources

#### Related

[Modality](/design/human-interface-guidelines/modality)

[Sheets](/design/human-interface-guidelines/sheets)

[Alerts](/design/human-interface-guidelines/alerts)

#### Developer documentation

[confirmationDialog(_:isPresented:titleVisibility:actions:)](/documentation/SwiftUI/View/confirmationDialog(_:isPresented:titleVisibility:actions:)-46zbb) — SwiftUI

[UIAlertController.Style.actionSheet](/documentation/UIKit/UIAlertController/Style/actionSheet) — UIKit

---

*Extracted by [sosumi.ai](https://sosumi.ai) - Making Apple docs AI-readable.*
*This is unofficial content. All Human Interface Guidelines belong to Apple Inc.*
```


## 来源：docs/fetched/sosumi-hig/sheets.md


```md
**Navigation:** [Human Interface Guidelines](/design/human-interface-guidelines)

**article**

# Sheets

> A sheet helps people perform a scoped task that’s closely related to their current context.

![A stylized representation of a sheet extending down from the top of a window. The image is tinted red to subtly reflect the red in the original six-color Apple logo.](https://docs-assets.developer.apple.com/published/357ff0b017e9241da82888bd3aec4372/components-sheet-intro%402x.png)

By default, a sheet is *modal*, presenting a targeted experience that prevents people from interacting with the parent view until they dismiss the sheet (for more on modal presentation, see [Modality](/design/human-interface-guidelines/modality)). A modal sheet is useful for requesting specific information from people or presenting a simple task that they can complete before returning to the parent view. For example, a sheet might let people supply information needed to complete an action, such as attaching a file, choosing the location for a move or save, or specifying the format for a selection.

In macOS, visionOS, and watchOS, a sheet is always modal, but in iOS and iPadOS, a sheet can also be nonmodal. When a nonmodal sheet is onscreen, people use its functionality to directly affect the current task in the parent view without dismissing the sheet. For example, Notes on iPhone and iPad uses a nonmodal sheet to help people apply different formatting to various text selections as they edit a note.

![A screenshot of an in-progress note on iPhone. Several words are selected and highlighted. In the bottom half of the screen, the format sheet shows that the selected words use the regular body font.](https://docs-assets.developer.apple.com/published/56830eea369c54ce82f6867a0907f3f3/sheets-nonmodal-notes-text-regular%402x.png)

![A screenshot of the same in-progress note on iPhone. Different words are selected and highlighted. The format sheet shows that the selected words use the body font in italics.](https://docs-assets.developer.apple.com/published/f7b427fb2d880e16df4ed1025a43b47c/sheets-nonmodal-notes-text-italic%402x.png)

## Best practices

**Use a sheet to present simple content or tasks.** A sheet allows some of the parent view to remain visible, helping people retain their original context as they interact with the sheet.

**For complex or prolonged user flows, consider alternatives to sheets.** For example, iOS and iPadOS offer a full-screen style of modal view that can work well to display content like videos, photos, or camera views or to help people perform multistep tasks like document or photo editing. (For developer guidance, see [UIModalPresentationStyle.fullScreen](/documentation/UIKit/UIModalPresentationStyle/fullScreen).) In a macOS experience, you might want to open a new window or let people enter full-screen mode instead of using a sheet. For example, a self-contained task like editing a document tends to work well in a separate window, whereas [Going full screen](/design/human-interface-guidelines/going-full-screen) can help people view media. In visionOS, you can give people a way to transition your app to a Full Space where they can dive into content or a task; for guidance, see [Immersive experiences](/design/human-interface-guidelines/immersive-experiences).

**Display only one sheet at a time from the main interface.** When people close a sheet, they expect to return to the parent view or window. If closing a sheet takes people back to another sheet, they can lose track of where they are in your app. If something people do within a sheet results in another sheet appearing, close the first sheet before displaying the new one. If necessary, you can display the first sheet again after people dismiss the second one.

**Use a nonmodal view when you want to present supplementary items that affect the main task in the parent view.** To give people access to information and actions they need while continuing to interact with the main window, consider using a [Split views](/design/human-interface-guidelines/split-views) in visionOS or a [Panels](/design/human-interface-guidelines/panels) in macOS; in iOS and iPadOS, you can use a nonmodal sheet for this workflow. For guidance, see [iOS, iPadOS](/design/human-interface-guidelines/sheets#iOS-iPadOS).

## Platform considerations

*No additional considerations for tvOS.*

### iOS, iPadOS

A resizable sheet expands when people scroll its contents or drag the *grabber*, which is a small horizontal indicator that can appear at the top edge of a sheet. Sheets resize according to their *detents*, which are particular heights at which a sheet naturally rests. Designed for iPhone, detents specify particular heights at which a sheet naturally rests. The system defines two detents: *large* is the height of a fully expanded sheet and *medium* is about half of the fully expanded height.

![An illustration showing an iPhone screen in portrait orientation containing a solid rounded rectangle that occupies almost all of the screen, representing a full-screen sheet. A rounded close button appears in the upper-left corner of the sheet.](https://docs-assets.developer.apple.com/published/c2a600adb5237892585d71d2ae61c9a6/sheets-large-detent%402x.png)

![An illustration showing an iPhone screen in portrait orientation containing a solid rounded rectangle that occupies half of the screen, representing a half-screen sheet. A rounded close button appears in the upper-left corner of the sheet.](https://docs-assets.developer.apple.com/published/413ac0d4cf462891f2ba9d0cd4bb01f1/sheets-medium-detent%402x.png)

Sheets automatically support the large detent. Adding the medium detent allows the sheet to rest at both heights, whereas specifying only medium prevents the sheet from expanding to full height. For developer guidance, see [detents](/documentation/UIKit/UISheetPresentationController/detents).

**In an iPhone app, consider supporting the medium detent to allow progressive disclosure of the sheet’s content.** For example, a share sheet displays the most relevant items within the medium detent, where they’re visible without resizing. To view more items, people can scroll or expand the sheet. In contrast, you might not want to support the medium detent if a sheet’s content is more useful when it displays at full height. For example, the compose sheets in Messages and Mail display only at full height to give people enough room to create content.

**Include a grabber in a resizable sheet.** A grabber shows people that they can drag the sheet to resize it; they can also tap it to cycle through the detents. In addition to providing a visual indicator of resizability, a grabber also works with VoiceOver so people can resize the sheet without seeing the screen. For developer guidance, see [prefersGrabberVisible](/documentation/UIKit/UISheetPresentationController/prefersGrabberVisible).

**Support swiping to dismiss a sheet.** People expect to swipe vertically to dismiss a sheet instead of tapping a dismiss button. If people have unsaved changes in the sheet when they begin swiping to dismiss it, use an action sheet to let them confirm their action.

**Position Done and Cancel buttons as people expect.** Typically, a Done or Dismiss button belongs in a sheet’s top-right corner in a left-to-right layout. The Cancel button belongs in a sheet’s top-left corner.

The exception to this is for sheets with additional subviews, where the Cancel button belongs in the top-right; this provides room for the Back button in the top-left on pages after the first. At the end of the navigation flow, replace the Cancel button with the Done button.

![An illustration of the top half of a sheet on iPhone. A Cancel button appears in the top-left corner of the view.](https://docs-assets.developer.apple.com/published/4c0ea03add08b05592c51ed58ebb79f1/sheets-close-button-placement-no-back%402x.png)

![An illustration of the top half of a sheet on iPhone. A Back button appears in the top-left corner of the view, and a Cancel button appears in the top-right corner.](https://docs-assets.developer.apple.com/published/4325d8e5db78c585b01a7137e34189c7/sheets-close-button-placement-with-back%402x.png)

**Prefer using the page or form sheet presentation styles in an iPadOS app.** Each style uses a default size for the sheet, centering its content on top of a dimmed background view and providing a consistent experience. For developer guidance, see [UIModalPresentationStyle](/documentation/UIKit/UIModalPresentationStyle).

### macOS

In macOS, a sheet is a cardlike view with rounded corners that floats on top of its parent window. The parent window is dimmed while the sheet is onscreen, signaling that people can’t interact with it until they dismiss the sheet. However, people expect to interact with other app windows before dismissing a sheet.

![A screenshot of the Notes app, with the What's New in Notes sheet centered on top of a dimmed Notes document in the background.](https://docs-assets.developer.apple.com/published/582e02d0df9b4a07dea002053f9ec6ea/sheets-macos-notes%402x.png)

**Present a sheet in a reasonable default size.** People don’t generally expect to resize sheets, so it’s important to use a size that’s appropriate for the content you display. In some cases, however, people appreciate a resizable sheet — such as when they need to expand the contents for a clearer view — so it’s a good idea to support resizing.

**Let people interact with other app windows without first dismissing a sheet.** When a sheet opens, you bring its parent window to the front — if the parent window is a document window, you also bring forward its modeless document-related panels. When people want to interact with other windows in your app, make sure they can bring those windows forward even if they haven’t dismissed the sheet yet.

**Position a sheet’s dismiss buttons as people expect.** People expect to find all buttons that dismiss a sheet — including Done, OK, and Cancel — at the bottom of the view, in the trailing corner.

**Use a panel instead of a sheet if people need to repeatedly provide input and observe results.** A find and replace panel, for example, might let people initiate replacements individually, so they can observe the result of each search for correctness. For guidance, see [Panels](/design/human-interface-guidelines/panels).

### visionOS

While a sheet is visible in a visionOS app, it floats in front of its parent window, dimming it, and becoming the target of people’s interactions with the app.

[A recording showing a sheet opening above a blank window in visionOS.](https://docs-assets.developer.apple.com/published/e691ccf19838ffbc34a5ca862de1bb52/visionos-modal-sheet.mp4)

**Avoid displaying a sheet that emerges from the bottom edge of a window.** To help people view the sheet, prefer centering it in their [Field of view](/design/human-interface-guidelines/spatial-layout#Field-of-view).

**Present a sheet in a default size that helps people retain their context.** Avoid displaying a sheet that covers most or all of its window, but consider letting people resize the sheet if they want.

### watchOS

In watchOS, a sheet is a full-screen view that slides over your app’s current content. The sheet is semitransparent to help maintain the current context, but the system applies a material to the background that blurs and desaturates the covered content.

![A screenshot of a sheet with a primary Action button and a default cancel button on Apple Watch.](https://docs-assets.developer.apple.com/published/fcdad96a098bea9c7b98a114403e46f2/sheets-watch-overlay%402x.png)

**Use a sheet only when your modal task requires a custom title or custom content presentation.** If you need to give people important information or present a set of choices, consider using an [Alerts](/design/human-interface-guidelines/alerts) or [Action sheets](/design/human-interface-guidelines/action-sheets).

**Keep sheet interactions brief and occasional.** Use a sheet only as a temporary interruption to the current workflow, and only to facilitate an important task. Avoid using a sheet to help people navigate your app’s content.

**Change the default label of the dismiss control only if it makes sense in your app.** By default, the sheet displays a round Cancel button in the upper left corner. Use this button when the sheet lets people make changes to the app’s behavior or to their data. If your sheet simply presents information without enabling a task, use the standard Done button instead. You can use a [Toolbars](/design/human-interface-guidelines/toolbars) to display multiple buttons.

![A screenshot of a watch displaying a sheet with the standard check mark Done button on Apple Watch.](https://docs-assets.developer.apple.com/published/bc70ac8a01bd110befa02132e9f53672/sheets-watch-custom%402x.png)

**If you change the default label, prefer using SF Symbols to represent the action.** Avoid using a label that might mislead people into thinking that the sheet is part of a hierarchical navigation interface. Also, if the text in the top-leading corner looks like a page or app title, people won’t know how to dismiss the sheet. For guidance, see [Standard icons](/design/human-interface-guidelines/icons#Standard-icons).

![A screenshot that shows a top toolbar with the default Cancel button at the top of the screen on Apple Watch.](https://docs-assets.developer.apple.com/published/4b2b3901392b3a2101bf98fbee0b7809/modal-sheet-watchos-do%402x.png)

![A checkmark in a circle to indicate correct usage.](https://docs-assets.developer.apple.com/published/88662da92338267bb64cd2275c84e484/checkmark%402x.png)

![A screenshot that shows a top toolbar with a custom Back button at the top of the screen on Apple Watch.](https://docs-assets.developer.apple.com/published/3342cdf046b51d5b7e22008f4fa36cf8/modal-sheet-watchos-do-not-1%402x.png)

![An X in a circle to indicate incorrect usage.](https://docs-assets.developer.apple.com/published/209f6f0fc8ad99d9bf59e12d82d06584/crossout%402x.png)

![A screenshot that shows a top toolbar with a button with the words Page title at the top of the screen on Apple Watch.](https://docs-assets.developer.apple.com/published/7e655a4130904ed5def637dde60325f9/modal-sheet-watchos-do-not-2%402x.png)

![An X in a circle to indicate incorrect usage.](https://docs-assets.developer.apple.com/published/209f6f0fc8ad99d9bf59e12d82d06584/crossout%402x.png)

## Resources

#### Related

[Modality](/design/human-interface-guidelines/modality)

[Action sheets](/design/human-interface-guidelines/action-sheets)

[Popovers](/design/human-interface-guidelines/popovers)

[Panels](/design/human-interface-guidelines/panels)

#### Developer documentation

[sheet(item:onDismiss:content:)](/documentation/SwiftUI/View/sheet(item:onDismiss:content:)) — SwiftUI

[UISheetPresentationController](/documentation/UIKit/UISheetPresentationController) — UIKit

[presentAsSheet(_:)](/documentation/AppKit/NSViewController/presentAsSheet(_:)) — AppKit

## Change log

| Date | Changes |
| --- | --- |
| March 29, 2024 | Added guidance to use form or page sheet styles in iPadOS apps. |
| December 5, 2023 | Recommended using a split view to offer supplementary items in a visionOS app. |
| June 21, 2023 | Updated to include guidance for visionOS. |
| June 5, 2023 | Updated guidance for using sheets in watchOS. |

---

*Extracted by [sosumi.ai](https://sosumi.ai) - Making Apple docs AI-readable.*
*This is unofficial content. All Human Interface Guidelines belong to Apple Inc.*
```


## 来源：docs/fetched/sosumi-hig/windows.md


```md
**Navigation:** [Human Interface Guidelines](/design/human-interface-guidelines)

**article**

# Windows

> A window presents UI views and components in your app or game.

![A stylized representation of a window with close, minimize, and full-screen buttons. The image is tinted red to subtly reflect the red in the original six-color Apple logo.](https://docs-assets.developer.apple.com/published/3c5ea22db1d7d414c160c95ed7f62ec9/components-window-intro%402x.png)

In iPadOS, macOS, and visionOS, windows help define the visual boundaries of app content and separate it from other areas of the system, and enable multitasking workflows both within and between apps. Windows include system-provided interface elements such as frames and window controls that let people open, close, resize, and relocate them.

Conceptually, apps use two types of windows to display content:

- A *primary* window presents the main navigation and content of an app, and actions associated with them.
- An *auxiliary* window presents a specific task or area in an app. Dedicated to one experience, an auxiliary window doesn’t allow navigation to other app areas, and it typically includes a button people use to close it after completing the task.

For guidance laying out content within a window on any platform, see [Layout](/design/human-interface-guidelines/layout); for guidance laying out content in Apple Vision Pro space, see [Spatial layout](/design/human-interface-guidelines/spatial-layout). For developer guidance, see [Windows](/documentation/SwiftUI/Windows).

## Best practices

**Make sure that your windows adapt fluidly to different sizes to support multitasking and multiwindow workflows.** For guidance, see [Layout](/design/human-interface-guidelines/layout) and [Multitasking](/design/human-interface-guidelines/multitasking).

**Choose the right moment to open a new window.** Opening content in a separate window is great for helping people multitask or preserve context. For example, Mail opens a new window whenever someone selects the Compose action, so both the new message and the existing email are visible at the same time. However, opening new windows excessively creates clutter and can make navigating your app more confusing. Avoid opening new windows as default behavior unless it makes sense for your app.

**Consider providing the option to view content in a new window.** While it’s best to avoid opening new windows as default behavior unless it benefits your user experience, it’s also great to give people the flexibility of viewing content in multiple ways. Consider letting people view content in a new window using a command in a [Context menus](/design/human-interface-guidelines/context-menus) or in the [File menu](/design/human-interface-guidelines/the-menu-bar#File-menu). For developer guidance, see [OpenWindowAction](/documentation/SwiftUI/OpenWindowAction).

**Avoid creating custom window UI.** System-provided windows look and behave in a way that people understand and recognize. Avoid making custom window frames or controls, and don’t try to replicate the system-provided appearance. Doing so without perfectly matching the system’s look and behavior can make your app feel broken.

**Use the term *window* in user-facing content.** The system refers to app windows as *windows* regardless of type. Using different terms — including *scene*, which refers to window implementation — is likely to confuse people.

## Platform considerations

*Not supported in iOS, tvOS, or watchOS.*

### iPadOS

Windows present in one of two ways depending on a person’s choice in Multitasking & Gestures settings.

- **Full screen.** App windows fill the entire screen, and people switch between them — or between multiple windows of the same app — using the app switcher.
- **Windowed.** People can freely resize app windows. Multiple windows can be onscreen at once, and people can reposition them and bring them to the front. The system remembers window size and placement even when an app is closed.

**Make sure window controls don’t overlap toolbar items.** When windowed, app windows include window controls at the leading edge of the toolbar. If your app has toolbar buttons at the leading edge, they might be hidden by window controls when they appear. To prevent this, instead of placing buttons directly on the leading edge, move them inward when the window controls appear.

**Consider letting people use a gesture to open content in a new window.** For example, people can use the pinch gesture to expand a Notes item into a new window. For developer guidance, see [collectionView(_:sceneActivationConfigurationForItemAt:point:)](/documentation/UIKit/UICollectionViewDelegate/collectionView(_:sceneActivationConfigurationForItemAt:point:)) (to transition from a collection view item), or [UIWindowScene.ActivationInteraction](/documentation/UIKit/UIWindowScene/ActivationInteraction) (to transition from an item in any other view).

> [!TIP]
> If you only need to let people view one file, you can present it without creating your own window, but you must support multiple windows in your app. For developer guidance, see [QLPreviewSceneActivationConfiguration](/documentation/QuickLook/QLPreviewSceneActivationConfiguration).

### macOS

In macOS, people typically run several apps at the same time, often viewing windows from multiple apps on one desktop and switching frequently between different windows — moving, resizing, minimizing, and revealing the windows to suit their work style.

To learn about setting up a window to display your game in macOS, see [Managing your game window for Metal in macOS](/documentation/Metal/managing-your-game-window-for-metal-in-macos).

#### macOS window anatomy

A macOS window consists of a frame and a body area. People can move a window by dragging the frame and can often resize the window by dragging its edges.

The *frame* of a window appears above the body area and can include window controls and a  [Toolbars](/design/human-interface-guidelines/toolbars). In rare cases, a window can also display a bottom bar, which is a part of the frame that appears below body content.

#### macOS window states

A macOS window can have one of three states:

- **Main.** The frontmost window that people view is an app’s main window. There can be only one main window per app.
- **Key.** Also called the *active window*, the key window accepts people’s input. There can be only one key window onscreen at a time. Although the front app’s main window is usually the key window, another window — such as a panel floating above the main window — might be key instead. People typically click a window to make it key; when people click an app’s Dock icon to bring all of that app’s windows forward, only the most recently accessed window becomes key.
- **Inactive.** A window that’s not in the foreground is an inactive window.

The system gives main, key, and inactive windows different appearances to help people visually identify them. For example, the key window uses color in the title bar options for closing, minimizing, and zooming; inactive windows and main windows that aren’t key use gray in these options. Also, inactive windows don’t use [Materials](/design/human-interface-guidelines/materials) (an effect that can pull color into a window from the content underneath it), which makes them appear subdued and seem visually farther away than the main and key windows.

![An illustration of a stack of three windows, as follows: An inactive window in the background, an app’s main window in the middle, and a key window appearing above the other two windows.](https://docs-assets.developer.apple.com/published/7ecd910726f347fb452d9ecd2b492d22/window-states%402x.png)

> [!NOTE]
> Some windows — typically, panels like Colors or Fonts — become the key window only when people click the window’s title bar or a component that requires keyboard input, such as a text field.

**Make sure custom windows use the system-defined appearances.** People rely on the visual differences between windows to help them identify the foreground window and know which window will accept their input. When you use system-provided components, a window’s background and button appearances update automatically when the window changes state; if you use custom implementations, you need to do this work yourself.

**Avoid putting critical information or actions in a bottom bar, because people often relocate a window in a way that hides its bottom edge.** If you must include one, use it only to display a small amount of information directly related to a window’s contents or to a selected item within it. For example, Finder uses a bottom bar (called the status bar) to display the total number of items in a window, the number of selected items, and how much space is available on the disk. A bottom bar is small, so if you have more information to display, consider using an inspector, which typically presents information on the trailing side of a split view.

### visionOS

visionOS defines two main window styles: default and volumetric. Both a default window (called a *window*) and a volumetric window (called a *volume*) can display 2D and 3D content, and people can view multiple windows and volumes at the same time in both the Shared Space and a Full Space.

![An illustration representing a window in visionOS. The illustration consists of two parallel rounded rectangles, slightly separated and displayed on an angle, positioned above a window bar.](https://docs-assets.developer.apple.com/published/e8dc51484c2e5f3289a5f6a878f4c47d/visionos-window-style-2d-window%402x.png)

![An illustration representing a volume in visionOS. The illustration consists of a translucent cube. The base of the cube is darker than the other sides. The front of the cube is positioned above a window bar.](https://docs-assets.developer.apple.com/published/92d953d099f72f9909c47bad408f4c9b/visionos-window-style-3d-volume%402x.png)

> [!NOTE]
> visionOS also defines the *plain* window style, which is similar to the default style, except that the upright plane doesn’t use the glass background. For developer guidance, see [PlainWindowStyle](/documentation/SwiftUI/PlainWindowStyle).

The system defines the initial position of the first window or volume people open in your app or game. In both the Shared Space and a Full Space, people can move windows and volumes to new locations.

#### visionOS windows

The default window style consists of an upright plane that uses an unmodifiable background [Materials](/design/human-interface-guidelines/materials) called *glass* and includes a close button, window bar, and resize controls that let people close, move, and resize the window. A window can also include a Share button, [Tab bars](/design/human-interface-guidelines/tab-bars), [Toolbars](/design/human-interface-guidelines/toolbars), and one or more [Ornaments](/design/human-interface-guidelines/ornaments). By default, visionOS uses dynamic [Scale](/design/human-interface-guidelines/spatial-layout#Scale) to help a window’s size appear to remain consistent regardless of its proximity to the viewer. For developer guidance, see [DefaultWindowStyle](/documentation/SwiftUI/DefaultWindowStyle).

![A screenshot of a window for an app named 'Hello World' in visionOS. The window includes text and buttons for entering different experiences.](https://docs-assets.developer.apple.com/published/95650cb19e1930e6b08ca5aa3b5b06a0/visionos-window-2d%402x.png)

**Prefer using a window to present a familiar interface and to support familiar tasks.** Help people feel at home in your app by displaying an interface they’re already comfortable with, reserving more [Immersive experiences](/design/human-interface-guidelines/immersive-experiences) for the meaningful content and activities you offer. If you want to showcase bounded 3D content like a game board, consider using a [visionOS volumes](/design/human-interface-guidelines/windows#visionOS-volumes).

**Retain the window’s glass background.** The default glass background helps your content feel like part of people’s surroundings while adapting dynamically to lighting and using specular reflections and shadows to communicate the window’s scale and position. Removing the glass material tends to cause UI elements and text to become less legible and to no longer appear related to each other; using an opaque background obscures people’s surroundings and can make a window feel constricting and heavy.

**Choose an initial window size that minimizes empty areas within it.** By default, a window measures 1280x720 pt. When a window first opens, the system places it about two meters in front of the wearer, giving it an apparent width of about three meters. Too much empty space inside a window can make it look unnecessarily large while also obscuring other content in people’s space.

**Aim for an initial shape that suits a window’s content.** For example, a default Keynote window is wide because slides are wide, whereas a default Safari window is tall because most webpages are much longer than they are wide. For games, a tower-building game is likely to open in a taller window than a driving game.

**Choose a minimum and maximum size for each window to help keep your content looking great.** People appreciate being able to resize windows as they customize their space, but you need to make sure your layout adjusts well across all sizes. If you don’t set a minimum and maximum size for a window, people could make it so small that UI elements overlap or so large that your app or game becomes unusable. For developer guidance, see [Positioning and sizing windows](/documentation/visionOS/positioning-and-sizing-windows).

![A screenshot of a window for an app in visionOS. The window includes text that discusses objects in orbit, and it includes buttons for viewing a satellite, the moon, and a telescope. The satellite button is selected and a 3D satellite is displayed.](https://docs-assets.developer.apple.com/published/db1e41fe4000281898003f792ff037c8/visionos-window-2d-with-volume%402x.png)

**Minimize the depth of 3D content you display in a window.** The system adds highlights and shadows to the views and controls within a window, giving them the appearance of [Depth](/design/human-interface-guidelines/spatial-layout#Depth) and helping them feel more substantial, especially when people view the window from an angle. Although you can display 3D content in a window, the system clips it if the content extends too far from the window’s surface. To display 3D content that has greater depth, use a volume.

#### visionOS volumes

You can use a volume to display 2D or 3D content that people can view from any angle. A volume includes window-management controls just like a window, but unlike in a window, a volume’s close button and window bar shift position to face the viewer as they move around the volume. For developer guidance, see [VolumetricWindowStyle](/documentation/SwiftUI/VolumetricWindowStyle).

![A screenshot of a volume containing a 3D globe in visionOS, beside a window.](https://docs-assets.developer.apple.com/published/99098a290c36254e48329511216e1d5a/visionos-window-3d%402x.png)

**Prefer using a volume to display rich, 3D content.** In contrast, if you want to present a familiar, UI-centric interface, it generally works best to use a [visionOS windows](/design/human-interface-guidelines/windows#visionOS-windows).

**Place 2D content so it looks good from multiple angles.** Because a person’s perspective changes as they move around a volume, the location of 2D content within it might appear to change in ways that don’t make sense. To pin 2D content to specific areas of 3D content inside a volume, you can use an attachment.

**In general, use dynamic scaling.** Dynamic scaling helps a volume’s content remain comfortably legible and easy to interact with, even when it’s far away from the viewer. On the other hand, if you want a volume’s content to represent a real-world object, like a product in a retail app, you can use fixed scaling (this is the default).

**Take advantage of the default baseplate appearance to help people discern the edges of a volume.** In visionOS 2 and later, the system automatically makes a volume’s horizontal “floor,” or *baseplate*, visible by displaying a gentle glow around its border when people look at it. If your content doesn’t fill the volume, the system-provided glow can help people become aware of the volume’s edges, which can be particularly useful in keeping the resize control easy to find. On the other hand, if your content is full bleed or fills the volume’s bounds — or if you display a custom baseplate appearance — you may not want the default glow.

**Consider offering high-value content in an ornament.** In visionOS 2 and later, a volume can include an ornament in addition to a toolbar and tab bar. You can use an ornament to reduce clutter in a volume and elevate important views or controls. When you use an attachment anchor to specify the ornament’s location, such as `topBack` or `bottomFront`, the ornament remains in the same position, relative to the viewer’s perspective, as they move around the volume. Be sure to avoid placing an ornament on the same edge as a toolbar or tab bar, and prefer creating only one additional ornament to avoid overshadowing the important content in your volume. For developer guidance, see [ornament(visibility:attachmentAnchor:contentAlignment:ornament:)](/documentation/SwiftUI/View/ornament(visibility:attachmentAnchor:contentAlignment:ornament:)).

**Choose an alignment that supports the way people interact with your volume.** As people move a volume, the baseplate can remain parallel to the floor of a person’s surroundings, or it can tilt to match the angle at which a person is looking. In general, a volume that remains parallel to the floor works well for content that people don’t interact with much, whereas a volume that tilts to match where a person is looking can keep content comfortably usable, even when the viewer is reclining.

## Resources

#### Related

[Layout](/design/human-interface-guidelines/layout)

[Split views](/design/human-interface-guidelines/split-views)

[Multitasking](/design/human-interface-guidelines/multitasking)

#### Developer documentation

[Windows](/documentation/SwiftUI/Windows) — SwiftUI

[WindowGroup](/documentation/SwiftUI/WindowGroup) — SwiftUI

[UIWindow](/documentation/UIKit/UIWindow) — UIKit

[NSWindow](/documentation/AppKit/NSWindow) — AppKit

#### Videos

- [Elevate the design of your iPad app](https://developer.apple.com/videos/play/wwdc2025/208) - Make your app look and feel great on iPadOS. Learn best practices for designing a responsive layout for resizable app windows. Get familiar with window controls and explore the best ways to accommodate them. Discover the building blocks of a great menu bar. And meet the new pointer and its updated effects.

## Change log

| Date | Changes |
| --- | --- |
| June 9, 2025 | Added best practices, and updated with guidance for resizable windows in iPadOS. |
| June 10, 2024 | Updated to include guidance for using volumes in visionOS 2 and added game-specific examples. |
| June 21, 2023 | Updated to include guidance for visionOS. |

---

*Extracted by [sosumi.ai](https://sosumi.ai) - Making Apple docs AI-readable.*
*This is unofficial content. All Human Interface Guidelines belong to Apple Inc.*
```


## 来源：docs/fetched/sosumi-hig/lists-and-tables.md


```md
**Navigation:** [Human Interface Guidelines](/design/human-interface-guidelines)

**article**

# Lists and tables

> Lists and tables present data in one or more columns of rows.

![A stylized representation of a three-row table with header and footer text. The image is tinted red to subtly reflect the red in the original six-color Apple logo.](https://docs-assets.developer.apple.com/published/c3e26d2515ac05cae7aba2704f8640d6/components-lists-and-tables-intro%402x.png)

A table or list can represent data that’s organized in groups or hierarchies, and it can support user interactions like selecting, adding, deleting, and reordering. Apps and games in all platforms can use tables to present content and options; many apps use lists to express an overall information hierarchy and help people navigate it. For example, iOS Settings uses a hierarchy of lists to help people choose options, and several apps — such as Mail in iPadOS and macOS — use a table within a [split view](https://developer.apple.com/design/human-interface-guidelines/split-views).

Sometimes, people need to work with complex data in a multicolumn table or a spreadsheet. Apps that offer productivity tasks often use a table to represent various characteristics or attributes of the data in separate, sortable columns.

## Best practices

**Prefer displaying text in a list or table.** A table can include any type of content, but the row-based format is especially well suited to making text easy to scan and read. If you have items that vary widely in size — or you need to display a large number of images — consider using a [collection](https://developer.apple.com/design/human-interface-guidelines/collections) instead.

**Let people edit a table when it makes sense.** People appreciate being able to reorder a list, even if they can’t add or remove items. In iOS and iPadOS, people must enter an edit mode before they can select table items.

**Provide appropriate feedback when people select a list item.** The feedback can vary depending on whether selecting the item reveals a new view or toggles the item’s state. In general, a table that helps people navigate through a hierarchy persistently highlights the selected row to clarify the path people are taking. In contrast, a table that lists options often highlights a row only briefly before adding an image — such as a checkmark — indicating that the item is selected.

## Content

**Keep item text succinct so row content is comfortable to read.** Short, succinct text can help minimize truncation and wrapping, making text easier to read and scan. If each item consists of a large amount of text, consider alternatives that help you avoid displaying over-large table rows. For example, you could list item titles only, letting people choose an item to reveal its content in a detail view.

**Consider ways to preserve readability of text that might otherwise get clipped or truncated.** When a table is narrow — for example, if people can vary its width — you want content to remain recognizable and easy to read. Sometimes, an ellipsis in the middle of text can make an item easier to distinguish because it preserves both the beginning and the end of the content.

**Use descriptive column headings in a multicolumn table.** Use nouns or short noun phrases with [title-style capitalization](https://support.apple.com/guide/applestyleguide/c-apsgb744e4a3/web#apdca93e113f1d64), and don’t add ending punctuation. If you don’t include a column heading in a single-column table view, use a label or a header to help people understand the context.

## Style

**Choose a table or list style that coordinates with your data and platform.** Some styles use visual details to help communicate grouping and hierarchy or to provide specific experiences. In iOS and iPadOS, for example, the grouped style uses headers, footers, and additional space to separate groups of data; the elliptical style available in watchOS makes items appear as if they’re rolling off a rounded surface as people scroll; and macOS defines a bordered style that uses alternating row backgrounds to help make large tables easier to use. For developer guidance, see [ListStyle](/documentation/SwiftUI/ListStyle).

**Choose a row style that fits the information you need to display.** For example, you might need to display a small image in the leading end of a row, followed by a brief explanatory label. Some platforms provide built-in row styles you can use to arrange content in list rows, such as the [UIListContentConfiguration](/documentation/UIKit/UIListContentConfiguration-swift.struct) API you can use to lay out content in a list’s rows, headers, and footers in iOS, iPadOS, and tvOS.

## Platform considerations

### iOS, iPadOS, visionOS

**Use an info button only to reveal more information about a row’s content.** An info button — called a *detail disclosure button* when it appears in a list row — doesn’t support navigation through a hierarchical table or list. If you need to let people drill into a list or table row’s subviews, use a disclosure indicator accessory control. For developer guidance, see [UITableViewCell.AccessoryType.disclosureIndicator](/documentation/UIKit/UITableViewCell/AccessoryType-swift.enum/disclosureIndicator).

![An illustration of a grouped list of rows. Each list item includes an info button at the trailing end of the row.](https://docs-assets.developer.apple.com/published/fd301d26835e0341b95eaa2027f200f2/info-button-in-list%402x.png)

![An illustration of a grouped list of rows. Each list item includes a right-pointing chevron at the trailing end of the row.](https://docs-assets.developer.apple.com/published/dcb3678fe458846713b03756ab5e1a28/disclosure-indicator-in-list%402x.png)

**Avoid adding an index to a table that displays controls — like disclosure indicators — in the trailing ends of its rows.** An *index* typically consists of the letters in an alphabet, displayed vertically at the trailing side of a list. People can jump to a specific section in the list by choosing the index letter that maps to it. Because both the index and elements like disclosure indicators appear on the trailing side of a list, it can be difficult for people to use one element without activating the other.

### macOS

**When it provides value, let people click a column heading to sort a table view based on that column**. If people click the heading of a column that’s already sorted, re-sort the data in the opposite direction.

**Let people resize columns.** Data displayed in a table view often varies in width. People appreciate resizing columns to help them concentrate on different areas or reveal clipped data.

**Consider using alternating row colors in a multicolumn table.** Alternating colors can help people track row values across columns, especially in a wide table.

**Use an outline view instead of a table view to present hierarchical data.** An [outline view](https://developer.apple.com/design/human-interface-guidelines/outline-views) looks like a table view, but includes disclosure triangles for exposing nested levels of data. For example, an outline view might display folders and the items they contain.

### tvOS

**Confirm that images near a table still look good as each row highlights and slightly increases in size when it becomes focused.** A focused row’s corners can also become rounded, which may affect the appearance of images on either side of it. Account for this effect as you prepare images, and don’t add your own masks to round the corners.

### watchOS

**When possible, limit the number of rows.** Short lists are easier for people to scan, but sometimes people expect a long list of items. For example, if people subscribe to a large number of podcasts, they might think something’s wrong if they can’t view all their items. You can help make a long list more manageable by listing the most relevant items and providing a way for people to view more.

**Constrain the length of detail views if you want to support vertical page-based navigation.** People use vertical page-based navigation to swipe vertically among the detail items of different list rows. Navigating in this way saves time because people don’t need to return to the list to tap a new detail item, but it works only when detail views are short. If your detail views scroll, people won’t be able to use vertical page-based navigation to swipe among them.

## Resources

#### Related

[Collections](/design/human-interface-guidelines/collections)

[Outline views](/design/human-interface-guidelines/outline-views)

[Layout](/design/human-interface-guidelines/layout)

#### Developer documentation

[List](/documentation/SwiftUI/List) — SwiftUI

[Tables](/documentation/SwiftUI/Tables) — SwiftUI

[UITableView](/documentation/UIKit/UITableView) — UIKit

[NSTableView](/documentation/AppKit/NSTableView) — AppKit

#### Videos

- [Stacks, Grids, and Outlines in SwiftUI](https://developer.apple.com/videos/play/wwdc2020/10031) - Display detailed data in your SwiftUI apps more quickly and efficiently with improved stacks and new list and outline views. Now available on iOS and iPadOS for the first time, outlines are a new multi-platform tool for expressing hierarchical data that work alongside stacks and lists. Learn how to use new and improved tools in SwiftUI to display more content on screen when using table views, create smooth-scrolling and responsive stacks, and build out list views for content that needs more than a vStack can provide. Take your layout options even further with the new grid view, as well as disclosure groups.

To get the most out of this video, we recommend first checking out “SwiftUI App Essentials,” which provides an overview of everything new in SwiftUI for 2020. If you’re brand-new to coding with SwiftUI, we also suggest watching 2019’s “SwiftUI Essentials” talk.

## Change log

| Date | Changes |
| --- | --- |
| June 21, 2023 | Updated to include guidance for visionOS. |
| June 5, 2023 | Updated guidance to reflect changes in watchOS 10. |

---

*Extracted by [sosumi.ai](https://sosumi.ai) - Making Apple docs AI-readable.*
*This is unofficial content. All Human Interface Guidelines belong to Apple Inc.*
```


## 来源：docs/fetched/sosumi-hig/menus.md


```md
**Navigation:** [Human Interface Guidelines](/design/human-interface-guidelines)

**article**

# Menus

> A menu reveals its options when people interact with it, making it a space-efficient way to present commands in your app or game.

![A stylized representation of a menu containing a selected item and displaying a submenu. The image is tinted red to subtly reflect the red in the original six-color Apple logo.](https://docs-assets.developer.apple.com/published/a64b5649dc039710622ba211979e116b/components-menus-intro%402x.png)

Menus are ubiquitous in apps and games, so most people already know how to use them. Whether you use system-provided components or custom ones, people expect menus to behave in familiar ways. For example, people understand that opening a menu reveals one or more *menu items*, each of which represents a command, option, or state that affects the current selection or context. The guidance for labeling and organizing menu items applies to all types of menus in all experiences.

> [!NOTE]
> Several system-provided components also include menus that support specific use cases. For example, a [Pop-up buttons](/design/human-interface-guidelines/pop-up-buttons) or [Pull-down buttons](/design/human-interface-guidelines/pull-down-buttons) can reveal a menu of options directly related to its action; a [Context menus](/design/human-interface-guidelines/context-menus) lets people access a small number of frequently used actions relevant to their current view or task; and in macOS and iPadOS, [The menu bar](/design/human-interface-guidelines/the-menu-bar) menus contain all the commands people can perform in the app or game.

## Labels

A menu item’s label describes what it does and may include a symbol if it helps to clarify meaning. In an app, a menu item can also display the associated keyboard command, if there is one; in a game, a menu item rarely displays a keyboard command because a game typically needs to handle input from a wider range of devices and may offer game-specific mappings for various keys.

> [!NOTE]
> Depending on menu layout, an iOS, iPadOS, or visionOS app can display a few unlabeled menu items that use only symbols or icons to identify them. For guidance, see [visionOS](/design/human-interface-guidelines/menus#visionOS) and [iOS, iPadOS](/design/human-interface-guidelines/menus#iOS-iPadOS).

**For each menu item, write a label that clearly and succinctly describes it.** In general, label a menu item that initiates an action using a verb or verb phrase that describes the action, such as View, Close, or Select. For guidance labeling menu items that show and hide something in the interface or show the currently selected state of something, see [Toggled items](/design/human-interface-guidelines/menus#Toggled-items). As with all the copy you write, let your app’s or game’s communication style guide the tone of the menu-item labels you create.

**To be consistent with platform experiences, use title-style capitalization.** Although a game might have a different writing style, generally prefer using title-style capitalization, which capitalizes every word except articles, coordinating conjunctions, and short prepositions, and capitalizes the last word in the label, regardless of the part of speech. For complete guidance on this style of capitalization in English, see [title-style capitalization](https://support.apple.com/guide/applestyleguide/c-apsgb744e4a3/web#apdca93e113f1d64).

**Remove articles like *a*, *an*, and *the* from menu-item labels to save space.** In English, articles always lengthen labels, but rarely enhance understanding. For example, changing a menu-item label from  View Settings to View the Settings doesn’t provide additional clarification.

**Show people when a menu item is unavailable.** An unavailable menu item often appears dimmed and doesn’t respond to interactions. If all of a menu’s items are unavailable, the menu itself needs to remain available so people can open it and learn about the commands it contains.

**Append an ellipsis to a menu item’s label when the action requires more information before it can complete.** The ellipsis character (…) signals that people need to input information or make additional choices, typically within another view.

## Icons

**Represent menu item actions with familiar icons.** Icons help people recognize common actions throughout your app. Use the same icons as the system to represent actions such as Copy, Share, and Delete, wherever they appear. For a list of icons that represent common actions, see [Standard icons](/design/human-interface-guidelines/icons#Standard-icons).

**Don’t display an icon if you can’t find one that clearly represents the menu item.** Not all menu items need an icon. Be careful when adding icons for custom menu items to avoid confusion with other existing actions, and don’t add icons just for the sake of ornamentation.

![An illustration of a menu containing the days of the week. Each menu item is represented by a different symbol with no relation to the corresponding day.](https://docs-assets.developer.apple.com/published/e612c40d780feb72382a1d387aa556f6/menus-days-of-the-week-incorrect-icons%402x.png)

![An X in a circle to indicate incorrect usage.](https://docs-assets.developer.apple.com/published/209f6f0fc8ad99d9bf59e12d82d06584/crossout%402x.png)

![An illustration of a menu containing the days of the week with no accompanying symbols.](https://docs-assets.developer.apple.com/published/72bddfbe313d096cac7f09d136d2a601/menus-days-of-the-week-correct-no-icons%402x.png)

![A checkmark in a circle to indicate correct usage.](https://docs-assets.developer.apple.com/published/88662da92338267bb64cd2275c84e484/checkmark%402x.png)

**Use a single icon to introduce a group of similar items.** Instead of adding individual icons for each action, or reusing the same icon for all of them, establish a common theme with the symbol for the first item and rely on the menu item text to keep the remaining items distinct.

![An illustration of an Edit menu that includes several similar Copy actions, with each represented by a different symbol.](https://docs-assets.developer.apple.com/published/7deb98def27f19a33794b9ec6cee02b4/menus-copy-actions-different-icons-incorrect%402x.png)

![An X in a circle to indicate incorrect usage.](https://docs-assets.developer.apple.com/published/209f6f0fc8ad99d9bf59e12d82d06584/crossout%402x.png)

![An illustration of an Edit menu that includes several similar Copy actions, with each represented by the same Copy symbol.](https://docs-assets.developer.apple.com/published/60241bb399a7e5faa06e9e53de4d858b/menus-copy-actions-repeated-icons-incorrect%402x.png)

![An X in a circle to indicate incorrect usage.](https://docs-assets.developer.apple.com/published/209f6f0fc8ad99d9bf59e12d82d06584/crossout%402x.png)

![An illustration of an Edit menu that includes several similar Copy actions. The first is represented by the Copy symbol, and the others with no symbol.](https://docs-assets.developer.apple.com/published/ee3e63278a8b0b023e35e963077f2596/menus-copy-actions-single-icon-correct%402x.png)

![A checkmark in a circle to indicate correct usage.](https://docs-assets.developer.apple.com/published/88662da92338267bb64cd2275c84e484/checkmark%402x.png)

## Organization

Organizing menu items in ways that reflect how people use your app or game can make your experience feel straightforward and easy to use.

**Prefer listing important or frequently used menu items first.** People tend to start scanning a menu from the top, so listing high-priority items first often means that people can find what they want without reading the entire menu.

**Consider grouping logically related items.** For example, grouping editing commands like Copy, Cut, and Paste or camera commands like Look Up, Look Down, and Look Left can help people remember where to find them. To help people visually distinguish such groups, use a separator. Depending on the platform and type of menu, a *separator* appears between groups of items as a horizontal line or a short gap in the menu’s background appearance.

**Prefer keeping all logically related commands in the same group, even if the commands don’t all have the same importance.** For example, people generally use Paste and Match Style much less often than they use Paste, but they expect to find both commands in the same group that contains more frequently used editing commands like Copy and Cut.

**Be mindful of menu length.** People need more time and attention to read a long menu, which means they may miss the command they want. If a menu is too long, consider dividing it into separate menus. Alternatively, you might be able to use a submenu to shorten the list, such as listing difficulty levels in a submenu of a New Game menu item. The exception is when a menu contains user-defined or dynamically generated content, like the History and Bookmarks menus in Safari. People expect such a menu to accommodate all the items they add to it, so a long menu is fine, and scrolling is acceptable.

## Submenus

Sometimes, a menu item can reveal a set of closely related items in a subordinate list called a *submenu*. A menu item indicates the presence of a submenu by displaying a symbol — like a chevron — after its label. Submenus are functionally identical to menus, aside from their hierarchical positioning.

**Use submenus sparingly.** Each submenu adds complexity to the interface and hides the items it contains. You might consider creating a submenu when a term appears in more than two menu items in the same group. For example, instead of offering separate menu items for Sort by Date, Sort by Score, and Sort by Time, a game could present a menu item that uses a submenu to list the sorting options Date, Score, and Time. It generally works well to use the repeated term — in this case, *Sort by* — in the menu item’s label to help people predict the contents of the submenu.

**Limit the depth and length of submenus.** It can be difficult for people to reveal multiple levels of hierarchical submenus, so it’s generally best to restrict them to a single level. Also, if a submenu contains more than about five items, consider creating a new menu.

**Make sure a submenu remains available even when its nested menu items are unavailable.** A submenu item — like all menu items — needs to let people open it and learn about the commands it contains.

**Prefer using a submenu to indenting menu items.** Using indentation is inconsistent with the system and doesn’t clearly express the relationships between the menu items.

## Toggled items

Menu items often represent attributes or objects that people can turn on or off. If you want to avoid listing a separate menu item for each state, it can be efficient to create a single, toggled menu item that communicates the current state and lets people change it.

**Consider using a changeable label that describes an item’s current state.** For example, instead of listing two menu items like Show Map and Hide Map, you could include one menu item whose label changes from Show Map to Hide Map, depending on whether the map is visible.

**Include a verb if a changeable label isn’t clear enough.** For example, people might not know whether the changeable labels HDR On and HDR Off describe actions or states. If you needed to clarify that these items represent actions, you could add verbs to the labels, like Turn HDR On and Turn HDR Off.

**If necessary, display both menu items instead of one toggled item.** Sometimes, it helps people to view both actions or states at the same time. For example, a game could list both Take Account Online and Take Account Offline items, so when someone’s account is online, only the Take Account Offline menu item appears available.

**Consider using a checkmark to show that an attribute is currently in effect.** It’s easy for people to scan for checkmarks in a list of attributes to find the ones that are selected. For example, in the standard Format > Font menu, checkmarks can make it easy for people notice the styles that apply to selected text.

**Consider offering a menu item that makes it easy to remove multiple toggled attributes.** For example, if you let people apply several styles to selected text, it can work well to provide a menu item — such as Plain — that removes all applied formatting attributes at one time.

## In-game menus

In-game menus give players ways to control gameplay as well as determine [settings](https://developer.apple.com/design/human-interface-guidelines/settings) for the game as a whole.

**Let players navigate in-game menus using the platform’s default interaction method.** People expect to use the same interactions to navigate your menus as they use for navigating other menus on the device. For example, players expect to navigate your game menus using touch in iOS and iPadOS, and direct and indirect gestures in visionOS.

**Make sure your menus remain easy to open and read on all platforms you support.** Each platform defines specific sizes that work best for fonts and interaction targets. Sometimes, scaling your game content to display on a different screen — especially a mobile device screen — can make in-game menus too small for people to read or interact with. If this happens, modify the size of the tap targets and consider alternative ways to communicate the menu’s content. For guidance, see [Typography](/design/human-interface-guidelines/typography) and [Touch controls](/design/human-interface-guidelines/game-controls#Touch-controls).

## Platform considerations

*No additional considerations for macOS, tvOS, or watchOS.*

### iOS, iPadOS

In iOS and iPadOS, a menu can display items in one of the following three layouts.

![A diagram showing small, medium, and large menu layouts, each containing the same set of menu items.](https://docs-assets.developer.apple.com/published/d04cabb2d7b38602590cd6d59d79a0a0/small-medium-large-menu-layouts%402x.png)

- **Small.** A row of four items appears at the top of the menu, above a list that contains the remaining items. For each item in the top row, the menu displays a symbol or icon, but no label.
- **Medium.** A row of three items appears at the top of the menu, above a list that contains the remaining items. For each item in the top row, the menu displays a symbol or icon above a short label.
- **Large (the default).** The menu displays all items in a list.

For developer guidance, see [preferredElementSize](/documentation/UIKit/UIMenu/preferredElementSize).

**Choose a small or medium menu layout when it can help streamline people’s choices.** Consider using the medium layout if your app has three important actions that people often want to perform. For example, Notes uses the medium layout to give people a quick way to perform the Scan, Lock, and Pin actions. Use the small layout only for closely related actions that typically appear as a group, such as Bold, Italic, Underline, and Strikethrough. For each action, use a recognizable symbol that helps people identify the action without a label.

### visionOS

In visionOS, a menu can display items using the small or large layout styles that iOS and iPadOS define (for guidance, see [iOS, iPadOS](/design/human-interface-guidelines/menus#iOS-iPadOS)). You can present a menu in your app or game from 3D content using a SwiftUI view. To ensure that your menu is always visible to people, even when other content occludes it, you can apply a [breakthrough effect](https://developer.apple.com/documentation/swiftui/view/presentationbreakthrougheffect(_:)). As in macOS, an open menu in a visionOS window can appear outside of the window’s boundaries.

**Prefer displaying a menu near the content it controls.** Because people need to look at a menu item before tapping it, they might miss the item’s effect if the content it controls is too far away.

![A partial screenshot showing an app window in visionOS. The window contains several buttons, including a 'More' button, which is selected. A menu containing a list of actions is displayed beneath the button.](https://docs-assets.developer.apple.com/published/b424693063f332d9edd65d555fec417e/visionos-notes-menu-popover-style%402x.png)

**Prefer the subtle breakthrough effect in most cases.** This effect blends the presentation with its surrounding content, to maintain legibility and usability while preserving the depth and context of the scene. When you select [automatic](/documentation/SwiftUI/BreakthroughEffect/automatic) for the breakthrough effect of a menu that overlaps with 3D content, the system applies [subtle](/documentation/SwiftUI/BreakthroughEffect/subtle) by default. You can use [prominent](/documentation/SwiftUI/BreakthroughEffect/prominent) if it’s important to display a menu prominently over the entire scene in your app or game, but this can disrupt the experience for people and potentially cause discomfort. Alternatively, you can use [none](/documentation/SwiftUI/BreakthroughEffect/none) to fully occlude your menu behind other 3D content — for example, in a puzzle game that requires people to navigate around barriers — but this may make it difficult for people to see and access the menu.

## Resources

#### Related

[Pop-up buttons](/design/human-interface-guidelines/pop-up-buttons)

[Pull-down buttons](/design/human-interface-guidelines/pull-down-buttons)

[Context menus](/design/human-interface-guidelines/context-menus)

[The menu bar](/design/human-interface-guidelines/the-menu-bar)

#### Developer documentation

[Menu](/documentation/SwiftUI/Menu) — SwiftUI

[Menus and shortcuts](/documentation/UIKit/menus-and-shortcuts) — UIKit

[Menus](/documentation/AppKit/menus) — AppKit

## Change log

| Date | Changes |
| --- | --- |
| December 16, 2025 | Added guidance for presenting menus with breakthrough effects in visionOS. |
| July 28, 2025 | Added guidance for representing menu items with icons. |
| June 10, 2024 | Added guidance for in-game menus and included game-specific examples. |
| June 21, 2023 | Updated to include guidance for visionOS. |
| September 14, 2022 | Added guidelines for using the small, medium, and large menu layouts in iPadOS. |

---

*Extracted by [sosumi.ai](https://sosumi.ai) - Making Apple docs AI-readable.*
*This is unofficial content. All Human Interface Guidelines belong to Apple Inc.*
```


## 来源：docs/fetched/sosumi-hig/the-menu-bar.md


```md
**Navigation:** [Human Interface Guidelines](/design/human-interface-guidelines)

**article**

# The menu bar

> On a Mac or an iPad, the menu bar at the top of the screen displays the top-level menus in your app or game.

![A stylized representation of the macOS menu bar displaying a selected menu. The image is tinted red to subtly reflect the red in the original six-color Apple logo.](https://docs-assets.developer.apple.com/published/1196662c916a44013329c4c6a1ba03d4/components-the-menu-bar-intro%402x.png)

Mac users are very familiar with the macOS menu bar, and they rely on it to help them learn what an app does and find the commands they need. To help your app or game feel at home in macOS, it’s essential to provide a consistent menu bar experience.

Menu bar menus on iPad are similar to those on Mac, appearing in the same order and with familiar sets of menu items. When you adopt the menu structure that people expect from their experience on Mac, it helps them immediately understand and take advantage of the menu bar on iPad as well.

Keyboard shortcuts in iPadOS use the same patterns as in macOS. For guidance, see [Standard keyboard shortcuts](/design/human-interface-guidelines/keyboards#Standard-keyboard-shortcuts).

![An illustration of an app window on iPad, with its menu bar appearing at the top of the screen and the Edit menu open.](https://docs-assets.developer.apple.com/published/7c3a4ae9470f62e0eb41b8ce297032f8/menu-bar-ipad-overview%402x.png)

Menus in the menu bar share most of the appearance and behavior characteristics that all menu types have. To learn about menus in general — and how to organize and label menu items — see [Menus](/design/human-interface-guidelines/menus).

## Anatomy

When present in the menu bar, the following menus appear in the order listed below.

- *YourAppName* (you supply a short version of your app’s name for this menu’s title)
- File
- Edit
- Format
- View
- App-specific menus, if any
- Window
- Help

In addition, the macOS menu bar includes the Apple menu on the leading side and menu bar extras on the trailing side. See [macOS](/design/human-interface-guidelines/the-menu-bar#macOS) for guidance.

## Best practices

**Support the default system-defined menus and their ordering.** People expect to find menus and menu items in an order they’re familiar with. In many cases, the system implements the functionality of standard menu items so you don’t have to. For example, when people select text in a standard text field, the system makes the Edit > Copy menu item available.

**Always show the same set of menu items.** Keeping menu items visible helps people learn what actions your app supports, even if they’re unavailable in the current context. If a menu bar item isn’t actionable, disable the action instead of hiding it from the menu.

**Represent menu item actions with familiar icons.** Icons help people recognize common actions throughout your app. Use the same icons as the system to represent actions such as Copy, Share, and Delete, wherever they appear. For a list of icons that represent common actions, see [Standard icons](/design/human-interface-guidelines/icons#Standard-icons). For additional guidance, see [Menus](/design/human-interface-guidelines/menus).

**Support the keyboard shortcuts defined for the standard menu items you include.** People expect to use the keyboard shortcuts they already know for standard menu items, like Copy, Cut, Paste, Save, and Print. Define custom keyboard shortcuts only when necessary. For guidance, see [Standard keyboard shortcuts](/design/human-interface-guidelines/keyboards#Standard-keyboard-shortcuts).

**Prefer short, one-word menu titles.** Various factors — like different display sizes and the presence of menu bar extras — can affect the spacing and appearance of your menus. One-word menu titles work especially well in the menu bar because they take little space and are easy for people to scan. If you need to use more than one word in the menu title, use title-style capitalization.

## App menu

The app menu lists items that apply to your app or game as a whole, rather than to a specific task, document, or window. To help people quickly identify the active app, the menu bar displays your app name in bold.

The app menu typically contains the following menu items listed in the following order.

| Menu item | Action | Guidance |
| --- | --- | --- |
| About *YourAppName* | Displays the About window for your app, which includes copyright and version information. | Prefer a short name of 16 characters or fewer. Don’t include a version number. |
| Settings… | Opens your [Settings](/design/human-interface-guidelines/settings) window, or your app’s page in iPadOS Settings. | Use only for app-level settings. If you also offer document-specific settings, put them in the File menu. |
| Optional app-specific items | Performs custom app-level setting or configuration actions. | List custom app-configuration items after the Settings item and within the same group. |
| Services (macOS only) | Displays a submenu of services from the system and other apps that apply to the current context. |  |
| Hide *YourAppName* (macOS only) | Hides your app and all of its windows, and then activates the most recently used app. | Use the same short app name you supply for the About item. |
| Hide Others (macOS only) | Hides all other open apps and their windows. |  |
| Show All (macOS only) | Shows all other open apps and their windows behind your app’s windows. |  |
| Quit *YourAppName* | Quits your app. Pressing Option changes Quit *YourAppName* to Quit and Keep Windows. | Use the same short app name you supply for the About item. |

**Display the About menu item first.** Include a separator after the About menu item so that it appears by itself in a group.

## File menu

The File menu contains commands that help people manage the files or documents an app supports. If your app doesn’t handle any types of files, you can rename or eliminate this menu.

The File menu typically contains the following menu items listed in the following order.

| Menu item | Action | Guidance |
| --- | --- | --- |
| New *Item* | Creates a new document, file, or window. | For *Item*, use a term that names the type of item your app creates. For example, Calendar uses *Event* and *Calendar*. |
| Open | Can open the selected item or present an interface in which people select an item to open. | If people need to select an item in a separate interface, an ellipsis follows the command to indicate that more input is required. |
| Open Recent | Displays a submenu that lists recently opened documents and files that people can select, and typically includes a *Clear Menu* item. | List document and filenames that people recognize in the submenu; don’t display file paths. List the documents in the order people last opened them, with the most recently opened document first. |
| Close | Closes the current window or document. Pressing Option changes Close to Close All. For a tab-based window, Close Tab replaces Close. | In a tab-based window, consider adding a Close Window item to let people close the entire window with one click or tap. |
| Close Tab | Closes the current tab in a tab-based window. Pressing Option changes Close Tab to Close Other Tabs. |  |
| Close File | Closes the current file and all its associated windows. | Consider supporting this menu item if your app can open multiple views of the same file. |
| Save | Saves the current document or file. | Automatically save changes periodically as people work so they don’t need to keep choosing File > Save. For a new document, prompt people for a name and location. If you need to let people save a file in multiple formats, prefer a pop-up menu that lets people choose a format in the Save sheet. |
| Save All | Saves all open documents. |  |
| Duplicate | Duplicates the current document, leaving both documents open. Pressing Option changes Duplicate to Save As. | Prefer Duplicate to menu items like Save As, Export, Copy To, and Save To because these items don’t clarify the relationship between the original file and the new one. |
| Rename… | Lets people change the name of the current document. |  |
| Move To… | Prompts people to choose a new location for the document. |  |
| Export As… | Prompts people for a name, output location, and export file format. After exporting the file, the current document remains open; the exported file doesn’t open. | Reserve the Export As item for when you need to let people export content in a format your app doesn’t typically handle. |
| Revert To | When people turn on autosaving, displays a submenu that lists recent document versions and an option to display the version browser. After people choose a version to restore, it replaces the current document. |  |
| Page Setup… | Opens a panel for specifying printing parameters like paper size and printing orientation. A document can save the printing parameters that people specify. | Include the Page Setup item if you need to support printing parameters that apply to a specific document. Parameters that are global in nature, like a printer’s name, or that people change frequently, like the number of copies to print, belong in the Print panel. |
| Print… | Opens the standard Print panel, which lets people print to a printer, send a fax, or save as a PDF. |  |

## Edit menu

The Edit menu lets people make changes to content in the current document or text container, and provides commands for interacting with the Clipboard. Because many editing commands apply to any editable content, the Edit menu is useful even in apps that aren’t document-based.

**Determine whether Find menu items belong in the Edit menu.** For example, if your app lets people search for files or other types of objects, Find menu items might be more appropriate in the File menu.

The Edit menu typically contains the following top-level menu items, listed in the following order.

| Menu item | Action | Guidance |
| --- | --- | --- |
| Undo | Reverses the effect of the previous user operation. | Clarify the target of the undo. For example, if people just selected a menu item, you can append the item’s title, such as Undo Paste and Match Style. For a text entry operation, you might append the word *Typing* to give Undo Typing. |
| Redo | Reverses the effect of the previous Undo operation. | Clarify the target of the redo. For example, if people just reversed a menu item selection, you can append the item’s title, such as Redo Paste and Match Style. For a text entry operation, you might append the word *Typing* to give Redo Typing. |
| Cut | Removes the selected data and stores it on the Clipboard, replacing the previous contents of the Clipboard. |  |
| Copy | Duplicates the selected data and stores it on the Clipboard. |  |
| Paste | Inserts the contents of the Clipboard at the current insertion point. The Clipboard contents remain unchanged, permitting people to choose Paste multiple times. |  |
| Paste and Match Style | Inserts the contents of the Clipboard at the current insertion point, matching the style of the inserted text to the surrounding text. |  |
| Delete | Removes the selected data, but doesn’t place it on the Clipboard. | Provide a Delete menu item instead of an Erase or Clear menu item. Choosing Delete is the equivalent of pressing the Delete key, so it’s important for the naming to be consistent. |
| Select All | Highlights all selectable content in the current document or text container. |  |
| Find | Displays a submenu containing menu items for performing search operations in the current document or text container. Standard submenus include: Find, Find and Replace, Find Next, Find Previous, Use Selection for Find, and Jump to Selection. |  |
| Spelling and Grammar | Displays a submenu containing menu items for checking for and correcting spelling and grammar in the current document or text container. Standard submenus include: Show Spelling and Grammar, Check Document Now, Check Spelling While Typing, Check Grammar With Spelling, and Correct Spelling Automatically. |  |
| Substitutions | Displays a submenu containing items that let people toggle automatic substitutions while they type in a document or text container. Standard submenus include: Show Substitutions, Smart Copy/Paste, Smart Quotes, Smart Dashes, Smart Links, Data Detectors, and Text Replacement. |  |
| Transformations | Displays a submenu containing items that transform selected text. Standard submenus include: Make Uppercase, Make Lowercase, and Capitalize. |  |
| Speech | Displays a submenu containing Start Speaking and Stop Speaking items, which control when the system audibly reads selected text. |  |
| Start Dictation | Opens the dictation window and converts spoken words into text that’s added at the current insertion point. The system automatically adds the Start Dictation menu item at the bottom of the Edit menu. |  |
| Emoji & Symbols | Displays a Character Viewer, which includes emoji, symbols, and other characters people can insert at the current insertion point. The system automatically adds the Emoji & Symbols menu item at the bottom of the Edit menu. |  |

## Format menu

The Format menu lets people adjust text formatting attributes in the current document or text container. You can exclude this menu if your app doesn’t support formatted text editing.

The Format menu typically contains the following top-level menu items, listed in the following order.

| Menu item | Action |
| --- | --- |
| Font | Displays a submenu containing items for adjusting font attributes of the selected text. Standard submenus include: Show Fonts, Bold, Italic, Underline, Bigger, Smaller, Show Colors, Copy Style, and Paste Style. |
| Text | Displays a submenu containing items for adjusting text attributes of the selected text. Standard submenus include: Align Left, Align Center, Justify, Align Right, Writing Direction, Show Ruler, Copy Ruler, and Paste Ruler. |

## View menu

The View menu lets people customize the appearance of all an app’s windows, regardless of type.

> [!IMPORTANT]
> The View menu doesn’t include items for navigating between or managing specific windows; the [Window menu](/design/human-interface-guidelines/the-menu-bar#Window-menu) provides these commands.

**Provide a View menu even if your app supports only a subset of the standard view functions.** For example, if your app doesn’t include a tab bar, toolbar, or sidebar, but does support full-screen mode, provide a View menu that includes only the Enter/Exit Full Screen menu item.

**Ensure that each show/hide item title reflects the current state of the corresponding view.** For example, when the toolbar is hidden, provide a Show Toolbar menu item; when the toolbar is visible, provide a Hide Toolbar menu item.

The View menu typically contains the following top-level menu items, listed in the following order.

| Menu item | Action |
| --- | --- |
| Show/Hide Tab Bar | Toggles the visibility of the [Tab bars](/design/human-interface-guidelines/tab-bars) above the body area in a tab-based window |
| Show All Tabs/Exit Tab Overview | Enters and exits a view (similar to Mission Control) that provides an overview of all open tabs in a tab-based window |
| Show/Hide Toolbar | In a window that includes a [Toolbars](/design/human-interface-guidelines/toolbars), toggles the toolbar’s visibility |
| Customize Toolbar | In a window that includes a toolbar, opens a view that lets people customize toolbar items |
| Show/Hide Sidebar | In a window that includes a [Sidebars](/design/human-interface-guidelines/sidebars), toggles the sidebar’s visibility |
| Enter/Exit Full Screen | In an app that supports a [Going full screen](/design/human-interface-guidelines/going-full-screen), opens the window at full-screen size in a new space |

## App-specific menus

Your app’s custom menus appear in the menu bar between the View menu and the Window menu. For example, Safari’s menu bar includes app-specific History and Bookmarks menus.

**Provide app-specific menus for custom commands.** People look in the menu bar when searching for app-specific commands, especially when using an app for the first time. Even when commands are available elsewhere in your app, it’s important to list them in the menu bar. Putting commands in the menu bar makes them easier for people to find, lets you assign keyboard shortcuts to them, and makes them more accessible to people using Full Keyboard Access. Excluding commands from the menu bar — even infrequently used or advanced commands — risks making them difficult for everyone to find.

**As much as possible, reflect your app’s hierarchy in app-specific menus.** For example, Mail lists the Mailbox, Message, and Format menus in an order that mirrors the relationships of these items: mailboxes contain messages, and messages contain formatting.

**Aim to list app-specific menus in order from most to least general or commonly used.** People tend to expect menus in the leading end of a list to be more specialized than menus in the trailing end.

## Window menu

The Window menu lets people navigate, organize, and manage an app’s windows.

> [!IMPORTANT]
> The Window menu doesn’t help people customize the appearance of windows or close them. To customize a window, people use commands in the [View menu](/design/human-interface-guidelines/the-menu-bar#View-menu); to close a window, people choose Close in the [File menu](/design/human-interface-guidelines/the-menu-bar#File-menu).

**Provide a Window menu even if your app has only one window.** Include the Minimize and Zoom menu items so people using Full Keyboard Access can use the keyboard to invoke these functions.

**Consider including menu items for showing and hiding panels.** A [Panels](/design/human-interface-guidelines/panels) provides information, configuration options, or tools for interacting with content in a primary window, and typically appears only when people need it. There’s no need to provide access to the font panel or text color panel because the Format menu lists these panels.

The Window menu typically contains the following top-level menu items, listed in the following order.

| Menu item | Action | Guidance |
| --- | --- | --- |
| Minimize | Minimizes the active window to the Dock. Pressing the Option key changes this item to Minimize All. |  |
| Zoom | Toggles between a predefined size appropriate to the window’s content and the window size people set. Pressing the Option key changes this item to Zoom All. | Avoid using Zoom to enter or exit full-screen mode. The [View menu](/design/human-interface-guidelines/the-menu-bar#View-menu) supports these functions. |
| Show Previous Tab | Shows the tab before the current tab in a tab-based window. |  |
| Show Next Tab | Shows the tab after the current tab in a tab-based window. |  |
| Move Tab to New Window | Opens the current tab in a new window. |  |
| Merge All Windows | Combines all open windows into a single tabbed window. |  |
| Enter/Exit Full Screen | In an app that supports a [Going full screen](/design/human-interface-guidelines/going-full-screen), opens the window at full-screen size in a new space. | Include this item in the Window menu only if your app doesn’t have a View menu. In this scenario, continue to provide separate Minimize and Zoom menu items. |
| Bring All to Front | Brings all an app’s open windows to the front, maintaining their onscreen location, size, and layering order. (Clicking the app icon in the Dock has the same effect.) Pressing the Option key changes this item to Arrange in Front, which brings an app’s windows to the front in a neatly tiled arrangement. |  |
| *Name of an open app-specific window* | Brings the selected window to the front. | List the currently open windows in alphabetical order for easy scanning. Avoid listing panels or other modal views. |

## Help menu

The Help menu — located at the trailing end of the menu bar — provides access to an app’s help documentation. When you use the Help Book format for this documentation, macOS automatically includes a search field at the top of the Help menu.

| Menu item | Action | Guidance |
| --- | --- | --- |
| Send *YourAppName* Feedback to Apple | Opens the Feedback Assistant, in which people can provide feedback. |  |
| *YourAppName* Help | When the content uses the Help Book format, opens the content in the built-in Help Viewer. |  |
| *Additional Item* |  | Use a separator between your primary help documentation and additional items, which might include registration information or release notes. Keep the total the number of items you list in the Help menu small to avoid overwhelming people with too many choices when they need help. Alternatively, consider linking to additional items from within your help documentation. |

For guidance, see [Offering help](/design/human-interface-guidelines/offering-help); for developer guidance, see [NSHelpManager](/documentation/AppKit/NSHelpManager).

## Dynamic menu items

In rare cases, it can make sense to present a *dynamic menu item*, which is a menu item that changes its behavior when people choose it while pressing a modifier key (Control, Option, Shift, or Command). For example, the *Minimize* item in the Window menu changes to *Minimize All* when people press the Option key.

**Avoid making a dynamic menu item the only way to accomplish a task.** Dynamic menu items are hidden by default, so they’re best suited to offer shortcuts to advanced actions that people can accomplish in other ways. For example, if someone hasn’t discovered the *Minimize All* dynamic menu item in the Window menu, they can still minimize each open window.

**Use dynamic menu items primarily in menu bar menus.** Adding a dynamic menu item to contextual or Dock menus can make the item even harder for people to discover.

**Require only a single modifier key to reveal a dynamic menu item.** It can be physically awkward to press more than one key while simultaneously opening a menu and choosing a menu item, in addition to reducing the discoverability of the dynamic behavior. For developer guidance, see [isAlternate](/documentation/AppKit/NSMenuItem/isAlternate).

> [!TIP]
> macOS automatically sets the width of a menu to hold the widest item, including dynamic menu items.

## Platform considerations

*Not supported in iOS, tvOS, visionOS, or watchOS.*

### iPadOS

The menu bar displays the top-level menus for your app or game, including both system-provided menus and any custom ones you choose to add. People reveal the menu bar by moving the pointer to the top edge of the screen, or swiping down from it. When visible, the menu bar occupies the same vertical space as the [Status bars](/design/human-interface-guidelines/status-bars) at the top edge of the screen.

As with the macOS menu bar, the iPadOS menu bar provides a familiar way for people to learn what an app does, find the commands they need, and discover keyboard shortcuts.  While they are similar in most respects, there are a few key differences between the menu bars on each platform.

|  | iPadOS | macOS |
| --- | --- | --- |
| Menu bar visibility | Hidden until revealed | Visible by default |
| Horizontal alignment | Centered | Leading side |
| Menu bar extras | Not available | System default and custom |
| Window controls | In the menu bar when the app is full screen | Never in the menu bar |
| Apple menu | Not available | Always available |
| App menu | About, Services, and app visibility-related items not available | Always available |

**Because the menu bar is often hidden when running an app full screen, ensure that people can access all of your app’s functions through its UI.**  In particular, always offer other ways to accomplish tasks assigned to dynamic menu items, since these are only available when a hardware keyboard is connected. Avoid using the menu bar as a catch-all location for functionality that doesn’t fit in elsewhere.

**Reserve the YourAppName > Settings menu item for opening your app’s page in iPadOS Settings.** If your app includes its own internal preferences area, link to it with a separate menu item beneath Settings in the same group. Place any other custom app-wide configuration options in this section as well.

**For apps with tab-style navigation, consider adding each tab as a menu item in the View menu.** Since each tab is a different view of the app, the View menu is a natural place to offer an additional way to navigate between tabs. If you do this, consider assigning key bindings to each tab to make navigation even more convenient.

**Consider grouping menu items into submenus to conserve vertical space.** Menu item rows on iPad use more space than on Mac to make them easier to tap. Because of this, and the smaller screen sizes of some iPads, it can be helpful to group related items into submenus more frequently than in the menu bar on Mac.

### macOS

The menu bar in macOS includes the Apple menu, which is always the first item on the leading side of the menu bar. The Apple menu includes system-defined menu items that are always available, and you can’t modify or remove it. Space permitting, the system can also display menu bar extras in the trailing end of the menu bar. For guidance, see [Menu bar extras](/design/human-interface-guidelines/the-menu-bar#Menu-bar-extras).

When menu bar space is constrained, the system prioritizes the display of menus and essential menu bar extras. To ensure that menus remain readable, the system may decrease the space between the titles, truncating them if necessary.

When people enter full-screen mode, the menu bar typically hides until they reveal it by moving the pointer to the top of the screen. For guidance, see [Going full screen](/design/human-interface-guidelines/going-full-screen).

#### Menu bar extras

A menu bar extra exposes app-specific functionality using an icon that appears in the menu bar when your app is running, even when it’s not the frontmost app. Menu bar extras are on the opposite side of the menu bar from your app’s menus. For developer guidance, see [MenuBarExtra](/documentation/SwiftUI/MenuBarExtra).

When necessary, the system hides menu bar extras to make room for app menus. Similarly, if there are too many menu bar extras, the system may hide some to avoid crowding app menus.

![A screenshot of the Input menu bar extra and its menu.](https://docs-assets.developer.apple.com/published/97a8b1969dd941fc8920da157b345fb5/menu-bar-extras%402x.png)

**Consider using a symbol to represent your menu bar extra.** You can create an [Icons](/design/human-interface-guidelines/icons) or you can choose one of the [SF Symbols](/design/human-interface-guidelines/sf-symbols), using it as-is or customizing it to suit your needs. Both interface icons and symbols use black and clear colors to define their shapes; the system can apply other colors to the black areas in each image so it looks good on both dark and light menu bars, and when your menu bar extra is selected. The menu bar’s height is 24 pt.

**Display a menu — not a popover — when people click your menu bar extra.** Unless the app functionality you want to expose is too complex for a menu, avoid presenting it in a [Popovers](/design/human-interface-guidelines/popovers).

**Let people — not your app — decide whether to put your menu bar extra in the menu bar.** Typically, people add a menu bar extra to the menu bar by changing a setting in an app’s settings window. To ensure discoverability, however, consider giving people the option of doing so during setup.

**Avoid relying on the presence of menu bar extras.** The system hides and shows menu bar extras regularly, and you can’t be sure which other menu bar extras people have chosen to display or predict the location of your menu bar extra.

**Consider exposing app-specific functionality in other ways, too.** For example, you can provide a [Dock menu](https://developer.apple.com/design/human-interface-guidelines/dock-menus) that appears when people Control-click your app’s Dock icon. People can hide or choose not to use your menu bar extra, but a Dock menu is aways available when your app is running.

## Resources

#### Related

[Menus](/design/human-interface-guidelines/menus)

[Dock menus](/design/human-interface-guidelines/dock-menus)

[Standard keyboard shortcuts](/design/human-interface-guidelines/keyboards#Standard-keyboard-shortcuts)

#### Developer documentation

[CommandMenu](/documentation/SwiftUI/CommandMenu) — SwiftUI

[Adding menus and shortcuts to the menu bar and user interface](/documentation/UIKit/adding-menus-and-shortcuts-to-the-menu-bar-and-user-interface) — UIKit

[NSStatusBar](/documentation/AppKit/NSStatusBar) — AppKit

#### Videos

- [Elevate the design of your iPad app](https://developer.apple.com/videos/play/wwdc2025/208) - Make your app look and feel great on iPadOS. Learn best practices for designing a responsive layout for resizable app windows. Get familiar with window controls and explore the best ways to accommodate them. Discover the building blocks of a great menu bar. And meet the new pointer and its updated effects.

## Change log

| Date | Changes |
| --- | --- |
| June 9, 2025 | Added guidance for the menu bar in iPadOS. |

---

*Extracted by [sosumi.ai](https://sosumi.ai) - Making Apple docs AI-readable.*
*This is unofficial content. All Human Interface Guidelines belong to Apple Inc.*
```


## 来源：docs/fetched/sosumi-hig/icons.md


```md
**Navigation:** [Human Interface Guidelines](/design/human-interface-guidelines)

**article**

# Icons

> An effective icon is a graphic asset that expresses a single concept in ways people instantly understand.

![A sketch of the Command key icon. The image is overlaid with rectangular and circular grid lines and is tinted yellow to subtly reflect the yellow in the original six-color Apple logo.](https://docs-assets.developer.apple.com/published/e71f139e5e50d9d10d91830b0af405c1/foundations-icons-intro%402x.png)

Apps and games use a variety of simple icons to help people understand the items, actions, and modes they can choose. Unlike [App icons](/design/human-interface-guidelines/app-icons), which can use rich visual details like shading, texturing, and highlighting to evoke the app’s personality, an *interface icon* typically uses streamlined shapes and touches of color to communicate a straightforward idea.

You can design interface icons — also called *glyphs* — or you can choose symbols from the SF Symbols app, using them as-is or customizing them to suit your needs. Both interface icons and symbols use black and clear colors to define their shapes; the system can apply other colors to the black areas in each image. For guidance, see [SF Symbols](/design/human-interface-guidelines/sf-symbols).

## Best practices

**Create a recognizable, highly simplified design.** Too many details can make an interface icon confusing or unreadable. Strive for a simple, universal design that most people will recognize quickly. In general, icons work best when they use familiar visual metaphors that are directly related to the actions they initiate or content they represent.

**Maintain visual consistency across all interface icons in your app.** Whether you use only custom icons or mix custom and system-provided ones, all interface icons in your app need to use a consistent size, level of detail, stroke thickness (or weight), and perspective. Depending on the visual weight of an icon, you may need to adjust its dimensions to ensure that it appears visually consistent with other icons.

![Diagram of four glyphs in a row. From the left, the glyphs are a camera, a heart, an envelope, and an alarm clock. Two horizontal dashed lines show the bottom and top boundaries of the row and a horizontal red line shows the midpoint. All four glyphs are solid black; some include interior detail lines in white. Parts of the alarm clock extend above the top dashed line because its lighter visual weight requires greater height to achieve balance with the other glyphs.](https://docs-assets.developer.apple.com/published/f1cf8ce0ca53b7cb3bce1391a378f6ce/custom-icon-sizes%402x.png)

![Diagram of the same four glyphs shown above and the same horizontal dashed lines at top and bottom and horizontal red line through the middle. In this diagram, all four glyphs are solid gray; the interior detail lines are black to emphasize that all lines use the same weight.](https://docs-assets.developer.apple.com/published/91320cdd7a31574df355383d83eb1ceb/custom-icon-line-weights%402x.png)

**In general, match the weights of interface icons and adjacent text.** Unless you want to emphasize either the icons or the text, using the same weight for both gives your content a consistent appearance and level of emphasis.

**If necessary, add padding to a custom interface icon to achieve optical alignment.** Some icons — especially asymmetric ones — can look unbalanced when you center them geometrically instead of optically. For example, the download icon shown below has more visual weight on the bottom than on the top, which can make it look too low if it’s geometrically centered.

![Two images of a white arrow that points down to a white horizontal line segment within a black disk. The image on the right includes two horizontal pink bars — one between the top of the glyph and the top of the disk and the other between the bottom of the glyph and the bottom of the disk — that show the glyph is geometrically centered within the disk.](https://docs-assets.developer.apple.com/published/1c13eed753a1ebcfd6d35929738476c7/asymmetric-glyph%402x.png)

In such cases, you can slightly adjust the position of the icon until it’s optically centered. When you create an asset that includes your adjustments as padding around an interface icon (as shown below on the right), you can optically center the icon by geometrically centering the asset.

![Two images of a white arrow that points down to a white horizontal line segment within a black disk. The image on the left includes the two horizontal pink bars in the same locations as in the previous illustration, but the glyph has been moved up by a few pixels. The image on the right includes a pink rectangle overlaid on top of the glyph to represent a padding area, which includes the extra pixels below the glyph.](https://docs-assets.developer.apple.com/published/c31bce31456820badff997c95db264c6/asymmetric-glyph-optically-centered%402x.png)

Adjustments for optical centering are typically very small, but they can have a big impact on your app’s appearance.

![Two images of a white arrow that points down to a white horizontal line segment within a black disk. The glyph on the left is geometrically centered and the one on the right is optically centered.](https://docs-assets.developer.apple.com/published/5d9da37476ee3225a29ce3efbfd86cac/asymmetric-glyph-before-and-after%402x.png)

**Provide a selected-state version of an interface icon only if necessary.** You don’t need to provide selected and unselected appearances for an icon that’s used in standard system components such as toolbars, tab bars, and buttons. The system updates the visual appearance of the selected state automatically.

![An image of two toolbar buttons that share a background. The left button shows the Filter icon in a selected state, using a blue tint color for its background. The right button shows the More icon in an unselected state, using the default appearance for toolbar buttons.](https://docs-assets.developer.apple.com/published/b5c874fca24c428b421c008b29709986/icons-selection-correct%402x.png)

**Use inclusive images.** Consider how your icons can be understandable and welcoming to everyone. Prefer depicting gender-neutral human figures and avoid images that might be hard to recognize across different cultures or languages. For guidance, see [Inclusion](/design/human-interface-guidelines/inclusion).

**Include text in your design only when it’s essential for conveying meaning.** For example, using a character in an interface icon that represents text formatting can be the most direct way to communicate the concept. If you need to display individual characters in your icon, be sure to localize them. If you need to suggest a passage of text, design an abstract representation of it, and include a flipped version of the icon to use when the context is right-to-left. For guidance, see [Right to left](/design/human-interface-guidelines/right-to-left).

![A partial screenshot of the SF Symbols app showing the info panel for the character symbol, which looks like the capital letter A. Below the image, the following eight localized versions of the symbol are listed: Latin, Arabic, Hebrew, Hindi, Japanese, Korean, Thai, and Chinese.](https://docs-assets.developer.apple.com/published/1037fd04c26206ca1b1dee2e34e123af/character-in-glyph%402x.png)

![A partial screenshot of the SF Symbols app showing the info panel for the text dot page symbol, which looks like three left-aligned horizontal lines inside a rounded rectangle. Below the image, the left-to-right and right-to-left localized versions are shown.](https://docs-assets.developer.apple.com/published/2edc8ff4ae7af79f32543009ba2f7084/abstract-text-in-glyph%402x.png)

**If you create a custom interface icon, use a vector format like PDF or SVG.** The system automatically scales a vector-based interface icon for high-resolution displays, so you don’t need to provide high-resolution versions of it. In contrast, PNG — used for app icons and other images that include effects like shading, textures, and highlighting — doesn’t support scaling, so you have to supply multiple versions for each PNG-based interface icon. Alternatively, you can create a custom SF Symbol and specify a scale that ensures the symbol’s emphasis matches adjacent text. For guidance, see [SF Symbols](/design/human-interface-guidelines/sf-symbols).

**Provide alternative text labels for custom interface icons.** Alternative text labels — or accessibility descriptions — aren’t visible, but they let VoiceOver audibly describe what’s onscreen, simplifying navigation for people with visual disabilities. For guidance, see [VoiceOver](/design/human-interface-guidelines/voiceover).

**Avoid using replicas of Apple hardware products.** Hardware designs tend to change frequently and can make your interface icons and other content appear dated. If you must display Apple hardware, use only the images available in [Apple Design Resources](https://developer.apple.com/design/resources/) or the SF Symbols that represent various Apple products.

## Standard icons

For icons to represent common actions in [Menus](/design/human-interface-guidelines/menus), [Toolbars](/design/human-interface-guidelines/toolbars), [Buttons](/design/human-interface-guidelines/buttons), and other places in interfaces across Apple platforms, you can use these [SF Symbols](/design/human-interface-guidelines/sf-symbols).

### Editing

| Action | Icon | Symbol name |
| --- | --- | --- |
| Cut | ![An icon showing a pair of scissors.](https://docs-assets.developer.apple.com/published/16c5fe84ae743e06cf2d388fc64e0cf4/icons-symbols-meaning-cut%402x.png) | `scissors` |
| Copy | ![An icon showing two copies of a document.](https://docs-assets.developer.apple.com/published/a88919c55265efbadeac0df5e16ffd05/icons-symbols-meaning-copy%402x.png) | `document.on.document` |
| Paste | ![An icon showing a document in front of a clipboard.](https://docs-assets.developer.apple.com/published/20e32bbb2a3a94eb35d01ddfa9c630e0/icons-symbols-meaning-paste%402x.png) | `document.on.clipboard` |
| Done | ![An icon showing a checkmark.](https://docs-assets.developer.apple.com/published/833bd3b8ccdf0e2fee0893b3858ddae5/icons-symbols-meaning-done-save%402x.png) | `checkmark ` |
| Save |  |  |
| Cancel | ![An icon showing an X.](https://docs-assets.developer.apple.com/published/b834206c8d155bc1b0d9d17c206c6da3/icons-symbols-meaning-close-cancel%402x.png) | `xmark` |
| Close |  |  |
| Delete | ![An icon showing a trash can.](https://docs-assets.developer.apple.com/published/61f8368d02b05af22d3253a892ced7f3/icons-symbols-meaning-delete%402x.png) | `trash` |
| Undo | ![An icon showing an arrow curving toward the top left.](https://docs-assets.developer.apple.com/published/e3e973d07e4cfa983c92e37da5b3e104/icons-symbols-meaning-undo%402x.png) | `arrow.uturn.backward` |
| Redo | ![An icon showing an arrow curving toward the top right.](https://docs-assets.developer.apple.com/published/0f263db97ca2b7c31bbbd3cd5682d071/icons-symbols-meaning-redo%402x.png) | `arrow.uturn.forward` |
| Compose | ![An icon showing a pencil positioned over a square.](https://docs-assets.developer.apple.com/published/cfac914468b7fa2f287495f8644f3937/icons-symbols-meaning-compose%402x.png) | `square.and.pencil` |
| Duplicate | ![An icon showing a square with a plus sign on top of another square.](https://docs-assets.developer.apple.com/published/96323f746d3c67172648745420a15c27/icons-symbols-meaning-duplicate%402x.png) | `plus.square.on.square` |
| Rename | ![An icon showing a pencil.](https://docs-assets.developer.apple.com/published/8d3692b6e29cf0cdcb7885af414b2693/icons-symbols-meaning-rename%402x.png) | `pencil` |
| Move to | ![An icon showing a folder.](https://docs-assets.developer.apple.com/published/77c3e45c395bf2d2225c85979eca53a8/icons-symbols-meaning-move-to-folder%402x.png) | `folder` |
| Folder |  |  |
| Attach | ![An icon showing a paperclip.](https://docs-assets.developer.apple.com/published/e493eab83f8cc2a6f0aaa2ced386dcff/icons-symbols-meaning-attach%402x.png) | `paperclip` |
| Add | ![An icon showing a plus sign.](https://docs-assets.developer.apple.com/published/e0a7d36fc7aecfd6e49a4d0c0cb196af/icons-symbols-meaning-add%402x.png) | `plus` |
| More | ![An icon showing an ellipsis.](https://docs-assets.developer.apple.com/published/92e0b17a3881b62008563deb4a2aca40/icons-symbols-meaning-more%402x.png) | `ellipsis` |

### Selection

| Action | Icon | Symbol name |
| --- | --- | --- |
| Select | ![An icon showing a checkmark in a circle.](https://docs-assets.developer.apple.com/published/7eac493b5a3896062a90328117d43e90/icons-symbols-meaning-select-all%402x.png) | `checkmark.circle` |
| Deselect | ![An icon showing an X.](https://docs-assets.developer.apple.com/published/b834206c8d155bc1b0d9d17c206c6da3/icons-symbols-meaning-deselect-close%402x.png) | `xmark` |
| Close |  |  |
| Delete | ![An icon showing a trash can.](https://docs-assets.developer.apple.com/published/61f8368d02b05af22d3253a892ced7f3/icons-symbols-meaning-delete%402x.png) | `trash` |

### Text formatting

| Action | Icon | Symbol name |
| --- | --- | --- |
| Superscript | ![An icon showing the capital letter A with the number 1 in the upper right corner.](https://docs-assets.developer.apple.com/published/7e5e3d9b1b0eb6f340f531841d6b27f9/icons-symbols-meaning-superscript%402x.png) | `textformat.superscript` |
| Subscript | ![An icon showing the capital letter A with the number 1 in the lower right corner.](https://docs-assets.developer.apple.com/published/aac330c124cac37a78e02d6049943e53/icons-symbols-meaning-subscript%402x.png) | `textformat.subscript` |
| Bold | ![An icon showing the capital letter B in bold.](https://docs-assets.developer.apple.com/published/c8695e06d6461e79c145e9b6627f70ac/icons-symbols-meaning-bold%402x.png) | `bold` |
| Italic | ![An icon showing the capital letter I in italics.](https://docs-assets.developer.apple.com/published/9f560283ff88d8d1d4b48f278a831b7b/icons-symbols-meaning-italic%402x.png) | `italic` |
| Underline | ![An icon showing the capital letter U with an underline.](https://docs-assets.developer.apple.com/published/3b0d371f10bde381bfa1c9a8999797ec/icons-symbols-meaning-underline%402x.png) | `underline` |
| ​​Align Left | ![An icon showing a stack of four horizontal lines of varying widths that align at the left edge.](https://docs-assets.developer.apple.com/published/68c0ff42aa0ac813b57b663562198e15/icons-symbols-meaning-align-left%402x.png) | `text.alignleft` |
| Center | ![An icon showing a stack of four horizontal lines of varying widths that align in the center.](https://docs-assets.developer.apple.com/published/a10b48c850a047efd4a72cc2919c30da/icons-symbols-meaning-align-center%402x.png) | `text.aligncenter` |
| Justified | ![An icon showing a stack of four horizontal lines of identical widths.](https://docs-assets.developer.apple.com/published/d71f35b4f71149b0b908dd1ff8cfe01e/icons-symbols-meaning-align-justified%402x.png) | `text.justify` |
| Align Right | ![An icon showing a stack of four horizontal lines of varying widths that align at the right edge.](https://docs-assets.developer.apple.com/published/8af1da29f8f3173510521492642a82be/icons-symbols-meaning-align-right%402x.png) | `text.alignright` |

### Search

| Action | Icon | Symbol name |
| --- | --- | --- |
| Search | ![An icon showing a magnifying glass.](https://docs-assets.developer.apple.com/published/585f5454757731f942979247bf886ecb/icons-symbols-meaning-search%402x.png) | `magnifyingglass` |
| Find | ![An icon showing a magnifying glass above a document.](https://docs-assets.developer.apple.com/published/646c6a152822dde685e52a2791ff672f/icons-symbols-meaning-find%402x.png) | `text.page.badge.magnifyingglass` |
| Find and Replace |  |  |
| Find Next |  |  |
| Find Previous |  |  |
| Use Selection for Find |  |  |
| Filter | ![An icon showing a stack of three horizontal lines decreasing in width from top to bottom.](https://docs-assets.developer.apple.com/published/e0924492d663dac952860673a61f4f96/icons-symbols-meaning-filter%402x.png) | `line.3.horizontal.decrease` |

### Sharing and exporting

| Action | Icon | Symbol name |
| --- | --- | --- |
| Share | ![An icon showing an arrow pointing up from the middle of square.](https://docs-assets.developer.apple.com/published/b5fa28be3d82955fc380f44783befd32/icons-symbols-meaning-sharing%402x.png) | `square.and.arrow.up` |
| Export |  |  |
| Print | ![An icon showing a printer.](https://docs-assets.developer.apple.com/published/9de4d23e30e6fd8331215dd6dab12878/icons-symbols-meaning-print%402x.png) | `printer` |

### Users and accounts

| Action | Icon | Symbol name |
| --- | --- | --- |
| Account | ![An icon showing an abstract representation of a person’s head and shoulders in a circular outline.](https://docs-assets.developer.apple.com/published/512c86a1c2c99bc09991c89c1e535441/icons-symbols-meaning-account-user%402x.png) | `person.crop.circle` |
| User |  |  |
| Profile |  |  |

### Ratings

| Action | Icon | Symbol name |
| --- | --- | --- |
| Dislike | ![An icon showing a hand giving a thumbs down gesture.](https://docs-assets.developer.apple.com/published/189b97655ff655985deec03d0466b898/icons-symbols-meaning-dislike%402x.png) | `hand.thumbsdown` |
| Like | ![An icon showing a hand giving a thumbs up gesture.](https://docs-assets.developer.apple.com/published/6f38eef523ffbb4f1d6de22a6a022309/icons-symbols-meaning-like%402x.png) | `hand.thumbsup` |

### Layer ordering

| Action | Icon | Symbol name |
| --- | --- | --- |
| Bring to Front | ![An icon showing a stack of three squares overlapping each other, with the top square using a solid fill style while the other squares are outlines.](https://docs-assets.developer.apple.com/published/c5da334738c9baf5ddaa0d6ed9de0af6/icons-symbols-meaning-bring-to-front%402x.png) | `square.3.layers.3d.top.filled` |
| Send to Back | ![An icon showing a stack of three squares overlapping each other, with the bottom square using a solid fill style while the other squares are outlines.](https://docs-assets.developer.apple.com/published/1006037b6fa15950ca7ceb933dbb4805/icons-symbols-meaning-send-to-back%402x.png) | `square.3.layers.3d.bottom.filled` |
| Bring Forward | ![An icon showing a stack of two squares overlapping each other, with the top square using a solid fill style while the other square is an outline.](https://docs-assets.developer.apple.com/published/88b18e0384bca2cd93151169bd507aa3/icons-symbols-meaning-bring-forward%402x.png) | `square.2.layers.3d.top.filled` |
| Send Backward | ![An icon showing a stack of two squares overlapping each other, with the bottom square using a solid fill style while the other square is an outline.](https://docs-assets.developer.apple.com/published/49eb0ed5381249d763d30d4e515bc57b/icons-symbols-meaning-send-backwards%402x.png) | `square.2.layers.3d.bottom.filled` |

### Other

| Action | Icon | Symbol name |
| --- | --- | --- |
| Alarm | ![An icon showing an alarm clock.](https://docs-assets.developer.apple.com/published/b777cb6bcc99642b037824c78a7efb0e/icons-symbols-meaning-alarm%402x.png) | `alarm` |
| Archive | ![An icon showing a file box.](https://docs-assets.developer.apple.com/published/50a3b677d72b3d031ea66d10198bfb59/icons-symbols-meaning-archive%402x.png) | `archivebox` |
| Calendar | ![An icon showing a calendar.](https://docs-assets.developer.apple.com/published/4b14bf07cf562405caebedb2e200e3dc/icons-symbols-meaning-calendar%402x.png) | `calendar` |

## Platform considerations

*No additional considerations for iOS, iPadOS, tvOS, visionOS, or watchOS.*

### macOS

#### Document icons

If your macOS app can use a custom document type, you can create a document icon to represent it. Traditionally, a document icon looks like a piece of paper with its top-right corner folded down. This distinctive appearance helps people distinguish documents from apps and other content, even when icon sizes are small.

If you don’t supply a document icon for a file type you support, macOS creates one for you by compositing your app icon and the file’s extension onto the canvas. For example, Preview uses a system-generated document icon to represent JPG files.

![An image of the Preview document icon for a JPG file.](https://docs-assets.developer.apple.com/published/bfe462604c63811cb542e7c0fc46185e/doc-icon-generated%402x.png)

In some cases, it can make sense to create a set of document icons to represent a range of file types your app handles. For example, Xcode uses custom document icons to help people distinguish projects, AR objects, and Swift code files.

![Image of an Xcode project document icon.](https://docs-assets.developer.apple.com/published/8cd56a7291cd6b41fe391958f704c823/doc-icon-custom-1%402x.png)

![Image of a document icon for an AR object.](https://docs-assets.developer.apple.com/published/a1449177968f693c1bd68c2b146df7c3/doc-icon-custom-2%402x.png)

![Image of a document icon for a Swift file.](https://docs-assets.developer.apple.com/published/495bd043bf65349ec96f6728941386f8/doc-icon-custom-3%402x.png)

To create a custom document icon, you can supply any combination of background fill, center image, and text. The system layers, positions, and masks these elements as needed and composites them onto the familiar folded-corner icon shape.

![A square canvas that contains a grid of pink lines and a jagged white EKG line that runs horizontally across the middle. The pink grid gets lighter in color toward the bottom edge.](https://docs-assets.developer.apple.com/published/2aed446834a2dc6e8275b6bd7a797ca9/doc-icon-parts-background-fill%402x.png)

![A solid pink heart.](https://docs-assets.developer.apple.com/published/b59c836903d1b409ab9e21f81762df3e/doc-icon-parts-center-image%402x.png)

![The word heart in all caps.](https://docs-assets.developer.apple.com/published/56c5adedc0c08a167a4a03e706924ee6/doc-icon-parts-text%402x.png)

![A custom document icon that displays the pink heart and the word heart on top of the pink grid and white EKG line.](https://docs-assets.developer.apple.com/published/d5da9148d27f60891780ab1a9546a111/doc-icon-parts%402x.png)

[Apple Design Resources](https://developer.apple.com/design/resources/#macos-apps) provides a template you can use to create a custom background fill and center image for a document icon. As you use this template, follow the guidelines below.

**Design simple images that clearly communicate the document type.** Whether you use a background fill, a center image, or both, prefer uncomplicated shapes and a reduced palette of distinct colors. Your document icon can display as small as 16x16 px, so you want to create designs that remain recognizable at every size.

**Designing a single, expressive image for the background fill can be a great way to help people understand and recognize a document type.** For example, Xcode and TextEdit both use rich background images that don’t include a center image.

![Image of an Xcode project document icon.](https://docs-assets.developer.apple.com/published/8cd56a7291cd6b41fe391958f704c823/doc-icon-custom-1%402x.png)

![Image of a TextEdit rich text document icon.](https://docs-assets.developer.apple.com/published/f32709a5ff5742e79fd03a58ae1dd9c6/doc-icon-fill-only%402x.png)

**Consider reducing complexity in the small versions of your document icon.** Icon details that are clear in large versions can look blurry and be hard to recognize in small versions. For example, to ensure that the grid lines in the custom heart document icon remain clear in intermediate sizes, you might use fewer lines and thicken them by aligning them to the reduced pixel grid. In the 16x16 px size, you might remove the lines altogether.

![Pixelated image of the heart document icon. The grid, the EKG line, the heart shape, and the word heart are visible but blurry.](https://docs-assets.developer.apple.com/published/1f8bc7946a75363224f373924b557a3a/doc-icon-fewer-details-1%402x.png)

![Pixelated image of the heart document icon, in which only the blurry heart shape and EKG line are visible.](https://docs-assets.developer.apple.com/published/e46ac887801d9a16393948c3f2098715/doc-icon-fewer-details-2%402x.png)

![Pixelated image of the heart document icon, in which only the blurry heart shape is visible.](https://docs-assets.developer.apple.com/published/fd0d2afcd76a9b25c1217ef2ffb1ad0e/doc-icon-fewer-details-3%402x.png)

**Avoid placing important content in the top-right corner of your background fill.** The system automatically masks your image to fit the document icon shape and draws the white folded corner on top of the fill. Create a set of background images in the sizes listed below.

- 512x512 px @1x, 1024x1024 px @2x
- 256x256 px @1x, 512x512 px @2x
- 128x128 px @1x, 256x256 px @2x
- 32x32 px @1x, 64x64 px @2x
- 16x16 px @1x, 32x32 px @2x

**If a familiar object can convey a document’s type or its connection with your app, consider creating a center image that depicts it.** Design a simple, unambiguous image that’s clear and recognizable at every size. The center image measures half the size of the overall document icon canvas. For example, to create a center image for a 32x32 px document icon, use an image canvas that measures 16x16 px. You can provide center images in the following sizes:

- 256x256 px @1x, 512x512 px @2x
- 128x128 px @1x, 256x256 px @2x
- 32x32 px @1x, 64x64 px @2x
- 16x16 px @1x, 32x32 px @2x

**Define a margin that measures about 10% of the image canvas and keep most of the image within it.** Although parts of the image can extend into this margin for optical alignment, it’s best when the image occupies about 80% of the image canvas. For example, most of the center image in a 256x256 px canvas would fit in an area that measures 205x205 px.

![Diagram of the solid pink heart shape within blue margins that measure 10 percent of the canvas width.](https://docs-assets.developer.apple.com/published/7cc19b2ae1e99d26ba69e1351683ede1/doc-icon-parts-margins%402x.png)

**Specify a succinct term if it helps people understand your document type.** By default, the system displays a document’s extension at the bottom edge of the document icon, but if the extension is unfamiliar you can supply a more descriptive term. For example, the document icon for a SceneKit scene file uses the term *scene* instead of the file extension *scn*. The system automatically scales the extension text to fit in the document icon, so be sure to use a term that’s short enough to be legible at small sizes. By default, the system capitalizes every letter in the text.

![Image of a SceneKit scene document icon.](https://docs-assets.developer.apple.com/published/3b4bb7de9edb5870d3a162aae8153163/doc-icon-custom-extension%402x.png)

## Resources

#### Related

[App icons](/design/human-interface-guidelines/app-icons)

[SF Symbols](/design/human-interface-guidelines/sf-symbols)

#### Videos

- [Designing Glyphs](https://developer.apple.com/videos/play/wwdc2017/823) - Glyphs are a powerful communication tool and a fundamental element of your app’s design language. Learn about important considerations when conceptualizing glyphs and key design principles of crafting effective glyph sets for spaces inside and outside of your app.

## Change log

| Date | Changes |
| --- | --- |
| June 9, 2025 | Added a table of SF Symbols that represent common actions. |
| June 21, 2023 | Updated to include guidance for visionOS. |

---

*Extracted by [sosumi.ai](https://sosumi.ai) - Making Apple docs AI-readable.*
*This is unofficial content. All Human Interface Guidelines belong to Apple Inc.*
```


## 来源：docs/fetched/sosumi-hig/color.md


```md
**Navigation:** [Human Interface Guidelines](/design/human-interface-guidelines)

**article**

# Color

> Judicious use of color can enhance communication, evoke your brand, provide visual continuity, communicate status and feedback, and help people understand information.

![A sketch of a paint palette, suggesting the use of color. The image is overlaid with rectangular and circular grid lines and is tinted yellow to subtly reflect the yellow in the original six-color Apple logo.](https://docs-assets.developer.apple.com/published/10ec5551985c77cabaeaaaff016cdfd8/foundations-color-intro%402x.png)

The system defines colors that look good on various backgrounds and appearance modes, and can automatically adapt to vibrancy and accessibility settings. Using system colors is a convenient way to make your experience feel at home on the device.

You may also want to use custom colors to enhance the visual experience of your app or game and express its unique personality. The following guidelines can help you use color in ways that people appreciate, regardless of whether you use system-defined or custom colors.

## Best practices

**Avoid using the same color to mean different things.** Use color consistently throughout your interface, especially when you use it to help communicate information like status or interactivity. For example, if you use your brand color to indicate that a borderless button is interactive, using the same or similar color to stylize noninteractive text is confusing.

**Make sure all your app’s colors work well in light, dark, and increased contrast contexts.** iOS, iPadOS, macOS, and tvOS offer both light and [Dark Mode](/design/human-interface-guidelines/dark-mode) appearance settings. [System colors](/design/human-interface-guidelines/color#System-colors) vary subtly depending on the system appearance, adjusting to ensure proper color differentiation and contrast for text, symbols, and other elements. With the Increase Contrast setting turned on, the color differences become far more apparent. When possible, use system colors, which already define variants for all these contexts. If you define a custom color, make sure to supply light and dark variants, and an increased contrast option for each variant that provides a significantly higher amount of visual differentiation. Even if your app ships in a single appearance mode, provide both light and dark colors to support Liquid Glass adaptivity in these contexts.

![A screenshot of the Notes app in iOS with the light system appearance and default contrast. The Notes app is open to a note with the text 'Note'. The text is selected, which shows a yellow selection highlight and text editing menu. The Done button appears in the upper-right corner. The Liquid Glass background of the button is yellow, and its label, which shows a checkmark, is white. The shade of yellow is vibrant.](https://docs-assets.developer.apple.com/published/033f3f6540cc36385bc5993e2152895b/color-context-light-mode%402x.png)

![A screenshot of the Notes app in iOS with the light system appearance and increased contrast. The Notes app is open to a note with the text 'Note'. The text is selected, which shows a yellow selection highlight and text editing menu. The Done button appears in the upper-right corner. The Liquid Glass background of the button is yellow, and its label, which shows a checkmark, is black. The shade of yellow is darker to provide more contrast and differentiation against the note's white background.](https://docs-assets.developer.apple.com/published/9fa4e239f30421b0f00ee77dcace0c14/color-context-light-mode-high-contrast%402x.png)

![A screenshot of the Notes app in iOS with the dark system appearance and default contrast. The Notes app is open to a note with the text 'Note'. The text is selected, which shows a yellow selection highlight and text editing menu. The Done button appears in the upper-right corner. The Liquid Glass background of the button is yellow, and its label, which shows a checkmark, is white.](https://docs-assets.developer.apple.com/published/dc3523da3cba1dd53d3501c763335e6c/color-context-dark-mode%402x.png)

![A screenshot of the Notes app in iOS with the dark system appearance and increased contrast. The Notes app is open to a note with the text 'Note'. The text is selected, which shows a yellow selection highlight and text editing menu. The Done button appears in the upper-right corner. The Liquid Glass background of the button is yellow, and its label, which shows a checkmark, is black.](https://docs-assets.developer.apple.com/published/95af2bc7dece914a5f870f38edac2998/color-context-dark-mode-high-contrast%402x.png)

**Test your app’s color scheme under a variety of lighting conditions.** Colors can look different when you view your app outside on a sunny day or in dim light. In bright surroundings, colors look darker and more muted. In dark environments, colors appear bright and saturated. In visionOS, colors can look different depending on the colors of a wall or object in a person’s physical surroundings and how it reflects light. Adjust app colors to provide an optimal viewing experience in the majority of use cases.

**Test your app on different devices.** For example, the True Tone display — available on certain iPhone, iPad, and Mac models — uses ambient light sensors to automatically adjust the white point of the display to adapt to the lighting conditions of the current environment. Apps that primarily support reading, photos, video, and gaming can strengthen or weaken this effect by specifying a white point adaptivity style (for developer guidance, see [UIWhitePointAdaptivityStyle](/documentation/BundleResources/Information-Property-List/UIWhitePointAdaptivityStyle)). Test tvOS apps on multiple brands of HD and 4K TVs, and with different display settings. You can also test the appearance of your app using different color profiles on a Mac — such as P3 and Standard RGB (sRGB) — by choosing a profile in System Settings > Displays. For guidance, see [Color management](/design/human-interface-guidelines/color#Color-management).

**Consider how artwork and translucency affect nearby colors.** Variations in artwork sometimes warrant changes to nearby colors to maintain visual continuity and prevent interface elements from becoming overpowering or underwhelming. Maps, for example, displays a light color scheme when in map mode but switches to a dark color scheme when in satellite mode. Colors can also appear different when placed behind or applied to a translucent element like a toolbar.

**If your app lets people choose colors, prefer system-provided color controls where available.** Using built-in color pickers provides a consistent user experience, in addition to letting people save a set of colors they can access from any app. For developer guidance, see [ColorPicker](/documentation/SwiftUI/ColorPicker).

## Inclusive color

**Avoid relying solely on color to differentiate between objects, indicate interactivity, or communicate essential information.** When you use color to convey information, be sure to provide the same information in alternative ways so people with color blindness or other visual disabilities can understand it. For example, you can use text labels or glyph shapes to identify objects or states.

**Avoid using colors that make it hard to perceive content in your app.** For example,  insufficient contrast can cause icons and text to blend with the background and make content hard to read, and people who are color blind might not be able to distinguish some color combinations. For guidance, see [Accessibility](/design/human-interface-guidelines/accessibility).

**Consider how the colors you use might be perceived in other countries and cultures.** For example, red communicates danger in some cultures, but has positive connotations in other cultures. Make sure the colors in your app send the message you intend.

![An illustration of an upward-trending stock chart in the Stocks app in English. The line of the graph is green to indicate the rising value of the stock during the selected time period.](https://docs-assets.developer.apple.com/published/5969ae10a6eaca6879fb43df4f651e4d/color-inclusive-color-charts-english%402x.png)

![An illustration of an upward-trending stock chart in the Stocks app in Chinese. The line of the graph is red to indicate the rising value of the stock during the selected time period.](https://docs-assets.developer.apple.com/published/e84b6e7089f1fb8f73712da462d66164/color-inclusive-color-charts-chinese%402x.png)

## System colors

**Avoid hard-coding system color values in your app.** Documented color values are for your reference during the app design process. The actual color values may fluctuate from release to release, based on a variety of environmental variables. Use APIs like [Color](/documentation/SwiftUI/Color) to apply system colors.

iOS, iPadOS, macOS, and visionOS also define sets of *dynamic system colors* that match the color schemes of standard UI components and automatically adapt to both light and dark contexts. Each dynamic color is semantically defined by its purpose, rather than its appearance or color values. For example, some colors represent view backgrounds at different levels of hierarchy and other colors represent foreground content, such as labels, links, and separators.

**Avoid redefining the semantic meanings of dynamic system colors.** To ensure a consistent experience and ensure your interface looks great when the appearance of the platform changes, use dynamic system colors as intended. For example, don’t use the [separator](https://developer.apple.com/documentation/uikit/uicolor/separator) color as a text color, or [secondary text label](https://developer.apple.com/documentation/uikit/uicolor/secondarylabel) color as a background color.

## Liquid Glass color

By default, [Liquid Glass](/design/human-interface-guidelines/materials#Liquid-Glass) has no inherent color, and instead takes on colors from the content directly behind it. You can apply color to some Liquid Glass elements, giving them the appearance of colored or stained glass. This is useful for drawing emphasis to a specific control, like a primary call to action, and is the approach the system uses for prominent button styling. Symbols or text labels on Liquid Glass controls can also have color.

![A screenshot of the Done button in iOS, which appears as a checkmark on a blue Liquid Glass background.](https://docs-assets.developer.apple.com/published/df4d0a0bca32edb16d7ff86e34d6fe2d/color-liquid-glass-overview-tinted%402x.png)

![A screenshot of a tab bar in iOS, with the first tab selected. The symbol and text label of the selected tab bar item are blue.](https://docs-assets.developer.apple.com/published/5a9078b2ea4baec1f15773638c9377c6/color-liquid-glass-overview-color-over-tab-bar%402x.png)

![A screenshot of the Share button in iOS over a colorful image. The colors from the background image infuse the Liquid Glass in the button, affecting its color.](https://docs-assets.developer.apple.com/published/9cf610d972c97dee46b9e206525b2ae7/color-liquid-glass-overview-clear%402x.png)

For smaller elements like toolbars and tab bars, the system can adapt Liquid Glass between a light and dark appearance in response to the underlying content. By default, symbols and text on these elements follow a monochromatic color scheme, becoming darker when the underlying content is light, and lighter when it’s dark. Liquid Glass appears more opaque in larger elements like sidebars to preserve legibility over complex backgrounds and accommodate richer content on the material’s surface.

**Apply color sparingly to the Liquid Glass material, and to symbols or text on the material.** If you apply color, reserve it for elements that truly benefit from emphasis, such as status indicators or primary actions. To emphasize primary actions, apply color to the background rather than to symbols or text. For example, the system applies the app accent color to the background in prominent buttons — such as the Done button — to draw attention and elevate their visual prominence. Refrain from adding color to the background of multiple controls.

![A screenshot of the top half of an iPhone app that shows a toolbar with several buttons. All of the buttons in the toolbar use a blue accent color for their Liquid Glass background.](https://docs-assets.developer.apple.com/published/9b7b9adb67ee5f70839540534fdeb374/colors-liquid-glass-usage-incorrect%402x.png)

![An X in a circle to indicate incorrect usage.](https://docs-assets.developer.apple.com/published/209f6f0fc8ad99d9bf59e12d82d06584/crossout%402x.png)

![A screenshot of the top half of an iPhone app that shows a toolbar with several buttons. Only the Done button in the toolbar uses a blue accent color for its Liquid Glass background.](https://docs-assets.developer.apple.com/published/3897d0d7c8736728d130dcc820e9a688/colors-liquid-glass-usage-correct%402x.png)

![A checkmark in a circle to indicate correct usage.](https://docs-assets.developer.apple.com/published/88662da92338267bb64cd2275c84e484/checkmark%402x.png)

**Avoid using similar colors in control labels if your app has a colorful background.** While color can make apps more visually appealing, playful, or reflective of your brand, too much color can be overwhelming and make control labels more difficult to read. If your app features colorful backgrounds or visually rich content, prefer a monochromatic appearance for toolbars and tab bars, or choose an accent color with sufficient visual differentiation. By contrast, in apps with primarily monochromatic content or backgrounds, choosing your brand color as the app accent color can be an effective way to tailor your app experience and reflect your company’s identity.

**Be aware of the placement of color in the content layer.** Make sure your interface maintains sufficient contrast by avoiding overlap of similar colors in the content layer and controls when possible. Although colorful content might intermittently scroll underneath controls, make sure its default or resting state — like the top of a screen of scrollable content — maintains clear legibility.

## Color management

A *color space* represents the colors in a *color model* like RGB or CMYK. Common color spaces — sometimes called *gamuts* — are sRGB and Display P3.

![Diagram showing the colors included in the sRGB space, compared to the larger number of colors included in the P3 color space.](https://docs-assets.developer.apple.com/published/c10d0ec4c78a6b824552058caac031b5/color-graphic-wide-color%402x.png)

A *color profile* describes the colors in a color space using, for example, mathematical formulas or tables of data that map colors to numerical representations. An image embeds its color profile so that a device can interpret the image’s colors correctly and reproduce them on a display.

**Apply color profiles to your images.** Color profiles help ensure that your app’s colors appear as intended on different displays. The sRGB color space produces accurate colors on most displays.

**Use wide color to enhance the visual experience on compatible displays.** Wide color displays support a P3 color space, which can produce richer, more saturated colors than sRGB. As a result, photos and videos that use wide color are more lifelike, and visual data and status indicators that use wide color can be more meaningful. When appropriate, use the Display P3 color profile at 16 bits per pixel (per channel) and export images in PNG format. Note that you need to use a wide color display to design wide color images and select P3 colors.

**Provide color space–specific image and color variations if necessary.** In general, P3 colors and images appear fine on sRGB displays. Occasionally, it may be hard to distinguish two very similar P3 colors when viewing them on an sRGB display. Gradients that use P3 colors can also sometimes appear clipped on sRGB displays. To avoid these issues and to ensure visual fidelity on both wide color and sRGB displays, you can use the asset catalog of your Xcode project to provide different versions of images and colors for each color space.

## Platform considerations

### iOS, iPadOS

iOS defines two sets of dynamic background colors — *system* and *grouped* — each of which contains primary, secondary, and tertiary variants that help you convey a hierarchy of information. In general, use the grouped background colors ([systemGroupedBackground](/documentation/UIKit/UIColor/systemGroupedBackground), [secondarySystemGroupedBackground](/documentation/UIKit/UIColor/secondarySystemGroupedBackground), and [tertiarySystemGroupedBackground](/documentation/UIKit/UIColor/tertiarySystemGroupedBackground)) when you have a grouped table view; otherwise, use the system set of background colors ([systemBackground](/documentation/UIKit/UIColor/systemBackground), [secondarySystemBackground](/documentation/UIKit/UIColor/secondarySystemBackground), and [tertiarySystemBackground](/documentation/UIKit/UIColor/tertiarySystemBackground)).

With both sets of background colors, you generally use the variants to indicate hierarchy in the following ways:

- Primary for the overall view
- Secondary for grouping content or elements within the overall view
- Tertiary for grouping content or elements within secondary elements

For foreground content, iOS defines the following dynamic colors:

| Color | Use for… | UIKit API |
| --- | --- | --- |
| Label | A text label that contains primary content. | [label](/documentation/UIKit/UIColor/label) |
| Secondary label | A text label that contains secondary content. | [secondaryLabel](/documentation/UIKit/UIColor/secondaryLabel) |
| Tertiary label | A text label that contains tertiary content. | [tertiaryLabel](/documentation/UIKit/UIColor/tertiaryLabel) |
| Quaternary label | A text label that contains quaternary content. | [quaternaryLabel](/documentation/UIKit/UIColor/quaternaryLabel) |
| Placeholder text | Placeholder text in controls or text views. | [placeholderText](/documentation/UIKit/UIColor/placeholderText) |
| Separator | A separator that allows some underlying content to be visible. | [separator](/documentation/UIKit/UIColor/separator) |
| Opaque separator | A separator that doesn’t allow any underlying content to be visible. | [opaqueSeparator](/documentation/UIKit/UIColor/opaqueSeparator) |
| Link | Text that functions as a link. | [link](/documentation/UIKit/UIColor/link) |

### macOS

macOS defines the following dynamic system colors (you can also view them in the Developer palette of the standard Color panel):

| Color | Use for… | AppKit API |
| --- | --- | --- |
| Alternate selected control text color | The text on a selected surface in a list or table. | [alternateSelectedControlTextColor](/documentation/AppKit/NSColor/alternateSelectedControlTextColor) |
| Alternating content background colors | The backgrounds of alternating rows or columns in a list, table, or collection view. | [alternatingContentBackgroundColors](/documentation/AppKit/NSColor/alternatingContentBackgroundColors) |
| Control accent | The accent color people select in System Settings. | [controlAccentColor](/documentation/AppKit/NSColor/controlAccentColor) |
| Control background color | The background of a large interface element, such as a browser or table. | [controlBackgroundColor](/documentation/AppKit/NSColor/controlBackgroundColor) |
| Control color | The surface of a control. | [controlColor](/documentation/AppKit/NSColor/controlColor) |
| Control text color | The text of a control that is available. | [controlTextColor](/documentation/AppKit/NSColor/controlTextColor) |
| Current control tint | The system-defined control tint. | [currentControlTint](/documentation/AppKit/NSColor/currentControlTint) |
| Unavailable control text color | The text of a control that’s unavailable. | [disabledControlTextColor](/documentation/AppKit/NSColor/disabledControlTextColor) |
| Find highlight color | The color of a find indicator. | [findHighlightColor](/documentation/AppKit/NSColor/findHighlightColor) |
| Grid color | The gridlines of an interface element, such as a table. | [gridColor](/documentation/AppKit/NSColor/gridColor) |
| Header text color | The text of a header cell in a table. | [headerTextColor](/documentation/AppKit/NSColor/headerTextColor) |
| Highlight color | The virtual light source onscreen. | [highlightColor](/documentation/AppKit/NSColor/highlightColor) |
| Keyboard focus indicator color | The ring that appears around the currently focused control when using the keyboard for interface navigation. | [keyboardFocusIndicatorColor](/documentation/AppKit/NSColor/keyboardFocusIndicatorColor) |
| Label color | The text of a label containing primary content. | [labelColor](/documentation/AppKit/NSColor/labelColor) |
| Link color | A link to other content. | [linkColor](/documentation/AppKit/NSColor/linkColor) |
| Placeholder text color | A placeholder string in a control or text view. | [placeholderTextColor](/documentation/AppKit/NSColor/placeholderTextColor) |
| Quaternary label color | The text of a label of lesser importance than a tertiary label, such as watermark text. | [quaternaryLabelColor](/documentation/AppKit/NSColor/quaternaryLabelColor) |
| Secondary label color | The text of a label of lesser importance than a primary label, such as a label used to represent a subheading or additional information. | [secondaryLabelColor](/documentation/AppKit/NSColor/secondaryLabelColor) |
| Selected content background color | The background for selected content in a key window or view. | [selectedContentBackgroundColor](/documentation/AppKit/NSColor/selectedContentBackgroundColor) |
| Selected control color | The surface of a selected control. | [selectedControlColor](/documentation/AppKit/NSColor/selectedControlColor) |
| Selected control text color | The text of a selected control. | [selectedControlTextColor](/documentation/AppKit/NSColor/selectedControlTextColor) |
| Selected menu item text color | The text of a selected menu. | [selectedMenuItemTextColor](/documentation/AppKit/NSColor/selectedMenuItemTextColor) |
| Selected text background color | The background of selected text. | [selectedTextBackgroundColor](/documentation/AppKit/NSColor/selectedTextBackgroundColor) |
| Selected text color | The color for selected text. | [selectedTextColor](/documentation/AppKit/NSColor/selectedTextColor) |
| Separator color | A separator between different sections of content. | [separatorColor](/documentation/AppKit/NSColor/separatorColor) |
| Shadow color | The virtual shadow cast by a raised object onscreen. | [shadowColor](/documentation/AppKit/NSColor/shadowColor) |
| Tertiary label color | The text of a label of lesser importance than a secondary label. | [tertiaryLabelColor](/documentation/AppKit/NSColor/tertiaryLabelColor) |
| Text background color | The background color behind text. | [textBackgroundColor](/documentation/AppKit/NSColor/textBackgroundColor) |
| Text color | The text in a document. | [textColor](/documentation/AppKit/NSColor/textColor) |
| Under page background color | The background behind a document’s content. | [underPageBackgroundColor](/documentation/AppKit/NSColor/underPageBackgroundColor) |
| Unemphasized selected content background color | The selected content in a non-key window or view. | [unemphasizedSelectedContentBackgroundColor](/documentation/AppKit/NSColor/unemphasizedSelectedContentBackgroundColor) |
| Unemphasized selected text background color | A background for selected text in a non-key window or view. | [unemphasizedSelectedTextBackgroundColor](/documentation/AppKit/NSColor/unemphasizedSelectedTextBackgroundColor) |
| Unemphasized selected text color | Selected text in a non-key window or view. | [unemphasizedSelectedTextColor](/documentation/AppKit/NSColor/unemphasizedSelectedTextColor) |
| Window background color | The background of a window. | [windowBackgroundColor](/documentation/AppKit/NSColor/windowBackgroundColor) |
| Window frame text color | The text in the window’s title bar area. | [windowFrameTextColor](/documentation/AppKit/NSColor/windowFrameTextColor) |

#### App accent colors

Beginning in macOS 11, you can specify an *accent color* to customize the appearance of your app’s buttons, selection highlighting, and sidebar icons. The system applies your accent color when the current value in General > Accent color settings is *multicolor*.

![A screenshot of the accent color picker in the System Settings app.](https://docs-assets.developer.apple.com/published/93ebe4b08af4e94a5c4479459fc7905b/colors-accent-colors-picker-multicolor%402x.png)

If people set their accent color setting to a value other than multicolor, the system applies their chosen color to the relevant items throughout your app, replacing your accent color. The exception is a sidebar icon that uses a fixed color you specify. Because a fixed-color sidebar icon uses a specific color to provide meaning, the system doesn’t override its color when people change the value of accent color settings. For guidance, see [Sidebars](/design/human-interface-guidelines/sidebars).

### tvOS

**Consider choosing a limited color palette that coordinates with your app logo.** Subtle use of color can help you communicate your brand while deferring to the content.

**Avoid using only color to indicate focus.** Subtle scaling and responsive animation are the primary ways to denote interactivity when an element is in focus.

### visionOS

**Use color sparingly, especially on glass.** Standard visionOS windows typically use the system-defined glass [Materials](/design/human-interface-guidelines/materials), which lets light and objects from people’s physical surroundings and their space show through. Because the colors in these physical and virtual objects are visible through the glass, they can affect the legibility of colorful app content in the window. Prefer using color in places where it can help call attention to important information or show the relationship between parts of the interface.

**Prefer using color in bold text and large areas.** Color in lightweight text or small areas can make them harder to see and understand.

**In a fully immersive experience, help people maintain visual comfort by keeping brightness levels balanced.** Although using high contrast can help direct people’s attention to important content, it can also cause visual discomfort if people’s eyes have adjusted to low light or darkness. Consider making content fully bright only when the rest of the visual context is also bright. For example, avoid displaying a bright object on a very dark or black background, especially if the object flashes or moves.

### watchOS

**Use background color to support existing content or supply additional information.** Background color can establish a sense of place and help people recognize key content. For example, in Activity, each infographic view for the Move, Exercise, and Stand Activity rings has a background that matches the color of the ring. Use background color when you have something to communicate, rather than as a solely visual flourish. Avoid using full-screen background color in views that are likely to remain onscreen for long periods of time, such as in a workout or audio-playing app.

**Recognize that people might prefer graphic complications to use tinted mode instead of full color.** The system can use a single color that’s based on the wearer’s selected color in a graphic complication’s images, gauges, and text. For guidance, see [Complications](/design/human-interface-guidelines/complications).

## Specifications

### System colors

| Name | SwiftUI API | Default (light) | Default (dark) | Increased contrast (light) | Increased contrast (dark) |
| --- | --- | --- | --- | --- | --- |
| Red | [red](/documentation/SwiftUI/Color/red) | ![R-255,G-56,B-60](https://docs-assets.developer.apple.com/published/56ba9eebe119d2e1b3063503a2eb45b7/colors-unified-red-light%402x.png) | ![R-255,G-66,B-69](https://docs-assets.developer.apple.com/published/9d7a7df4db48b0dcbd2915724d010235/colors-unified-red-dark%402x.png) | ![R-233,G-21,B-45](https://docs-assets.developer.apple.com/published/5b3473fcd986facfdee26a24601c7082/colors-unified-accessible-red-light%402x.png) | ![R-255,G-97,B-101](https://docs-assets.developer.apple.com/published/d097760a50a181eb7f688e9d62f4e710/colors-unified-accessible-red-dark%402x.png) |
| Orange | [orange](/documentation/SwiftUI/Color/orange) | ![R-255,G-141,B-40](https://docs-assets.developer.apple.com/published/57f431ec786e31e33f578ace3dbb8c78/colors-unified-orange-light%402x.png) | ![R-255,G-146,B-48](https://docs-assets.developer.apple.com/published/e906c25c1cadcb9cf7514d01b83f3bb7/colors-unified-orange-dark%402x.png) | ![R-197,G-83,B-0](https://docs-assets.developer.apple.com/published/2222321d0b29cad6987f0f6e26d198c1/colors-unified-accessible-orange-light%402x.png) | ![R-255,G-160,B-86](https://docs-assets.developer.apple.com/published/c82984219db600ea8396f4fd1933fc19/colors-unified-accessible-orange-dark%402x.png) |
| Yellow | [yellow](/documentation/SwiftUI/Color/yellow) | ![R-255,G-204,B-0](https://docs-assets.developer.apple.com/published/bebac431675840fa7e0e70cce0a6eb76/colors-unified-yellow-light%402x.png) | ![R-255,G-214,B-0](https://docs-assets.developer.apple.com/published/80c02086ccc5f013058932129cf9c6d3/colors-unified-yellow-dark%402x.png) | ![R-161,G-106,B-0](https://docs-assets.developer.apple.com/published/a51b94b82d9ea46e9de2ab8da5a57bbe/colors-unified-accessible-yellow-light%402x.png) | ![R-254,G-223,B-67](https://docs-assets.developer.apple.com/published/cd06b12d9e053739b089fb102b70901e/colors-unified-accessible-yellow-dark%402x.png) |
| Green | [green](/documentation/SwiftUI/Color/green) | ![R-52,G-199,B-89](https://docs-assets.developer.apple.com/published/b4226cfcf596812d46bd084322f47e65/colors-unified-green-light%402x.png) | ![R-48,G-209,B-88](https://docs-assets.developer.apple.com/published/7724e5dd4f60d300eaffe45c9a5e1f9d/colors-unified-green-dark%402x.png) | ![R-0,G-137,B-50](https://docs-assets.developer.apple.com/published/51471c6578d192e9dae6f40d8ace1835/colors-unified-accessible-green-light%402x.png) | ![R-74,G-217,B-104](https://docs-assets.developer.apple.com/published/aff6bca03c74050c6b78015925c8fd21/colors-unified-accessible-green-dark%402x.png) |
| Mint | [mint](/documentation/SwiftUI/Color/mint) | ![R-0,G-200,B-179](https://docs-assets.developer.apple.com/published/5d07acb38b9d0d7098f0b92456a7d27c/colors-unified-mint-light%402x.png) | ![R-0,G-218,B-195](https://docs-assets.developer.apple.com/published/851d8c0c2bea51a9377ae31520097e8c/colors-unified-mint-dark%402x.png) | ![R-0,G-133,B-117](https://docs-assets.developer.apple.com/published/d24198fce4dd42183e7b35abc9b67c20/colors-unified-accessible-mint-light%402x.png) | ![R-84,G-223,B-203](https://docs-assets.developer.apple.com/published/72586072586bb6d91589cc4ab78177b1/colors-unified-accessible-mint-dark%402x.png) |
| Teal | [teal](/documentation/SwiftUI/Color/teal) | ![R-0,G-195,B-208](https://docs-assets.developer.apple.com/published/6b8e5d90758cc858b4d3e20110a31f53/colors-unified-teal-light%402x.png) | ![R-0,G-210,B-224](https://docs-assets.developer.apple.com/published/d02bd29f4ba3580e84756f8c332fd677/colors-unified-teal-dark%402x.png) | ![R-0,G-129,B-152](https://docs-assets.developer.apple.com/published/f2137be89fb79e4822b633a450d6fc2c/colors-unified-accessible-teal-light%402x.png) | ![R-59,G-221,B-236](https://docs-assets.developer.apple.com/published/9a76a2333c746ded944e6610a01d4daf/colors-unified-accessible-teal-dark%402x.png) |
| Cyan | [cyan](/documentation/SwiftUI/Color/cyan) | ![R-0,G-192,B-232](https://docs-assets.developer.apple.com/published/3eb3076ca71a16ce1bede399e815e736/colors-unified-cyan-light%402x.png) | ![R-60,G-211,B-254](https://docs-assets.developer.apple.com/published/34399c5683f58d0710a50625f2fbca64/colors-unified-cyan-dark%402x.png) | ![R-0,G-126,B-174](https://docs-assets.developer.apple.com/published/e54287c8eb8d532283dac9d646886953/colors-unified-accessible-cyan-light%402x.png) | ![R-109,G-217,B-255](https://docs-assets.developer.apple.com/published/6d3ef826eb37c61642d57f798de4d14f/colors-unified-accessible-cyan-dark%402x.png) |
| Blue | [blue](/documentation/SwiftUI/Color/blue) | ![R-0,G-136,B-255](https://docs-assets.developer.apple.com/published/6ea9cabe180214ed99be04320df3501b/colors-unified-blue-light%402x.png) | ![R-0,G-145,B-255](https://docs-assets.developer.apple.com/published/580c321f95c59b2b4479be066d24f10f/colors-unified-blue-dark%402x.png) | ![R-30,G-110,B-244](https://docs-assets.developer.apple.com/published/f46653318bcfae105ff78fe412d64da2/colors-unified-accessible-blue-light%402x.png) | ![R-92,G-184,B-255](https://docs-assets.developer.apple.com/published/07b7bcb2d65911636342cee25db1f953/colors-unified-accessible-blue-dark%402x.png) |
| Indigo | [indigo](/documentation/SwiftUI/Color/indigo) | ![R-97,G-85,B-245](https://docs-assets.developer.apple.com/published/2da5c45a0e483dcaac4447464da4b6a7/colors-unified-indigo-light%402x.png) | ![R-109,G-124,B-255](https://docs-assets.developer.apple.com/published/b5e1fd9a1fc2347cc7238668b2df251b/colors-unified-indigo-dark%402x.png) | ![R-86,G-74,B-222](https://docs-assets.developer.apple.com/published/e326f52473ede4e5427208f9929196d9/colors-unified-accessible-indigo-light%402x.png) | ![R-167,G-170,B-255](https://docs-assets.developer.apple.com/published/d19249c65dab279c41f16c802365df10/colors-unified-accessible-indigo-dark%402x.png) |
| Purple | [purple](/documentation/SwiftUI/Color/purple) | ![R-203,G-48,B-224](https://docs-assets.developer.apple.com/published/2f07dfc6c397fba6d0abda5f5051a025/colors-unified-purple-light%402x.png) | ![R-219,G-52,B-242](https://docs-assets.developer.apple.com/published/04bce86fef3077014010ce6cfceb659f/colors-unified-purple-dark%402x.png) | ![R-176,G-47,B-194](https://docs-assets.developer.apple.com/published/a63779bec8a313582e11c6bbe348fc10/colors-unified-accessible-purple-light%402x.png) | ![R-234,G-141,B-255](https://docs-assets.developer.apple.com/published/82c3b96b548cbc455ef685f3e44d01d1/colors-unified-accessible-purple-dark%402x.png) |
| Pink | [pink](/documentation/SwiftUI/Color/pink) | ![R-255,G-45,B-85](https://docs-assets.developer.apple.com/published/1486931dce50d7610a397607afc0fb4d/colors-unified-pink-light%402x.png) | ![R-255,G-55,B-95](https://docs-assets.developer.apple.com/published/d68a9dbf37bab028b011f68fdd794e9c/colors-unified-pink-dark%402x.png) | ![R-231,G-18,B-77](https://docs-assets.developer.apple.com/published/d696af68031ce91a63330e0469ff592b/colors-unified-accessible-pink-light%402x.png) | ![R-255,G-138,B-196](https://docs-assets.developer.apple.com/published/a64993da9a61253e266e411d76c2cefd/colors-unified-accessible-pink-dark%402x.png) |
| Brown | [brown](/documentation/SwiftUI/Color/brown) | ![R-172,G-127,B-94](https://docs-assets.developer.apple.com/published/366eca06d26c2f759d6200a1e9b0a56f/colors-unified-brown-light%402x.png) | ![R-183,G-138,B-102](https://docs-assets.developer.apple.com/published/df6c5da440560b2054af5b55fe9b87f4/colors-unified-brown-dark%402x.png) | ![R-149,G-109,B-81](https://docs-assets.developer.apple.com/published/c80a760835a2bc94a68337d0208a469e/colors-unified-accessible-brown-light%402x.png) | ![R-219,G-166,B-121](https://docs-assets.developer.apple.com/published/3c6062e007c9d60e4684d063b3618786/colors-unified-accessible-brown-dark%402x.png) |

visionOS system colors use the default dark color values.

### iOS, iPadOS system gray colors

| Name | UIKit API | Default (light) | Default (dark) | Increased contrast (light) | Increased contrast (dark) |
| --- | --- | --- | --- | --- | --- |
| Gray | [systemGray](/documentation/UIKit/UIColor/systemGray) | ![R-142,G-142,B-147](https://docs-assets.developer.apple.com/published/cc1289b6fd4b76c79bbeda356463232a/ios-default-systemgray%402x.png) | ![R-142,G-142,B-147](https://docs-assets.developer.apple.com/published/cc1289b6fd4b76c79bbeda356463232a/ios-default-systemgraydark%402x.png) | ![R-108,G-108,B-112](https://docs-assets.developer.apple.com/published/5d86cbc8b4ddef8b68954882b4c87a18/ios-accessible-systemgray%402x.png) | ![R-174,G-174,B-178](https://docs-assets.developer.apple.com/published/d00617ff05181a53d2cb5ddf143d502e/ios-accessible-systemgraydark%402x.png) |
| Gray (2) | [systemGray2](/documentation/UIKit/UIColor/systemGray2) | ![R-174,G-174,B-178](https://docs-assets.developer.apple.com/published/d00617ff05181a53d2cb5ddf143d502e/ios-default-systemgray2%402x.png) | ![R-99,G-99,B-102](https://docs-assets.developer.apple.com/published/1f681e808c0f4f35a2e7642872719c8b/ios-default-systemgray2dark%402x.png) | ![R-142,G-142,B-147](https://docs-assets.developer.apple.com/published/cc1289b6fd4b76c79bbeda356463232a/ios-accessible-systemgray2%402x.png) | ![R-124,G-124,B-128](https://docs-assets.developer.apple.com/published/f941ec556140a435aa9556a993e57e63/ios-accessible-systemgray2dark%402x.png) |
| Gray (3) | [systemGray3](/documentation/UIKit/UIColor/systemGray3) | ![R-199,G-199,B-204](https://docs-assets.developer.apple.com/published/bcbb9fb97382e52aa09de7239a6edcf7/ios-default-systemgray3%402x.png) | ![R-72,G-72,B-74](https://docs-assets.developer.apple.com/published/d99ad33dcdd426585e7107e1b130d713/ios-default-systemgray3dark%402x.png) | ![R-174,G-174,B-178](https://docs-assets.developer.apple.com/published/d00617ff05181a53d2cb5ddf143d502e/ios-accessible-systemgray3%402x.png) | ![R-84,G-84,B-86](https://docs-assets.developer.apple.com/published/693c40b65e2752b3a2b7741d61ebbb3b/ios-accessible-systemgray3dark%402x.png) |
| Gray (4) | [systemGray4](/documentation/UIKit/UIColor/systemGray4) | ![R-209,G-209,B-214](https://docs-assets.developer.apple.com/published/5e1c546e8c78d9700b1ee58ce3a39972/ios-default-systemgray4%402x.png) | ![R-58,G-58,B-60](https://docs-assets.developer.apple.com/published/983cdcdfa9a664db0c5ff7c09905582a/ios-default-systemgray4dark%402x.png) | ![R-188,G-188,B-192](https://docs-assets.developer.apple.com/published/93644725b33daf923f7e3a146e9b2d42/ios-accessible-systemgray4%402x.png) | ![R-68,G-68,B-70](https://docs-assets.developer.apple.com/published/6439d861c1fe8a41615d5f09d3cde938/ios-accessible-systemgray4dark%402x.png) |
| Gray (5) | [systemGray5](/documentation/UIKit/UIColor/systemGray5) | ![R-229,G-229,B-234](https://docs-assets.developer.apple.com/published/91f296b3990bfe6dcd28b1804c803581/ios-default-systemgray5%402x.png) | ![R-44,G-44,B-46](https://docs-assets.developer.apple.com/published/a8b1d65979b02865c203f18019b1084d/ios-default-systemgray5dark%402x.png) | ![R-216,G-216,B-220](https://docs-assets.developer.apple.com/published/616159815cf002c39f570affa027c298/ios-accessible-systemgray5%402x.png) | ![R-54,G-54,B-56](https://docs-assets.developer.apple.com/published/aacb35c6af213ef544f77d26df56df39/ios-accessible-systemgray5dark%402x.png) |
| Gray (6) | [systemGray6](/documentation/UIKit/UIColor/systemGray6) | ![R-242,G-242,B-247](https://docs-assets.developer.apple.com/published/3d60e2b1bf4771610453a31de912647b/ios-default-systemgray6%402x.png) | ![R-28,G-28,B-30](https://docs-assets.developer.apple.com/published/5d86f031014f556ef2d26da001c1f639/ios-default-systemgray6dark%402x.png) | ![R-235,G-235,B-240](https://docs-assets.developer.apple.com/published/82102708ad5dc7921fc0473f6ace4613/ios-accessible-systemgray6%402x.png) | ![R-36,G-36,B-38](https://docs-assets.developer.apple.com/published/5dc6249020925c5ec09f88f8adc9bbaa/ios-accessible-systemgray6dark%402x.png) |

In SwiftUI, the equivalent of `systemGray` is [gray](/documentation/SwiftUI/Color/gray).

## Resources

#### Related

[Dark Mode](/design/human-interface-guidelines/dark-mode)

[Accessibility](/design/human-interface-guidelines/accessibility)

[Materials](/design/human-interface-guidelines/materials)

[Apple Design Resources](https://developer.apple.com/design/resources/)

#### Developer documentation

[Color](/documentation/SwiftUI/Color) — SwiftUI

[UIColor](/documentation/UIKit/UIColor) — UIKit

[Color](/documentation/AppKit/color) — AppKit

#### Videos

- [Meet Liquid Glass](https://developer.apple.com/videos/play/wwdc2025/219) - Liquid Glass unifies Apple platform design language while providing a more dynamic and expressive user experience. Get to know the design principles of Liquid Glass, explore its core optical and physical properties, and learn where to use it and why.

## Change log

| Date | Changes |
| --- | --- |
| December 16, 2025 | Updated guidance for Liquid Glass. |
| June 9, 2025 | Updated system color values, and added guidance for Liquid Glass. |
| February 2, 2024 | Distinguished UIKit and SwiftUI gray colors in iOS and iPadOS, and added guidance for balancing brightness levels in visionOS apps. |
| September 12, 2023 | Enhanced guidance for using background color in watchOS views, and added color swatches for tvOS. |
| June 21, 2023 | Updated to include guidance for visionOS. |
| June 5, 2023 | Updated guidance for using background color in watchOS. |
| December 19, 2022 | Corrected RGB values for system mint color (Dark Mode) in iOS and iPadOS. |

---

*Extracted by [sosumi.ai](https://sosumi.ai) - Making Apple docs AI-readable.*
*This is unofficial content. All Human Interface Guidelines belong to Apple Inc.*
```


## 来源：docs/fetched/sosumi-hig/split-views.md


```md
**Navigation:** [Human Interface Guidelines](/design/human-interface-guidelines)

**article**

# Split views

> A split view manages the presentation of multiple adjacent panes of content, each of which can contain a variety of components, including tables, collections, images, and custom views.

![A stylized representation of a window consisting of three areas: a sidebar, a canvas, and an inspector. The image is tinted red to subtly reflect the red in the original six-color Apple logo.](https://docs-assets.developer.apple.com/published/68c529d6dd40b4b46f1862f1cdbadec4/components-split-view-intro%402x.png)

Typically, you use a split view to show multiple levels of your app’s hierarchy at once and support navigation between them. In this scenario, selecting an item in the view’s primary pane displays the item’s contents in the secondary pane. Similarly, a split view can display a tertiary pane if items in the secondary pane contain additional content.

It’s common to use a split view to display a [Sidebars](/design/human-interface-guidelines/sidebars) for navigation, where the leading pane lists the top-level items or collections in an app, and the secondary and optional tertiary panes can present child collections and item details. Rarely, you might also use a split view to provide groups of functionality that supplement the primary view — for example, Keynote in macOS uses split view panes to present the slide navigator, the presenter notes, and the inspector pane in areas that surround the main slide canvas.

## Best practices

**To support navigation, persistently highlight the current selection in each pane that leads to the detail view.** The selected appearance clarifies the relationship between the content in various panes and helps people stay oriented.

**Consider letting people drag and drop content between panes.** Because a split view provides access to multiple levels of hierarchy, people can conveniently move content from one part of your app to another by dragging items to different panes. For guidance, see [Drag and drop](/design/human-interface-guidelines/drag-and-drop).

## Platform considerations

### iOS

**Prefer using a split view in a regular — not a compact — environment.** A split view needs horizontal space in which to display multiple panes. In a compact environment, such as iPhone in portrait orientation, it’s difficult to display multiple panes without wrapping or truncating the content, making it less legible and harder to interact with.

### iPadOS

In iPadOS, a split view can include either two vertical panes, like Mail, or three vertical panes, like Keynote.

**Account for narrow, compact, and intermediate window widths.** Since iPad windows are fluidly resizable, it’s important to consider the design of a split view layout at multiple widths. In particular, ensure that it’s possible to navigate between the various panes in a logical way. For guidance, see [Layout](/design/human-interface-guidelines/layout). For developer guidance, see [NavigationSplitView](/documentation/SwiftUI/NavigationSplitView) and [UISplitViewController](/documentation/UIKit/UISplitViewController).

### macOS

In macOS, you can arrange the panes of a split view vertically, horizontally, or both. A split view includes dividers between panes that can support dragging to resize them. For developer guidance, see [VSplitView](/documentation/SwiftUI/VSplitView) and [HSplitView](/documentation/SwiftUI/HSplitView).

**Set reasonable defaults for minimum and maximum pane sizes.** If people can resize the panes in your app’s split view, make sure to use sizes that keep the divider visible. If a pane gets too small, the divider can seem to disappear, becoming difficult to use.

**Consider letting people hide a pane when it makes sense.** If your app includes an editing area, for example, consider letting people hide other panes to reduce distractions or allow more room for editing — in Keynote, people can hide the navigator and presenter notes panes when they want to edit slide content.

**Provide multiple ways to reveal hidden panes.** For example, you might provide a toolbar button or a menu command — including a keyboard shortcut — that people can use to restore a hidden pane.

**Prefer the thin divider style.** The thin divider measures one point in width, giving you maximum space for content while remaining easy for people to use. Avoid using thicker divider styles unless you have a specific need. For example, if both sides of a divider present table rows that use strong linear elements that might make a thin divider hard to distinguish, it might work to use a thicker divider. For developer guidance, see [NSSplitView.DividerStyle](/documentation/AppKit/NSSplitView/DividerStyle-swift.enum).

### tvOS

In tvOS, a split view can work well to help people filter content. When people choose a filter category in the primary pane, your app can display the results in the secondary pane.

**Choose a split view layout that keeps the panes looking balanced.** By default, a split view devotes a third of the screen width to the primary pane and two-thirds to the secondary pane, but you can also specify a half-and-half layout.

**Display a single title above a split view, helping people understand the content as a whole.** People already know how to use a split view to navigate and filter content; they don’t need titles that describe what each pane contains.

**Choose the title’s alignment based on the type of content the secondary pane contains.** Specifically, when the secondary pane contains a content collection, consider centering the title in the window. In contrast, if the secondary pane contains a single main view of important content, consider placing the title above the primary view to give the content more room.

### visionOS

**To display supplementary information, prefer a split view instead of a new window.** A split view gives people convenient access to more information without leaving the current context, whereas a new window may confuse people who are trying to navigate or reposition content. Opening more windows also requires you to carefully manage the relationship between views in your app or game. If you need to request a small amount of information or present a simple task that someone must complete before returning to their main task, use a [Sheets](/design/human-interface-guidelines/sheets).

### watchOS

In watchOS, the split view displays either the list view or a detail view as a full-screen view.

**Automatically display the most relevant detail view.** When your app launches, show people the most pertinent information. For example, display information relevant to their location, the time, or their recent actions.

**If your app displays multiple detail pages, place the detail views in a vertical [Tab views](/design/human-interface-guidelines/tab-views).** People can then use the Digital Crown to scroll between the detail view’s tabs. watchOS also displays a page indicator next to the Digital Crown, indicating the number of tabs and the currently selected tab.

![A screenshot showing a detail view with a vertical tab on Apple Watch. The page indicator next to the Digital Crown shows that the fifth tab is currently selected.](https://docs-assets.developer.apple.com/published/3f36258648d54880e800568e88b5076b/split-view-watch-vertical-tab%402x.png)

## Resources

#### Related

[Sidebars](/design/human-interface-guidelines/sidebars)

[Tab bars](/design/human-interface-guidelines/tab-bars)

[Layout](/design/human-interface-guidelines/layout)

#### Developer documentation

[NavigationSplitView](/documentation/SwiftUI/NavigationSplitView) — SwiftUI

[UISplitViewController](/documentation/UIKit/UISplitViewController) — UIKit

[NSSplitViewController](/documentation/AppKit/NSSplitViewController) — AppKit

#### Videos

- [Make your UIKit app more flexible](https://developer.apple.com/videos/play/wwdc2025/282) - Find out how your UIKit app can become more flexible on iPhone, iPad, Mac, and Apple Vision Pro by using scenes and container view controllers. Learn to unlock your app’s full potential by transitioning from an app-centric to a scene-based lifecycle, including enhanced window resizing and improved multitasking. Explore enhancements to UISplitViewController, such as interactive column resizing and first-class support for inspector columns. And make your views and controls more adaptive by adopting new layout APIs.

## Change log

| Date | Changes |
| --- | --- |
| June 9, 2025 | Added iOS and iPadOS platform considerations. |
| December 5, 2023 | Added guidance for split views in visionOS. |
| June 5, 2023 | Added guidance for split views in watchOS. |

---

*Extracted by [sosumi.ai](https://sosumi.ai) - Making Apple docs AI-readable.*
*This is unofficial content. All Human Interface Guidelines belong to Apple Inc.*
```
