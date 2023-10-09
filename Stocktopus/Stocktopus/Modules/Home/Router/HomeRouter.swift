//
//  HomeRouter.swift
//  Stocktopus
//
//  Created by Enes Buğra Yenidünya on 6.10.2023.
//

import UIKit

// MARK: - HomeRouing
protocol HomeRouing {
    var viewController: UIViewController? { get set }
    
    func navigateToDetail(with ticker: String)
}

// MARK: - HomeRouter
final class HomeRouter: HomeRouing {
    
    // MARK: Properties
    weak var viewController: UIViewController?
    
    private var navigationController: UINavigationController? {
        viewController?.navigationController
    }
    
    // MARK: Functions
    func navigateToDetail(with ticker: String) {
        let detailController = DetailBuilder.build(with: ticker)
        navigationController?.pushViewController(detailController, animated: true)
    }
}
