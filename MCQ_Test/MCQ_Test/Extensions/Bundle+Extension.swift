//
//  Bundle+Extension.swift
//  MCQ_Test
//
//  Created by Ramprasad A on 05/01/18.
//  Copyright © 2018 Ramprasad A. All rights reserved.
//

import Foundation

extension Bundle {
    
    func parsePlist(ofName name: String) -> [String: AnyObject]? {
        
        // check if plist data available
        guard let plistURL = Bundle.main.url(forResource: name, withExtension: "plist"),
            let data = try? Data(contentsOf: plistURL)
            else {
                return nil
        }
        
        // parse plist into [String: Anyobject]
        guard let plistDictionary = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: AnyObject] else {
            return nil
        }
        
        return plistDictionary
    }
}
