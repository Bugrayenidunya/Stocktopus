//
//  DetailController.swift
//  Stocktopus
//
//  Created by Enes Buğra Yenidünya on 7.10.2023.
//

import UIKit

final class DetailController: UIViewController {
    
    // MARK: Properties
    private let viewModel: DetailViewModelInput

    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commonInit()
    }
    
    // MARK: Init
    init(viewModel: DetailViewModelInput) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - DetailViewModelOutput
extension DetailController: DetailViewModelOutput {
    
}

// MARK: - Helpers
private extension DetailController {
    func commonInit() {
        setupViews()
    }
    
    func setupViews() {
        
    }
}
