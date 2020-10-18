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
                    BarChartView(data: HarvestCalculator(harvests: harvests).calcTotalByMonth(filterByTags: chosenTags, filterByCrops: chosenCrops))
                        .background(
                            RoundedRectangle(
                                cornerRadius: 20
                            )
                            .foregroundColor(Color.white)
                            .shadow(radius: settings.cardShadowRadius)
                            
                        )
                        .padding(settings.cardPadding)
                        .frame(height: geometry.size.height * 0.4)
                    
                    
                    NavigationView {
                        
                        
                        Form {
                            
                            
                            Section(header: Text("Filter by crop:")
                                        .font(.headline)
                                    
                            ) {
                                NavigationLink(destination: CropListFilterView(chosenCrops: $chosenCrops).environment(\.managedObjectContext, self.managedObjectContext)) {
                                    Text("Choose Crops")
                                }
                                HStack {
                                    // Flexible grid of cropnames
                                    FlexibleView(
                                        data: chosenCrops,
                                        spacing: CGFloat(8),
                                        alignment: .leading
                                    ) { crop in
                                        
                                        Text("\(crop.cropName ?? "...")")
                                            .padding(.vertical, 6)
                                            .padding(.horizontal, 8)
                                            .foregroundColor(.white)
                                            .background(settings.bgColor.opacity(0.9))
                                            .cornerRadius(20)
                                            .buttonStyle(BorderlessButtonStyle()) // Bug fix so that entire row doesn't highlight
                                        
                                    }
                                    .padding(.horizontal, CGFloat(8))
                                }
                            } // end section
                            
                            // Filtering by tags
                            Section(header: Text("Filter by tag:")
                                        .font(.headline)
                            ) {
                                
                                NavigationLink(destination: TagListFilterView(chosenTags: $chosenTags).environment(\.managedObjectContext, self.managedObjectContext)) {
                                    Text("Choose Tags")
                                }
                                
                                HStack {
                                    // Flexible grid of potential tags
                                    FlexibleView(
                                        data: chosenTags,
                                        spacing: CGFloat(8),
                                        alignment: .leading
                                    ) { tag in
                                        TagView(tag: tag,
                                                fontSize: .body)
                                            .disabled(true) // turn off button action
                                        
                                    }
                                    .padding(.horizontal, CGFloat(8))
                                }
                            } // end section
                            
                            
                        }
                        .navigationBarTitle("Filters", displayMode: .inline) // Avoid large white space if viewing from Settings
                        .foregroundColor(Color.black)
                    }
                    
                    
                } // Vstack
            } // Zstack
        } // Geometry reader
    } // View
} // struct
