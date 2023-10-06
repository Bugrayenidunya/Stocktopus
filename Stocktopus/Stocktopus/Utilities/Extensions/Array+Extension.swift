//
//  Array+Extension.swift
//  Stocktopus
//
//  Created by Enes Buğra Yenidünya on 6.10.2023.
//

import Apollo

extension Array where Element == GraphQLError {
    /// Get single error description for given [GraphQLError]
    func generateErrorDescription() -> String {
        return self.map { $0.localizedDescription }.joined(separator: "\n")
    }
}
