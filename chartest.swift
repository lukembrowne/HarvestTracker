//
//  chartest.swift
//  HarvestTracker
//
//  Created by Luke Browne on 9/23/20.
//  Copyright © 2020 Luke Browne. All rights reserved.
//

import SwiftUI
import SwiftUICharts

struct chartest: View {
    var body: some View {
        
        VStack {
            
            BarChartView(data: ChartData(values: [("2018 Q4",63150), ("2019 Q1",50900), ("2019 Q2",77550), ("2019 Q3",79600), ("2019 Q4",92550)]), title: "Sales", legend: "Quarterly", form: ChartForm.large) // legend is optional

            MultiLineChartView(data: [([8,32,11,23,40,28], GradientColors.green), ([90,99,78,111,70,60,77], GradientColors.purple), ([34,56,72,38,43,100,50], GradientColors.orngPink)], title: "Title")

            
//            BarChartView(data: ChartData(points: [8,23,54,32,12,37,7,23,43]), title: "Title", legend: "Legendary") // legend is optional

        }

    }
}

struct chartest_Previews: PreviewProvider {
    static var previews: some View {
        chartest()
    }
}
