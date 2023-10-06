//
//  NetworkError.swift
//  Stocktopus
//
//  Created by Enes Buğra Yenidünya on 6.10.2023.
//

import Apollo

public enum NetworkError: Error {
    case invalidResponse
    case networkError(Error)
    case graphQLErrors([GraphQLError], String)
}
