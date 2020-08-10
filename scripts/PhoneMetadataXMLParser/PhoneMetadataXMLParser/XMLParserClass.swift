//
//  XMLParserClass.swift
//  PhoneMetadataXMLParser
//
//  Created by Rastaar Haghi on 8/5/20.
//  Copyright © 2020 Google LLC. All rights reserved.
//

import Foundation

class XMLParserClass: NSObject {
    
    
    
    
    var plist = Dictionary<String, Any>()
    
    func handleTerritory(territoryElement: XMLElement) -> PhoneMetadata {
        let phoneMetadata: PhoneMetadata = PhoneMetadata()
        
        // Set all possible attributes provided in a territory element.
        if let id = territoryElement.attribute(forName: "id") {
            phoneMetadata.codeID = (id.objectValue as! String)
        }
        // countryCode Int32?
        if let countryCode = territoryElement.attribute(forName: "countryCode") {
            if let countryCodeInt = Int32(countryCode.objectValue as! String) {
                phoneMetadata.countryCode = countryCodeInt
            }
        }
        // internationalPrefix: String?
        if let internationalPrefix = territoryElement.attribute(forName: "internationalPrefix") {
            phoneMetadata.internationalPrefix = (internationalPrefix.objectValue as! String)
        }
        
        // preferredInternationalPrefix: String?
        if let preferredInternationalPrefix = territoryElement.attribute(forName: "preferredInternationalPrefix") {
            phoneMetadata.preferredInternationalPrefix = (preferredInternationalPrefix.objectValue as! String)
        }
        // nationalPrefix: String?
        if let nationalPrefix = territoryElement.attribute(forName: "nationalPrefix") {
            phoneMetadata.nationalPrefix = (nationalPrefix.objectValue as! String)
        }
        // preferredExtnPrefix: String?
        if let preferredExtnPrefix = territoryElement.attribute(forName: "preferredExtnPrefix") {
            phoneMetadata.preferredExtnPrefix = (preferredExtnPrefix.objectValue as! String)
        }
        
        // nationalPrefixForParsing: String?
        if let nationalPrefixForParsing = territoryElement.attribute(forName: "nationalPrefixForParsing") {
            phoneMetadata.nationalPrefixForParsing = (nationalPrefixForParsing.objectValue as! String)
        }
        
        // nationalPrefixTransformRule: String?
        if let nationalPrefixTransformRule = territoryElement.attribute(forName: "nationalPrefixTransformRule") {
            phoneMetadata.nationalPrefixTransformRule = (nationalPrefixTransformRule.objectValue as! String)
        }
        
        // mainCountryForCode: Bool?
        if let mainCountryForCode = territoryElement.attribute(forName: "mainCountryForCode") {
            phoneMetadata.mainCountryForCode = (mainCountryForCode.objectValue as! NSString).boolValue
        }
        
        // leadingDigits: String?
        if let leadingDigits = territoryElement.attribute(forName: "leadingDigits") {
            phoneMetadata.leadingDigits = (leadingDigits.objectValue as! String)
        }
        
        if let leadingZeroPossible = territoryElement.attribute(forName: "leadingZeroPossible") {
            phoneMetadata.leadingZeroPossible = (leadingZeroPossible.objectValue as! NSString).boolValue
        }
        
        if let mobileNumberPortableRegion = territoryElement.attribute(forName: "mobileNumberPortableRegion") {
            phoneMetadata.mobileNumberPortableRegion = (mobileNumberPortableRegion.objectValue as! NSString).boolValue
        }
        
        // Create PhoneNumberDesc objects to place in territories available.
        if let generalDesc = territoryElement.elements(forName: "generalDesc").first {
            phoneMetadata.generalDesc = parsePhoneNumberDesc(phoneNumberDescElement: generalDesc)
        }
        
        if let fixedLine = territoryElement.elements(forName: "fixedLine").first {
            phoneMetadata.fixedLine = parsePhoneNumberDesc(phoneNumberDescElement: fixedLine)
        }
        
        if let mobile = territoryElement.elements(forName: "mobile").first {
            phoneMetadata.mobile = parsePhoneNumberDesc(phoneNumberDescElement: mobile)
        }
        
        if let tollFree = territoryElement.elements(forName: "tollFree").first {
            phoneMetadata.tollFree = parsePhoneNumberDesc(phoneNumberDescElement: tollFree)
        }
        
        if let premiumRate = territoryElement.elements(forName: "premiumRate").first {
            phoneMetadata.premiumRate = parsePhoneNumberDesc(phoneNumberDescElement: premiumRate)
        }
        
        if let sharedCost = territoryElement.elements(forName: "sharedCost").first {
            phoneMetadata.sharedCost = parsePhoneNumberDesc(phoneNumberDescElement: sharedCost)
        }
        
        if let personalNumber = territoryElement.elements(forName: "personalNumber").first {
            phoneMetadata.personalNumber = parsePhoneNumberDesc(phoneNumberDescElement: personalNumber)
        }
        
        if let voip = territoryElement.elements(forName: "voip").first {
            phoneMetadata.voip = parsePhoneNumberDesc(phoneNumberDescElement: voip)
        }
        
        if let pager = territoryElement.elements(forName: "pager").first {
            phoneMetadata.pager = parsePhoneNumberDesc(phoneNumberDescElement: pager)
        }
        
        if let uan = territoryElement.elements(forName: "uan").first {
            phoneMetadata.uan = parsePhoneNumberDesc(phoneNumberDescElement: uan)
        }
        
        if let voicemail = territoryElement.elements(forName: "voicemail").first {
            phoneMetadata.voicemail = parsePhoneNumberDesc(phoneNumberDescElement: voicemail)
        }
        
        if let noInternationalDialling = territoryElement.elements(forName: "noInternationalDialling").first {
            phoneMetadata.noInternationalDialling = parsePhoneNumberDesc(phoneNumberDescElement: noInternationalDialling)
        }
        
        if let emergency = territoryElement.elements(forName: "emergency").first {
            phoneMetadata.emergency = parsePhoneNumberDesc(phoneNumberDescElement: emergency)
        }
        
        if let shortCode = territoryElement.elements(forName: "shortCode").first {
            phoneMetadata.shortCode = parsePhoneNumberDesc(phoneNumberDescElement: shortCode)
        }
        
        if let standardRate = territoryElement.elements(forName: "standardRate").first {
            phoneMetadata.standardRate = parsePhoneNumberDesc(phoneNumberDescElement: standardRate)
        }
        
        if let carrierSpecific = territoryElement.elements(forName: "carrierSpecific").first {
            phoneMetadata.carrierSpecific = parsePhoneNumberDesc(phoneNumberDescElement: carrierSpecific)
        }
        
        if let smsServices = territoryElement.elements(forName: "smsServices").first {
            phoneMetadata.smsServices = parsePhoneNumberDesc(phoneNumberDescElement: smsServices)
        }
        
        let availableFormat = territoryElement.elements(forName: "availableFormats")
        if availableFormat.count > 0 {
            let numberFormats = availableFormat[0].elements(forName: "numberFormat")
            for numberFormat in numberFormats {
                let currNumberFormat: NumberFormat = parseNumberFormat(numberFormatElement: numberFormat)
                phoneMetadata.numberFormats.append(currNumberFormat)
                
                // should only have at most one intlFormat object per numberFormat object
                let intlFormatElement = numberFormat.elements(forName: "intlFormat")
                if intlFormatElement.count == 0 {
                    let intlFormat: NumberFormat = currNumberFormat
                    phoneMetadata.intlNumberFormats.append(intlFormat)
                } else if intlFormatElement[0].objectValue as! String != "NA" {
                    let intlFormat: NumberFormat = parseNumberFormat(numberFormatElement: intlFormatElement[0])
                    phoneMetadata.intlNumberFormats.append(intlFormat)
                }
                
            }
        }
        
        if phoneMetadata.mobile?.nationalNumberPattern != nil && phoneMetadata.mobile?.nationalNumberPattern == phoneMetadata.fixedLine?.nationalNumberPattern {
            phoneMetadata.sameMobileAndFixedLinePattern = true
        }
        
        return phoneMetadata
    }
    
    func parsePhoneNumberDesc(phoneNumberDescElement: XMLElement) -> PhoneNumberDesc {
        let phoneNumberDesc: PhoneNumberDesc = PhoneNumberDesc()
        let possibleLengths = phoneNumberDescElement.elements(forName: "possibleLengths")
        for _ in possibleLengths {
            // For a PhoneNumberDesc Object, we only expect one possibleLengths XML element.
            let length = possibleLengths[0]
            
            // EX: national = "6,8"
            if let nationalLength = length.attribute(forName: "national") {
                let nationalLengths = (nationalLength.objectValue as! String).split(separator: ",")
                for individualLength in nationalLengths {
                    phoneNumberDesc.possibleLength.append(Int32(individualLength))
                }
            }
            // EX: localOnly = "5,6,9"
            if let localOnly = length.attribute(forName: "localOnly") {
                let localOnlyLengths = (localOnly.objectValue as! String).split(separator: ",")
                for individualLength in localOnlyLengths {
//                    print(individualLength)
                    phoneNumberDesc.possibleLengthLocalOnly.append(Int32(individualLength))
                }
            }
        }
        
        let nationalNumberPattern = phoneNumberDescElement.elements(forName: "nationalNumberPattern")
        // Ensure that a nationalNumberPattern is provided before attempting to extract. 
        if nationalNumberPattern.count > 0 {
            phoneNumberDesc.nationalNumberPattern = (nationalNumberPattern[0].objectValue as! String).replacingOccurrences(of: " ", with: "")
        }
        
        let exampleNumber = phoneNumberDescElement.elements(forName: "exampleNumber")
        if exampleNumber.count > 0 {
            phoneNumberDesc.exampleNumber = (exampleNumber[0].objectValue as! String)
        }
        
        return phoneNumberDesc
    }

    func parseNumberFormat(numberFormatElement: XMLElement) -> NumberFormat {
        let numberFormat: NumberFormat = NumberFormat()
        
        if let pattern = numberFormatElement.attribute(forName: "pattern") {
            numberFormat.pattern = (pattern.objectValue as! String)
        }
        
        if let nationalPrefixFormattingRule = numberFormatElement.attribute(forName: "nationalPrefixFormattingRule") {
            numberFormat.nationalPrefixFormattingRule = (nationalPrefixFormattingRule.objectValue as! String)
        }
        
        if let nationalPrefixOptionalWhenFormatting = numberFormatElement.attribute(forName: "nationalPrefixOptionalWhenFormatting") {
            numberFormat.nationalPrefixOptionalWhenFormatting = (nationalPrefixOptionalWhenFormatting.objectValue as! NSString).boolValue
        }
        
        let leadingDigitsElements = numberFormatElement.elements(forName: "leadingDigits")
        for leadingDigitsElement in leadingDigitsElements {
            numberFormat.leadingDigitsPattern.append(leadingDigitsElement.objectValue as! String)
        }
        
        let format = numberFormatElement.elements(forName: "format")
        if format.count > 0 {
            numberFormat.format = (format[0].objectValue as! String)
        }
                
        return numberFormat
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    override init() {
        super.init()
        // Load metadata file from GitHub.
        let phoneMetadata = URL(string: "https://raw.githubusercontent.com/google/libphonenumber/master/resources/PhoneNumberMetadata.xml")!
//        let phoneMetadataForTesting = URL(string: "https://raw.githubusercontent.com/googlei18n/libphonenumber/master/javascript/i18n/phonenumbers/metadatafortesting.js")!
//        let shortNumberMetadata = URL(string: "https://raw.githubusercontent.com/googlei18n/libphonenumber/master/javascript/i18n/phonenumbers/shortnumbermetadata.js")!

        let currentDir = FileManager.default.currentDirectoryPath
        let baseURL = URL(fileURLWithPath: currentDir).appendingPathComponent("generatedJSON")
        try? FileManager.default.createDirectory(at: baseURL, withIntermediateDirectories: true)
        do {
            let metadata = try synchronouslyFetchMetadata(from: phoneMetadata)
            // Parse the file into XML Document using DOM
            let parser = try XMLDocument(data: metadata, options: [])
            let rootElement = parser.rootElement()
            let phoneMetadataCollection: PhoneMetadataCollection = PhoneMetadataCollection()
            
            // This stores all of the <territory> elements in file
            let territoriesElement = rootElement?.elements(forName: "territories")[0]
            for element in territoriesElement!.elements(forName: "territory") {
                phoneMetadataCollection.metadata.append(handleTerritory(territoryElement: element))
            }
            print(getDocumentsDirectory().appendingPathComponent("example.plist"))
//            let encoder = JSONEncoder()
//            let data = try encoder.encode(phoneMetadataCollection)
//            try data.write(to: URL(fileURLWithPath: "/Users/rastaar/Desktop/metadata.json"))
            let path = getDocumentsDirectory().appendingPathComponent("example.plist")
//                let plistEncoder = PropertyListEncoder()
//                let data = try plistEncoder.encode(phoneMetadataCollection.metadata)
            let data = try NSKeyedArchiver.archivedData(withRootObject: phoneMetadataCollection.metadata, requiringSecureCoding: false)
            print(data)
            print("HERE")
            try data.write(to: path)
        } catch {
            print(error)
        }
    }
}
