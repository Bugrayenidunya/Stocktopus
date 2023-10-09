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
    private let router: DetailRouting
    private let ticker: String
    private var cancallables: [AnyCancellable] = []
    @Published private(set) var stockDetailSubject = PassthroughSubject<StockDetailDTO, Never>()
    @Published private(set) var chartDataSubject = PassthroughSubject<CandleChartData, Never>()
    
    var stockDetailPublisher: AnyPublisher<StockDetailDTO, Never> {
        stockDetailSubject.eraseToAnyPublisher()
    }
    
    var chartDataPublisher: AnyPublisher<CandleChartData, Never> {
        chartDataSubject.eraseToAnyPublisher()
    }
    
    weak var output: DetailViewModelOutput?
    
    // MARK: Init
    init(loadingManager: Loading, alertManager: AlertShowable, networkManager: Networking, router: DetailRouting, ticker: String) {
        self.loadingManager = loadingManager
        self.alertManager = alertManager
        self.networkManager = networkManager
        self.router = router
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
        if let dataPoints = stockDetail.stockAggregates?.results {
            var candleDataEntries: [CandleChartDataEntry] = []

            for (index, dataPoint) in dataPoints.enumerated() {
                guard let dataPoint else { return }
            
                if let open = dataPoint.o, let close = dataPoint.c,  let high = dataPoint.h, let low = dataPoint.l {
                    let entry = CandleChartDataEntry(x: Double(index), shadowH: high, shadowL: low, open: open, close: close)
                    candleDataEntries.append(entry)
                }
            }

            let set1 = CandleChartDataSet(entries: candleDataEntries)
            set1.axisDependency = .left
            set1.drawIconsEnabled = false
            set1.shadowColor = .darkGray
            set1.shadowWidth = 0.7
            set1.decreasingColor = .red
            set1.decreasingFilled = true
            set1.increasingColor = .green
            set1.increasingFilled = true
            set1.neutralColor = .blue

            let data = CandleChartData(dataSet: set1)
            self.chartDataSubject.send(data)
        }
    }
}
