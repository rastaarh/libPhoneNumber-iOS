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
    
    func handleTerritory(territoryElement: XMLElement) {
        var phoneMetadata: PhoneMetadata = PhoneMetadata()
        
        if let id = territoryElement.attribute(forName: "id") {
            phoneMetadata.id = (id.objectValue as! String)
        }
        // countryCode Int32?
        if let countryCode = territoryElement.attribute(forName: "countryCode") {
            if let countryCodeInt = Int32(countryCode.objectValue as! String) {
                phoneMetadata.country_code = countryCodeInt
            }
        }
        // internationalPrefix: String?
        if let internationalPrefix = territoryElement.attribute(forName: "internationalPrefix") {
            phoneMetadata.international_prefix = (internationalPrefix.objectValue as! String)
        }
        
        // preferredInternationalPrefix: String?
        if let preferredInternationalPrefix = territoryElement.attribute(forName: "preferredInternationalPrefix") {
            phoneMetadata.preferred_international_prefix = (preferredInternationalPrefix.objectValue as! String)
        }
        // nationalPrefix: String?
        if let nationalPrefix = territoryElement.attribute(forName: "nationalPrefix") {
            phoneMetadata.national_prefix = (nationalPrefix.objectValue as! String)
        }
        // preferredExtnPrefix: String?
        if let preferredExtnPrefix = territoryElement.attribute(forName: "preferredExtnPrefix") {
            phoneMetadata.preferred_extn_prefix = (preferredExtnPrefix.objectValue as! String)
        }
        
        // nationalPrefixForParsing: String?
        if let nationalPrefixForParsing = territoryElement.attribute(forName: "nationalPrefixForParsing") {
            phoneMetadata.national_prefix_for_parsing = (nationalPrefixForParsing.objectValue as! String)
        }
        
        // nationalPrefixTransformRule: String?
        if let nationalPrefixTransformRule = territoryElement.attribute(forName: "nationalPrefixTransformRule") {
            phoneMetadata.national_prefix_transform_rule = (nationalPrefixTransformRule.objectValue as! String)
        }
        
        // mainCountryForCode: Bool?
        if let mainCountryForCode = territoryElement.attribute(forName: "mainCountryForCode") {
            phoneMetadata.main_country_for_code = (mainCountryForCode.objectValue as! NSString).boolValue
        }
        
        // leadingDigits: String?
        if let leadingDigits = territoryElement.attribute(forName: "leadingDigits") {
            phoneMetadata.leading_digits = (leadingDigits.objectValue as! String)
        }
        
        if let leadingZeroPossible = territoryElement.attribute(forName: "leadingZeroPossible") {
            phoneMetadata.leading_zero_possible = (leadingZeroPossible.objectValue as! NSString).boolValue
        }
        
        if let mobileNumberPortableRegion = territoryElement.attribute(forName: "mobileNumberPortableRegion") {
            phoneMetadata.mobile_number_portable_region = (mobileNumberPortableRegion.objectValue as! NSString).boolValue
        }
        
        if let generalDesc = territoryElement.elements(forName: "generalDesc").first {
            phoneMetadata.general_desc = parsePhoneNumberDesc(phoneNumberDescElement: generalDesc)
        }
        
        if let fixedLine = territoryElement.elements(forName: "fixedLine").first {
            phoneMetadata.fixed_line = parsePhoneNumberDesc(phoneNumberDescElement: fixedLine)
        }
        
        if let mobile = territoryElement.elements(forName: "mobile").first {
            phoneMetadata.mobile = parsePhoneNumberDesc(phoneNumberDescElement: mobile)
        }
        
        if let tollFree = territoryElement.elements(forName: "tollFree").first {
            phoneMetadata.toll_free = parsePhoneNumberDesc(phoneNumberDescElement: tollFree)
        }
        
        if let premiumRate = territoryElement.elements(forName: "premiumRate").first {
            phoneMetadata.premium_rate = parsePhoneNumberDesc(phoneNumberDescElement: premiumRate)
        }
        
        if let sharedCost = territoryElement.elements(forName: "sharedCost").first {
            phoneMetadata.shared_cost = parsePhoneNumberDesc(phoneNumberDescElement: sharedCost)
        }
        
        if let personalNumber = territoryElement.elements(forName: "personalNumber").first {
            phoneMetadata.personal_number = parsePhoneNumberDesc(phoneNumberDescElement: personalNumber)
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
            phoneMetadata.no_international_dialling = parsePhoneNumberDesc(phoneNumberDescElement: noInternationalDialling)
        }
        
        if let voicemail = territoryElement.elements(forName: "voicemail").first {
            phoneMetadata.voicemail = parsePhoneNumberDesc(phoneNumberDescElement: voicemail)
        }
        
//        print(phoneMetadata)
        
    }
    
    func parsePhoneNumberDesc(phoneNumberDescElement: XMLElement) -> PhoneNumberDesc {
        let phoneNumberDesc: PhoneNumberDesc = PhoneNumberDesc()
        let possibleLengths = phoneNumberDescElement.elements(forName: "possibleLengths")
        for _ in possibleLengths {
            let length = possibleLengths[0]
            if let nationalLength = length.attribute(forName: "national") {
                phoneNumberDesc.possible_length.append(Int32(nationalLength.objectValue as! String))
                print("Possible Length: \(phoneNumberDesc.possible_length)")
            }
            if let localOnly = length.attribute(forName: "localOnly") {
                phoneNumberDesc.possible_length_local_only.append(Int32(localOnly.objectValue as! String))
                print("Possible local only length: \(phoneNumberDesc.possible_length_local_only)")
            }
        }
        
        let nationalNumberPattern = phoneNumberDescElement.elements(forName: "nationalNumberPattern")
        if nationalNumberPattern.count > 0 {
            phoneNumberDesc.national_number_pattern = (nationalNumberPattern[0].objectValue as! String)
            print("National number pattern: \(String(describing: phoneNumberDesc.national_number_pattern))")
        }
        
        let exampleNumber = phoneNumberDescElement.elements(forName: "exampleNumber")
        if exampleNumber.count > 0 {
            phoneNumberDesc.example_number = (exampleNumber[0].objectValue as! String)
            print("Example Number: \(String(describing: phoneNumberDesc.example_number))")
        }
        return phoneNumberDesc
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

        // Phone metadata
        do {
            let metadata = try synchronouslyFetchMetadata(from: phoneMetadata)
            // Parse the file into XML Document using DOM
            let parser = try XMLDocument(data: metadata, options: [])
            let rootElement = parser.rootElement()
            
            // This stores all of the <territory> elements in file
            let territoriesElement = rootElement?.elements(forName: "territories")[0]
            for element in territoriesElement!.elements(forName: "territory") {
                handleTerritory(territoryElement: element)
            }
            
        } catch {
            print("Error reached")
        }
    }
}
