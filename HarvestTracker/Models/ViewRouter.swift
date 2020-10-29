//
//  ViewRouter.swift
//  HarvestTracker
//
//  Created by Luke Browne on 10/25/20.
//  Copyright © 2020 Luke Browne. All rights reserved.
//

import Foundation


class ViewRouter: ObservableObject {
    
    @Published var currentPage: String
    
    init() {
        
        if !UserDefaults.standard.bool(forKey: "didLaunchBefore") {
            UserDefaults.standard.set(true, forKey: "didLaunchBefore")
            currentPage = "onboardingView"
        } else {
            currentPage = "tabNavigationView"
        }
        
    }
    
}
