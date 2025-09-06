//
//  NetworkService.swift
//  ChandanTask
//
//  Created by Chandan Sharda on 03/09/25.
//

import Foundation

// MARK: - HTTP Methods
enum HTTPMethod: String {
    case get     = "GET"
    case post    = "POST"
    case put     = "PUT"
    case delete  = "DELETE"
    case patch   = "PATCH"
}

// MARK: - Errors
enum NetworkError: Error, Equatable {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case statusCode(Int)
    case decodingFailed(Error)

    static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL),
             (.invalidResponse, .invalidResponse):
            return true
        case (.statusCode(let a), .statusCode(let b)):
            return a == b
        case (.requestFailed, .requestFailed),
             (.decodingFailed, .decodingFailed):
            return true
        default:
            return false
        }
    }
}


// MARK: - Protocol
protocol NetworkServicing {
    func request<T: Decodable>(
        endpoint: String,
        method: HTTPMethod,
        body: Data?
    ) async throws -> T
}

final class NetworkService: NetworkServicing {

    private let session: URLSession
    private let baseURL: String
    private let decoder: JSONDecoder

    init(baseURL: String, session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        self.decoder = decoder
    }

    func request<T: Decodable>(
        endpoint: String,
        method: HTTPMethod = .get,
        body: Data? = nil
    ) async throws -> T {
        guard let url = URL(string: baseURL + endpoint) else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let (data, response) = try await session.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode) else {
                throw NetworkError.invalidResponse
            }

            do {
                return try decoder.decode(T.self, from: data)
            } catch {
                throw NetworkError.decodingFailed(error)
            }

        } catch {
            throw NetworkError.requestFailed(error)
        }
    }
}

