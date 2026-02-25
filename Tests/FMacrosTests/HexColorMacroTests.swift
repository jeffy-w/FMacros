import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

@testable import FMacrosPlugin

final class HexColorMacroTests: XCTestCase {

    private let macros: [String: Macro.Type] = [
        "hexColor": HexColorMacro.self,
    ]

    func testBasicHexColor() throws {
        assertMacroExpansion(
            """
            #hexColor("red9", "#4D000A")
            """,
            expandedSource: """
            /// `#4D000A`
            static var red9: UIColor {
                return UIColor(hexString: "#4D000A") ?? .clear
            }
            """,
            macros: macros
        )
    }

    func testWithDescription() throws {
        assertMacroExpansion(
            """
            #hexColor("brand6_normal", "#FFDD4C", desc: "品牌主色")
            """,
            expandedSource: """
            /// 品牌主色 (`#FFDD4C`)
            static var brand6_normal: UIColor {
                return UIColor(hexString: "#FFDD4C") ?? .clear
            }
            """,
            macros: macros
        )
    }

    func testWithAlpha() throws {
        assertMacroExpansion(
            """
            #hexColor("gray2_A7", "#333333", alpha: 0.7)
            """,
            expandedSource: """
            /// `#333333` alpha: 0.7
            static var gray2_A7: UIColor {
                return UIColor(hexString: "#333333", alpha: 0.7) ?? .clear
            }
            """,
            macros: macros
        )
    }

    func testWithAlphaAndDescription() throws {
        assertMacroExpansion(
            """
            #hexColor("gray2_A7", "#333333", alpha: 0.7, desc: "灰色 70%")
            """,
            expandedSource: """
            /// 灰色 70% (`#333333` alpha: 0.7)
            static var gray2_A7: UIColor {
                return UIColor(hexString: "#333333", alpha: 0.7) ?? .clear
            }
            """,
            macros: macros
        )
    }

    func testAlphaOneIsOmitted() throws {
        assertMacroExpansion(
            """
            #hexColor("white1", "#FFFFFF", alpha: 1.0)
            """,
            expandedSource: """
            /// `#FFFFFF`
            static var white1: UIColor {
                return UIColor(hexString: "#FFFFFF") ?? .clear
            }
            """,
            macros: macros
        )
    }

    func testShortHex() throws {
        assertMacroExpansion(
            """
            #hexColor("shortRed", "#F00")
            """,
            expandedSource: """
            /// `#F00`
            static var shortRed: UIColor {
                return UIColor(hexString: "#F00") ?? .clear
            }
            """,
            macros: macros
        )
    }

    func testInvalidHexMissingHash() throws {
        assertMacroExpansion(
            ##"""
            #hexColor("bad", "FF0000")
            """##,
            expandedSource: ##"""
            #hexColor("bad", "FF0000")
            """##,
            diagnostics: [
                DiagnosticSpec(message: ##"hex 值必须以 # 开头,如 "#FF0000""##, line: 1, column: 1),
            ],
            macros: macros
        )
    }

    func testInvalidHexLength() throws {
        assertMacroExpansion(
            ##"""
            #hexColor("bad", "#FF00")
            """##,
            expandedSource: ##"""
            #hexColor("bad", "#FF00")
            """##,
            diagnostics: [
                DiagnosticSpec(message: ##"hex 值长度无效: "#FF00" (4位),应为 #RGB (3位) 或 #RRGGBB (6位)"##, line: 1, column: 1),
            ],
            macros: macros
        )
    }

    func testInvalidHexCharacters() throws {
        assertMacroExpansion(
            ##"""
            #hexColor("bad", "#4D000A8O")
            """##,
            expandedSource: ##"""
            #hexColor("bad", "#4D000A8O")
            """##,
            diagnostics: [
                DiagnosticSpec(message: ##"hex 值包含非法字符: "O",仅允许 0-9 A-F a-f"##, line: 1, column: 1),
            ],
            macros: macros
        )
    }
}
