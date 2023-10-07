//
//  HomeCollectionViewCellDTO.swift
//  Stocktopus
//
//  Created by Enes Buğra Yenidünya on 6.10.2023.
//

import Foundation

struct HomeCollectionViewCellDTO: HomeCollectionViewCellProvider, Hashable {
    let id = UUID()
    var ticker: String
    var companyName: String
}
