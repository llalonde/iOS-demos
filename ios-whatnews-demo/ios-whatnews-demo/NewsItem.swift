//
//  NewsItem.swift
//  ios-whatnews-demo
//
//  Created by lorilalonde on 2017-11-15.
//  Copyright © 2017 Lori Lalonde. All rights reserved.
//

import UIKit

class NewsItem {
    
    //Declare your model variables here
    var headline : String = ""
    var imageURL : String = ""
    var description : String = ""
    var textAnalytics : Double = 0.0
    var sentimentImage : String = ""
    
    func updateNewsItemImage(sentimentValue: Double) {
        
        textAnalytics = sentimentValue
        
        switch (textAnalytics) {
            
        case 0...0.39 :
            sentimentImage = "Sad"
        case 0.4...0.69 :
            sentimentImage = "Neutral"
        case 0.7...1.0 :
            sentimentImage = "Good"
            
        default :
            sentimentImage = ""
        }
        
    }
}
