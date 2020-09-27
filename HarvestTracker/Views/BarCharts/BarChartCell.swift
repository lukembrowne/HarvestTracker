//
//  ChartCell.swift
//  ChartView
//
//  Created by András Samu on 2019. 06. 12..
//  Copyright © 2019. András Samu. All rights reserved.
//
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

public struct BarChartCell : View {
    var value: Double
    var label: String
    var index: Int = 0
    var width: Float
    var numberOfDataPoints: Int
    var cellWidth: Double {
        return Double(width)/(Double(numberOfDataPoints) * 1.5)
    }
    
    @State var scaleValue: Double = 0
    @Binding var touchLocation: CGFloat
    public var body: some View {
        
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 4)
                    .fill(LinearGradient(gradient: Gradient(colors: [.white, .green]), startPoint: .bottom, endPoint: .top))
            }
            .frame(width: CGFloat(self.cellWidth))
            .scaleEffect(CGSize(width: 1, height: self.scaleValue), anchor: .bottom)
            .onAppear(){
                self.scaleValue = self.value
            }
            .animation(Animation.spring().delay(self.touchLocation < 0 ?  Double(self.index) * 0.04 : 0))
            
            Text(label)
                .font(.footnote)
        }
        
        
    }
    
}

#if DEBUG
struct ChartCell_Previews : PreviewProvider {
    static var previews: some View {
        BarChartCell(value: Double(0.75), label: "Test", width: 320, numberOfDataPoints: 12, touchLocation: .constant(-1))
    }
}
#endif
