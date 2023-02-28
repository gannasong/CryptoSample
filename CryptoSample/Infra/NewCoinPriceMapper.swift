//
//  NewCoinPriceMapper.swift
//  CryptoSample
//
//  Created by SUNG HAO LIN on 2023/2/28.
//

import Foundation

enum NewCoinPriceMapper {
    private struct Response: Decodable {
        let PRICE: Double
        let FROMSYMBOL: String
    }

    static func map(_ data: Data) throws -> NewCoinPrice? {
        let response = try JSONDecoder().decode(Response.self, from:  data)
        return NewCoinPrice(price: response.PRICE, symbol: response.FROMSYMBOL)
    }
}
