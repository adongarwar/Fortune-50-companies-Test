//
//  URLSession+Extensions.swift
//  Fortune 50 companies
//
//  Created by Avinash Dongarwar on 4/10/22.
//

import Foundation

extension URLSession {
	
	func fetchData(at url: URL, offlineFileName: String?,
				   completion: @escaping (Result<[Company], Error>) -> Void) {
	self.dataTask(with: url) { (data, response, error) in
	  if let error = error {
		completion(.failure(error))
	  }

	  if let data = data {
		do {
		  let companies = try JSONDecoder().decode([Company].self, from: data)	
		  if let offlineFileName = offlineFileName {
			data.save(toFile: offlineFileName)
		  }
		  completion(.success(companies))
		} catch let decoderError {
		  completion(.failure(decoderError))
		}
	  }
	}.resume()
  }
}
