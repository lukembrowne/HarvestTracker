//
//  HomeView.swift
//  HarvestTracker
//
//  Created by Luke Browne on 9/11/20.
//  Copyright © 2020 Luke Browne. All rights reserved.
//

import SwiftUI

struct TabNavigationView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var settings: UserSettings
    
    // State variables
    @State var isPresented = false
    @State private var selectedTab = 1
    @State var isPresentedChooseCrop = false


    var body: some View {
        
        TabView(selection: $selectedTab) {
            
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }.tag(1)
            
            AnalysisView().environment(\.managedObjectContext, self.managedObjectContext)
                .tabItem {
                    Image(systemName: "chart.bar")
                    Text("Analysis")
                }.tag(2)
            
            CropListView().environment(\.managedObjectContext, self.managedObjectContext)
                .tabItem {
                    Image(systemName: "plus.circle")
                    Text("Add Harvest")
                }.tag(3)
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }.tag(4)
            
        }
        
    }
    
    }


struct TabNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        TabNavigationView().environmentObject(UserSettings())
    }
}
