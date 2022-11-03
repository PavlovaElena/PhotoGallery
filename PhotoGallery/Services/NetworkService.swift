//
//  NetworkService.swift
//  PhotoGallery
//
//  Created by Elena Pavlova on 30.10.2022.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

class NetworkService {
    static let shared = NetworkService()
    private init() {}
    
    func fetchData(for searchTerm: String, completion: @escaping(Result<SearchResult, NetworkError>) -> Void) {
        let url = assembleURL(searchTerm: searchTerm)
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                completion(.failure(.noData))
                print(error?.localizedDescription ?? "no description")
                return
            }
            do {
                let result = try JSONDecoder().decode(SearchResult.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(result))
                }
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
    
    private func assembleURL(searchTerm: String) -> URLRequest {
        let parameters = prepareParameters(searchTerm: searchTerm)
        let url = prepareURL(parameters: parameters)
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = prepareHeader()
        request.httpMethod = "get"
        return request
    }
    
    private func prepareParameters(searchTerm: String) -> [String : String] {
        var parameters: [String : String] = [:]
        parameters["query"] = searchTerm
        parameters["page"] = String(1)
        parameters["per_page"] = String(30)
        return parameters
    }
    
    private func prepareURL(parameters: [String : String]) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.unsplash.com"
        components.path = "/search/photos"
        components.queryItems = parameters.map {URLQueryItem(name: $0, value: $1)}
        return components.url!
    }
    
    private func prepareHeader() -> [String : String] {
        var header: [String : String] = [:]
        header["Authorization"] = "Client-ID W1XsCNx6w5O2ci4DnNkUPHbO1tWpR78ve5rtuKSm3_A"
        return header
    }
}
