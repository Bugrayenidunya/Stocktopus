//
//  Alert.swift
//  Stocktopus
//
//  Created by Enes Buğra Yenidünya on 7.10.2023.
//

import Foundation

extension Constant {
    class Alert {
        static let title = "Opps!"
        static let ok = "Ok"
        static func apiLimitErrorMessage(time: String) -> String { return "You exceeded your api call limit per minute. Please wait for \(time) seconds" }
    }
}
