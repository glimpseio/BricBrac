//
//  Curio+Cocoa.swift
//  Bric-à-brac
//
//  Created by Marc Prud'hommeaux on 7/20/15.
//  Copyright © 2010-2020 io.glimpse. All rights reserved.
//

/// NOTE: do not import any BricBrac framework headers; curiotool needs to be compiled as one big lump of source with no external frameworks

#if canImport(Foundation)
import Foundation
import BricBrac

public extension Curio {
    /// Outputs a Swift file with the types for the given module. If the output text is the same as the destination
    /// file, then nothing will be output and the file will remain untouched, making this tool suitable to use
    /// as part of a build process (since it will not unnecessarily dirty a file).
    ///
    /// - Parameters:
    ///   - module: the module to output
    ///   - name: the rootname
    ///   - dir: the folder
    ///   - source: the schema source file (optional: to be included with `includeSchemaSourceVar`)
    /// - Returns: true if the schema was output successfully *and* it was different than any pre-existing file that is present
    func emit(_ module: CodeModule, name: String, dir: String, source: String? = nil) throws -> Bool {
        let locpath = (dir as NSString).appendingPathComponent(name)

        let emitter = CodeEmitter(stream: "")
        module.emit(emitter)

        var code = emitter.stream

        /// Embed the schema source string directly in the output file; the string can itself be parsed into a `JSONSchema` instance.
        if let includeSchemaSourceVar = includeSchemaSourceVar,
           let source = source {
            let parts = includeSchemaSourceVar.split(separator: ".")
            if parts.count == 2 {
                code += "\n\npublic extension \(parts[0]) {\n    /// The source of the JSON Schema for this type.\n    static let \(parts[1]): String = \"\"\"\n\(source)\n\"\"\"\n}\n"
            } else {
                code += "public var \(includeSchemaSourceVar) = \"\"\"\n\(source)\n\"\"\""
            }
        }
        let tmppath = (NSTemporaryDirectory() as NSString).appendingPathComponent(name)
        try code.write(toFile: tmppath, atomically: true, encoding: String.Encoding.utf8)

        let loccode: String
        do {
            loccode = try NSString(contentsOfFile: locpath, encoding: String.Encoding.utf8.rawValue) as String
        } catch {
            loccode = ""
        }

        if loccode == code {
            return false // contents are unchanged from local version; skip compiling
        }

        let bundle = Bundle(for: JSONParser.self).executablePath!
        let frameworkDir = ((bundle as NSString).deletingLastPathComponent as NSString).deletingLastPathComponent

        let args = [
            "/usr/bin/xcrun",
            "swiftc",
//            "-target", "macosx",
//            "-sdk", "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.13.sdk",
            "-F", frameworkDir,
            "-o", (tmppath as NSString).deletingPathExtension,
            tmppath,
        ]

        print(args.joined(separator: " "))

        let task = Process.launchedProcess(launchPath: args[0], arguments: Array(args.dropFirst()))
        task.waitUntilExit()
        let status = task.terminationStatus
        if status != 0 {
            throw CodegenErrors.compileError("Could not compile \(tmppath)")
        }

        if status == 0 {
            if loccode != code { // if the code has changed, then write it to the test
                if FileManager.default.fileExists(atPath: locpath) {
                    try! FileManager.default.trashItem(at: URL(fileURLWithPath: locpath), resultingItemURL: nil)
                }
                try code.write(toFile: locpath, atomically: true, encoding: String.Encoding.utf8)
            }
        }

        return true
    }
}
#endif

