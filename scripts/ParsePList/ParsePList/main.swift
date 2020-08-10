//
//  main.swift
//  ParsePList
//
//  Created by Rastaar Haghi on 8/7/20.
//  Copyright © 2020 Google LLC. All rights reserved.
//

import Foundation
import libPhoneNumber_iOS

print("Hello, World!")
do {
    let fileManager = FileManager.default
    let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
    let path = documentDirectory.appending("/example.plist")
    if (fileManager.fileExists(atPath: path)) {
        let data = try Data(contentsOf: URL(fileURLWithPath: path))
        let plist = try! PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil)
            as! [String: Any]
        let arr = plist["metadata"] as! NSArray
        
        var metadata: [NBPhoneMetaData] = [NBPhoneMetaData]()
        
        let archiver = NSKeyedArchiver(requiringSecureCoding: false)
        archiver.encode(metadata as NSArray)
        
        
//        for element in arr {
//            let archiver = NSKeyedArchiver(requiringSecureCoding: false)
//            archiver.encode(element)
//            let obj = NBPhoneMetaData(coder: archiver)
//        }
        print(metadata.count)
    } else {
        print("File already exists")
    }
}
