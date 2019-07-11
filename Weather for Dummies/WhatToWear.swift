//
//  WhatToWear.swift
//  Weather for Dummies
//
//  Created by Matvey on 7/8/19.
//  Copyright © 2019 Matvey. All rights reserved.
//

import Foundation

var dangerouslyHot = false
var dangerouslyCold = false
var calamityWarning = false

var bringCoatOrUmbrella = false
var waterproofShoes = false
var wearHat = false
var wearSweater = false
var wearGloves = false

var numberOfLayers = 1

let hotOrCold = ["It is extremely hot ", "It is very hot ", "It is hot, ", "It is pretty warm, ", "It is warm, ", "It is chilly, ", "It is cold, ", "It is very cold", "It is really cold", "It is freezing, ", "It is dangerously cold, "]

let precipitationAndHumidity = ["dry, ", "humid, ", "foggy, ", "raining, ", "pouring, ", "snowing, ", "hailing, "]

let windyOrNot = ["and not windy.", "and windy."]

func evaluateWeather(currentTemperature: Double?, currentPrecipitation: Double?) {
    
    guard let currentTemperature = currentTemperature else { return }
    guard let currentPrecipitation = currentPrecipitation else { return }
    
    print("currentTemperature: \(currentTemperature)")
    print("currentPrecipitation: \(currentPrecipitation)")
    
    switch currentTemperature {
    case ..<(-30):
        print("dangerously cold")
    case -20..<(-20):
        print("freezing")
    case -20..<(-10):
        print("really cold")
    case -10..<0:
        print("very cold")
    case 0..<8:
        print("cold")
    case 8..<16:
        print("chilly")
    case 16..<25:
        print("warm")
    case 25..<28:
        print("pretty warm")
    case 28..<35:
        print("hot")
    case 35..<42:
        print("very hot")
    case 42...:
        print("extremely hot")
    default:
        print("what's going on?")
    }
    
    
    switch currentPrecipitation {
    case 0.0...2.5:
        print("light rain")
    case 2.5..<7.6:
        print("moderate rain")
    case 7.6..<50:
        print("heavy rain")
    case 50...:
        print("violent rain")
    default:
        print("hmm")
    }
    
    
}


