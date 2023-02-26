//
//  CryptoEndpoint.swift
//  CryptoSample
//
//  Created by SUNG HAO LIN on 2023/2/26.
//

import Foundation

public enum CryptoEndpoint {
    case get(limit: UInt)

    public func url(baseURL: URL) -> URL {
        switch self {
            case let .get(limit):
                var components = URLComponents()
                components.scheme = baseURL.scheme
                components.host = baseURL.host
                components.path = baseURL.path + "/data/top/totaltoptiervolfull"
                components.queryItems = [
                    URLQueryItem(name: "limit", value: "\(limit)"),
                    URLQueryItem(name: "tsym", value: "USD")
                ].compactMap { $0 }
                return components.url!
        }
    }
}
