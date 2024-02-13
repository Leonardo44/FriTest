//
//  MealServiceAPI.swift
//  FriTest
//
//  Created by Leo on 12/2/24.
//

import Foundation
import Combine

public protocol MealServiceAPII: AnyObject where NetError == NetworkError {
    associatedtype NetError
    associatedtype DataAPI
    var url: URLSession { get set }
    
    func fetchHome() -> AnyPublisher<DataAPI, NetError>
}

public class MealServiceAPI: MealServiceAPII {
    public typealias NetError = NetworkError
    public typealias DataAPI = HomeAPI
    public var url: URLSession
    
    init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 20
        
        url = URLSession(configuration: config)
    }
    
    public func fetchHome() -> AnyPublisher<DataAPI, NetworkError> {
        var request = URLRequest(url: URL(string: "https://www.themealdb.com/api/json/v1/1/random.php")!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        return url.dataTaskPublisher(for: request)
            .tryMap{ response -> Data in
                
                guard let httpResponse = response.response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw NetworkError.serverError
                }
                
                return response.data
            }
            .decode(type: HomeAPI.self, decoder: JSONDecoder())
            .mapError { _ in
                return .dataError
            }
            .eraseToAnyPublisher()
    }
}
