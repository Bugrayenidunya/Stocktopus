//
//  CandleChartDataSet+Extensions.swift
//  Stocktopus
//
//  Created by Enes Buğra Yenidünya on 10.10.2023.
//

import DGCharts

extension CandleChartDataSet {
    func setStocktopusTheme() {
        axisDependency = .left
        drawIconsEnabled = false
        shadowColor = .darkGray
        shadowWidth = 0.7
        decreasingColor = .red
        decreasingFilled = true
        increasingColor = .green
        increasingFilled = true
        neutralColor = .blue
    }
}
