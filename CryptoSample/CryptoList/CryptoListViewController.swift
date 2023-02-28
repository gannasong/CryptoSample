//
//  CryptoListViewController.swift
//  CryptoSample
//
//  Created by SUNG HAO LIN on 2023/2/26.
//

import UIKit

class CryptoListViewController: UITableViewController {
    private var coins: [Coin] = []
    private let viewModel: CryptoListViewModel
    var viewIsReady: () -> Void = {}

    init(viewModel: CryptoListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "CryptoList"
        tableView.register(CryptoCell.self, forCellReuseIdentifier: CryptoCell.reuseIdentifier)
        tableView.rowHeight = 70

        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh(_ :)), for: .valueChanged)

        viewIsReady()

        viewModel.onCoinsLoading = { [weak self] isLoading in
            if isLoading {
                self?.refreshControl?.beginRefreshing()
            } else {
                self?.refreshControl?.endRefreshing()
            }
        }

        viewModel.add { [weak self] coins in
            self?.coins = coins
            self?.tableView.reloadData()
        }

        viewModel.onCoinsError = { [weak self] error in
            self?.handle(error) {
                self?.viewModel.fetchCoins()
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetchCoins()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coins.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CryptoCell.reuseIdentifier) as! CryptoCell
        let coin = coins[indexPath.row]
        let cellModel = CryptoItemCellModel(coin: coin, livePrice: coin.price)
        cell.configure(cellModel)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRowAt: ", indexPath.row)
    }

    @objc private func refresh(_ sender: Any) {
        viewModel.fetchCoins()
    }

    func didReceive(newCoinPrice: NewCoinPrice) {
        print("🟠 newCoinPrice: ", newCoinPrice)
        coins.forEach { print("> 🟠: \($0)") }
        if let row: Int = coins.firstIndex(where: { $0.symbol == newCoinPrice.symbol }) {
            print("> 🟠row: \(row)")
            let indexPath = IndexPath(row: row, section: 0)
            coins[row].update(with: newCoinPrice)
            print("> 🟠newCoinPrice2: \(newCoinPrice)")
            coins.forEach { print("> 🟠2: \($0)") }
            let cell = self.tableView.cellForRow(at: indexPath) as? CryptoCell
            let cellModel = CryptoItemCellModel(coin: coins[row], livePrice: newCoinPrice.price)
            print("🟠 cellModel: ", cellModel)
            cell?.configure(cellModel)
        }
    }
}
