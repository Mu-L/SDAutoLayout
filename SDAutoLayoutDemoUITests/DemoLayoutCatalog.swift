import XCTest

struct DemoLayoutSpec {
  let index: Int
  let navigationTitle: String
  let summary: String
  let settleSeconds: TimeInterval
  let check: (XCUIApplication, DemoLayoutContext) -> Void

  func makeContext() -> DemoLayoutContext {
    DemoLayoutContext(index: index, navigationTitle: navigationTitle)
  }
}

enum DemoLayoutCatalog {

  static let demoCount = 15

  static let all: [DemoLayoutSpec] = [
    DemoLayoutSpec(
      index: 0, navigationTitle: "DemoVC0", summary: "约束动画联动-彩色块布局",
      settleSeconds: 0.3
    ) { app, ctx in
      LayoutAssertionHelper.assertColoredLayoutBoxes(
        in: app, context: ctx, minCount: 4, indices: [0, 1, 2, 3, 4, 5]
      )
    },

    DemoLayoutSpec(
      index: 1, navigationTitle: "DemoVC1", summary: "内容/宽高自适应 label 与 button",
      settleSeconds: 0.3
    ) { app, ctx in
      DemoVC1LayoutAssertions.assertMatchesLayoutCode(in: app, context: ctx)
    },

    DemoLayoutSpec(
      index: 2, navigationTitle: "DemoVC2", summary: "自定义 Button + 流式子 view 排布",
      settleSeconds: 0.3
    ) { app, ctx in
      DemoScreenLayoutAssertions.assertDemo2(in: app, context: ctx)
    },

    DemoLayoutSpec(
      index: 3, navigationTitle: "DemoVC3", summary: "简单 TableView cell 高度自适应",
      settleSeconds: 0.5
    ) { app, ctx in
      DemoScreenLayoutAssertions.assertDemo3(in: app, context: ctx)
    },

    DemoLayoutSpec(
      index: 4, navigationTitle: "DemoVC4", summary: "多行 attributed label + 全宽按钮",
      settleSeconds: 0.3
    ) { app, ctx in
      DemoScreenLayoutAssertions.assertDemo4(in: app, context: ctx)
    },

    DemoLayoutSpec(
      index: 5, navigationTitle: "DemoVC5", summary: "TableHeader 自适应 + 图文 cell",
      settleSeconds: 0.8
    ) { app, ctx in
      DemoScreenLayoutAssertions.assertDemo5(in: app, context: ctx)
    },

    DemoLayoutSpec(
      index: 6, navigationTitle: "DemoVC6", summary: "ScrollView contentsize + 圆角块",
      settleSeconds: 0.5
    ) { app, ctx in
      DemoScreenLayoutAssertions.assertDemo6(in: app, context: ctx)
    },

    DemoLayoutSpec(
      index: 7, navigationTitle: "DemoVC7", summary: "多 cell 类型-两步高度自适应",
      settleSeconds: 0.8
    ) { app, ctx in
      DemoScreenLayoutAssertions.assertDemo7(in: app, context: ctx)
    },

    DemoLayoutSpec(
      index: 8, navigationTitle: "DemoVC8", summary: "升级版多 cell 一步高度自适应",
      settleSeconds: 0.8
    ) { app, ctx in
      DemoScreenLayoutAssertions.assertDemo8(in: app, context: ctx)
    },

    DemoLayoutSpec(
      index: 9, navigationTitle: "DemoVC9", summary: "朋友圈时间线",
      settleSeconds: 1.0
    ) { app, ctx in
      DemoScreenLayoutAssertions.assertDemo9(in: app, context: ctx)
    },

    DemoLayoutSpec(
      index: 10, navigationTitle: "DemoVC10", summary: "网易新闻列表",
      settleSeconds: 1.0
    ) { app, ctx in
      DemoScreenLayoutAssertions.assertDemo10(in: app, context: ctx)
    },

    DemoLayoutSpec(
      index: 11, navigationTitle: "DemoVC11", summary: "聊天列表",
      settleSeconds: 0.8
    ) { app, ctx in
      DemoScreenLayoutAssertions.assertDemo11(in: app, context: ctx)
    },

    DemoLayoutSpec(
      index: 12, navigationTitle: "DemoVC12", summary: "Scroll 流式布局",
      settleSeconds: 0.5
    ) { app, ctx in
      DemoScreenLayoutAssertions.assertDemo12(in: app, context: ctx)
    },

    DemoLayoutSpec(
      index: 13, navigationTitle: "DemoVC13", summary: "Scroll 纵向内容自适应",
      settleSeconds: 0.5
    ) { app, ctx in
      DemoScreenLayoutAssertions.assertDemo13(in: app, context: ctx)
    },

    DemoLayoutSpec(
      index: 14, navigationTitle: "DemoVC14", summary: "XIB cell 高度自适应",
      settleSeconds: 0.8
    ) { app, ctx in
      DemoScreenLayoutAssertions.assertDemo14(in: app, context: ctx)
    }
  ]
}
