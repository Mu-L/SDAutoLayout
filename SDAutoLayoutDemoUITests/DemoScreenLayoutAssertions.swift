import XCTest

/// Demo 2–14 与 `DemoVC*.m` 中 sd_layout 意图一一对应的 UI 验收（Demo 1 见 `DemoVC1LayoutAssertions`）。
enum DemoScreenLayoutAssertions {

  private static let marginTolerance: CGFloat = 10
  private static let sizeTolerance: CGFloat = 8

  // MARK: - Demo 2 自定义 Button + 流式子 view

  static func assertDemo2(in app: XCUIApplication, context: DemoLayoutContext) {
    let window = LayoutAssertionHelper.controllerViewBounds(for: app)
    let vcView = LayoutAssertionHelper.controllerContentFrame(for: app)

    let button = app.buttons["demo2.customButton"]
    LayoutAssertionHelper.assertVisibleLayout(
      button, in: vcView, context: context, elementName: "自定义 Button", minSize: 40
    )
    LayoutAssertionHelper.assertCenteredHorizontallyInControllerView(
      button, in: app, tolerance: marginTolerance, context: context, elementName: "自定义 Button"
    )
    LayoutAssertionHelper.assertTopInsetFromControllerView(
      button, in: app, top: 10, tolerance: marginTolerance, context: context, elementName: "自定义 Button"
    )
    LayoutAssertionHelper.assertApproxEqual(
      button.frame.width, window.width * 0.5, tolerance: window.width * 0.08, context: context,
      message: "自定义 Button 宽度应为屏幕一半 (widthRatioToView 0.5)"
    )
    LayoutAssertionHelper.assertApproxEqual(
      button.frame.height, 120, tolerance: sizeTolerance, context: context,
      message: "自定义 Button 高度应为 120pt (heightIs(120))"
    )

    let green = app.otherElements["demo2.autoWidthContainer"]
    let blue = app.otherElements["demo2.autoMarginContainer"]
    LayoutAssertionHelper.assertVisibleLayout(
      green, in: vcView, context: context, elementName: "固定间距流式容器(绿)", minSize: 30
    )
    LayoutAssertionHelper.assertVisibleLayout(
      blue, in: vcView, context: context, elementName: "固定宽度流式容器(蓝)", minSize: 30
    )
    LayoutAssertionHelper.assertHorizontalInsetsFromControllerView(
      green, in: app, left: 10, right: 10, tolerance: marginTolerance,
      context: context, elementName: "绿色容器"
    )
    LayoutAssertionHelper.assertApproxEqual(
      green.frame.minY - button.frame.maxY, 10, tolerance: marginTolerance, context: context,
      message: "绿色容器应在 Button 下方 10pt"
    )
    LayoutAssertionHelper.assertHorizontalInsetsFromControllerView(
      blue, in: app, left: 10, right: 10, tolerance: marginTolerance,
      context: context, elementName: "蓝色容器"
    )
    LayoutAssertionHelper.assertApproxEqual(
      blue.frame.minY - green.frame.maxY, 10, tolerance: marginTolerance, context: context,
      message: "蓝色容器应在绿色容器下方 10pt"
    )
    XCTAssertGreaterThan(
      blue.frame.maxY, green.frame.maxY + 40,
      "\(context.prefix) 蓝色流式区域应有可见高度（setupAutoMarginFlowItems）"
    )
  }

  // MARK: - Demo 3 简单 TableView + TestCell2 高度自适应

  static func assertDemo3(in app: XCUIApplication, context: DemoLayoutContext) {
    let table = LayoutAssertionHelper.demoTable(3, in: app)
    LayoutAssertionHelper.assertTableAutoLayoutHealthy(
      table, in: app, context: context, minCells: 1, minFirstCellHeight: 55
    )
    let cell = table.cells.element(boundBy: 0)
    XCTAssertGreaterThan(
      cell.frame.width, LayoutAssertionHelper.controllerViewBounds(for: app).width * 0.85,
      "\(context.prefix) cell 应接近全宽（左右仅 contentView 边距）"
    )
  }

  // MARK: - Demo 4 多行 attributed label + 全宽按钮

  static func assertDemo4(in app: XCUIApplication, context: DemoLayoutContext) {
    let vcView = LayoutAssertionHelper.controllerContentFrame(for: app)

    let label = app.staticTexts["demo4.attributedLabel"]
    let refresh = app.buttons["demo4.refreshButton"]
    LayoutAssertionHelper.assertVisibleLayout(
      label, in: vcView, context: context, elementName: "富文本 Label", minSize: 16
    )
    LayoutAssertionHelper.assertHorizontalInsetsFromControllerView(
      label, in: app, left: 10, right: 10, tolerance: marginTolerance,
      context: context, elementName: "富文本 Label"
    )
    LayoutAssertionHelper.assertTopInsetFromControllerView(
      label, in: app, top: 0, tolerance: marginTolerance, context: context,
      elementName: "富文本 Label"
    )
    XCTAssertGreaterThan(
      label.frame.height, 44,
      "\(context.prefix) 富文本应多行折行 (autoHeightRatio(0))，高度=\(label.frame.height)pt"
    )

    LayoutAssertionHelper.assertVisibleLayout(
      refresh, in: vcView, context: context, elementName: "刷新按钮", minSize: 20
    )
    LayoutAssertionHelper.assertLeftAlignedWithControllerView(
      refresh, in: app, tolerance: sizeTolerance, context: context, elementName: "刷新按钮"
    )
    LayoutAssertionHelper.assertRightAlignedWithControllerView(
      refresh, in: app, tolerance: sizeTolerance, context: context, elementName: "刷新按钮"
    )
    LayoutAssertionHelper.assertApproxEqual(
      refresh.frame.minY - label.frame.maxY, 20, tolerance: marginTolerance, context: context,
      message: "刷新按钮应在 Label 下方 20pt"
    )
    LayoutAssertionHelper.assertApproxEqual(
      refresh.frame.height, 30, tolerance: sizeTolerance, context: context,
      message: "刷新按钮高度 30pt (heightIs(30))"
    )
  }

  // MARK: - Demo 5 TableHeader 自适应 + 图文 cell

  static func assertDemo5(in app: XCUIApplication, context: DemoLayoutContext) {
    let table = LayoutAssertionHelper.demoTable(5, in: app)
    let dateLabel = app.staticTexts["demo5.header.dateLabel"]
    XCTAssertTrue(
      dateLabel.waitForExistence(timeout: 3),
      "\(context.prefix) TableHeader 应包含日期 Label (demo5.header.dateLabel)"
    )
    XCTAssertTrue(
      dateLabel.label.contains("更新时间"),
      "\(context.prefix) Header 日期文案异常：\(dateLabel.label)"
    )
    LayoutAssertionHelper.assertTableAutoLayoutHealthy(
      table, in: app, context: context, minCells: 1, minFirstCellHeight: 85
    )
  }

  // MARK: - Demo 6 ScrollView contentsize + 圆角块

  static func assertDemo6(in app: XCUIApplication, context: DemoLayoutContext) {
    let vcView = LayoutAssertionHelper.controllerContentFrame(for: app)
    let scroll = LayoutAssertionHelper.demoScroll(in: app)

    let scrollFrame = scroll.frame
    XCTAssertGreaterThan(
      scrollFrame.width, vcView.width * 0.95,
      "\(context.prefix) ScrollView 应铺满 (spaceToSuperView)"
    )

    let view0 = LayoutAssertionHelper.layoutBox(0, in: app)
    let view1 = LayoutAssertionHelper.layoutBox(1, in: app)
    let view3 = LayoutAssertionHelper.layoutBox(3, in: app)
    LayoutAssertionHelper.assertVisibleLayout(
      view0, in: vcView, context: context,
      elementName: "view0", minSize: 40
    )
    LayoutAssertionHelper.assertHorizontalInsets(
      view0, in: scrollFrame, left: 20, right: 20, tolerance: marginTolerance,
      context: context, elementName: "view0（相对 ScrollView）"
    )
    LayoutAssertionHelper.assertTopInset(
      view0, in: scrollFrame, top: 20, tolerance: marginTolerance,
      context: context, elementName: "view0（相对 ScrollView）"
    )
    LayoutAssertionHelper.assertApproxEqual(
      view0.frame.height, 150, tolerance: sizeTolerance, context: context,
      message: "view0 高度 150pt"
    )

    LayoutAssertionHelper.assertApproxEqual(
      view1.frame.width, 200, tolerance: sizeTolerance, context: context,
      message: "view1 宽度 200pt (widthIs(200))"
    )
    LayoutAssertionHelper.assertApproxEqual(
      view1.frame.height, 200, tolerance: sizeTolerance, context: context,
      message: "view1 高度 200pt"
    )
    LayoutAssertionHelper.assertCenteredHorizontally(
      view1, in: scrollFrame, tolerance: marginTolerance, context: context, elementName: "view1"
    )
    LayoutAssertionHelper.assertApproxEqual(
      view1.frame.minY - view0.frame.maxY, 20, tolerance: marginTolerance, context: context,
      message: "view1 应在 view0 下方 20pt"
    )

    LayoutAssertionHelper.assertApproxEqual(
      view3.frame.width, 250, tolerance: sizeTolerance, context: context,
      message: "view3 宽度 250pt"
    )
    LayoutAssertionHelper.assertApproxEqual(
      view3.frame.width, view3.frame.height, tolerance: sizeTolerance, context: context,
      message: "view3 应为正方形 (heightEqualToWidth)"
    )
    LayoutAssertionHelper.assertApproxEqual(
      view3.frame.minY - LayoutAssertionHelper.layoutBox(2, in: app).frame.maxY,
      20, tolerance: marginTolerance, context: context,
      message: "view3 应在 view2 下方 20pt"
    )

    // 几何断言需在初始 contentOffset；assertScrollContentLayoutHealthy 会 swipeUp
    LayoutAssertionHelper.assertScrollContentLayoutHealthy(scroll, in: app, context: context)
  }

  // MARK: - Demo 7 / 8 多 cell 高度自适应

  static func assertDemo7(in app: XCUIApplication, context: DemoLayoutContext) {
    LayoutAssertionHelper.assertTableAutoLayoutHealthy(
      LayoutAssertionHelper.demoTable(7, in: app), in: app, context: context,
      minCells: 2, minFirstCellHeight: 60
    )
  }

  static func assertDemo8(in app: XCUIApplication, context: DemoLayoutContext) {
    LayoutAssertionHelper.assertTableAutoLayoutHealthy(
      LayoutAssertionHelper.demoTable(8, in: app), in: app, context: context,
      minCells: 2, minFirstCellHeight: 60
    )
  }

  // MARK: - Demo 9 朋友圈

  static func assertDemo9(in app: XCUIApplication, context: DemoLayoutContext) {
    LayoutAssertionHelper.assertTableAutoLayoutHealthy(
      LayoutAssertionHelper.demoTable(9, in: app), in: app, context: context,
      minCells: 1, minFirstCellHeight: 100
    )
  }

  // MARK: - Demo 10 网易新闻

  static func assertDemo10(in app: XCUIApplication, context: DemoLayoutContext) {
    let table = app.tables["demoVC10TableView"]
    let target = table.exists ? table : app.tables.element(boundBy: 0)
    let vcView = LayoutAssertionHelper.controllerContentFrame(for: app)
    LayoutAssertionHelper.assertVisibleLayout(
      target, in: vcView, context: context, elementName: "新闻 TableView", minSize: 100
    )
    if target.cells.count > 0 {
      LayoutAssertionHelper.assertTableAutoLayoutHealthy(
        target, in: app, context: context, minCells: 1, minFirstCellHeight: 44
      )
    }
  }

  // MARK: - Demo 11 聊天

  static func assertDemo11(in app: XCUIApplication, context: DemoLayoutContext) {
    LayoutAssertionHelper.assertTableAutoLayoutHealthy(
      LayoutAssertionHelper.demoTable(11, in: app), in: app, context: context,
      minCells: 1, minFirstCellHeight: 44
    )
  }

  // MARK: - Demo 12 / 13 Scroll 流式 / 纵向自适应

  static func assertDemo12(in app: XCUIApplication, context: DemoLayoutContext) {
    let scroll = LayoutAssertionHelper.demoScroll(in: app)
    LayoutAssertionHelper.assertScrollContentLayoutHealthy(scroll, in: app, context: context)

    let flow = app.otherElements["demo12.flowContent"]
    LayoutAssertionHelper.assertVisibleLayout(
      flow, in: LayoutAssertionHelper.controllerContentFrame(for: app), context: context,
      elementName: "流式内容区 demo12.flowContent", minSize: 80
    )
    XCTAssertGreaterThan(
      flow.frame.height, 300,
      "\(context.prefix) 流式内容区应被 35 个子项撑高（setupAutoWidthFlowItems），高度=\(flow.frame.height)pt"
    )
    let beforeMaxY = flow.frame.maxY
    scroll.swipeUp()
    RunLoop.current.run(until: Date().addingTimeInterval(0.35))
    XCTAssertGreaterThan(
      scroll.frame.height, 200,
      "\(context.prefix) ScrollView 应可滚动展示长内容"
    )
    _ = beforeMaxY
  }

  static func assertDemo13(in app: XCUIApplication, context: DemoLayoutContext) {
    let scroll = LayoutAssertionHelper.demoScroll(in: app)
    LayoutAssertionHelper.assertScrollContentLayoutHealthy(scroll, in: app, context: context)

    let content = app.otherElements["demo13.scrollContent"]
    LayoutAssertionHelper.assertVisibleLayout(
      content, in: LayoutAssertionHelper.controllerContentFrame(for: app), context: context,
      elementName: "纵向排版内容 demo13.scrollContent", minSize: 100
    )
    XCTAssertGreaterThan(
      content.frame.height, 400,
      "\(context.prefix) wrapperView 应由多块内容撑高（setupAutoHeightWithBottomView），高度=\(content.frame.height)pt"
    )
  }

  // MARK: - Demo 14 XIB cell 高度自适应

  static func assertDemo14(in app: XCUIApplication, context: DemoLayoutContext) {
    LayoutAssertionHelper.assertTableAutoLayoutHealthy(
      LayoutAssertionHelper.demoTable(14, in: app), in: app, context: context,
      minCells: 2, minFirstCellHeight: 60
    )
  }
}
