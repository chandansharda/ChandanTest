//
//  NetworkServiceTests.swift
//  ChandanTaskTests
//
//  Created by Chandan Sharda on 06/09/25.
//

import XCTest
@testable import ChandanTask

class MockURLProtocol: URLProtocol {
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?

    override class func canInit(with request: URLRequest) -> Bool {
        true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            client?.urlProtocol(self, didFailWithError: URLError(.badServerResponse))
            return
        }

        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {}
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

        } catch let error as NetworkError {
            // don’t double wrap if it's already our error
            throw error
        } catch {
            throw NetworkError.requestFailed(error)
        }
    }
}

struct MockResponse: Codable, Equatable {
    let id: Int
    let name: String
}

final class NetworkServiceTests: XCTestCase {
    var sut: NetworkService!
    var session: URLSession!

    override func setUp() {
        super.setUp()
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        session = URLSession(configuration: config)
        sut = NetworkService(baseURL: "https://mockapi.com", session: session)
    }

    override func tearDown() {
        sut = nil
        session = nil
        MockURLProtocol.requestHandler = nil
        super.tearDown()
    }

    func test_request_success_decodesResponse() async throws {
        let expected = MockResponse(id: 1, name: "Test")
        let data = try JSONEncoder().encode(expected)

        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, data)
        }

        let result: MockResponse = try await sut.request(endpoint: "/success", method: .get)
        XCTAssertEqual(result, expected)
    }

    func test_request_non200Status_throwsInvalidResponse() async {
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 500,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, Data())
        }

        do {
            let _: MockResponse = try await sut.request(endpoint: "/error")
            XCTFail("Expected invalidResponse error")
        } catch let error as NetworkError {
            switch error {
            case .invalidResponse:
                break // ✅ expected
            default:
                XCTFail("Unexpected NetworkError: \(error)")
            }
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func test_request_decodingError_throwsDecodingFailed() async {
        let invalidData = #"{"wrong_key":123}"#.data(using: .utf8)!

        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, invalidData)
        }

        do {
            let _: MockResponse = try await sut.request(endpoint: "/decode")
            XCTFail("Expected decodingFailed error")
        } catch let error as NetworkError {
            switch error {
            case .decodingFailed:
                break
            default:
                XCTFail("Unexpected NetworkError: \(error)")
            }
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func test_request_sessionError_throwsRequestFailed() async {
        let expectedError = URLError(.timedOut)

        MockURLProtocol.requestHandler = { _ in
            throw expectedError
        }

        do {
            let _: MockResponse = try await sut.request(endpoint: "/timeout")
            XCTFail("Expected requestFailed error")
        } catch let error as NetworkError {
            switch error {
            case .requestFailed(let underlying):
                XCTAssertEqual((underlying as? URLError)?.code, .timedOut)
            default:
                XCTFail("Unexpected NetworkError: \(error)")
            }
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}

