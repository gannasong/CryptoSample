//
//  CryptoItemCellModel.swift
//  CryptoSample
//
//  Created by SUNG HAO LIN on 2023/2/28.
//

import UIKit

struct CryptoItemCellModel {
    let name: String
    let symbol: String
    let price: String
    let ticker: String
    let bgColor: UIColor


    init(coin: Coin, livePrice: Double){
        let currentPrice = coin.open24Hour
        let diffPrice: Double = livePrice - currentPrice
        let percentage = (diffPrice/livePrice)
        
        name = coin.name
        symbol = coin.symbol
        price = "\(livePrice.currencyFormat)"
        print("🟠 price: ", price)
        ticker = "\(diffPrice.diffFomat)(\(percentage.percentageFormat))"
        bgColor = diffPrice.sign == .minus ? .systemRed : .systemGreen
    }
}
