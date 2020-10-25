//
//  OnboardingView.swift
//  HarvestTracker
//
//  Created by Luke Browne on 10/25/20.
//  Copyright © 2020 Luke Browne. All rights reserved.
//

import SwiftUI

struct OnboardingView: View {
    
    
    var pages: [IntroPage]
    @State private var currentPage = 0
    
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var viewRouter: ViewRouter
    
    
    init() {
        
        self.pages = [IntroPage]()
        self.pages.append(IntroPage(imageName: "AppIcon_nobg",
                                    title: "Track your harvests",
                                    description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum"))
        self.pages.append(IntroPage(imageName: "AppIcon_nobg",
                                    title: "Add your own crops and tags",
                                    description: "Harvest Tracker comes with many common vegetables and crops pre-loaded, but you can add and customize your list of crops however you'd like. "))
        self.pages.append(IntroPage(imageName: "AppIcon_nobg",
                                    title: "Visualize your harvest data",
                                    description: "Once you have some harvests entered, you'll be able to your harvest amounts over time and filter based on date, crop type, and tag."))
        
    }
    
    
    
    var body: some View {
        
        ZStack {
            settings.bgColor.ignoresSafeArea() // to color in notch
            
            
            VStack {
                
                TabView(selection: $currentPage) {
                    ForEach (0 ..< self.pages.count) { index in
                        IntroPageView(page: self.pages[index])
                            .tag(index)
                            .padding()
                            .padding(.bottom, 20)
                    }
                }
                .tabViewStyle(PageTabViewStyle()) // the important part
                
                
                // NEXT button
                HStack {
                    Spacer()
                    
                    // Button to take to home page
                    Button(action: {
                        withAnimation (.easeInOut(duration: 0.5)) {
                            viewRouter.currentPage = "tabNavigationView"
                        }
                    }) {
                        Image(systemName: "checkmark")
                            .font(.largeTitle)
                            .foregroundColor(Color.white)
                            .padding()
                            .background(Circle().fill(settings.lightAccentColor))
                    }
                    
                    Spacer()
                }
                .padding()
            }
        }
    }
}


struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}


struct IntroPage {
    let imageName: String
    let title: String
    let description: String
}

struct IntroPageView: View {
    
    let page: IntroPage
    @EnvironmentObject var settings: UserSettings
    
    
    var body: some View {
        
        VStack {
            Spacer()
            Image(self.page.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
            Spacer()
            Group {
                HStack {
                    Text(self.page.title)
                        .font(.title)
                        .foregroundColor(Color.white)
                    Spacer()
                }
                HStack {
                    Text(self.page.description)
                        .foregroundColor(Color.white)
                    Spacer()
                }
            }
            .padding()
        }
    }
}
