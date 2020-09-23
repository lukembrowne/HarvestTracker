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


    
    
    var body: some View {
        
        TabView(selection: $selectedTab) {
            
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }.tag(1)
            
            chartest()
                .tabItem {
                    Image(systemName: "chart.bar")
                    Text("Reports")
                }.tag(2)
            
            CropListView().environment(\.managedObjectContext, self.managedObjectContext)
                .tabItem {
                    Image(systemName: "plus.circle")
                    Text("Add Harvest")
                }.tag(3)
            
            Text("Settings View")
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

//
//struct SheetPresenter<Content>: View where Content: View {
//
//    @Binding var presentingSheet: Bool
//    @Binding var selectedTab: Int
//
//    var content: Content
//
//    var body: some View {
//
//        Text("")
//            .sheet(isPresented: self.$presentingSheet,
//                   onDismiss: {
//                    self.selectedTab = 1
//
//            },
//                   content: { self.content })
//            .onAppear {
//                DispatchQueue.main.async {
//                    self.presentingSheet = true
//                }
//            }
//
//    }
//}
