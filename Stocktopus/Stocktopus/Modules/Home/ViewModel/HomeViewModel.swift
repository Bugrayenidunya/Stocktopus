//
//  HomeViewModel.swift
//  Stocktopus
//
//  Created by Enes Buğra Yenidünya on 6.10.2023.
//

import Foundation

protocol HomeViewModelInput {
    var output: HomeViewModelOutput? { get set }
}

protocol HomeViewModelOutput: AnyObject {
    
}

// MARK: - HomeViewModel
final class HomeViewModel: HomeViewModelInput {
    
    // MARK: Properties
    private let router: HomeRouing
    
    weak var output: HomeViewModelOutput?
    
    // MARK: Init
    init(router: HomeRouing) {
        self.router = router
    }
}
