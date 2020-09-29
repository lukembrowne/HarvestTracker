//
//  HomeView.swift
//  HarvestTracker
//
//  Created by Luke Browne on 9/11/20.
//  Copyright © 2020 Luke Browne. All rights reserved.
//

import SwiftUI

struct TabNavigationView: View {
    
    // State variables
    @State var isPresented = false
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State private var selectedTab = 1
    @State var isPresentedChooseCrop = false

    @ObservedObject var defaultUnit = DefaultUnit()
        
    var body: some View {
        
        TabView(selection: $selectedTab) {
            
            HomeView(defaultUnit: defaultUnit)
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }.tag(1)
            
            Text("Hello world")
                .tabItem {
                    Image(systemName: "chart.bar")
                    Text("Reports")
                }.tag(2)
            
            CropListView().environment(\.managedObjectContext, self.managedObjectContext)
                .tabItem {
                    Image(systemName: "plus.circle")
                    Text("Add Harvest")
                }.tag(3)
            
            SettingsView(defaultUnit: defaultUnit)
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }.tag(4)
            
        }
        
    }
    
    }


struct TabNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        TabNavigationView()
    }
}
