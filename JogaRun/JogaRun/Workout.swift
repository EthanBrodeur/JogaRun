//
//  Workout.swift
//  JogaRun
//
//  Created by Labuser on 4/4/17.
//  Copyright © 2017 Taylor. All rights reserved.
//

import Foundation

struct Workout {
    var distance: Double = 0.0
    var time: TimeInterval = 0.0 //this is in seconds
    var shoe = Shoe()
    var note: String = ""
    var avgHR: Double = 0.0
    var timeStamp = Date()
    
    //probably some helper method that divides time by 60 to get minutes quickly. also need to do string interpolation at some point
}

