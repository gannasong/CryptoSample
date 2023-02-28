//
//  CryptoCell.swift
//  CryptoSample
//
//  Created by SUNG HAO LIN on 2023/2/28.
//

import UIKit
import Then
import SnapKit

class CryptoCell: UITableViewCell {
    static let reuseIdentifier = "CryptoCell"

    let coinSymbolLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .headline)
    }

    let coinNameLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .caption1)
        $0.textColor = .darkGray
    }

    let priceLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .headline)
    }

    let tickerLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .body)
        $0.textColor = .white
        $0.backgroundColor = .systemGray
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(coinSymbolLabel)
        contentView.addSubview(coinNameLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(tickerLabel)

        coinSymbolLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(4)
            $0.left.equalToSuperview().offset(16)
            $0.height.equalTo(29.5)
        }

        coinNameLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-4)
            $0.left.equalToSuperview().offset(16)
            $0.height.equalTo(29.5)
        }

        priceLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(4)
            $0.right.equalToSuperview().offset(-16)
            $0.height.equalTo(29.5)
        }

        tickerLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-4)
            $0.right.equalToSuperview().offset(-16)
            $0.height.equalTo(29.5)
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        coinSymbolLabel.text = ""
        coinNameLabel.text = ""
        priceLabel.text = ""
        tickerLabel.text = ""
        tickerLabel.backgroundColor = .systemGray
    }

    func configure(_ cellModel: CryptoItemCellModel) {
        coinSymbolLabel.text = cellModel.symbol
        coinNameLabel.text = cellModel.name
        priceLabel.text = cellModel.price
        tickerLabel.text = cellModel.ticker
        tickerLabel.backgroundColor = cellModel.bgColor
    }
}
