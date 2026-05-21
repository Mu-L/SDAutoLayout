import XCTest

final class SDAutoLayoutDemoUITests: XCTestCase {

  private var app: XCUIApplication!

  override func setUpWithError() throws {
    continueAfterFailure = false
    app = XCUIApplication()
    app.launchArguments.append("-SDAutoLayoutUITest")
    app.launch()
  }

  /// 依次进入 Demo 0–14，按 `DemoLayoutCatalog` 规则检查自动布局。
  func testAllDemosAutoLayoutIsHealthy() {
    for spec in DemoLayoutCatalog.all {
      let ctx = spec.makeContext()
      XCTContext.runActivity(named: "Demo \(spec.index): \(spec.summary)") { _ in
        openDemo(row: spec.index, context: ctx)
        if spec.settleSeconds > 0 {
          RunLoop.current.run(until: Date().addingTimeInterval(spec.settleSeconds))
        }
        spec.check(app, ctx)
        navigateBackToDemoList(context: ctx)
      }
    }
  }

  func testDemoListIsVisible() {
    let list = app.tables["demoListTable"]
    XCTAssertTrue(
      list.waitForExistence(timeout: 5),
      "首页 Demo 列表未出现（demoListTable）"
    )
    XCTAssertTrue(
      app.staticTexts["Demo -- 0"].exists,
      "首页缺少 Demo -- 0 入口"
    )
    XCTAssertTrue(
      app.staticTexts["Demo -- 14"].exists,
      "首页缺少 Demo -- 14 入口（可尝试上滑列表）"
    )
  }

  func testOpenDemo1LayoutSnapshot() {
    let spec = DemoLayoutCatalog.all[1]
    let ctx = spec.makeContext()
    XCTContext.runActivity(named: "Demo 1: \(spec.summary)") { _ in
      openDemo(row: spec.index, context: ctx)
      RunLoop.current.run(until: Date().addingTimeInterval(spec.settleSeconds))
      spec.check(app, ctx)
      navigateBackToDemoList(context: ctx)
    }
  }

  // MARK: - Navigation

  private func openDemo(row: Int, context: DemoLayoutContext) {
    let list = app.tables["demoListTable"]
    XCTAssertTrue(
      list.waitForExistence(timeout: 5),
      "\(context.prefix) 无法返回首页：Demo 列表 (demoListTable) 未出现"
    )

    if !app.cells["demoCell.\(row)"].exists {
      list.swipeUp()
    }

    let cell = app.cells["demoCell.\(row)"]
    if cell.waitForExistence(timeout: 5) {
      cell.tap()
    } else {
      let title = app.staticTexts["Demo -- \(row)"]
      XCTAssertTrue(
        title.waitForExistence(timeout: 3),
        "\(context.prefix) 进入失败：找不到 Demo -- \(row) 入口"
      )
      title.tap()
    }

    XCTAssertTrue(
      app.navigationBars[context.navigationTitle].waitForExistence(timeout: 10),
      """
      \(context.prefix) 进入失败：10s 内未出现导航栏「\(context.navigationTitle)」。\
      可能 push 失败或页面标题不一致
      """
    )
  }

  private func navigateBackToDemoList(context: DemoLayoutContext) {
    let navBar = app.navigationBars.element(boundBy: 0)
    let backButton = navBar.buttons.element(boundBy: 0)
    if backButton.waitForExistence(timeout: 3), backButton.isHittable {
      backButton.tap()
    } else if app.navigationBars.buttons["Demo"].exists {
      app.navigationBars.buttons["Demo"].tap()
    } else {
      XCTFail("\(context.prefix) 返回失败：未找到返回按钮（Back 或「Demo」）")
      return
    }

    XCTAssertTrue(
      app.tables["demoListTable"].waitForExistence(timeout: 8),
      "\(context.prefix) 返回失败：8s 内未回到首页 Demo 列表 (demoListTable)"
    )
  }
}
