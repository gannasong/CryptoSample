//
//  CryptoEndpointTest.swift
//  CryptoSampleTests
//
//  Created by SUNG HAO LIN on 2023/2/26.
//

import XCTest

final class CryptoEndpointTest: XCTestCase {

    func test_crypto_endpointURL() {
        let baseURL = URL(string: "http://base-url.com")!

        let received = CryptoEndpoint.get(limit: 50).url(baseURL: baseURL)

        XCTAssertEqual(received.scheme, "http", "scheme")
        XCTAssertEqual(received.host, "base-url.com", "host")
        XCTAssertEqual(received.path, "/data/top/totaltoptiervolfull", "path")
        XCTAssertEqual(received.query?.contains("limit=50"), true, "limit param")
        XCTAssertEqual(received.query?.contains("tsym=USD"), true, "default to symbol param")
    }
}
