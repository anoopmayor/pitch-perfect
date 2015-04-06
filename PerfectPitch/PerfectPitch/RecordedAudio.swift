//
//  RecordedAudio.swift
//  PerfectPitch
//
//  Created by Jericho on 4/2/15.
//  Copyright (c) 2015 Jericho. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    
    //declare variables
    var filePathUrl: NSURL!
    var title: String!
    
    //initialize variables when class RecordedAudio is called
    init(filePathUrl: NSURL, title: String) {
        self.filePathUrl = filePathUrl
        self.title = title
    }
}

