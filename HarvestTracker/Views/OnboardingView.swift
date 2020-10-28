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
        self.pages.append(IntroPage(imageName: "OnboardingScreen1",
                                    title: "Welcome!",
                                    description: "The purpose of Harvest Tracker is to provide a tool to better understand the harvests coming from your garden. Use it to optimize your planting, or just satisfy your curiosity. Swipe left to continue the tutorial."))
        self.pages.append(IntroPage(imageName: "OnboardingScreen2",
                                    title: "Add your harvests",
                                    description: "The first step is to add some harvest data - choose the crop, weight, date, and any tags that may apply."))
        self.pages.append(IntroPage(imageName: "OnboardingScreen3",
                                    title: "Add your own crops",
                                    description: "Harvest Tracker comes with many common crops pre-loaded, but you can add and customize your list of crops however you'd like."))
        self.pages.append(IntroPage(imageName: "OnboardingScreen4",
                                    title: "Add your own tags",
                                    description: "You can add tags to every harvest as another useful way to organize and visualize patterns in your harvest data. You can customize your tags however you'd like."))
        self.pages.append(IntroPage(imageName: "OnboardingScreen5",
                                    title: "Visualize your harvest data",
                                    description: "Once you have some harvests entered, you'll be able to create graphs of your harvest amounts over time, filtering based on date, crop type, and tag."))
        
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
            Text(self.page.title)
                .font(.title)
                .foregroundColor(Color.white)
            Spacer()
                        
            HStack {
                Text(self.page.description)
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
                Spacer()
            }
                        
            //            HStack {
            //                Spacer()
            //                Image("AppIcon_nobg")
            //                    .resizable()
            //                    .aspectRatio(contentMode: .fit)
            //                    .frame(height: 50)
            //
            //                Spacer()
            //            }
            
            
            
            HStack {
                Spacer()
                
                Image(self.page.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(20)
                Spacer()
            }
            .padding()
        }
    }
}
