//
//  HomeSection.swift
//  Stocktopus
//
//  Created by Enes Buğra Yenidünya on 6.10.2023.
//

import Foundation

final class HomeSection: Hashable {
    
    // MARK: Properties
    var id = UUID()
    var items: [HomeCollectionViewCellDTO]
    
    // MARK: Init
    init(items: [HomeCollectionViewCellDTO]) {
        self.items = items
    }
    
    // MARK: Functions
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: HomeSection, rhs: HomeSection) -> Bool {
        lhs.id == rhs.id
    }
}
