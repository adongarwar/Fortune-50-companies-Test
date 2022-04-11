//
//  CompanyTableViewCell.swift
//  Fortune 50 companies
//
//  Created by Avinash Dongarwar on 4/10/22.
//

import UIKit

protocol CompanyTableViewCellDelegate: AnyObject {
	func favoriteButtonTapped(symbol: String)
}

class CompanyTableViewCell: UITableViewCell {
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var favoriteButton: UIButton!
	weak var delegate: CompanyTableViewCellDelegate?
	private var company: Company?
	

	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}

	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)

		// Configure the view for the selected state
	}
	
	func configure(company: Company, isFavorite: Bool) {
		self.company = company
		nameLabel.text = company.name
		favoriteButton.setTitle(isFavorite ? Strings.unfavoriteTitle : Strings.favoriteTitle,
								for: .normal)
	}
	
	@IBAction func favoritetapped(sender: UIButton) {
		guard let symbol = company?.symbol else {
			return
		}
		delegate?.favoriteButtonTapped(symbol: symbol)
	}
	
	enum Strings {
		static let favoriteTitle = "Favorite".localized()
		static let unfavoriteTitle = "Unfavorite".localized()
	}
}

