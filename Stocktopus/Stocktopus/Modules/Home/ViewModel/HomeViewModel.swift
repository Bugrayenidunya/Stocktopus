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
    private var cancallables: [AnyCancellable] = []
    private(set) var stocks: [GetStocksByLimitQuery.Data.Stocks.Datum] = []
    
    @Published private(set) var sectionsSubject = CurrentValueSubject<[HomeSection], Never>([])
    var sectionsPublisher: AnyPublisher<[HomeSection], Never> {
        sectionsSubject.eraseToAnyPublisher()
    }
    
    weak var output: HomeViewModelOutput?
    
    // MARK: Init
    init(router: HomeRouing, networkManager: Networking) {
        self.router = router
        self.networkManager = networkManager
        
        // Initial fetch
        fetchStocks(by: 25)
    }
    
    func fetchStocks(by limit: Int, cursor: String? = nil) {
        let query = GetStocksByLimitQuery(limit: GraphQLNullable<Int>(integerLiteral: limit), cursor: GraphQLNullable<String>(stringLiteral: cursor ?? .empty))
        
        networkManager.fetch(query: query)
            .sink { result in
                switch result {
                case .finished:
                    break
                case .failure(let networkError):
                    switch networkError {
                    case .invalidResponse:
                        print("")
                    case .graphQLErrors(_, _):
                        // TODO: Handle error handling here
                        print("")
                    case .networkError(_):
                        // TODO: Handle error handling here
                        print("")
                    }
                }
            } receiveValue: { response in
                guard let response else { return }
                
                self.stocks = response.stocks?.data ?? []
                let section = self.generateSection(with: self.stocks)
                self.sectionsSubject.send([section])
            }
            .store(in: &cancallables)
    }
}

// MARK: - Helpers
private extension HomeViewModel {
    func generateSection(with stocks: [GetStocksByLimitQuery.Data.Stocks.Datum]) -> HomeSection {
        var items: [HomeCollectionViewCellDTO] = []
        
        self.stocks.forEach { stock in
            let homeCollectionViewCellDTO = HomeCollectionViewCellDTO(ticker: stock.ticker, companyName: stock.name)
            items.append(homeCollectionViewCellDTO)
        }
        
        return HomeSection(items: items)
    }
}
