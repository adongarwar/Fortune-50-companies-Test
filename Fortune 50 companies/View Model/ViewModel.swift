//
//  ViewModel.swift
//  Fortune 50 companies
//
//  Created by Avinash Dongarwar on 4/10/22.
//

import Foundation
import Network

protocol ViewActionDelegate: AnyObject {
	// Define expected delegate blocks
	var errorHandler: ((Error) -> Void)? { get set }

	// Define expected delegate functions
	func dataRefreshed(companies: [Company])
}

class ViewModel {
	fileprivate let fileName = "companiesJsonData"
	fileprivate let favoritesFileName = "/tmp/foo.plist"
	
	weak var delegate: ViewActionDelegate?
	private var favorites = [String]()
	private let monitor = NWPathMonitor()
	
	
	func fetchCompanies() {
		let urlString = "https://us-central1-fbconfig-90755.cloudfunctions.net/getAllCompanies"
		let url = URL(string: urlString)!
		
		URLSession.shared.fetchData(at: url, offlineFileName: fileName) { [weak self] result in
		guard let strongself = self else { return }
		  switch result {
		  case .success(let result):
			DispatchQueue.main.async {
				strongself.delegate?.dataRefreshed(companies: result)
			}
			  
		  case .failure(let error):
			// Check internet connection
			strongself.monitor.pathUpdateHandler = { pathUpdateHandler in
				if pathUpdateHandler.status != .satisfied {
					strongself.readOfflineFile()
				} else {
					// An error, let's handle it
					strongself.delegate?.errorHandler?(error)
				}
			}
		  }
		}
	}
	
	func markFavorite(symbol: String) {
		if let index = favorites.firstIndex(of: symbol) {
			favorites.remove(at: index)
		} else {
			favorites.append(symbol)
		}
		saveFavoritesToDisk()
	}
	
	func isFavorite(symbol: String) -> Bool {
		if favorites.isEmpty {
			loadFavoritesFromDisk()
		}
		return favorites.contains(symbol)
	}
		
	private func readOfflineFile() {
		let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
		let path = paths.appendingPathComponent(fileName)
		if FileManager.default.fileExists(atPath: path) {
			do {
			  let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
			  let results = try JSONDecoder().decode([Company].self, from: data)
			  delegate?.dataRefreshed(companies: results)
			} catch let decoderError {
				delegate?.errorHandler?(decoderError)
			}
		}
	}
	
	private func saveFavoritesToDisk() {
		let fileUrl = URL(fileURLWithPath: favoritesFileName)
		(favorites as NSArray).write(to: fileUrl, atomically: true)
	}
	
	private func loadFavoritesFromDisk() {
		let fileUrl = URL(fileURLWithPath: favoritesFileName)
		if let contentsFromFile = NSArray(contentsOf: fileUrl) {
			favorites = contentsFromFile as! [String]
		}
	}
}
