//
//  DictionaryExtension.swift
//  CryptoSample
//
//  Created by SUNG HAO LIN on 2023/2/28.
//

import Foundation

extension Dictionary {
    var jsonData: Data? {
        return try? JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted])
    }

    func toJSONString() -> String? {
        if let jsonData = jsonData {
            return String(data: jsonData, encoding: .utf8)
        }

        return nil
    }
}

