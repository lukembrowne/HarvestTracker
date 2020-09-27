//
//  ChartRow.swift
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

public struct BarChartRow : View {
    
    var data: [Double]
    var labels: [String]
    
    var maxValue: Double {
        guard let max = data.max() else {
            return 1
        }
        return max != 0 ? max : 1
    }
    @Binding var touchLocation: CGFloat
    public var body: some View {
        GeometryReader { geometry in
            
            HStack(alignment: .bottom, spacing: (geometry.frame(in: .local).width-22)/CGFloat(self.data.count * 3)){
                
                ForEach(0..<self.data.count, id: \.self) { i in
                    
                    BarChartCell(value: self.normalizedValue(index: i),
                                 label: labels[i],
                                 index: i,
                                 width: Float(geometry.frame(in: .local).width - 22),
                                 numberOfDataPoints: self.data.count,
                                 touchLocation: self.$touchLocation)
                        
                        .scaleEffect(self.touchLocation > CGFloat(i)/CGFloat(self.data.count) && self.touchLocation < CGFloat(i+1)/CGFloat(self.data.count) ? CGSize(width: 1.4, height: 1.1) : CGSize(width: 1, height: 1), anchor: .bottom)
                        .animation(.spring())
                    
                }
            }
            .padding([.top, .leading, .trailing], 10)
        }
    }
    
    func normalizedValue(index: Int) -> Double {
        return Double(self.data[index])/Double(self.maxValue)
    }
}

#if DEBUG
struct ChartRow_Previews : PreviewProvider {
    static var previews: some View {
        Group {
            BarChartRow(data: [8,23,54,32,12,37,7], labels: ["a", "b", "c", "d", "e", "f", "g"], touchLocation: .constant(-1))
        }
    }
}
#endif
