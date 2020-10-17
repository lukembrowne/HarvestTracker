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
    
    @EnvironmentObject var settings: UserSettings
    
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
                
                // Add y axis
                //                VStack {
                //                    Text("\(Int(Measurement(value: maxValue, unit: UnitMass.grams).converted(to: .kilograms).value)) kg")
                //                        .font(.footnote)
                //                    Spacer()
                //
                //                }
                //                .frame(width: CGFloat(25))
                
                HStack {
                    
                    HStack {
                        
                        // Y axis label at the top
                        VStack {
                            Text("\(Int(Measurement(value: maxValue, unit: UnitMass.grams).converted(to: settings.unitMass).value)) \(settings.unitString)")
                                .font(.footnote)
                                .offset(x: 0, y: -8)
                            
                            Spacer()
                            
                            Text("0 \(settings.unitString)")
                                .font(.footnote)
                        }
                        
                        //                        Path{ path in
                        //                            path.move(to: CGPoint(x: 0, y: 0))
                        //                            path.addLine(to: CGPoint(x: geometry.frame(in: .local).width-85, y: 0))
                        //                                }
                        //                                .stroke(style: StrokeStyle( lineWidth: 2, dash: [5]))
                        //                        .foregroundColor(Color.black.opacity(0.15))
                        
                    }
                    
                    ZStack {
                        
                        // Add dashed line at the top
                        Path{ path in
                            path.move(to: CGPoint(x: 0, y: 0))
                            path.addLine(to:
                                            CGPoint(x: geometry.frame(in: .local).width - 60,
                                                    y: 0))
                        }
                        .stroke(style: StrokeStyle( lineWidth: 2, dash: [5]))
                        .foregroundColor(Color.black.opacity(0.15))
                        
                        // Bars
                        
                        ZStack {
                            
                            HStack {
                                ForEach(0..<self.data.count, id: \.self) { i in
                                    
                                    BarChartCell(value: self.normalizedValue(index: i),
                                                 label: labels[i],
                                                 index: i,
                                                 width: Float(geometry.frame(in: .local).width - 55), // Original width offset was 22
                                                 numberOfDataPoints: self.data.count,
                                                 touchLocation: self.$touchLocation)
                                        
                                        .scaleEffect(self.touchLocation > CGFloat(i)/CGFloat(self.data.count) && self.touchLocation < CGFloat(i+1)/CGFloat(self.data.count) ? CGSize(width: 1.4, height: 1.1) : CGSize(width: 1, height: 1), anchor: .bottom)
                                        .animation(.spring())
                                } // end foreach
                            } // end hstack
                            
                            
                            // Year label
                            VStack {
                                Spacer()
                                Text("2020")
                                    .font(.caption)
                                    .offset(x: 0, y: 20)
                            }
                        } // vstack
                    } // zstack
                } // hstack
            }
            .padding([.top, .leading, .trailing, .bottom], 10)
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
            BarChartRow(data: [8,23,54,32,12,37,7], labels: ["a", "b", "c", "d", "e", "f", "g"], touchLocation: .constant(-1)).environmentObject(UserSettings())
        }
    }
}
#endif
