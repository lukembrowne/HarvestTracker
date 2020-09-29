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
    private var data: ChartData
    public var title: String
    public var formSize:CGSize
    public var valueSpecifier:String
    
    @State private var touchLocation: CGFloat = -1.0
    @State private var showValue: Bool = false
    @State private var showLabelValue: Bool = false
    @State private var currentValue: Double = 0
    var isFullWidth:Bool {
        return self.formSize == ChartForm.large
    }
    init(data:ChartData, title: String, legend: String? = nil, form: CGSize? = ChartForm.medium, dropShadow: Bool? = true, cornerImage:Image? = Image(systemName: "waveform.path.ecg"), valueSpecifier: String? = "%.1f"){
        self.data = data
        self.title = title
        self.formSize = form!
        self.valueSpecifier = valueSpecifier!
    }
    
    public var body: some View {
        ZStack{
            Rectangle()
                .fill(Color.white)
                .cornerRadius(20)
            VStack(alignment: .leading){
                
                // Title text
                HStack{
                    Text(self.title)
                        .font(.title)
                    // Harvest total unit here
                    Text(" \(settings.unitString)")
                        .font(.caption)
                    Spacer()
                }.padding()
                
                // Plot bars
                BarChartRow(data: data.points.map{$0.1},
                            labels: data.points.map{$0.0},
                            touchLocation: self.$touchLocation)
                
            }
        }
        .gesture(DragGesture()
                    .onChanged({ value in
                        self.touchLocation = value.location.x/self.formSize.width
                        self.showValue = true
                        self.currentValue = self.getCurrentValue()?.1 ?? 0
                        if(self.data.valuesGiven && self.formSize == ChartForm.medium) {
                            self.showLabelValue = true
                        }
                    })
                    .onEnded({ value in
                        self.showValue = false
                        self.showLabelValue = false
                        self.touchLocation = -1
                    })
        )
        .gesture(TapGesture()
        )
    }
    
    func getArrowOffset(touchLocation:CGFloat) -> Binding<CGFloat> {
        let realLoc = (self.touchLocation * self.formSize.width) - 50
        if realLoc < 10 {
            return .constant(realLoc - 10)
        }else if realLoc > self.formSize.width-110 {
            return .constant((self.formSize.width-110 - realLoc) * -1)
        } else {
            return .constant(0)
        }
    }
    
    func getLabelViewOffset(touchLocation:CGFloat) -> CGFloat {
        return min(self.formSize.width-110,max(10,(self.touchLocation * self.formSize.width) - 50))
    }
    
    func getCurrentValue() -> (String,Double)? {
        guard self.data.points.count > 0 else { return nil}
        let index = max(0,min(self.data.points.count-1,Int(floor((self.touchLocation*self.formSize.width)/(self.formSize.width/CGFloat(self.data.points.count))))))
        return self.data.points[index]
    }
}

#if DEBUG
struct ChartView_Previews : PreviewProvider {
    static var previews: some View {
        BarChartView(data: TestData.values ,
                     title: "Test label",
                     valueSpecifier: "%.0f").environmentObject(UserSettings())
    }
}
#endif
