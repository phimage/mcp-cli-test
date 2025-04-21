//
//  Process+Extensions.swift
//  mcp-passthrough
//
//  Created by Eric on 4/21/25. MIT
//
import Foundation
import Logging
import MCP
#if canImport(System)
	import System
#else
	@preconcurrency import SystemPackage
#endif

extension Process {

	func stdioTransport(logger: Logger? = nil) -> StdioTransport {
		let input = Pipe()
		let output = Pipe()
		self.standardInput = input
		self.standardOutput = output
		// XXX: maybe be std err too (option); some return some log "message"

		return StdioTransport(
			input: FileDescriptor(rawValue: output.fileHandleForReading.fileDescriptor),
			output: FileDescriptor(rawValue: input.fileHandleForWriting.fileDescriptor),
			logger: logger)
	}

}
