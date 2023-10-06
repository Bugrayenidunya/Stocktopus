//
//  HomeBuilder.swift
//  Stocktopus
//
//  Created by Enes Buğra Yenidünya on 6.10.2023.
//

import Foundation

final class HomeBuilder {
    static func build() -> HomeController {
        let router = HomeRouter()
        
        let viewModel = HomeViewModel(router: router)
        
        let controller = HomeController(viewModel: viewModel)
        viewModel.output = controller
        
        return controller
    }
}
