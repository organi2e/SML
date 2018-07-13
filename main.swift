//
//  main.swift
//  SML
//
//  Created by kotan.kn on 7/13/18.
//  Copyright © 2018 teamlab. All rights reserved.
//
import Cocoa
import os.log
let application: NSApplication = .shared
let info: ProcessInfo = .processInfo
let arguments: ArraySlice<String> = info.arguments.suffix(from: 1)
let launchPaths: ArraySlice<String> = arguments.prefix(1)
let launchArguments: ArraySlice<String> = arguments.suffix(from: 2)
let process: Process = Process()
process.launchPath = launchPaths.first
process.arguments = Array(launchArguments)
process.launch()
guard process.isRunning else {
	exit(1)
}
process.terminationHandler = { _ in
	application.terminate(nil)
}
withExtendedLifetime(NSWorkspace.shared.notificationCenter.addObserver(forName: NSWorkspace.willSleepNotification, object: nil, queue: .current) { _ in
	if process.isRunning {
		process.terminate()
	} else {
		application.terminate(nil)
	}
}, application.run)
