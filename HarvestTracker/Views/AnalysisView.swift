//
//  AnalysisView.swift
//  HarvestTracker
//
//  Created by Luke Browne on 10/15/20.
//  Copyright © 2020 Luke Browne. All rights reserved.
//

import SwiftUI

struct AnalysisView: View {
    
    // Fetch Harvests
    @FetchRequest(entity: Harvest.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \Harvest.harvestDate, ascending: false)]
    ) var harvests: FetchedResults<Harvest>
    
    @FetchRequest(entity: Tag.entity(),
                  sortDescriptors: [
                    NSSortDescriptor(
                        key: "tagName",
                        ascending: true,
                        selector: #selector(NSString.caseInsensitiveCompare(_:))) // To make case insensitive
                  ]) var tags: FetchedResults<Tag>
    
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var settings: UserSettings
    
    @State var chosenTags = [Tag]()
    
    
    var body: some View {
        
        
        GeometryReader { geometry in
            
            
            ZStack {
                
                settings.bgColor.ignoresSafeArea() // to color in notch
                
                VStack {
                    
                    Text("Analysis")
                        .font(.largeTitle)
                        .padding([.top, .horizontal])
                        .foregroundColor(Color.white)
                    
                    // Add bar chart view
                    BarChartView(data: HarvestCalculator(harvests: harvests).calcTotalByMonth(filterByTags: chosenTags))
                        .background(
                            RoundedRectangle(
                                cornerRadius: 20
                            )
                            .foregroundColor(Color.white)
                            .shadow(radius: settings.cardShadowRadius)
                            
                        )
                        .padding(settings.cardPadding)
                        .frame(height: geometry.size.height * 0.5)
                    
                    
                    // Filters section
                    Text("Filters")
                        .font(.title)
                        .foregroundColor(Color.white)
                    
                    VStack {
                        Spacer()
                        
                        HStack {
                            Spacer()
                            Text("Tags")
                            Spacer()
                        }
                        
                        // Flexible grid of potential tags
                        FlexibleView(
                            data: tags,
                            spacing: CGFloat(8),
                            alignment: .leading
                        ) { tag in
                            TagView(tag: tag,
                                    chosenTags: $chosenTags)
                            
                        }
                        .padding(.horizontal, CGFloat(8))
                        
                        Spacer()
                    }
                    
                    .background(
                        RoundedRectangle(
                            cornerRadius: 20
                        )
                        .foregroundColor(Color.white)
                        .shadow(radius: settings.cardShadowRadius)
                        
                    )
                    .padding(settings.cardPadding)
                    
                    
                } // Vstack
            } // Zstack
        } // Geometry reader
    } // View
} // struct

//struct AnalysisView_Previews: PreviewProvider {
//    static var previews: some View {
//        AnalysisView()
//    }
//}
