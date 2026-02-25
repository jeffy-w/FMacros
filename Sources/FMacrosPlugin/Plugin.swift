import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct FMacrosPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        HexColorMacro.self,
    ]
}
