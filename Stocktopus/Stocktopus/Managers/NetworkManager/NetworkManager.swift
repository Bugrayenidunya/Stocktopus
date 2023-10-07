//
//  NetworkManager.swift
//  Stocktopus
//
//  Created by Enes Buğra Yenidünya on 6.10.2023.
//

import Apollo
import ApolloAPI
import Combine
import Foundation.NSURL

// MARK: - Networking
protocol Networking {
    func fetch<T: GraphQLQuery>(query: T) -> AnyPublisher<T.Data?, NetworkError>
}

// MARK: - NetworkManager
final class NetworkManager: Networking {
    
    // MARK: Properties
    static let shared: Networking = NetworkManager.init()
    
    private lazy var apolloClient = ApolloClient(url: URL(string: Constant.API.baseUrl)!)
    
    // MARK: Init
    private init() { }
    
    // MARK: Functions
    func fetch<T: GraphQLQuery>(query: T) -> AnyPublisher<T.Data?, NetworkError> {
        Future<T.Data?, NetworkError> { promise in
            self.apolloClient.fetch(query: query, cachePolicy: .returnCacheDataAndFetch) { result in
                switch result {
                case .success(let graphQLResult):
                    guard graphQLResult.errors == nil else {
                        let error = self.parse(errors: graphQLResult.errors!)
                        promise(.failure(error))
                        return
                    }
                    
                    if let data = graphQLResult.data {
                        promise(.success(data))
                    }
                case .failure(let error):
                    promise(.failure(NetworkError.networkError(error)))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

// MARK: - Helpers
private extension NetworkManager {
    func parse(errors: [GraphQLError]) -> NetworkError {
        if let response = errors.first?.extensions?["response"] as? [String: Any], let errorCode = response["status"] as? Int, errorCode == 429 {
            return NetworkError.apiCallLimitExceeded
        }
        
        return NetworkError.graphQLErrors(errors, errors.generateErrorDescription())
    }
}
