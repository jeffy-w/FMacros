import SwiftSyntax
import SwiftSyntaxMacros

public struct HexColorMacro: DeclarationMacro {

    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        let args = Array(node.arguments)

        let name = try extractStringLiteral(args, at: 0, label: "属性名称")
        let hex = try extractStringLiteral(args, at: 1, label: "hex 颜色值")

        try validateHex(hex)

        var alpha: String?
        var desc: String?

        for arg in args.dropFirst(2) {
            if arg.label?.text == "alpha" {
                alpha = extractNumericLiteral(arg.expression)
            } else if arg.label?.text == "desc" {
                if let value = extractStringLiteralValue(arg.expression), !value.isEmpty {
                    desc = value
                }
            }
        }

        let shouldOmitAlpha = alpha == nil || alpha == "1.0" || alpha == "1"

        let docComment = buildDocComment(hex: hex, alpha: shouldOmitAlpha ? nil : alpha, desc: desc)
        let initializer = buildInitializer(hex: hex, alpha: shouldOmitAlpha ? nil : alpha)

        let decl: DeclSyntax = """
            \(raw: docComment)
            class var \(raw: name): UIColor { return \(raw: initializer) }
            """
        return [decl]
    }
}

// MARK: - Argument Parsing

private func extractStringLiteral(_ args: [LabeledExprSyntax], at index: Int, label: String) throws -> String {
    guard args.count > index,
          let value = extractStringLiteralValue(args[index].expression)
    else {
        throw MacroError("第 \(index + 1) 个参数必须是字符串字面量 (\(label))")
    }
    return value
}

private func extractStringLiteralValue(_ expr: ExprSyntax) -> String? {
    expr.as(StringLiteralExprSyntax.self)?
        .segments.first?
        .as(StringSegmentSyntax.self)?
        .content.text
}

private func extractNumericLiteral(_ expr: ExprSyntax) -> String? {
    if let floatLiteral = expr.as(FloatLiteralExprSyntax.self) {
        return floatLiteral.literal.text
    }
    if let intLiteral = expr.as(IntegerLiteralExprSyntax.self) {
        return intLiteral.literal.text
    }
    return nil
}

// MARK: - Validation

private func validateHex(_ hex: String) throws {
    guard hex.hasPrefix("#") else {
        throw MacroError("hex 值必须以 # 开头,如 \"#FF0000\"")
    }
    let digits = hex.dropFirst()
    guard [3, 6].contains(digits.count),
          digits.allSatisfy({ $0.isHexDigit })
    else {
        throw MacroError("hex 值格式无效: \"\(hex)\",应为 #RGB / #RRGGBB")
    }
}

// MARK: - Code Generation

private func buildDocComment(hex: String, alpha: String?, desc: String?) -> String {
    var parts: [String] = []
    if let desc { parts.append(desc) }

    var hexPart = "`\(hex)`"
    if let alpha { hexPart += " alpha: \(alpha)" }

    if let desc {
        return "/// \(desc) (\(hexPart))"
    } else {
        return "/// \(hexPart)"
    }
}

private func buildInitializer(hex: String, alpha: String?) -> String {
    if let alpha {
        return "UIColor(hexString: \"\(hex)\", alpha: \(alpha)) ?? .clear"
    }
    return "UIColor(hexString: \"\(hex)\") ?? .clear"
}

// MARK: - Error

private struct MacroError: Error, CustomStringConvertible {
    let description: String
    init(_ description: String) { self.description = description }
}
