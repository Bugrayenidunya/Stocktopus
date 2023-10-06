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
           self.apolloClient.fetch(query: query) { result in
                switch result {
                case .success(let graphQLResult):
                    guard let data = graphQLResult.data else {
                        
                        if let errors = graphQLResult.errors {
                            let error = NetworkError.graphQLErrors(errors, errors.generateErrorDescription())
                            promise(.failure(error))
                        } else {
                            promise(.failure(NetworkError.invalidResponse))
                        }
                        
                        return
                    }
                    
                    promise(.success(data))
                    
                case .failure(let error):
                    promise(.failure(NetworkError.networkError(error)))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
