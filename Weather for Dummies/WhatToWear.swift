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

// Sample output: "It is cold, raining, and windy. Bring a coat or an umbrella, and wear at least 3 layers."

var beginningOfPhrase = ""
var middleOfPhrase = ""
var endOfPhrase = ""

var outputPhrase = ""


func evaluateWeather(currentTemperature: Double?, currentPrecipitation: Double?, currentHumidity: Int?, currentPrecipProbability: Double?) {
    
    guard let currentTemperature = currentTemperature else { return }
    guard let currentPrecipitation = currentPrecipitation else { return }
    guard let currentHumidity = currentHumidity else { return }
    
    print("currentTemperature: \(currentTemperature)")
    print("currentPrecipitation: \(currentPrecipitation)")
    print("currentHumidity: \(currentHumidity)")
    
    switch currentTemperature {
    case ..<(-30):
        outputPhrase = hotOrCold[hotOrCold.count - 1]
    case -20..<(-20):
        outputPhrase = hotOrCold[hotOrCold.count - 2]
    case -20..<(-10):
        outputPhrase = hotOrCold[hotOrCold.count - 3]
    case -10..<0:
        outputPhrase = hotOrCold[hotOrCold.count - 4]
    case 0..<8:
        outputPhrase = hotOrCold[hotOrCold.count - 5]
    case 8..<16:
        outputPhrase = hotOrCold[hotOrCold.count - 6]
    case 16..<25:
        outputPhrase = hotOrCold[hotOrCold.count - 7]
    case 25..<28:
        outputPhrase = hotOrCold[hotOrCold.count - 8]
    case 28..<35:
        outputPhrase = hotOrCold[hotOrCold.count - 9]
    case 35..<42:
        outputPhrase = hotOrCold[hotOrCold.count - 10]
    case 42...:
        outputPhrase = hotOrCold[hotOrCold.count - 11]
    default:
        print("what's going on?")
    }
    
    if currentPrecipitation == 0 {
    
        switch currentHumidity {
        case 0:
            outputPhrase.append(precipitationAndHumidity[0])
        default:
            outputPhrase.append(precipitationAndHumidity[1])
        }
        
    } else {
    
        switch currentPrecipitation {
        case 0.1..<2.5:
            
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
    
    
}


