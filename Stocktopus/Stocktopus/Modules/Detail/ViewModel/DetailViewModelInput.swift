//
//  DetailViewModelInput.swift
//  Stocktopus
//
//  Created by Enes Buğra Yenidünya on 8.10.2023.
//

import API
import Combine
import DGCharts

protocol DetailViewModelInput {
    var stockDetailPublisher: AnyPublisher<StockDetailProvider, Never> { get }
    var chartDataPublisher: AnyPublisher<CandleChartData, Never> { get }
    
    func viewDidLoad()
    func fetchStockDetail(with ticker: String)
}
