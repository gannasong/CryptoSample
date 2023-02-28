//
//  SceneDelegate.swift
//  CryptoSample
//
//  Created by SUNG HAO LIN on 2023/2/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private lazy var navigationController = UINavigationController()
    private lazy var baseURL = URL(string: "https://min-api.cryptocompare.com")!

    private lazy var httpClient: HTTPClient = {
        URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        configureWindow()
    }

    func configureWindow() {
        window?.rootViewController = navigationController
        navigationController.viewControllers = [makeCryptoListViewController()]
        window?.makeKeyAndVisible()
    }

    func makeCryptoListViewController() -> CryptoListViewController {
        let viewModel = CryptoListViewModel(
            service: MainQueueDispatchDecorator(
                decoratee: CryptoServiceAPI(
                    url: CryptoEndpoint.get(limit: 50).url(baseURL: baseURL),
                    client: httpClient
                )
            )
        )
        
        let vc = CryptoListViewController(viewModel: viewModel)

        let url = URL(string: "wss://streamer.cryptocompare.com/v2?api_key=1a18e49a89e03622d1875d5a12118a36d875988c1f8596a337a20c84a5f083ad")!
        let tracker = CoinWebSocketTracker(url: url, queue: .main)
        vc.viewIsReady = tracker.connect
        viewModel.add(coinsObserver: tracker.track)
        tracker.didReceiveNewCoinPrice = { [weak vc] newPrice in
            vc?.didReceive(newCoinPrice: newPrice)
        }

        return vc
    }
}
