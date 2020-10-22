//
//  ChartView.swift
//  ChartView
//
//  Created by András Samu on 2019. 06. 12..
//  Copyright © 2019. András Samu. All rights reserved.
//

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.


import SwiftUI

public struct BarChartView : View {
    
    @EnvironmentObject var settings: UserSettings

    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    @ObservedObject private var data: ChartData
    
    public var formSize:CGSize
    public var valueSpecifier:String
    @Binding var year: Int
    @Binding var chosenUnit: String
    
    init(data:ChartData, legend: String? = nil, form: CGSize? = ChartForm.medium, dropShadow: Bool? = true, cornerImage:Image? = Image(systemName: "waveform.path.ecg"), valueSpecifier: String? = "%.1f", year: Binding<Int>, chosenUnit: Binding<String>){
        self.data = data
        self.formSize = form!
        self.valueSpecifier = valueSpecifier!
        self._year = year
        self._chosenUnit = chosenUnit
    }
    
    public var body: some View {
        
            ZStack{

                VStack(alignment: .leading){

                    // Plot bars
                    BarChartRow(data: data.points.map{$0.1},
                                labels: data.points.map{$0.0},
                                year: $year,
                                chosenUnit: $chosenUnit)
                }
            } // Zstack
            .padding()

    } // End view
    
    
//    func getArrowOffset(touchLocation:CGFloat) -> Binding<CGFloat> {
//        let realLoc = (self.touchLocation * self.formSize.width) - 50
//        if realLoc < 10 {
//            return .constant(realLoc - 10)
//        }else if realLoc > self.formSize.width-110 {
//            return .constant((self.formSize.width-110 - realLoc) * -1)
//        } else {
//            return .constant(0)
//        }
//    }
//
//    func getLabelViewOffset(touchLocation:CGFloat) -> CGFloat {
//        return min(self.formSize.width-110,max(10,(self.touchLocation * self.formSize.width) - 50))
//    }
//
//    func getCurrentValue(width: CGFloat) -> (String,Double)? {
//
//        guard self.data.points.count > 0 else { return nil}
////        let index = max(0,min(self.data.points.count-1,Int(floor((self.touchLocation*self.formSize.width)/(self.formSize.width/CGFloat(self.data.points.count))))))
//
//        let index = max(0,min(self.data.points.count-1,Int(floor((self.touchLocation*width)/(width/CGFloat(self.data.points.count))))))
//
//        return self.data.points[index]
//    }
}
