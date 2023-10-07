//
//  DetailRouter.swift
//  Stocktopus
//
//  Created by Enes Buğra Yenidünya on 7.10.2023.
//

import UIKit

protocol DetailRouting {
    var navigationController: UINavigationController? { get set }
}

final class DetailRouter: DetailRouting {
    
    // MARK: Properties
    weak var navigationController: UINavigationController?
}
