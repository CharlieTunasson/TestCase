//
//  NetworkService.swift
//  QapitalTestCase
//
//  Created by Charlie Tuna on 2021-03-18.
//

import Foundation

final class NetworkService {

    enum NetworkError: Error {
        case invalidUrl
        case invalidBody
        case noData
        case unauthorized
        case badRequest
        case unknownStatuscode(statusCode: Int)
        case noResponse
        case error(_ error: Error)
    }

    enum HTTPMethod: String {
        case get = "GET"
    }

    private let defaultHeaders = ["Content-Type":"application/json"]

    func dispatchRequest(urlString: String,
                         method: HTTPMethod = .get,
                         additionalHeaders: [String: String]? = nil,
                         body: (Any & Encodable)? = nil,
                         completion: @escaping (Result<Data, NetworkError>) -> Void) {

        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidUrl))
            return
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = defaultHeaders.merged(with: additionalHeaders ?? [:])

        if let body = body {
            if let data = body.toJSONData() {
                urlRequest.httpBody = data
            } else {
                completion(.failure(.invalidBody))
                return
            }
        }

        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                completion(.failure(.error(error)))
                return
            }

            guard let data = data else {
                completion(.failure(.noData))
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200...209:
                    completion(.success(data))
                    return
                case 400...499:
                    completion(.failure(.unauthorized))
                    return
                case 500...599:
                    completion(.failure(.badRequest))
                    return
                default:
                    completion(.failure(.unknownStatuscode(statusCode: httpResponse.statusCode)))
                    return
                }
            } else {
                completion(.failure(.noResponse))
                return
            }
        }.resume()
    }
}

// MARK: - Convinience

private extension Encodable {
    func toJSONData() -> Data? {
        return try? JSONEncoder().encode(self)
    }
}

private extension Dictionary {
    mutating func merge(with dictionary: Dictionary) {
        dictionary.forEach { updateValue($1, forKey: $0) }
    }

    func merged(with dictionary: Dictionary) -> Dictionary {
        var dict = self
        dict.merge(with: dictionary)
        return dict
    }
}

