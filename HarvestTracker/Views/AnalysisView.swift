//
//  AnalysisView.swift
//  HarvestTracker
//
//  Created by Luke Browne on 10/15/20.
//  Copyright © 2020 Luke Browne. All rights reserved.
//

import SwiftUI
import CoreData

struct AnalysisView: View {
    
    // Fetch Harvests
    @FetchRequest(entity: Harvest.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \Harvest.crop?.cropName, ascending: true)]
    ) var harvests: FetchedResults<Harvest>
    
    // Fetch request for crops
    @FetchRequest(entity: Crop.entity(),
                  sortDescriptors: [
                    NSSortDescriptor(
                        key: "cropName",
                        ascending: true,
                        selector: #selector(NSString.caseInsensitiveCompare(_:))) // To make case insensitive
                  ]) var crops: FetchedResults<Crop>
    
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
    @State var chosenCrops = [Crop]()
    @State var displayedCrops = [Crop]()
   
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
                        .frame(height: geometry.size.height * 0.4)

                    
                    // Filters section
                    Text("Filters")
                        .font(.title)
                        .foregroundColor(Color.white)
                    
                    VStack {
                        
                        
                        
                        // Filter by crop
                        HStack {
                            Text("Filter by crop")
                            Spacer()
                        }
                        
                        
                        Divider()
                        
                        // Flexible grid of potential tags
                        FlexibleView(
                            data: harvests,
                            spacing: CGFloat(8),
                            alignment: .leading
                        ) { harvest in
                            
                                TagViewCrop(crop: harvest.crop!,
                                            chosenCrops: $chosenCrops,
                                            displayedCrops: $displayedCrops)
                        }
                        .padding(.horizontal, CGFloat(8))
                        
                        
                        // Filter by tags
                        HStack {
                            Text("Filter by tags")
                            Spacer()
                        }
                        
                        
                        Divider()
                        
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
                    .onAppear {
                        
                        print("appeared")
//                        getCropNames()
                        
//                        self.getCropNames()
//
//                        for harvest in harvests {
//
//                            if let name = harvest.crop?.cropName {
//                                cropNames.append(name)
//                            }
//
//                        }
//
//                       cropNames = Array(Set(cropNames)).sorted()) // To remove duplicate elements and alphabatize
//
                    }
                    
                    
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
