//
//  CryptoMapper.swift
//  CryptoSample
//
//  Created by SUNG HAO LIN on 2023/2/25.
//

import Foundation

enum CryptoMapper {
    private static var statusCode200: Int { return 200 }

    static func map(data: Data, response: HTTPURLResponse) -> CryptoService.Result {
        guard response.statusCode == statusCode200,
              let data = try? JSONDecoder().decode(CoinRootResponse.self, from: data) else {
            return .failure(CryptoServiceAPI.Error.invalidData)
        }

        return .success(data.coins)
    }

    private struct CoinRootResponse: Decodable {
        let data: [CoinResponse]

        enum CodingKeys: String, CodingKey {
            case data = "Data"
        }

        var coins: [Coin] {
            data.map(\.coin)
        }
    }

    private struct CoinResponse: Codable {
        let coinInfo: CoinInfo
        let raw: Raw?

        enum CodingKeys : String, CodingKey {
            case coinInfo = "CoinInfo"
            case raw = "RAW"
        }

        var coin: Coin {
            return Coin(name: coinInfo.fullName,
                        symbol: coinInfo.name,
                        price: raw?.usd.price ?? 0,
                        open24Hour: raw?.usd.open24Hour ?? 0)
        }
    }

    struct CoinInfo: Codable {
        let name: String
        let fullName: String

        private enum CodingKeys : String, CodingKey {
            case name = "Name"
            case fullName = "FullName"
        }
    }

    struct Raw: Codable{
        let usd: USD

        private enum CodingKeys: String, CodingKey {
            case usd = "USD"
        }
    }

    struct USD: Codable {
        let price: Double
        let open24Hour: Double

        private enum CodingKeys: String, CodingKey {
            case price = "PRICE"
            case open24Hour = "OPEN24HOUR"
        }
    }
}
