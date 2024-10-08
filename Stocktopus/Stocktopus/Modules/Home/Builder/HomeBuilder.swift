//
//  HomeBuilder.swift
//  Stocktopus
//
//  Created by Enes Buğra Yenidünya on 6.10.2023.
//

import Foundation

final class HomeBuilder {
    static func build() -> HomeController {
        let networManager = NetworkManager.shared
        let loadingManager = LoadingManager.shared
        var alertManager = AlertManager.shared
        
        let router = HomeRouter()
        let viewModel = HomeViewModel(router: router, networkManager: networManager, loadingManager: loadingManager, alertManager: alertManager)
        let controller = HomeController(viewModel: viewModel)
        
        alertManager.controller = controller
        router.viewController = controller
        
        return controller
    }
}
