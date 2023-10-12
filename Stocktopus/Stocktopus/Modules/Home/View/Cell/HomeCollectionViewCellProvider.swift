//
//  HomeCollectionViewCellProvider.swift
//  Stocktopus
//
//  Created by Enes Buğra Yenidünya on 6.10.2023.
//

import Foundation

protocol HomeCollectionViewCellProvider {
    var ticker: String { get }
    var companyName: String { get }
}
