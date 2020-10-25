//
//  SettingsView.swift
//  HarvestTracker
//
//  Created by Luke Browne on 9/28/20.
//  Copyright © 2020 Luke Browne. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var settings: UserSettings
    
    var units = ["oz", "lb", "g", "kg"]
    
    // If testing
    let testing = Testing()

    
    
    var body: some View {
        
        NavigationView {
            
            Form {
                
                // Change default unit of weight
                Section(header: Text("Change default unit")
                            .font(.headline)
//                            .foregroundColor(Color.white)
                ) {
                    
                    Picker("units", selection: $settings.unitString) {
                        ForEach(0 ..< units.count) { index in
                            Text(self.units[index])
                                .tag(self.units[index])
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                }
                
                // Edit crop list
                Section(header: Text("Crops")
                            .font(.headline)
//                            .foregroundColor(Color.white)
                ) {
                    
                    NavigationLink(destination: CropListView(cropEditMode: true).environment(\.managedObjectContext, self.managedObjectContext)) {
                        Text("Edit Crops")
                    }
                }
                
                // Edit tag list
                Section(header: Text("Tags")
                            .font(.headline)
//                            .foregroundColor(Color.white)
                ) {
                    
                    NavigationLink(destination: TagListView().environment(\.managedObjectContext, self.managedObjectContext)) {
                        Text("Edit Tags")
                    }
                }
                
                // About section
                Section(header: Text("About")
                            .font(.headline)
//                            .foregroundColor(Color.white)
                ) {
                    
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("0.1")
                    }
                    HStack {
                        Link("App Icon by Ewa Mazur", destination: URL(string: "https://www.iconfinder.com/mypoint13k")!)
                        Spacer()
                    }
                    HStack {
                        Link("Graph based on ChartView", destination: URL(string: "https://github.com/AppPear/ChartView")!)
                        Spacer()
                    }
                }
                
                // For testing
                Section(header: Text("Load data")
                            .font(.headline)
                ) {
                    Button("Load tags") {
                        testing.createTags(in: self.managedObjectContext)
                    }
                    Button("Load harvests") {
                        testing.createHarvests(in: self.managedObjectContext)
                    }
                    
                    Button("Delete all data") {
                        testing.deleteAllData(in: self.managedObjectContext)
                    }
                    
                }
                
                
                
            }
            .navigationBarTitle("Settings")
//            .onAppear {
//                UITableView.appearance().backgroundColor = UIColor(settings.bgColor)
//            }
            
        }
        
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView().environmentObject(UserSettings())
    }
}
