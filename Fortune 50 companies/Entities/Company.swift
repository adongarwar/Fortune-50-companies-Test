//
//  Company.swift
//  Fortune 50 companies
//
//  Created by Avinash Dongarwar on 4/10/22.
//

import Foundation

struct Company: Decodable {
  let name: String
  let symbol: String
  let marketCap: MarketCap
}

struct MarketCap: Decodable {
  let fmt: String
  let longFmt: String
  let raw: Double
}
