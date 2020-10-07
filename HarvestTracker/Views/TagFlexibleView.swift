//
//  TagFlexibleView.swift
//  HarvestTracker
//
//  Created by Luke Browne on 10/7/20.
//  Copyright © 2020 Luke Browne. All rights reserved.
//

import SwiftUI

struct TagFlexibleView: View {
    
    var originalItems = [
      "Here’s", "to", "the", "crazy", "ones", "the", "misfits", "the", "rebels", "the", "troublemakers", "the", "round", "pegs", "in", "the", "square", "holes", "the", "ones", "who", "see", "things", "differently", "they’re", "not", "fond", "of", "rules", "You", "can", "quote", "them", "disagree", "with", "them", "glorify", "or", "vilify", "them", "but", "the", "only", "thing", "you", "can’t", "do", "is", "ignore", "them", "because", "they", "change", "things", "they", "push", "the", "human", "race", "forward", "and", "while", "some", "may", "see", "them", "as", "the", "crazy", "ones", "we", "see", "genius", "because", "the", "ones", "who", "are", "crazy", "enough", "to", "think", "that", "they", "can", "change", "the", "world", "are", "the", "ones", "who", "do"
    ]
    
//    let alignments: [HorizontalAlignment] = [.leading, .center, .trailing]
//
//    var alignment: HorizontalAlignment {
//      alignments[alignmentIndex]
//    }
    
    var body: some View {
        ScrollView {
          FlexibleView(
            data: originalItems,
            spacing: CGFloat(8),
            alignment: .leading
          ) { item in
            Text(verbatim: item)
              .padding(8)
              .background(
                RoundedRectangle(cornerRadius: 8)
                  .fill(Color.gray.opacity(0.2))
               )
          }
          .padding(.horizontal, CGFloat(8))
        }
        
    }
    
    
}

//struct TagFlexibleView_Previews: PreviewProvider {
//    static var previews: some View {
//        TagFlexibleView()
//    }
//}
