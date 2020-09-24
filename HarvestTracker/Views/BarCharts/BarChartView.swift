//
//  ChartView.swift
//  ChartView
//
//  Created by András Samu on 2019. 06. 12..
//  Copyright © 2019. András Samu. All rights reserved.
//

import SwiftUI

public struct BarChartView : View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    private var data: ChartData
    public var title: String
    public var formSize:CGSize
    public var dropShadow: Bool
    public var valueSpecifier:String
    
    @State private var touchLocation: CGFloat = -1.0
    @State private var showValue: Bool = false
    @State private var showLabelValue: Bool = false
    @State private var currentValue: Double = 0
    var isFullWidth:Bool {
        return self.formSize == ChartForm.large
    }
    public init(data:ChartData, title: String, legend: String? = nil, form: CGSize? = ChartForm.medium, dropShadow: Bool? = true, cornerImage:Image? = Image(systemName: "waveform.path.ecg"), valueSpecifier: String? = "%.1f"){
        self.data = data
        self.title = title
        self.formSize = form!
        self.dropShadow = dropShadow!
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
                    Spacer()
                }.padding()
                
                // Plot bars
                BarChartRow(data: data.points.map{$0.1},
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
                     valueSpecifier: "%.0f")
    }
}
#endif
