//
//  Data+Extensions.swift
//  Fortune 50 companies
//
//  Created by Avinash Dongarwar on 4/11/22.
//

import Foundation

extension Data {
	func save(toFile: String) {
		if let documentDirectory = FileManager.default.urls(for: .documentDirectory,
															 in: .userDomainMask).first {
			let pathWithFileName = documentDirectory.appendingPathComponent(toFile)
			do {
				try self.write(to: pathWithFileName)
			} catch {
				print("Local Save failed")
			}
		}
	}
}
