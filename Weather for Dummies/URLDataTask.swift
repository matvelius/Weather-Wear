//
//  URLDataTask.swift
//  Weather for Dummies
//
//  Created by Matvey on 7/10/19.
//  Copyright © 2019 Matvey. All rights reserved.
//

import Foundation

// weird async issue

func getJSONFromURL(url: URL) -> [String: AnyObject] {
    
    var jsonToReturn: [String: AnyObject] = [:]
    
    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        
        guard let dataReceived = data else {
            print("didn't receive deta")
            return
        }
        
        do {
            let json = try JSONSerialization.jsonObject(with: dataReceived, options: .mutableContainers) as! [String: AnyObject]
            jsonToReturn = json
        }
        catch let jsonError {
            print(jsonError)
        }
        
    }
    
    task.resume()
    
    return jsonToReturn

}
