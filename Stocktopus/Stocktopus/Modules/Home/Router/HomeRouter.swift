//
//  HomeRouter.swift
//  Stocktopus
//
//  Created by Enes Buğra Yenidünya on 6.10.2023.
//

import UIKit

// MARK: - HomeRouing
protocol HomeRouing {
    var navigationController: UINavigationController? { get set }
}

// MARK: - HomeRouter
final class HomeRouter: HomeRouing {
    
    // MARK: Properties
    weak var navigationController: UINavigationController?
}
