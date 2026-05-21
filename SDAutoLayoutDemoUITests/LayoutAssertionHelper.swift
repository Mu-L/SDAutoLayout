import XCTest

/// 通过 XCUITest 的 frame 信息检查控件是否「布局正常」：有尺寸、落在屏幕可见区域内。
enum LayoutAssertionHelper {

  /// 与 pushed VC 的 `self.view` 对齐（`topSpaceToView(self.view, …)` 等；非透明导航栏时顶边在导航栏下）
  static func controllerContentFrame(for app: XCUIApplication) -> CGRect {
    contentBounds(for: app)
  }

  /// 主窗口 frame；仅用于必须相对屏幕的断言（如 Demo2 的 widthRatioToView 相对屏宽）
  static func controllerViewBounds(for app: XCUIApplication) -> CGRect {
    let window = app.windows.element(boundBy: 0)
    return window.exists ? window.frame : app.frame
  }

  static func contentBounds(for app: XCUIApplication) -> CGRect {
    let window = app.windows.element(boundBy: 0)
    guard window.exists else { return app.frame }
    var bounds = window.frame
    if let nav = app.navigationBars.allElementsBoundByIndex.first, nav.exists {
      let top = nav.frame.maxY
      if top > bounds.minY {
        bounds.origin.y = top
        bounds.size.height -= (top - window.frame.minY)
      }
    }
    return bounds
  }

  private static func frameDescription(_ frame: CGRect) -> String {
    String(
      format: "frame=(x:%.0f,y:%.0f,w:%.0f,h:%.0f)",
      frame.origin.x, frame.origin.y, frame.width, frame.height
    )
  }

  @discardableResult
  static func assertVisibleLayout(
    _ element: XCUIElement,
    in contentBounds: CGRect,
    context: DemoLayoutContext,
    elementName: String,
    minSize: CGFloat = 8,
    file: StaticString = #filePath,
    line: UInt = #line
  ) -> Bool {
    let p = context.prefix
    XCTAssertTrue(
      element.exists,
      "\(p) \(elementName)：元素不存在（accessibility 未找到）",
      file: file, line: line
    )
    let frame = element.frame
    XCTAssertGreaterThan(
      frame.width, minSize,
      "\(p) \(elementName)：宽度过小（要求 > \(minSize)pt），\(frameDescription(frame))",
      file: file, line: line
    )
    XCTAssertGreaterThan(
      frame.height, minSize,
      "\(p) \(elementName)：高度过小（要求 > \(minSize)pt），\(frameDescription(frame))",
      file: file, line: line
    )
    let visible = frame.intersection(contentBounds)
    XCTAssertGreaterThan(
      visible.width, minSize,
      "\(p) \(elementName)：在内容区水平方向不可见，\(frameDescription(frame))，内容区 \(frameDescription(contentBounds))",
      file: file, line: line
    )
    XCTAssertGreaterThan(
      visible.height, minSize,
      "\(p) \(elementName)：在内容区垂直方向不可见，\(frameDescription(frame))，内容区 \(frameDescription(contentBounds))",
      file: file, line: line
    )
    return true
  }

  static func layoutBox(_ index: Int, in app: XCUIApplication) -> XCUIElement {
    app.otherElements["demo.layout.view\(index)"]
  }

  static func demoTable(_ index: Int, in app: XCUIApplication) -> XCUIElement {
    let named = app.tables["demo.\(index).table"]
    return named.exists ? named : app.tables.element(boundBy: 0)
  }

  static func demoScroll(in app: XCUIApplication) -> XCUIElement {
    let named = app.scrollViews["demo.scroll.main"]
    return named.exists ? named : app.scrollViews.element(boundBy: 0)
  }

  static func assertColoredLayoutBoxes(
    in app: XCUIApplication,
    context: DemoLayoutContext,
    minCount: Int,
    indices: [Int] = Array(0...8),
    file: StaticString = #filePath,
    line: UInt = #line
  ) {
    let bounds = contentBounds(for: app)
    var visible = 0
    var missing: [Int] = []
    for index in indices {
      let box = layoutBox(index, in: app)
      guard box.exists else {
        missing.append(index)
        continue
      }
      let frame = box.frame
      let visiblePart = frame.intersection(bounds)
      if frame.width > 8, frame.height > 8,
         visiblePart.width > 8, visiblePart.height > 8 {
        visible += 1
      }
    }
    XCTAssertGreaterThanOrEqual(
      visible, minCount,
      """
      \(context.prefix) 彩色布局块数量不足：需要至少 \(minCount) 个可见 \
      (demo.layout.view0–8)，实际 \(visible) 个；\
      未找到的索引: \(missing.map(String.init).joined(separator: ","))
      """,
      file: file, line: line
    )
  }

  static func assertTableAutoLayoutHealthy(
    _ table: XCUIElement,
    in app: XCUIApplication,
    context: DemoLayoutContext,
    minCells: Int = 1,
    minFirstCellHeight: CGFloat = 44,
    file: StaticString = #filePath,
    line: UInt = #line
  ) {
    let bounds = contentBounds(for: app)
    assertVisibleLayout(
      table, in: bounds, context: context, elementName: "主列表 TableView", minSize: 100,
      file: file, line: line
    )

    let cells = table.cells
    XCTAssertGreaterThanOrEqual(
      cells.count, minCells,
      "\(context.prefix) TableView cell 数量不足：需要 ≥ \(minCells)，实际 \(cells.count)",
      file: file, line: line
    )

    for index in 0..<min(minCells, cells.count) {
      let cell = cells.element(boundBy: index)
      XCTAssertTrue(
        cell.waitForExistence(timeout: 3),
        "\(context.prefix) 第 \(index) 个 cell 在 3s 内未出现",
        file: file, line: line
      )
      let frame = cell.frame
      XCTAssertGreaterThan(
        frame.width, bounds.width * 0.5,
        "\(context.prefix) 第 \(index) 个 cell 过窄，\(frameDescription(frame))",
        file: file, line: line
      )
      if index == 0 {
        XCTAssertGreaterThan(
          frame.height, minFirstCellHeight,
          """
          \(context.prefix) 首行 cell 高度异常（可能高度自适应失败）：\
          需要 > \(minFirstCellHeight)pt，\(frameDescription(frame))
          """,
          file: file, line: line
        )
      } else {
        XCTAssertGreaterThan(
          frame.height, 20,
          "\(context.prefix) 第 \(index) 个 cell 高度过小，\(frameDescription(frame))",
          file: file, line: line
        )
      }
    }
  }

  static func assertScrollContentLayoutHealthy(
    _ scroll: XCUIElement,
    in app: XCUIApplication,
    context: DemoLayoutContext,
    file: StaticString = #filePath,
    line: UInt = #line
  ) {
    let bounds = contentBounds(for: app)
    assertVisibleLayout(
      scroll, in: bounds, context: context, elementName: "ScrollView (demo.scroll.main)",
      minSize: 120, file: file, line: line
    )

    scroll.swipeUp()
    RunLoop.current.run(until: Date().addingTimeInterval(0.4))

    let hasContent =
      app.staticTexts.count > 0
      || app.images.count > 0
      || app.buttons.count > 0
      || app.otherElements.count > 5
    XCTAssertTrue(
      hasContent,
      """
      \(context.prefix) ScrollView 上滑后未发现有效子内容\
      （texts=\(app.staticTexts.count) images=\(app.images.count) \
      buttons=\(app.buttons.count) others=\(app.otherElements.count)）
      """,
      file: file, line: line
    )
  }

  // MARK: - 几何关系（与 SDAutoLayout 链式约束对应）

  static func assertApproxEqual(
    _ actual: CGFloat,
    _ expected: CGFloat,
    tolerance: CGFloat,
    context: DemoLayoutContext,
    message: String,
    file: StaticString = #filePath,
    line: UInt = #line
  ) {
    XCTAssertLessThanOrEqual(
      abs(actual - expected), tolerance,
      "\(context.prefix) \(message)：实际 \(actual)，期望 \(expected)±\(tolerance)",
      file: file, line: line
    )
  }

  /// 元素左右边距相对容器（对应 leftSpaceToView / rightSpaceToView）
  static func assertHorizontalInsets(
    _ element: XCUIElement,
    in container: CGRect,
    left: CGFloat,
    right: CGFloat,
    tolerance: CGFloat = 8,
    context: DemoLayoutContext,
    elementName: String,
    file: StaticString = #filePath,
    line: UInt = #line
  ) {
    let frame = element.frame
    assertApproxEqual(
      frame.minX, container.minX + left, tolerance: tolerance, context: context,
      message: "\(elementName) 左边距应为 \(left)pt", file: file, line: line
    )
    assertApproxEqual(
      container.maxX - frame.maxX, right, tolerance: tolerance, context: context,
      message: "\(elementName) 右边距应为 \(right)pt", file: file, line: line
    )
  }

  // MARK: - 相对 self.view（DemoVC 里最常见的父视图）

  /// 透明导航栏时 `self.view` 顶与窗口齐；`translucent = NO` 时在导航栏下。按元素实际 y 自动选参照。
  static func resolvedControllerFrame(
    for app: XCUIApplication,
    element: XCUIElement,
    expectedTop: CGFloat
  ) -> CGRect {
    let window = controllerViewBounds(for: app)
    let content = controllerContentFrame(for: app)
    guard content.minY > window.minY + 1 else { return window }
    let y = element.frame.minY
    let windowError = abs(y - (window.minY + expectedTop))
    let contentError = abs(y - (content.minY + expectedTop))
    return windowError <= contentError ? window : content
  }

  static func assertTopInsetFromControllerView(
    _ element: XCUIElement,
    in app: XCUIApplication,
    top: CGFloat,
    tolerance: CGFloat = 8,
    context: DemoLayoutContext,
    elementName: String,
    file: StaticString = #filePath,
    line: UInt = #line
  ) {
    let container = resolvedControllerFrame(for: app, element: element, expectedTop: top)
    assertTopInset(
      element, in: container, top: top, tolerance: tolerance,
      context: context, elementName: elementName, file: file, line: line
    )
  }

  static func assertHorizontalInsetsFromControllerView(
    _ element: XCUIElement,
    in app: XCUIApplication,
    left: CGFloat,
    right: CGFloat,
    tolerance: CGFloat = 8,
    context: DemoLayoutContext,
    elementName: String,
    file: StaticString = #filePath,
    line: UInt = #line
  ) {
    let container = resolvedControllerFrame(for: app, element: element, expectedTop: 0)
    assertHorizontalInsets(
      element, in: container, left: left, right: right,
      tolerance: tolerance, context: context, elementName: elementName, file: file, line: line
    )
  }

  static func assertBottomInsetFromControllerView(
    _ element: XCUIElement,
    in app: XCUIApplication,
    bottom: CGFloat,
    tolerance: CGFloat = 8,
    context: DemoLayoutContext,
    elementName: String,
    file: StaticString = #filePath,
    line: UInt = #line
  ) {
    let window = controllerViewBounds(for: app)
    let content = controllerContentFrame(for: app)
    let container =
      (content.minY > window.minY + 1 && abs(element.frame.maxY - content.maxY) < abs(element.frame.maxY - window.maxY))
      ? content : window
    assertApproxEqual(
      container.maxY - element.frame.maxY, bottom, tolerance: tolerance, context: context,
      message: "\(elementName) 距 self.view 底边应为 \(bottom)pt", file: file, line: line
    )
  }

  static func assertCenteredHorizontallyInControllerView(
    _ element: XCUIElement,
    in app: XCUIApplication,
    tolerance: CGFloat = 8,
    context: DemoLayoutContext,
    elementName: String,
    file: StaticString = #filePath,
    line: UInt = #line
  ) {
    assertCenteredHorizontally(
      element, in: resolvedControllerFrame(for: app, element: element, expectedTop: 0),
      tolerance: tolerance, context: context, elementName: elementName, file: file, line: line
    )
  }

  static func assertLeftAlignedWithControllerView(
    _ element: XCUIElement,
    in app: XCUIApplication,
    tolerance: CGFloat = 8,
    context: DemoLayoutContext,
    elementName: String,
    file: StaticString = #filePath,
    line: UInt = #line
  ) {
    let vc = resolvedControllerFrame(for: app, element: element, expectedTop: 0)
    assertApproxEqual(
      element.frame.minX, vc.minX, tolerance: tolerance, context: context,
      message: "\(elementName) 应左对齐 self.view (leftEqualToView)", file: file, line: line
    )
  }

  static func assertRightAlignedWithControllerView(
    _ element: XCUIElement,
    in app: XCUIApplication,
    tolerance: CGFloat = 8,
    context: DemoLayoutContext,
    elementName: String,
    file: StaticString = #filePath,
    line: UInt = #line
  ) {
    let vc = resolvedControllerFrame(for: app, element: element, expectedTop: 0)
    assertApproxEqual(
      element.frame.maxX, vc.maxX, tolerance: tolerance, context: context,
      message: "\(elementName) 应右对齐 self.view (rightEqualToView)", file: file, line: line
    )
  }

  /// 元素顶部相对容器（对应 topSpaceToView）
  static func assertTopInset(
    _ element: XCUIElement,
    in container: CGRect,
    top: CGFloat,
    tolerance: CGFloat = 8,
    context: DemoLayoutContext,
    elementName: String,
    file: StaticString = #filePath,
    line: UInt = #line
  ) {
    assertApproxEqual(
      element.frame.minY, container.minY + top, tolerance: tolerance, context: context,
      message: "\(elementName) 上边距应为 \(top)pt", file: file, line: line
    )
  }

  /// 两元素底边对齐（对应 bottomEqualToView）
  static func assertBottomAligned(
    _ a: XCUIElement,
    _ b: XCUIElement,
    tolerance: CGFloat = 4,
    context: DemoLayoutContext,
    message: String,
    file: StaticString = #filePath,
    line: UInt = #line
  ) {
    assertApproxEqual(
      a.frame.maxY, b.frame.maxY, tolerance: tolerance, context: context,
      message: message, file: file, line: line
    )
  }

  /// 水平居中（对应 centerXEqualToView）
  static func assertCenteredHorizontally(
    _ element: XCUIElement,
    in container: CGRect,
    tolerance: CGFloat = 8,
    context: DemoLayoutContext,
    elementName: String,
    file: StaticString = #filePath,
    line: UInt = #line
  ) {
    let centerX = element.frame.midX
    let expected = container.midX
    assertApproxEqual(
      centerX, expected, tolerance: tolerance, context: context,
      message: "\(elementName) 应水平居中", file: file, line: line
    )
  }

  static func countSubstantialElements(in app: XCUIApplication, bounds: CGRect) -> Int {
    var count = 0
    let types: [XCUIElementQuery] = [
      app.staticTexts, app.buttons, app.images, app.otherElements
    ]
    for query in types {
      for index in 0..<min(query.count, 30) {
        let el = query.element(boundBy: index)
        guard el.exists else { continue }
        let part = el.frame.intersection(bounds)
        if part.width > 12, part.height > 12 { count += 1 }
      }
    }
    return count
  }
}
