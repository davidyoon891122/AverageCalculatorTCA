//
//  PlistReader.swift
//  AveragePriceCalculator
//
//  Created by Davidyoon on 11/21/24.
//

import Foundation

enum PlistType: String {
    
    static let `extension` = "plist"
    
    case admobInfo = "AdmobBanner-Info"
    
}

enum AdmobConstants {
    #if DEBUG
    static let admobId: String = "AdUnitID"
    #else
    static let admobId: String = "AdUnitIDDev"
    #endif
}

struct PlistReader {
    
    func getValueFromPlist(plistName: PlistType, key: String) -> String {
        
        guard let filePath = Bundle.main.path(forResource: plistName.rawValue, ofType: PlistType.extension),
              let plist = NSDictionary(contentsOfFile: filePath) else {
            fatalError("Couldn't find file \(plistName.rawValue).\(PlistType.extension)")
        }
        
        guard let value = plist.object(forKey: key) as? String else {
            fatalError("Couldn't find \(key) from \(plistName.rawValue).\(PlistType.extension)")
        }
        
        return value
    }
    
}
