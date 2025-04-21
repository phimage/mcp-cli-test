import ArgumentParser
import Foundation
import MCP
import Logging

#if canImport(System)
	import System
#else
	@preconcurrency import SystemPackage
#endif

enum  AppError: Swift.Error {
	case missingEnvParameter(String)
	case missingBinary(String)
}

@main
struct App: AsyncParsableCommand {

    @Flag(name: [.long], help: "display tools")
    var tools: Bool = false
    
    @Option(name: [.long], help: "external command to launch")
    var command: String?

    func run() async throws {
        let client = Client(name: "MyTestApp", version: "1.0.0")

		let exe: String = "/opt/homebrew/bin/npx"
		if !FileManager.default.fileExists(atPath: exe) {
			throw AppError.missingBinary(exe)
		}
	
        // If a command is specified, launch it and redirect I/O
		let process = Process()
		process.executableURL = URL(fileURLWithPath: exe)
		process.arguments = ["-y", "@modelcontextprotocol/server-github"]
	
		// copy current process environment
		var env = ProcessInfo.processInfo.environment
		if (env["GITHUB_PERSONAL_ACCESS_TOKEN"] == nil) {
			throw AppError.missingEnvParameter("GITHUB_PERSONAL_ACCESS_TOKEN")
		}
		
		let binDir = URL(fileURLWithPath: exe).deletingLastPathComponent().path
		if env["PATH"] == nil {
			env["PATH"] = binDir
		} else if !env["PATH"]!.contains(binDir) {
			env["PATH"] = binDir + ":" + env["PATH"]!
		}

		var logger = Logger(label: "com.example.app")
		logger.logLevel = .debug
		
		process.environment = env
		let transport = process.stdioTransport(logger: logger)

		try process.run()
		print("Process launched: \(exe)")
		try await client.connect(transport: transport)

		if (tools) {
			print("List tools:")
			let tools = try await client.listTools()
			for tool in tools {
				print("\(tool.name): \(tool.description)")
			}
		} else  {
			let result = try await client.initialize()
			print("\(result)")
		}
    }
}
