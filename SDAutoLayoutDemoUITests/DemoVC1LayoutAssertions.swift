import XCTest

/// DemoVC1 布局意图与 `DemoVC1.m` 中 sd_layout 链一一对应的 UI 验收。
///
/// 对应关系：
/// - setupAutoHeightView  → view1 包紫色多行 label + 橙色条，高度随内容
/// - setupAutoWidthLabel  → 右下宽度自适应 label（max 180, h=20）
/// - setupAutoHeightLabel → 左下固定宽 100、高度自适应，与右 label 底对齐
/// - setupAutoSizeButton  → view1 下方 20pt 水平居中，按钮随文字变宽、高 25
enum DemoVC1LayoutAssertions {

  private static let marginTolerance: CGFloat = 10
  private static let sizeTolerance: CGFloat = 6

  static func assertMatchesLayoutCode(in app: XCUIApplication, context: DemoLayoutContext) {
    let vcView = LayoutAssertionHelper.controllerContentFrame(for: app)
    let window = LayoutAssertionHelper.controllerViewBounds(for: app)

  // MARK: demo1 — view1 内容自适应容器
    let view1 = LayoutAssertionHelper.layoutBox(1, in: app)
    LayoutAssertionHelper.assertVisibleLayout(
      view1, in: vcView, context: context, elementName: "灰色 view1 (demo.layout.view1)", minSize: 40
    )
    // .leftSpaceToView(self.view, 10) .rightSpaceToView(self.view, 10) .topSpaceToView(self.view, 80)
    LayoutAssertionHelper.assertHorizontalInsetsFromControllerView(
      view1, in: app, left: 10, right: 10, tolerance: marginTolerance,
      context: context, elementName: "view1"
    )
    LayoutAssertionHelper.assertTopInsetFromControllerView(
      view1, in: app, top: 80, tolerance: marginTolerance,
      context: context, elementName: "view1"
    )

    let purple = app.staticTexts["demo1.purpleLabel"]
    let orange = app.otherElements["demo1.orangeBar"]
    LayoutAssertionHelper.assertVisibleLayout(
      purple, in: vcView, context: context, elementName: "紫色多行 Label", minSize: 16
    )
    LayoutAssertionHelper.assertVisibleLayout(
      orange, in: vcView, context: context, elementName: "橙色条", minSize: 16
    )

    // subview1: 距 view1 左/右/上 10；autoHeightRatio(0) → 多行
    LayoutAssertionHelper.assertHorizontalInsets(
      purple, in: view1.frame, left: 10, right: 10, tolerance: marginTolerance,
      context: context, elementName: "紫色 Label（相对 view1）"
    )
    LayoutAssertionHelper.assertTopInset(
      purple, in: view1.frame, top: 10, tolerance: marginTolerance,
      context: context, elementName: "紫色 Label（相对 view1）"
    )
    XCTAssertGreaterThan(
      purple.frame.height, 44,
      "\(context.prefix) 紫色 Label 应随文字多行增高（autoHeightRatio(0)），高度=\(purple.frame.height)pt"
    )

    // subview2: topSpaceToView(subview1, 10) widthRatioToView(subview1,1) heightIs(30) leftEqualToView(subview1)
    LayoutAssertionHelper.assertApproxEqual(
      orange.frame.minY - purple.frame.maxY, 10, tolerance: sizeTolerance, context: context,
      message: "橙色条应在紫色 Label 下方 10pt"
    )
    LayoutAssertionHelper.assertApproxEqual(
      orange.frame.height, 30, tolerance: sizeTolerance, context: context,
      message: "橙色条高度应为 30pt (heightIs(30))"
    )
    LayoutAssertionHelper.assertApproxEqual(
      orange.frame.width, purple.frame.width, tolerance: sizeTolerance, context: context,
      message: "橙色条宽度应与紫色 Label 相同 (widthRatioToView 1)"
    )
    LayoutAssertionHelper.assertApproxEqual(
      orange.frame.minX, purple.frame.minX, tolerance: sizeTolerance, context: context,
      message: "橙色条左缘应与紫色 Label 对齐 (leftEqualToView)"
    )

    // setupAutoHeightWithBottomView:subview2 bottomMargin:10
    LayoutAssertionHelper.assertApproxEqual(
      view1.frame.maxY - orange.frame.maxY, 10, tolerance: sizeTolerance, context: context,
      message: "view1 底边应在橙色条下方 10pt"
    )
    XCTAssertGreaterThan(
      view1.frame.height, 70,
      "\(context.prefix) view1 总高度应被内容撑开（> 70pt），实际 \(view1.frame.height)pt"
    )

  // MARK: demo2 — 右下宽度自适应 label
    let widthLabel = app.staticTexts["demo1.autoWidthLabel"]
    LayoutAssertionHelper.assertVisibleLayout(
      widthLabel, in: vcView, context: context, elementName: "宽度自适应 Label", minSize: 16
    )
    // .rightSpaceToView(self.view, 10) .bottomSpaceToView(self.view, 50) .heightIs(20)
    LayoutAssertionHelper.assertApproxEqual(
      window.maxX - widthLabel.frame.maxX, 10, tolerance: marginTolerance, context: context,
      message: "宽度自适应 Label 距 self.view 右边应为 10pt"
    )
    LayoutAssertionHelper.assertBottomInsetFromControllerView(
      widthLabel, in: app, bottom: 50, tolerance: marginTolerance,
      context: context, elementName: "宽度自适应 Label"
    )
    LayoutAssertionHelper.assertApproxEqual(
      widthLabel.frame.height, 20, tolerance: sizeTolerance, context: context,
      message: "宽度自适应 Label 高度应为 20pt (heightIs(20))"
    )
    XCTAssertLessThanOrEqual(
      widthLabel.frame.width, 180 + sizeTolerance,
      "\(context.prefix) 宽度自适应 Label 不应超过 maxWidth 180pt，实际 \(widthLabel.frame.width)pt"
    )
    XCTAssertGreaterThan(
      widthLabel.frame.width, 80,
      "\(context.prefix) 宽度自适应 Label 应随文字展宽，实际 \(widthLabel.frame.width)pt"
    )

  // MARK: demo3 — 左下固定宽、高度自适应，底与右 label 对齐
    let heightLabel = app.staticTexts["demo1.autoHeightLabel"]
    LayoutAssertionHelper.assertVisibleLayout(
      heightLabel, in: vcView, context: context, elementName: "高度自适应 Label", minSize: 16
    )
    // .leftSpaceToView(self.view, 10) .widthIs(100) .bottomEqualToView(_autoWidthLabel)
    LayoutAssertionHelper.assertApproxEqual(
      heightLabel.frame.minX, window.minX + 10, tolerance: marginTolerance, context: context,
      message: "高度自适应 Label 距 self.view 左边应为 10pt"
    )
    LayoutAssertionHelper.assertApproxEqual(
      heightLabel.frame.width, 100, tolerance: sizeTolerance, context: context,
      message: "高度自适应 Label 宽度应为 100pt (widthIs(100))"
    )
    LayoutAssertionHelper.assertBottomAligned(
      heightLabel, widthLabel, tolerance: sizeTolerance, context: context,
      message: "高度自适应 Label 应与宽度自适应 Label 底边对齐 (bottomEqualToView)"
    )
    XCTAssertGreaterThan(
      heightLabel.frame.height, 28,
      "\(context.prefix) 高度自适应 Label 应随文字折行增高（autoHeightRatio(0)），高度=\(heightLabel.frame.height)pt"
    )

  // MARK: demo4 — view1 下方居中，按钮随文字
    let button = app.buttons["demo1.autoSizeButton"]
    LayoutAssertionHelper.assertVisibleLayout(
      button, in: vcView, context: context, elementName: "自适应 Button", minSize: 20
    )
    // .centerXEqualToView(self.view) .topSpaceToView(self.view1, 20)
    LayoutAssertionHelper.assertCenteredHorizontallyInControllerView(
      button, in: app, tolerance: marginTolerance, context: context, elementName: "自适应 Button"
    )
    LayoutAssertionHelper.assertApproxEqual(
      button.frame.minY - view1.frame.maxY, 20, tolerance: marginTolerance, context: context,
      message: "Button 应在 view1 下方 20pt (topSpaceToView view1, 20)"
    )
    // setupAutoSizeWithHorizontalPadding:10 buttonHeight:25
    LayoutAssertionHelper.assertApproxEqual(
      button.frame.height, 25, tolerance: sizeTolerance, context: context,
      message: "Button 高度应为 25pt (buttonHeight:25)"
    )
    XCTAssertGreaterThan(
      button.frame.width, 120,
      "\(context.prefix) Button 宽度应随标题变宽（含左右 padding 10），实际 \(button.frame.width)pt"
    )
    XCTAssertLessThan(
      button.frame.width, window.width * 0.85,
      "\(context.prefix) Button 宽度不应异常铺满全屏"
    )
  }
}
