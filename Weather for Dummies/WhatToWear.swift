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


let precipitationAndHumidity = ["dry, ", "humid, ", "foggy, ", "raining, ", "pouring, ", "snowing, ", "hailing, "]

//let windyOrNot = ["and not windy.", "and windy."]

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
    currentVisibility: Double?,
    darkskyIconName: String?
    ) {
    
    resetParameters()
    
    guard let currentTemperature = currentTemperature else { return }
    guard let currentPrecipitation = currentPrecipitation else { return }
    guard let currentHumidity = currentHumidity else { return }
    guard let currentPrecipitationProbability = currentPrecipProbability else { return }
    guard let currentDewPoint = currentDewPoint else { return }
    guard let currentVisibility = currentVisibility else { return }
    let currentPrecipType: String = currentPrecipType ?? "n/a"
    let darkskyIconName: String = darkskyIconName ?? "clear-day"
    
    let differenceBetweenCurrentTemperatureAndDewPoint = currentTemperature - currentDewPoint
    
    print("currentTemperature: \(currentTemperature)")
    print("currentPrecipitation: \(currentPrecipitation)")
    print("currentHumidity: \(currentHumidity)")
    print("currentPrecipitationProbability: \(currentPrecipitationProbability)")
    print("currentDewPoint: \(currentDewPoint)")
    print("differenceBetweenCurrentTemperatureAndDewPoint: \(differenceBetweenCurrentTemperatureAndDewPoint)")
    print("currentPrecipType: \(currentPrecipType)")
    print("currentVisibility: \(currentVisibility)")

//    let hotOrCold = ["It is extremely hot, ", "It is very hot, ", "It is hot, ", "It is pretty warm, ", "It is warm, ", "It is chilly, ", "It is cold, ", "It is very cold, ", "It is really cold, ", "It is freezing, ", "It is dangerously cold, "]

    // TEMPERATURE
    
    switch currentTemperature {
    case ..<(-30):
        outputPhrase = "It is dangerously cold, "
        numberOfLayers = 4
        dangerouslyCold = true
    case -200..<(-20):
        outputPhrase = "It is freezing, "
        numberOfLayers = 4
    case -20..<(-10):
        outputPhrase = "It is really cold, "
        numberOfLayers = 3
    case -10..<0:
        outputPhrase = "It is very cold, "
        numberOfLayers = 3
    case 0..<8:
        outputPhrase = "It is cold, "
        numberOfLayers = 3
    case 8..<15:
        outputPhrase = "It is chilly, "
        numberOfLayers = 2
    case 15..<20:
        outputPhrase = "It is nice out, "
        numberOfLayers = 1
    case 20..<25:
        outputPhrase = "It is warm, "
        numberOfLayers = 1
    case 25..<30:
        outputPhrase = "It is hot, "
        numberOfLayers = 1
    case 30..<35:
        outputPhrase = "It is very hot, "
        numberOfLayers = 1
        
        if darkskyIconName == "clear-day" {
            wearHat = true
        }
    case 35...:
        outputPhrase = "It is extremely hot, "
        numberOfLayers = 1
        
        dangerouslyHot = true
        if darkskyIconName == "clear-day" {
            wearHat = true
        }
    default:
        print("something wrong with the temperature")
    }
    
    // HUMIDITY
    
    // no precipitation, just evaluate humidity
    if currentPrecipitation == 0 && currentPrecipitationProbability < 0.1 {
    
        switch currentHumidity {
        // dry when humidity is less than 30%
        case ..<30:
            middleOfPhrase = "dry, "
        // humid when temp & dew point are high enough, and there's no precipitation
        case 50..<99 where currentTemperature > 16 && currentPrecipitation < 0.1 && currentDewPoint > 16:
            middleOfPhrase = "humid, "
        case 99... where currentTemperature > 16 && currentPrecipitation < 0.1 && currentDewPoint > 16:
            middleOfPhrase = "foggy, "
        default: break
        }
    
    // deal with precipitation
    } else {
        
        numberOfLayers += 1
        
        // RAIN
        
        if currentPrecipType == "rain" {
            
            print("it's raining!")
    
            switch currentPrecipitation {
            case 0.1..<2.5:
                middleOfPhrase = "raining a little, "
            case 2.5..<7.6:
                middleOfPhrase = "raining, "
            case 7.6..<50:
                middleOfPhrase = "pouring, "
            case 50...:
                middleOfPhrase = "rain violently, "
            default:
                print("something wrong with rain")
            }
            
        // SNOW
        
        } else if currentPrecipType == "snow" {
            
            print("it's snowing!")
            
            switch currentVisibility {
            case ..<0.4:
                middleOfPhrase = "snowing heavily, "
            case 0.4..<0.8:
                middleOfPhrase = "snowing, "
            case 0.8...:
                middleOfPhrase = "snowing a little bit, "
            default:
                print("something wrong with snow")
            }
            
        }
        
        outputPhrase.append(middleOfPhrase)
    }
    
    // WIND
    endOfPhrase = numberOfLayers > 1 ? "and you should wear \(numberOfLayers) layers." : "and one layer should be enough."
    
    outputPhrase.append(endOfPhrase)
    
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


