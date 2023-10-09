//
//  StockDetailDTO.swift
//  Stocktopus
//
//  Created by Enes Buğra Yenidünya on 9.10.2023.
//

import API
import UIKit

struct StockDetailDTO {
    let ticker: String
    let name: String
    let logoUrl: String
    let price: String
    let currencyName: String
    let changeRate: String
    let description: String
    let address: String
    let openPrice: Double
    let closePrice: Double
    
    var rate: Double {
        ((closePrice - openPrice) / openPrice) * 100
    }
    
    var changeRateTextColor: UIColor {
        return rate > .zero ? .green : .red
    }
    
    var imageURL: URL? {
        URL(string: "\(logoUrl)?apiKey=\(Constant.API.polygonApiKey)")
    }
}

extension StockDetailDTO {
    init(with stockDetail: GetStockDetailForTickerQuery.Data.StockDetail) {
        self.ticker = stockDetail.ticker
        self.description = stockDetail.description ?? .empty
        self.address = stockDetail.address?.address1 ?? Constant.Message.noInfoData
        self.currencyName = stockDetail.currency_name ?? Constant.Message.noAddressData
        self.name = stockDetail.name
        self.logoUrl = stockDetail.branding?.logo_url ?? .empty
        self.openPrice = stockDetail.stockAggregates?.results?.last??.c ?? .zero
        self.closePrice = stockDetail.stockAggregates?.results?.first??.o ?? .zero
        self.price = String(closePrice)
        
        let rate = ((closePrice - openPrice) / openPrice) * 100
        self.changeRate = "\(String(format: "%.2f", rate))%"
    }
}
