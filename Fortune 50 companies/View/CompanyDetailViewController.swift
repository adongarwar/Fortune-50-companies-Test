//
//  CompanyDetailViewController.swift
//  Fortune 50 companies
//
//  Created by Avinash Dongarwar on 4/11/22.
//

import Foundation
import UIKit

class CompanyDetailViewController: UIViewController {
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var symbolLabel: UILabel!
	@IBOutlet weak var rankLabel: UILabel!
	var company: Company?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		if let company = company {
			title = company.name
			nameLabel.text = "\(Strings.nameTitle) \(company.name)"
			symbolLabel.text = "\(Strings.nameTitle) \(company.symbol)"
			rankLabel.text = "\(Strings.rankTitle) \(company.marketCap.fmt)"
		}
	}
	
	enum Strings {
		static let nameTitle = "Name:".localized()
		static let symbolTitle = "Symbol:".localized()
		static let rankTitle = "Rank:".localized()
	}
}
