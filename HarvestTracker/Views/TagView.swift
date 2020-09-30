//
//  TagView.swift
//  HarvestTracker
//
//  Created by Luke Browne on 9/29/20.
//  Copyright © 2020 Luke Browne. All rights reserved.
//

import SwiftUI

struct TagView: View {
    
    var tagName: String
    var tagColorHex: String
    
    
    var body: some View {
//        Button(action: {}) {
            HStack {
                Text(tagName)
//                Image(systemName: "xmark.circle")
            }
//        }
        .padding(5)
        .foregroundColor(.white)
            .background(Color(UIColor(hexString: tagColorHex, alpha: 0.8)))
        .cornerRadius(20)
    }
}

//struct TagView_Previews: PreviewProvider {
//    static var previews: some View {
//        TagView(tagName: "Test",
//                tagColorHex: "000000")
//    }
//}
