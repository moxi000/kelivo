# iOS 26 / macOS 26 Liquid Glass 设计开发文档汇编（sosumi 镜像）

> 说明：本文档聚合自 Apple 文档 + sosumi.ai 的镜像抓取（将 `developer.apple.com` 替换为 `sosumi.ai`）。  
> 抓取时间：2026-03-11。  

## 1. 任务目标

汇总 iOS 26 和 macOS 26 中引入的 Liquid Glass 相关官方开发文档，形成可直接用于研发落地的版本化清单。

## 2. 核心总览页

### [Liquid Glass](https://sosumi.ai/documentation/technologyoverviews/liquid-glass)

该页是总览入口，说明 Liquid Glass 在 Apple 平台的设计目标、设计原则、示例入口与入口指引。  
重要点：

1. 涵盖全平台（iOS、iPadOS、macOS、tvOS、watchOS）。
2. 明确指向 `adopting-liquid-glass` 为落地入口。
3. 在示例中明确了 Landmarks 作为 iOS / iPadOS / macOS 示例应用。

### [Adopting Liquid Glass](https://sosumi.ai/documentation/technologyoverviews/adopting-liquid-glass)

本页是面向开发适配的核心指导页。强调：

1. 尽量优先采用系统组件自动适配；避免过度自定义背景或外观。
2. 视觉层定义清晰：标准组件 / 导航层 / 内容层要有层级区分。
3. 涉及控件、导航、菜单工具条、窗口与模态、列表、搜索、滚动边缘（scroll edge）等关键行为。
4. 明确 iOS/iPadOS/macOS/macCatalyst 26 及以上场景中可见变化。

## 3. SwiftUI 关键文档（iOS + macOS 主线）

### 3.1 关键 API 文档

| 文档 | 可用性 | 作用 |
|---|---|---|
| [glassEffect(_:in:)](https://sosumi.ai/documentation/SwiftUI/View/glasseffect%28_%3Ain%3A%29) | iOS 26.0+, iPadOS 26.0+, Mac Catalyst 26.0+, macOS 26.0+, tvOS 26.0+, watchOS 26.0+ | 在视图上应用 Liquid Glass 材质。 |
| [glassEffectID(_:in:)](https://sosumi.ai/documentation/SwiftUI/View/glasseffectid%28_%3Ain%3A%29) | iOS 26.0+, iPadOS 26.0+, Mac Catalyst 26.0+, macOS 26.0+, tvOS 26.0+, watchOS 26.0+ | 结合容器实现形态融合与过渡动画。 |
| [GlassEffectContainer](https://sosumi.ai/documentation/SwiftUI/GlassEffectContainer) | iOS 26.0+, iPadOS 26.0+, Mac Catalyst 26.0+, macOS 26.0+, tvOS 26.0+, watchOS 26.0+ | 合并多个 Liquid Glass 形状，改善融合与性能。 |
| [backgroundExtensionEffect()](https://sosumi.ai/documentation/SwiftUI/View/backgroundextensioneffect%28%29) | iOS 26.0+, iPadOS 26.0+, Mac Catalyst 26.0+, macOS 26.0+, tvOS 26.0+, visionOS 26.0+, watchOS 26.0+ | 在安全区域外延展背景内容，常用于侧边栏/检查器场景。 |
| [scrollEdgeEffectStyle(_:for:)](https://sosumi.ai/documentation/SwiftUI/View/scrollEdgeEffectStyle%28_%3Afor%3A%29) | iOS 26.0+, iPadOS 26.0+, Mac Catalyst 26.0+, macOS 26.0+, tvOS 26.0+, watchOS 26.0+ | 控制滚动边缘效果。 |
| [PrimitiveButtonStyle/glass](https://sosumi.ai/documentation/SwiftUI/PrimitiveButtonStyle/glass) | iOS 26.0+, iPadOS 26.0+, Mac Catalyst 26.0+, macOS 26.0+, tvOS 26.0+, watchOS 26.0+ | 适配按钮的 Liquid Glass 风格。 |
| [Glass button style family](https://sosumi.ai/documentation/SwiftUI/GlassButtonStyle) | 文档无独立 `Available on` 行，但与主 API 一致为 26.0+ 平台系列 | 按钮样式补充说明，文档页与容器页关联。 |
| [GlassProminentButtonStyle](https://sosumi.ai/documentation/SwiftUI/GlassProminentButtonStyle) | 同上 | 强调按钮视觉层级。 |
| [ScrollEdgeEffectStyle](https://sosumi.ai/documentation/SwiftUI/ScrollEdgeEffectStyle) | iOS / iPadOS / Mac Catalyst / macOS / tvOS / visionOS / watchOS 26.0+ | 指定滚动边缘效果取值。 |
| [defaultGlassEffectShape](https://sosumi.ai/documentation/SwiftUI/DefaultGlassEffectShape) | 文档无独立可用性标注 | 默认形状定义（胶囊）。 |

### 3.2 采样页（Landmarks）

| 示例文档 | 可用性 | 可直接复用实践 |
|---|---|---|
| [Landmarks: Building an app with Liquid Glass](https://sosumi.ai/documentation/SwiftUI/Landmarks-Building-an-app-with-Liquid-Glass) | iOS 26.0+, iPadOS 26.0+, Mac Catalyst 26.0+, macOS 26.0+, Xcode 26.0+ | 涵盖标准 glass 工具栏、背景延展、侧边栏/检查器下滚动体验与自定义 Liquid Glass 动效。 |
| [Landmarks: Applying a background extension effect](https://sosumi.ai/documentation/SwiftUI/Landmarks-Applying-a-background-extension-effect) | iOS 26.0+, iPadOS 26.0+, Mac Catalyst 26.0+, macOS 26.0+, Xcode 26.0+ | 讲解 `backgroundExtensionEffect()` 的实际布局方式。 |
| [Landmarks: Extending horizontal scrolling under a sidebar or inspector](https://sosumi.ai/documentation/SwiftUI/Landmarks-Extending-horizontal-scrolling-under-a-sidebar-or-inspector) | iOS 26.0+, iPadOS 26.0+, Mac Catalyst 26.0+, macOS 26.0+, Xcode 26.0+ | 在水平滚动列中实现边栏/检查器下延展展示。 |
| [Landmarks: Refining the system provided Liquid Glass effect in toolbars](https://sosumi.ai/documentation/SwiftUI/Landmarks-Refining-the-system-provided-glass-effect-in-toolbars) | iOS 26.0+, iPadOS 26.0+, Mac Catalyst 26.0+, macOS 26.0+, Xcode 26.0+ | 以 `ToolbarSpacer` / `ToolbarItem` 分组提升工具栏可读性。 |
| [Landmarks: Displaying custom activity badges](https://sosumi.ai/documentation/SwiftUI/Landmarks-Displaying-custom-activity-badges) | iOS 26.0+, iPadOS 26.0+, Mac Catalyst 26.0+, macOS 26.0+, Xcode 26.0+ | 结合 `glassEffect` 与 `glassEffectID` 做形态变换动画。 |

### 3.3 SwiftUI 实战指南页

- [Applying Liquid Glass to custom views](https://sosumi.ai/documentation/SwiftUI/Applying-Liquid-Glass-to-custom-views)：建议与 `GlassEffectContainer` 联合使用，重点关注 `glassEffectUnion(id:namespace:)` 与 `glassEffectTransition`。
- [GlassEffectTransition](https://sosumi.ai/documentation/SwiftUI/GlassEffectTransition)：解释形态过渡类型。
- [Glass](https://sosumi.ai/documentation/SwiftUI/Glass)、`.interactive()`、`form grouped` 等配套 API/示例，可作为按钮与表单的补充资料。

## 4. UIKit 关键文档（iOS / iPadOS / tvOS / Mac Catalyst）

- [UIGlassEffect](https://sosumi.ai/documentation/uikit/uiglasseffect)  
  可用性：iOS 26.0+, iPadOS 26.0+, Mac Catalyst 26.0+, tvOS 26.0+  
  作用：底层 glass 材质效果类。

- [UIGlassContainerEffect](https://sosumi.ai/documentation/uikit/uiglasscontainereffect)  
  可用性：iOS 26.0+, iPadOS 26.0+, Mac Catalyst 26.0+, tvOS 26.0+  
  作用：多个 glass 元素合并为单一渲染实体，减少系统压力。

- [UIBackgroundExtensionView](https://sosumi.ai/documentation/uikit/uibackgroundextensionview)  
  可用性：iOS 26.0+, iPadOS 26.0+, Mac Catalyst 26.0+, tvOS 26.0+, visionOS 26.0+  
  作用：内容安全区外扩展，适合侧边栏/检查器下背景衔接。

- [UIScrollEdgeEffect](https://sosumi.ai/documentation/uikit/uiscrolledgeeffect)  
  可用性：iOS 26.0+, iPadOS 26.0+, Mac Catalyst 26.0+, tvOS 26.0+, visionOS 26.0+  
  作用：控制滚动边缘液态效果。

- [UIButton.Configuration.glass()](https://sosumi.ai/documentation/uikit/uibutton/configuration-swift.struct/glass%28%29)  
  可用性：iOS 26.0+, iPadOS 26.0+, tvOS 26.0+, Mac Catalyst 为 `undefined+`（建议在本地 SDK 版本中验证）。  
  作用：按钮液态样式工厂。

- [UIButton.Configuration.prominentGlass()](https://sosumi.ai/documentation/uikit/uibutton/configuration-swift.struct/prominentglass%28%29)  
  可用性：同上  
  作用：更强对比按钮液态样式。

- [UIButton.Configuration.clearGlass()](https://sosumi.ai/documentation/uikit/uibutton/configuration-swift.struct/clearglass%28%29)  
  可用性：同上  
  作用：清透液态按钮样式。

- [UIButton.Configuration.prominentClearGlass()](https://sosumi.ai/documentation/uikit/uibutton/configuration-swift.struct/prominentclearglass%28%29)  
  可用性：同上  
  作用：清透 + 强调等级按钮液态样式。

- [UIKit updates](https://sosumi.ai/documentation/updates/uikit)（June 2025）  
  该页确认新增 liquid glass 相关 API（UIGlassEffect、UIGlassContainerEffect、Button glass 配置、UIScrollEdgeEffect、UIBackgroundExtensionView）。

## 5. AppKit 关键文档（macOS 主线）

- [NSGlassEffectView](https://sosumi.ai/documentation/AppKit/NSGlassEffectView)  
  可用性：macOS 26.0+  
  作用：将子视图嵌入动态液体材质。

- [NSGlassEffectContainerView](https://sosumi.ai/documentation/AppKit/NSGlassEffectContainerView)  
  可用性：macOS 26.0+  
  作用：按距离合并相邻 glass 视图，提升渲染性能和一致性。

- [NSGlassEffectView.Style](https://sosumi.ai/documentation/AppKit/NSGlassEffectView/Style-swift.enum)  
  可用性：macOS 26.0+  
  作用：定义标准 glass 样式（如 clear/regular）。

- [NSButton.BezelStyle.glass](https://sosumi.ai/documentation/AppKit/NSButton/BezelStyle-swift.enum/Glass)  
  可用性：macOS 26.0+  
  作用：按钮胶囊化液态外观。

- [NSBackgroundExtensionView](https://sosumi.ai/documentation/AppKit/NSBackgroundExtensionView)  
  可用性：macOS 26.0+  
  作用：在侧边栏、标题栏、检查器下扩展背景。

- [NSVisualEffectView](https://sosumi.ai/documentation/AppKit/NSVisualEffectView)  
  可用性：macOS 10.10+  
  作用：历史视觉效果容器，作为兼容/过渡方案（非 Liquid Glass 专用命名）。

- [AppKit updates](https://sosumi.ai/documentation/updates/appkit)（June 2025）  
  该页确认新增 `NSGlassEffectView`、`NSGlassEffectContainerView` 和 `NSButton.BezelStyle.glass`。

## 6. 设计规范（Human Interface Guidelines）

以下 HIG 页面与 Liquid Glass 落地关系最强，建议按模块联动查阅：

- [Materials](https://sosumi.ai/design/human-interface-guidelines/materials)  
- [App Icons](https://sosumi.ai/design/human-interface-guidelines/app-icons)  
- [Buttons](https://sosumi.ai/design/human-interface-guidelines/buttons)  
- [Tab Bars](https://sosumi.ai/design/human-interface-guidelines/tab-bars)  
- [Sidebars](https://sosumi.ai/design/human-interface-guidelines/sidebars)  
- [Toolbars](https://sosumi.ai/design/human-interface-guidelines/toolbars)  
- [Search Fields](https://sosumi.ai/design/human-interface-guidelines/search-fields)  
- [Action Sheets](https://sosumi.ai/design/human-interface-guidelines/action-sheets)  
- [Sheets](https://sosumi.ai/design/human-interface-guidelines/sheets)  
- [Windows](https://sosumi.ai/design/human-interface-guidelines/windows)  
- [Lists & Tables](https://sosumi.ai/design/human-interface-guidelines/lists-and-tables)  
- [Menus](https://sosumi.ai/design/human-interface-guidelines/menus)  
- [Menu Bar](https://sosumi.ai/design/human-interface-guidelines/the-menu-bar)  
- [Icons](https://sosumi.ai/design/human-interface-guidelines/icons)  
- [Color](https://sosumi.ai/design/human-interface-guidelines/color)  
- [Split Views](https://sosumi.ai/design/human-interface-guidelines/split-views)  

## 7. iOS / macOS 落地对照清单（建议先做）

1. 先开 `iOS 26.0+` 和 `macOS 26.0+` 运行路径验证；优先确认系统控件是否自动带来液态材质外观。  
2. 涉及自定义组件时，优先替换为 `glassEffect` + `GlassEffectContainer` 组合，并用 `scrollEdgeEffectStyle`/`UIScrollEdgeEffect` 管理内容边缘可读性。  
3. iPad / macOS 分栏场景优先使用 `backgroundExtensionEffect()` 或 `UIBackgroundExtensionView` / `NSBackgroundExtensionView` 做背景连续性。  
4. macOS 按钮/控件层面优先检查 `NSButton.BezelStyle.glass` 与 AppKit 的 `NSGlassEffect` 系列是否可行；若存在兼容性边界，用 `NSVisualEffectView` 作为平滑回退。  
5. 关注 `Mac Catalyst` 可用性字段（有少量 API 标注为 `undefined+`），结合实际工具链再做最终决策。  

## 8. 变更与补充策略

如果你希望我继续延伸为“可执行清单版本”，下一步我可以在此基础上再补 2 份文件：

- `LiquidGlass-实施检查清单（iOS）`  
- `LiquidGlass-实施检查清单（macOS）`  

清单内容会按页面、组件类型、验收点、回归测试场景逐项落地。  

## 9. 已抓取内容存档（fetch 结果）

你要求“保存链接内容而不只是地址”已完成。以下文件保存了每个目标页面的抓取正文：

1. `sosumi` 基础文档（technologyoverview + SwiftUI API）

- [docs/fetched/sosumi-core/liquid-glass.md](/Users/moxi/voiceinput-macos/docs/fetched/sosumi-core/liquid-glass.md)
- [docs/fetched/sosumi-core/adopting-liquid-glass.md](/Users/moxi/voiceinput-macos/docs/fetched/sosumi-core/adopting-liquid-glass.md)
- [docs/fetched/sosumi-core/glasseffect-in.md](/Users/moxi/voiceinput-macos/docs/fetched/sosumi-core/glasseffect-in.md)
- [docs/fetched/sosumi-core/glasseffectid-in.md](/Users/moxi/voiceinput-macos/docs/fetched/sosumi-core/glasseffectid-in.md)
- [docs/fetched/sosumi-core/GlassEffectContainer.md](/Users/moxi/voiceinput-macos/docs/fetched/sosumi-core/GlassEffectContainer.md)
- [docs/fetched/sosumi-core/backgroundextensioneffect.md](/Users/moxi/voiceinput-macos/docs/fetched/sosumi-core/backgroundextensioneffect.md)
- [docs/fetched/sosumi-core/scrollEdgeEffectStyle-for.md](/Users/moxi/voiceinput-macos/docs/fetched/sosumi-core/scrollEdgeEffectStyle-for.md)
- [docs/fetched/sosumi-core/PrimitiveButtonStyle-glass.md](/Users/moxi/voiceinput-macos/docs/fetched/sosumi-core/PrimitiveButtonStyle-glass.md)
- [docs/fetched/sosumi-core/GlassButtonStyle.md](/Users/moxi/voiceinput-macos/docs/fetched/sosumi-core/GlassButtonStyle.md)
- [docs/fetched/sosumi-core/GlassProminentButtonStyle.md](/Users/moxi/voiceinput-macos/docs/fetched/sosumi-core/GlassProminentButtonStyle.md)
- [docs/fetched/sosumi-core/ScrollEdgeEffectStyle.md](/Users/moxi/voiceinput-macos/docs/fetched/sosumi-core/ScrollEdgeEffectStyle.md)
- [docs/fetched/sosumi-core/DefaultGlassEffectShape.md](/Users/moxi/voiceinput-macos/docs/fetched/sosumi-core/DefaultGlassEffectShape.md)

2. Landmarks 示例与实战指南（完整抓取）

- [docs/fetched/sosumi-landmarks/Landmarks-Building-an-app-with-Liquid-Glass.md](/Users/moxi/voiceinput-macos/docs/fetched/sosumi-landmarks/Landmarks-Building-an-app-with-Liquid-Glass.md)
- [docs/fetched/sosumi-landmarks/Landmarks-Applying-a-background-extension-effect.md](/Users/moxi/voiceinput-macos/docs/fetched/sosumi-landmarks/Landmarks-Applying-a-background-extension-effect.md)
- [docs/fetched/sosumi-landmarks/Landmarks-Extending-horizontal-scrolling-under-a-sidebar-or-inspector.md](/Users/moxi/voiceinput-macos/docs/fetched/sosumi-landmarks/Landmarks-Extending-horizontal-scrolling-under-a-sidebar-or-inspector.md)
- [docs/fetched/sosumi-landmarks/Landmarks-Refining-the-system-provided-glass-effect-in-toolbars.md](/Users/moxi/voiceinput-macos/docs/fetched/sosumi-landmarks/Landmarks-Refining-the-system-provided-glass-effect-in-toolbars.md)
- [docs/fetched/sosumi-landmarks/Landmarks-Displaying-custom-activity-badges.md](/Users/moxi/voiceinput-macos/docs/fetched/sosumi-landmarks/Landmarks-Displaying-custom-activity-badges.md)
- [docs/fetched/sosumi-landmarks/Applying-Liquid-Glass-to-custom-views.md](/Users/moxi/voiceinput-macos/docs/fetched/sosumi-landmarks/Applying-Liquid-Glass-to-custom-views.md)
- [docs/fetched/sosumi-landmarks/GlassEffectTransition.md](/Users/moxi/voiceinput-macos/docs/fetched/sosumi-landmarks/GlassEffectTransition.md)
- [docs/fetched/sosumi-landmarks/Glass.md](/Users/moxi/voiceinput-macos/docs/fetched/sosumi-landmarks/Glass.md)

3. UIKit 与更新说明

- [docs/fetched/sosumi-uikit/fetch-manifest.md](/Users/moxi/voiceinput-macos/docs/fetched/sosumi-uikit/fetch-manifest.md)
- [docs/fetched/sosumi-uikit/uiglasseffect.md](/Users/moxi/voiceinput-macos/docs/fetched/sosumi-uikit/uiglasseffect.md)
- [docs/fetched/sosumi-uikit/uiglasscontainereffect.md](/Users/moxi/voiceinput-macos/docs/fetched/sosumi-uikit/uiglasscontainereffect.md)
- [docs/fetched/sosumi-uikit/uibackgroundextensionview.md](/Users/moxi/voiceinput-macos/docs/fetched/sosumi-uikit/uibackgroundextensionview.md)
- [docs/fetched/sosumi-uikit/uiscrolledgeeffect.md](/Users/moxi/voiceinput-macos/docs/fetched/sosumi-uikit/uiscrolledgeeffect.md)
- [docs/fetched/sosumi-uikit/uibutton-config-glass.md](/Users/moxi/voiceinput-macos/docs/fetched/sosumi-uikit/uibutton-config-glass.md)
- [docs/fetched/sosumi-uikit/uibutton-config-prominentglass.md](/Users/moxi/voiceinput-macos/docs/fetched/sosumi-uikit/uibutton-config-prominentglass.md)
- [docs/fetched/sosumi-uikit/uibutton-config-clearglass.md](/Users/moxi/voiceinput-macos/docs/fetched/sosumi-uikit/uibutton-config-clearglass.md)
- [docs/fetched/sosumi-uikit/uibutton-config-prominentclearglass.md](/Users/moxi/voiceinput-macos/docs/fetched/sosumi-uikit/uibutton-config-prominentclearglass.md)
- [docs/fetched/sosumi-uikit/uikit-updates.md](/Users/moxi/voiceinput-macos/docs/fetched/sosumi-uikit/uikit-updates.md)

4. AppKit 与更新说明

- [docs/fetched/sosumi-appkit/fetch-manifest.md](/Users/moxi/voiceinput-macos/docs/fetched/sosumi-appkit/fetch-manifest.md)
- [docs/fetched/sosumi-appkit/NSGlassEffectView.md](/Users/moxi/voiceinput-macos/docs/fetched/sosumi-appkit/NSGlassEffectView.md)
- [docs/fetched/sosumi-appkit/NSGlassEffectContainerView.md](/Users/moxi/voiceinput-macos/docs/fetched/sosumi-appkit/NSGlassEffectContainerView.md)
- [docs/fetched/sosumi-appkit/NSGlassEffectView-Style.md](/Users/moxi/voiceinput-macos/docs/fetched/sosumi-appkit/NSGlassEffectView-Style.md)
- [docs/fetched/sosumi-appkit/NSButton-BezelStyle-Glass.md](/Users/moxi/voiceinput-macos/docs/fetched/sosumi-appkit/NSButton-BezelStyle-Glass.md)
- [docs/fetched/sosumi-appkit/NSBackgroundExtensionView.md](/Users/moxi/voiceinput-macos/docs/fetched/sosumi-appkit/NSBackgroundExtensionView.md)
- [docs/fetched/sosumi-appkit/NSVisualEffectView.md](/Users/moxi/voiceinput-macos/docs/fetched/sosumi-appkit/NSVisualEffectView.md)
- [docs/fetched/sosumi-appkit/AppKit-updates.md](/Users/moxi/voiceinput-macos/docs/fetched/sosumi-appkit/AppKit-updates.md)

5. Human Interface Guidelines（HIG）抓取

- [docs/fetched/sosumi-hig/fetch-manifest.md](/Users/moxi/voiceinput-macos/docs/fetched/sosumi-hig/fetch-manifest.md)
- [docs/fetched/sosumi-hig/materials.md](/Users/moxi/voiceinput-macos/docs/fetched/sosumi-hig/materials.md)
- [docs/fetched/sosumi-hig/app-icons.md](/Users/moxi/voiceinput-macos/docs/fetched/sosumi-hig/app-icons.md)
- [docs/fetched/sosumi-hig/buttons.md](/Users/moxi/voiceinput-macos/docs/fetched/sosumi-hig/buttons.md)
- [docs/fetched/sosumi-hig/tab-bars.md](/Users/moxi/voiceinput-macos/docs/fetched/sosumi-hig/tab-bars.md)
- [docs/fetched/sosumi-hig/sidebars.md](/Users/moxi/voiceinput-macos/docs/fetched/sosumi-hig/sidebars.md)
- [docs/fetched/sosumi-hig/toolbars.md](/Users/moxi/voiceinput-macos/docs/fetched/sosumi-hig/toolbars.md)
- [docs/fetched/sosumi-hig/search-fields.md](/Users/moxi/voiceinput-macos/docs/fetched/sosumi-hig/search-fields.md)
- [docs/fetched/sosumi-hig/action-sheets.md](/Users/moxi/voiceinput-macos/docs/fetched/sosumi-hig/action-sheets.md)
- [docs/fetched/sosumi-hig/sheets.md](/Users/moxi/voiceinput-macos/docs/fetched/sosumi-hig/sheets.md)
- [docs/fetched/sosumi-hig/windows.md](/Users/moxi/voiceinput-macos/docs/fetched/sosumi-hig/windows.md)
- [docs/fetched/sosumi-hig/lists-and-tables.md](/Users/moxi/voiceinput-macos/docs/fetched/sosumi-hig/lists-and-tables.md)
- [docs/fetched/sosumi-hig/menus.md](/Users/moxi/voiceinput-macos/docs/fetched/sosumi-hig/menus.md)
- [docs/fetched/sosumi-hig/the-menu-bar.md](/Users/moxi/voiceinput-macos/docs/fetched/sosumi-hig/the-menu-bar.md)
- [docs/fetched/sosumi-hig/icons.md](/Users/moxi/voiceinput-macos/docs/fetched/sosumi-hig/icons.md)
- [docs/fetched/sosumi-hig/color.md](/Users/moxi/voiceinput-macos/docs/fetched/sosumi-hig/color.md)
- [docs/fetched/sosumi-hig/split-views.md](/Users/moxi/voiceinput-macos/docs/fetched/sosumi-hig/split-views.md)

6. 单文件完整归档（你刚刚要求的版本）

- [docs/liquid-glass-26-ios-macos-doc-full-archive.md](/Users/moxi/voiceinput-macos/docs/liquid-glass-26-ios-macos-doc-full-archive.md)

## 目录结构说明

你看到的“有的有二级目录、有的没有”，是因为内容归类策略不同，不是遗漏。现在规则统一为：

- `docs/liquid-glass-26-ios-macos-docs.md` 是总览与索引。
- `docs/liquid-glass-26-ios-macos-doc-full-archive.md` 是全文拼接归档。
- `docs/fetched/sosumi-core/` 保存 technology overview、adopting 及 SwiftUI API（核心开发线）。
- `docs/fetched/sosumi-landmarks/` 保存 Landmarks 示例和实践指南（含 `Applying/Glass/GlassEffectTransition`）。
- `docs/fetched/sosumi-uikit/` 保存 UIKit API 与更新说明。
- `docs/fetched/sosumi-appkit/` 保存 AppKit API 与更新说明。
- `docs/fetched/sosumi-hig/` 保存 HIG 相关页面。
- 你在 `docs/fetched/sosumi-*/` 看到的 `.html` 文件是抓取镜像的原始 HTML 备份，`.md` 是可读文本稿。
