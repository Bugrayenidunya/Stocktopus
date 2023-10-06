//
//  HomeController.swift
//  Stocktopus
//
//  Created by Enes Buğra Yenidünya on 6.10.2023.
//

import UIKit

final class HomeController: UIViewController {
    
    // MARK: Properties
    private var viewModel: HomeViewModelInput

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .purple
    }
    
    // MARK: Init
    init(viewModel: HomeViewModelInput) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - HomeViewModelOutput
extension HomeController: HomeViewModelOutput {
    
}
