//
//  StockDetailProvider.swift
//  Stocktopus
//
//  Created by Enes Buğra Yenidünya on 10.10.2023.
//

import UIKit

protocol StockDetailProvider {
    var ticker: String { get }
    var name: String { get }
    var logoUrl: String { get }
    var price: String { get }
    var currencyName: String { get }
    var changeRate: String { get }
    var description: String { get }
    var address: String { get }
    var openPrice: Double { get }
    var closePrice: Double { get }
    var rate: Double { get }
    var changeRateTextColor: UIColor { get }
    var imageURL: URL? { get }
}
