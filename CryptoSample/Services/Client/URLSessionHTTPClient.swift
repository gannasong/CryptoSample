//
//  URLSessionHTTPClient.swift
//  CryptoSample
//
//  Created by SUNG HAO LIN on 2023/2/26.
//

import Foundation

class URLSessionHTTPClient: HTTPClient {
    private let session: URLSession
    private struct UnexpectedValuesRepresentation: Error {}

    private struct URLSessionTaskWrapper: HTTPClientTask {
        let wrapped: URLSessionTask

        func cancel() {
            wrapped.cancel()
        }
    }

    init(session: URLSession) {
        self.session = session
    }

    func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        let task = session.dataTask(with: url) { data, response, error in
            completion(Result {
                if let error = error {
                    throw error
                } else if let data = data, let response = response as? HTTPURLResponse {
                    return (data, response)
                } else {
                    throw UnexpectedValuesRepresentation()
                }
            })
        }

        task.resume()
        return URLSessionTaskWrapper(wrapped: task)
    }
}
