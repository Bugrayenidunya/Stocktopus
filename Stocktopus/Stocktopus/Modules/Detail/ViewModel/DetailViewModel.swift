//
//  DetailViewModel.swift
//  Stocktopus
//
//  Created by Enes Buğra Yenidünya on 8.10.2023.
//

import Foundation

final class DetailViewModel: DetailViewModelInput {
    
    // MARK: Properties
    private let loadingManager: Loading
    private let alertManager: AlertShowable
    private let networkManager: Networking
    private let router: DetailRouting
    private let ticker: String
    
    weak var output: DetailViewModelOutput?
    
    // MARK: Init
    init(loadingManager: Loading, alertManager: AlertShowable, networkManager: Networking, router: DetailRouting, ticker: String) {
        self.loadingManager = loadingManager
        self.alertManager = alertManager
        self.networkManager = networkManager
        self.router = router
        self.ticker = ticker
    }
}
