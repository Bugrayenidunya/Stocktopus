//
//  HomeViewModel.swift
//  Stocktopus
//
//  Created by Enes Buğra Yenidünya on 6.10.2023.
//

import Foundation
import API
import Combine

// MARK: - HomeViewModel
final class HomeViewModel: HomeViewModelInput, ObservableObject {
    
    // MARK: Properties
    private let router: HomeRouing
    private let networkManager: Networking
    private let loadingManager: Loading
    private let alertManager: AlertShowable
    private var cancallables: [AnyCancellable] = []
    private(set) var stockList: [GetStocksByLimitQuery.Data.Stocks.Datum] = []
    private(set) var isFetching = false
    private(set) var hasMoreData = false
    private(set) var stocks: GetStocksByLimitQuery.Data.Stocks?
    @Published private(set) var sectionsSubject = CurrentValueSubject<[HomeSection], Never>([])
    
    var sectionsPublisher: AnyPublisher<[HomeSection], Never> {
        sectionsSubject.eraseToAnyPublisher()
    }
    
    weak var output: HomeViewModelOutput?
    
    // MARK: Init
    init(router: HomeRouing, networkManager: Networking, loadingManager: Loading, alertManager: AlertShowable) {
        self.router = router
        self.networkManager = networkManager
        self.loadingManager = loadingManager
        self.alertManager = alertManager
    }
    
    func viewDidLoad() {
        fetchStocks()
    }
    
    func loadMoreStocks() {
        guard hasMoreData, !isFetching else { return }
        fetchStocks(cursor: stocks?.cursor)
    }
    
    func fetchStocks(cursor: String? = nil) {
        setIsFetching(true)
        
        let query = GetStocksByLimitQuery(limit: GraphQLNullable(integerLiteral: Constant.API.fetchLimit) , cursor: GraphQLNullable(stringLiteral: cursor ?? .empty))
        
        networkManager.fetch(query: query)
            .sink { [weak self] result in
                guard let self else { return }
                setIsFetching(false)
                
                switch result {
                case .finished:
                    break
                case .failure(let networkError):
                    handleNetworkError(networkError)
                }
            } receiveValue: { [weak self] response in
                guard let self else { return }
                setIsFetching(false)
                
                guard let response = response, let stocks = response.stocks else {
                    self.restoreFetchState()
                    return
                }
                
                self.stocks = stocks
                hasMoreData = stocks.has_more
                handleResponseData(stocks.data)
            }
            .store(in: &cancallables)
    }
}

// MARK: - Helpers
private extension HomeViewModel {
    func setIsFetching(_ isFetching: Bool) {
        isFetching ? loadingManager.show() : loadingManager.hide()
        self.isFetching = isFetching
    }
    
    func handleResponseData(_ newData: [GetStocksByLimitQuery.Data.Stocks.Datum]) {
        self.stockList.append(contentsOf: newData)
        let section = self.generateSection(with: self.stockList)
        self.sectionsSubject.send([section])
    }
    
    func handleNetworkError(_ error: NetworkError) {
        self.alertManager.showAlert(with: error)
        self.restoreFetchState()
    }
    
    func generateSection(with stocks: [GetStocksByLimitQuery.Data.Stocks.Datum]) -> HomeSection {
        var items: [HomeCollectionViewCellDTO] = []
        
        stocks.forEach { stock in
            let homeCollectionViewCellDTO = HomeCollectionViewCellDTO(ticker: stock.ticker, companyName: stock.name)
            items.append(homeCollectionViewCellDTO)
        }
        
        return HomeSection(items: items)
    }
    
    func restoreFetchState() {
        hasMoreData = true
        isFetching = false
    }
}
