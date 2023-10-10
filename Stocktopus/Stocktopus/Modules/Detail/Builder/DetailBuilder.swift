//
//  DetailBuilder.swift
//  Stocktopus
//
//  Created by Enes Buğra Yenidünya on 8.10.2023.
//

import Foundation

final class DetailBuilder {
    static func build(with ticker: String) -> DetailController {
        let loadingManager = LoadingManager.shared
        let alertManager = AlertManager.shared
        let networkManager = NetworkManager.shared
        
        let viewModel = DetailViewModel(loadingManager: loadingManager, alertManager: alertManager, networkManager: networkManager, ticker: ticker)
        let controller = DetailController(viewModel: viewModel)
        
        alertManager.controller = controller
        
        return controller
    }
}
