//
//  StringExtension.swift
//  CryptoSample
//
//  Created by SUNG HAO LIN on 2023/2/28.
//

import Foundation

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
}
