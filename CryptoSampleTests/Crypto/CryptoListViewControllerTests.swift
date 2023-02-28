//
//  CryptoListViewControllerTests.swift
//  CryptoSampleTests
//
//  Created by SUNG HAO LIN on 2023/2/28.
//

import XCTest

final class CryptoListViewControllerTests: XCTestCase {

    func test_viewDidLoad_setsTitle() {
        let sut = makeSUT(viewModel: makeViewModel())

        sut.loadViewIfNeeded()

        XCTAssertEqual(sut.title, "CryptoList")
    }

    func test_viewDidLoad_initialState() {
        let sut = makeSUT(viewModel: makeViewModel())

        sut.loadViewIfNeeded()

        XCTAssertEqual(sut.numberOfCoin(), 0)
    }

    func test_viewDidLoad_doesNotLoadCryptoFromAPI() {
        let service = CryptoServiceSpy()
        let viewModel = makeViewModel(service: service)
        let sut = makeSUT(viewModel: viewModel)

        sut.loadViewIfNeeded()

        XCTAssertEqual(service.loadCryptoCount, 0)
    }

    func test_viewWillAppear_loadCoinsFromAPI() {
        let service = CryptoServiceSpy()
        let viewModel = makeViewModel(service: service)
        let sut = makeSUT(viewModel: viewModel)

        sut.loadViewIfNeeded()
        sut.beginAppearanceTransition(true, animated: false)

        XCTAssertEqual(service.loadCryptoCount, 1)
    }

//    func test_viewDidLoad_rendersCoins() {
//        let service = CryptoServiceSpy([makeCoin(name: "Bitcoin", symbol: "BTC", price: 100)])
//        let viewModel = makeViewModel(service: service)
//        let sut = makeSUT(viewModel: viewModel)
//
//        sut.loadViewIfNeeded()
//        sut.beginAppearanceTransition(true, animated: false)
//
//        XCTAssertEqual(sut.numberOfCoin(), 1)
//        XCTAssertEqual(sut.name(atRow: 0), "Bitcoin")
//        XCTAssertEqual(sut.symbol(atRow: 0), "BTC")
//        XCTAssertEqual(sut.price(atRow: 0), "$100.00")
//    }

    func test_coinUpdated_updateCoinCell() {
        let service = CryptoServiceSpy([makeCoin(name: "Bitcoin", symbol: "BTC", price: 100)])
        let viewModel = makeViewModel(service: service)
        let sut = makeSUT(viewModel: viewModel)

        sut.loadViewIfNeeded()
        sut.beginAppearanceTransition(true, animated: false)

        sut.didReceive(newCoinPrice: NewCoinPrice(price: 123, symbol: "BTC"))

        XCTAssertEqual(sut.numberOfCoin(), 1)
        XCTAssertEqual(sut.name(atRow: 0), "Bitcoin")
        XCTAssertEqual(sut.symbol(atRow: 0), "BTC")
        XCTAssertEqual(sut.price(atRow: 0), "$120.00")
    }

    // MARK: - Helpers

    private func makeSUT(viewModel: CryptoListViewModel) -> CryptoListViewController {
        let sut = CryptoListViewController(viewModel: viewModel)
        return sut
    }

    private func makeViewModel(service: CryptoServiceSpy = .init()) -> CryptoListViewModel {
        let viewModel = CryptoListViewModel(service: service)
        return viewModel
    }
}

private extension CryptoListViewController {
    private var coinSection: Int { 0 }

    func numberOfCoin() -> Int {
        tableView.numberOfRows(inSection: coinSection)
    }

    func name(atRow row: Int) -> String? {
        cryptoCell(atRow: row)?.coinNameLabel.text
    }

    func symbol(atRow row: Int) -> String? {
        cryptoCell(atRow: row)?.coinSymbolLabel.text
    }

    func price(atRow row: Int) -> String? {
        cryptoCell(atRow: row)?.priceLabel.text
    }

    func cryptoCell(atRow row: Int) -> CryptoCell? {
        let ds = tableView.dataSource
        let indexPath = IndexPath(row: row, section: coinSection)
        return ds?.tableView(tableView, cellForRowAt: indexPath) as? CryptoCell
    }
}

private func makeCoin(name: String, symbol: String, price: Double) -> Coin {
    return Coin(name: name, symbol: symbol, price: price, open24Hour: 0)
}

struct AnyError: LocalizedError {
    var errorDescription: String?
}

class CryptoServiceSpy: CryptoService {
    private(set) var loadCryptoCount = 0
    private let result: Result<[Coin], Error>

    init(_ result: [Coin] = []) {
        self.result = .success(result)
    }

    init(_ result: Error) {
        self.result = .failure(result)
    }

    func load(completion: @escaping (Result<[Coin], Error>) -> Void) {
        loadCryptoCount += 1
        completion(result)
    }
}
