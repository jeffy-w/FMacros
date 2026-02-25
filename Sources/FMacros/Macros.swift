/// FMacros - 项目通用宏

/// 生成 `UIColor` 类属性,同时自动生成包含 hex 值的文档注释。
///
/// hex 字符串只需写一次,宏会同时生成文档注释和属性声明,
/// 从根本上消除注释与代码不一致的问题。
///
/// ```swift
/// extension UIColor {
///     #hexColor("red9", "#4D000A")
///     #hexColor("brand6_normal", "#FFDD4C", desc: "品牌主色")
///     #hexColor("gray2_A7", "#333333", alpha: 0.7)
///     #hexColor("gray2_A7", "#333333", alpha: 0.7, desc: "灰色 70%")
/// }
/// ```
///
/// - Parameters:
///   - name: 属性名称
///   - hex: hex 颜色值,如 `"#FF0000"`
///   - alpha: 透明度,默认 1.0
///   - desc: 可选的语义描述
@freestanding(declaration, names: arbitrary)
public macro hexColor(
    _ name: String,
    _ hex: String,
    alpha: Float = 1.0,
    desc: String = ""
) = #externalMacro(module: "FMacrosPlugin", type: "HexColorMacro")
