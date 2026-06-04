//
//  MarketPriceChartView.swift
//  IMW
//
//  Created by Марат Саляхетдинов on 03.06.2026.
//

import Charts
import SwiftUI

struct MarketPriceChartView: View {

    let viewModel: MarketDetailModel.ChartViewModel

    var body: some View {
        Chart(viewModel.points) { point in
            AreaMark(
                x: .value("Date", point.date),
                y: .value("Price", point.price)
            )
            .foregroundStyle(
                LinearGradient(
                    colors: [Color(uiColor: viewModel.lineColor).opacity(0.24), Color(uiColor: viewModel.lineColor).opacity(0.02)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )

            LineMark(
                x: .value("Date", point.date),
                y: .value("Price", point.price)
            )
            .foregroundStyle(Color(uiColor: viewModel.lineColor))
            .lineStyle(.init(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
            .interpolationMethod(.catmullRom)
        }
        .chartXAxis(.hidden)
        .chartYAxis {
            AxisMarks(position: .trailing)
        }
        .chartPlotStyle { plotArea in
            plotArea.background(Color.clear)
        }
    }
}
