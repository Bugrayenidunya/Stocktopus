//
//  HomeViewModelInput.swift
//  Stocktopus
//
//  Created by Enes Buğra Yenidünya on 7.10.2023.
//

import API
import Combine

protocol HomeViewModelInput {
    var output: HomeViewModelOutput? { get set }
    var sectionsSubject: CurrentValueSubject<[HomeSection], Never> { get }
    var stocks: [GetStocksByLimitQuery.Data.Stocks.Datum] { get }
    
    func fetchStocks(by limit: Int, cursor: String?)
}
