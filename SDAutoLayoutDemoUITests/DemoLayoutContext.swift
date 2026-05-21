import Foundation

/// 当前正在验收的 Demo 页面，用于拼接到失败信息里。
struct DemoLayoutContext {
  let index: Int
  let navigationTitle: String

  /// 例如：[Demo 4 DemoVC4]
  var prefix: String { "[Demo \(index) \(navigationTitle)]" }
}
