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

var middleOfPhrase = ""
var endOfPhrase = ""

var outputPhrase = ""


func evaluateWeather(
    currentTemperature: Double?,
    currentPrecipitation: Double?,
    currentHumidity: Int?,
    currentPrecipProbability: Double?,
    currentDewPoint: Double?,
    currentPrecipType: String?,
    currentVisibility: Double?
    ) {
    
    resetParameters()
    
    guard let currentTemperature = currentTemperature else { return }
    guard let currentPrecipitation = currentPrecipitation else { return }
    guard let currentHumidity = currentHumidity else { return }
    guard let currentPrecipitationProbability = currentPrecipProbability else { return }
    guard let currentDewPoint = currentDewPoint else { return }
    guard let currentVisibility = currentVisibility else { return }
    let currentPrecipType: String = currentPrecipType ?? "n/a"
    
    let differenceBetweenCurrentTemperatureAndDewPoint = currentTemperature - currentDewPoint
    
    print("currentTemperature: \(currentTemperature)")
    print("currentPrecipitation: \(currentPrecipitation)")
    print("currentHumidity: \(currentHumidity)")
    print("currentPrecipitationProbability: \(currentPrecipitationProbability)")
    print("currentDewPoint: \(currentDewPoint)")
    print("differenceBetweenCurrentTemperatureAndDewPoint: \(differenceBetweenCurrentTemperatureAndDewPoint)")
    print("currentPrecipType: \(currentPrecipType)")
    print("currentVisibility: \(currentVisibility)")

    
    switch currentTemperature {
    case ..<(-30):
        outputPhrase = hotOrCold[hotOrCold.count - 1]
        numberOfLayers = 4
        dangerouslyCold = true
    case -20..<(-20):
        outputPhrase = hotOrCold[hotOrCold.count - 2]
        numberOfLayers = 4
    case -20..<(-10):
        outputPhrase = hotOrCold[hotOrCold.count - 3]
        numberOfLayers = 3
    case -10..<0:
        outputPhrase = hotOrCold[hotOrCold.count - 4]
        numberOfLayers = 3
    case 0..<8:
        outputPhrase = hotOrCold[hotOrCold.count - 5]
        numberOfLayers = 3
    case 8..<16:
        outputPhrase = hotOrCold[hotOrCold.count - 6]
        numberOfLayers = 2
    case 16..<25:
        outputPhrase = hotOrCold[hotOrCold.count - 7]
        numberOfLayers = 1
    case 25..<28:
        outputPhrase = hotOrCold[hotOrCold.count - 8]
        numberOfLayers = 1
    case 28..<35:
        outputPhrase = hotOrCold[hotOrCold.count - 9]
        numberOfLayers = 1
    case 35..<42:
        outputPhrase = hotOrCold[hotOrCold.count - 10]
        numberOfLayers = 1
    case 42...:
        outputPhrase = hotOrCold[hotOrCold.count - 11]
        numberOfLayers = 1
        dangerouslyHot = true
    default:
        print("something wrong with the temperature")
    }
    
    // no precipitation, just evaluate humidity
    if currentPrecipitation == 0 && currentPrecipitationProbability < 0.1 {
    
        switch currentHumidity {
        // dry when humidity is less than 30%
        case ..<30:
            outputPhrase.append(precipitationAndHumidity[0])
        // humid when temp & dew point are high enough, and there's no precipitation
        case 50... where currentTemperature > 16 && currentPrecipitation < 0.1 && currentDewPoint > 16:
            outputPhrase.append(precipitationAndHumidity[1])
        default: break
        }
    
    // deal with precipitation
    } else {
        
        if currentPrecipType == "rain" {
    
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
                print("something wrong with rain")
            }
        
        } else if currentPrecipType == "snow" {
            
            switch currentVisibility {
            case ..<0.4:
                print("snowing heavily.")
            case 0.4..<0.8:
                print("snowing.")
            case 0.8...:
                print("snowing a bit.")
            default:
                print("something wrong with snow")
            }
            
        }
    }
    
    
}

func resetParameters() {
    dangerouslyHot = false
    dangerouslyCold = false
    calamityWarning = false
    
    bringCoatOrUmbrella = false
    waterproofShoes = false
    wearHat = false
    wearSweater = false
    wearGloves = false
    
    numberOfLayers = 1
}


