//
//  CryptoService.swift
//  CryptoSample
//
//  Created by SUNG HAO LIN on 2023/2/24.
//

import Foundation

protocol CryptoService {
    typealias Result = Swift.Result<[Coin], Error>

    func load(completion: @escaping (Result) -> Void)
}

final class CryptoServiceAPI: CryptoService {
    typealias Result = CryptoService.Result

    private let url: URL
    private let client: HTTPClient

    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }

    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }

    func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { [weak self] result in
            guard self != nil else { return }
            switch result {
                case let .success((data, response)):
                    completion(CryptoMapper.map(data: data, response: response))
                case .failure:
                    completion(.failure(Error.connectivity))
            }
        }
    }
}
