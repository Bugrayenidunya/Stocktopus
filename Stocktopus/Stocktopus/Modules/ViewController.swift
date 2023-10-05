//
//  ViewController.swift
//  Stocktopus
//
//  Created by Enes Buğra Yenidünya on 5.10.2023.
//

import UIKit

final class ViewController: UIViewController {
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .blue
    }

    // MARK: Init
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

