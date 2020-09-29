//
//  SettingsView.swift
//  HarvestTracker
//
//  Created by Luke Browne on 9/28/20.
//  Copyright © 2020 Luke Browne. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var settings: UserSettings
    var units = ["oz", "lb", "g", "kg"]
    
    
    var body: some View {
        
        NavigationView {
            
        Form {
            
            // Change default unit of weight
            Section(header: Text("Change default unit").font(.headline)) {
                
                Picker("units", selection: $settings.unitString) {
                    ForEach(0 ..< units.count) { index in
                        Text(self.units[index])
                            .tag(self.units[index])
                    }
                }
                .pickerStyle(SegmentedPickerStyle())

            }
            
            // Edit crop list
            Section(header: Text("Edit crop list").font(.headline)) {
                
                Text("Button to edit crop list")
            }
            
            // About section
            Section(header: Text("About").font(.headline)) {
                
                
                HStack {
                     Text("Version")
                     Spacer()
                     Text("0.1")
                 }
            }
        }
        .navigationBarTitle("Settings")

        }
        
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView().environmentObject(UserSettings())
    }
}
