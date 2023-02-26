//
//  Coin.swift
//  CryptoSample
//
//  Created by SUNG HAO LIN on 2023/2/24.
//

import Foundation

struct Coin {
    let name: String
    let symbol: String
    let price: Double
    let open24Hour: Double

    var subs: String {
        return "2~Binance~\(symbol)~USDT"
    }

    mutating func update(with new: NewCoinPrice) {
        if new.symbol == symbol {
            self = Coin(name: name,
                        symbol: symbol,
                        price: price,
                        open24Hour: open24Hour)
        }
    }
}

extension Coin: Equatable {}
