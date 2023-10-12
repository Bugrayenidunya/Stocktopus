//
//  DetailViewModel.swift
//  Stocktopus
//
//  Created by Enes Buğra Yenidünya on 8.10.2023.
//

import API
import Combine
import DGCharts
import Foundation

final class DetailViewModel: DetailViewModelInput {
    
    // MARK: Properties
    private let loadingManager: Loading
    private let alertManager: AlertShowable
    private let networkManager: Networking
    private let ticker: String
    private var cancallables: [AnyCancellable] = []
    
    @Published private var stockDetailSubject = PassthroughSubject<StockDetailProvider, Never>()
    @Published private var chartDataSubject = PassthroughSubject<CandleChartData, Never>()
    
    var stockDetailPublisher: AnyPublisher<StockDetailProvider, Never> {
        stockDetailSubject.eraseToAnyPublisher()
    }
    
    var chartDataPublisher: AnyPublisher<CandleChartData, Never> {
        chartDataSubject.eraseToAnyPublisher()
    }
    
    // MARK: Init
    init(loadingManager: Loading, alertManager: AlertShowable, networkManager: Networking, ticker: String) {
        self.loadingManager = loadingManager
        self.alertManager = alertManager
        self.networkManager = networkManager
        self.ticker = ticker
    }
    
    func viewDidLoad() {
        fetchStockDetail(with: ticker)
    }
    
    func fetchStockDetail(with ticker: String) {
        loadingManager.show()
        
        let timespan = GraphQLNullable<String>(stringLiteral: "minute")
        let range = GraphQLNullable<Int>(integerLiteral: 15)
        let limit = GraphQLNullable<Int>(integerLiteral: 1000)
        let startDate = GraphQLNullable<String>(stringLiteral: Date().getLastBusinessDay())
        let endDate = GraphQLNullable<String>(stringLiteral: Date().getLastBusinessDay())
        
        networkManager.fetch(query: GetStockDetailForTickerQuery(ticker: ticker, timespan: timespan, range: range, startDate: startDate, endDate: endDate, limit: limit))
            .sink { [weak self] result in
                guard let self else { return }
                loadingManager.hide()
                
                switch result {
                case .finished:
                    break
                case .failure(let networkError):
                    self.alertManager.showAlert(with: networkError)
                    break
                }
            } receiveValue: { [weak self] response in
                guard let self else { return }
                
                guard let stockDetail = response?.stockDetail else { return }
                
                generateChartData(for: stockDetail)
                
                let stockDetailDTO = StockDetailDTO(with: stockDetail)
                self.stockDetailSubject.send(stockDetailDTO)
            }
            .store(in: &cancallables)
    }
    
    func generateChartData(for stockDetail: GetStockDetailForTickerQuery.Data.StockDetail) {
        guard let dataPoints = stockDetail.stockAggregates?.results else { return }
        
        var candleDataEntries: [CandleChartDataEntry] = []
        dataPoints.enumerated().forEach { index, dataPoint in
            
            guard
                let open = dataPoint?.o,
                let close = dataPoint?.c,
                let high = dataPoint?.h,
                let low = dataPoint?.l
            else {
                return
            }
            
            let entry = CandleChartDataEntry(x: Double(index), shadowH: high, shadowL: low, open: open, close: close)
            candleDataEntries.append(entry)
        }
        
        let dataSet = CandleChartDataSet(entries: candleDataEntries)
        dataSet.setStocktopusTheme()
        
        let data = CandleChartData(dataSet: dataSet)
        self.chartDataSubject.send(data)
    }
}
