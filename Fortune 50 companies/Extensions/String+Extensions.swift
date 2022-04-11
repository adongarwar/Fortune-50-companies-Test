//
//  String+Extensions.swift
//  Fortune 50 companies
//
//  Created by Avinash Dongarwar on 4/10/22.
//

import Foundation
extension String {
	func localized(withComment comment: String? = nil) -> String {
		return NSLocalizedString(self, comment: comment ?? "")
	}

}
