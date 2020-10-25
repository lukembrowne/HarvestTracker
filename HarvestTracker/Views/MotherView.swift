//
//  MotherView.swift
//  HarvestTracker
//
//  Created by Luke Browne on 10/25/20.
//  Copyright © 2020 Luke Browne. All rights reserved.
//

import SwiftUI

struct MotherView: View {
    
    @EnvironmentObject var viewRouter: ViewRouter
    @Environment(\.managedObjectContext) var managedObjectContext
    
    
    var body: some View {
        
        VStack {
                 if viewRouter.currentPage == "onboardingView" {
                     OnboardingView().environmentObject(viewRouter)
                 } else if viewRouter.currentPage == "tabNavigationView" {
                     TabNavigationView().environment(\.managedObjectContext, self.managedObjectContext)
                 }
             }
        
    }
}

struct MotherView_Previews: PreviewProvider {
    static var previews: some View {
        MotherView()
    }
}
