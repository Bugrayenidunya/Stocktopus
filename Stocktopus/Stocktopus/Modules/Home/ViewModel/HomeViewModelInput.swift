//
//  HomeViewModelInput.swift
//  Stocktopus
//
//  Created by Enes Buğra Yenidünya on 7.10.2023.
//

import API
import Combine

protocol HomeViewModelInput {
    var sectionsPublisher: AnyPublisher<[HomeSection], Never> { get }
    var stockList: [GetStocksByLimitQuery.Data.Stocks.Datum] { get }
    var hasMoreData: Bool { get }
    var isFetching: Bool { get }
    
    func viewDidLoad()
    func fetchStocks(cursor: String?)
    func loadMoreStocks()
    func didSelectItem(at index: Int)
}
