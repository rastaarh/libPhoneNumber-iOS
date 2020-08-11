//
//  PhoneMetadataProtos.swift
//  PhoneMetadataXMLParser
//
//  Created by Rastaar Haghi on 8/5/20.
//  Copyright © 2020 Google LLC. All rights reserved.
//

// mark classes
import Foundation

class NumberFormat: NSObject, NSCoding, Codable {
    func encode(with coder: NSCoder) {
        coder.encode(pattern, forKey: "pattern")
        coder.encode(format, forKey: "format")
        coder.encode(leadingDigitsPattern, forKey: "leadingDigitsPattern")
        coder.encode(nationalPrefixFormattingRule, forKey: "nationalPrefixFormattingRule")
        coder.encode(nationalPrefixOptionalWhenFormatting, forKey: "nationalPrefixOptionalWhenFormatting")
        coder.encode(domesticCarrierCodeFormattingRule, forKey: "domesticCarrierCodeFormattingRule")
    }
    
    required init?(coder: NSCoder) {
        if(coder.decodeObject(forKey: "pattern") == nil) {
            print("Pattern was nil")
            
        }
        self.pattern = (coder.decodeObject(forKey: "pattern") as! String)
        self.format = (coder.decodeObject(forKey: "format") as! String)
        self.leadingDigitsPattern = coder.decodeObject(forKey: "leadingDigitsPattern") as! Array<String>
        self.nationalPrefixFormattingRule = coder.decodeObject(forKey: "nationalPrefixFormattingRule") as? String
        self.nationalPrefixOptionalWhenFormatting = coder.decodeObject(forKey: "nationalPrefixOptionalWhenFormatting") as? Bool
        self.domesticCarrierCodeFormattingRule = coder.decodeObject(forKey: "domesticCarrierCodeFormattingRule") as? String
    }
    
    override init() {
        self.leadingDigitsPattern = []
    }
    
    var pattern: String!
    var format: String!
    var leadingDigitsPattern: [String]
    var nationalPrefixFormattingRule: String?
    var nationalPrefixOptionalWhenFormatting: Bool? = false
    var domesticCarrierCodeFormattingRule: String?
}

class PhoneNumberDesc: NSObject, NSCoding, Codable {
    func encode(with coder: NSCoder) {
        
        coder.encode(nationalNumberPattern, forKey: "nationalNumberPattern")
        coder.encode(possibleLength, forKey: "possibleLength")
        coder.encode(possibleLengthLocalOnly, forKey: "possibleLengthLocalOnly")
        coder.encode(exampleNumber, forKey: "exampleNumber")
    }
    
    required init?(coder: NSCoder) {
        self.nationalNumberPattern = (coder.decodeObject(forKey: "nationalNumberPattern") as? String)
        self.possibleLength = (coder.decodeObject(forKey: "possibleLength") as! [Int32?])
        self.possibleLengthLocalOnly = (coder.decodeObject(forKey: "possibleLengthLocalOnly") as! [Int32?])
        self.exampleNumber = (coder.decodeObject(forKey: "exampleNumber") as? String)
    }
    
    override init() {}
    
    var nationalNumberPattern: String?
    var possibleLength: [Int32?] = []
    var possibleLengthLocalOnly: [Int32?] = []
    var exampleNumber: String?
}

class PhoneMetadata: NSObject, NSCoding, Codable {
    func encode(with coder: NSCoder) {
        // Handle PhoneNumberDesc encodings.
        coder.encode(generalDesc, forKey: "generalDesc")
        coder.encode(fixedLine, forKey: "fixedLine")
        coder.encode(mobile, forKey: "mobile")
        coder.encode(tollFree, forKey: "tollFree")
        coder.encode(premiumRate, forKey: "premiumRate")
        coder.encode(sharedCost, forKey: "sharedCost")
        coder.encode(personalNumber, forKey: "personalNumber")
        coder.encode(voip, forKey: "voip")
        coder.encode(pager, forKey: "pager")
        coder.encode(uan, forKey: "uan")
        coder.encode(emergency, forKey: "emergency")
        coder.encode(voicemail, forKey: "voicemail")
        coder.encode(shortCode, forKey: "shortCode")
        coder.encode(standardRate, forKey: "standardRate")
        coder.encode(carrierSpecific, forKey: "carrierSpecific")
        coder.encode(smsServices, forKey: "smsServices")
        coder.encode(noInternationalDialling, forKey: "noInternationalDialling")
        
        // Handle other encodings.
        coder.encode(codeID, forKey: "codeID")
        coder.encode(countryCode, forKey: "countryCode")
        coder.encode(internationalPrefix, forKey: "internationalPrefix")
        coder.encode(preferredInternationalPrefix, forKey: "preferredInternationalPrefix")
        coder.encode(nationalPrefix, forKey: "nationalPrefix")
        coder.encode(preferredExtnPrefix, forKey: "preferredExtnPrefix")
        coder.encode(nationalPrefixForParsing, forKey: "nationalPrefixForParsing")
        coder.encode(nationalPrefixTransformRule, forKey: "nationalPrefixTransformRule")
        coder.encode(sameMobileAndFixedLinePattern, forKey: "sameMobileAndFixedLinePattern")
        coder.encode(numberFormats, forKey: "numberFormats")
        coder.encode(intlNumberFormats, forKey: "intlNumberFormats")
        coder.encode(mainCountryForCode, forKey: "mainCountryForCode")
        coder.encode(leadingDigits, forKey: "leadingDigits")
        coder.encode(leadingZeroPossible, forKey: "leadingZeroPossible")
        coder.encode(mobileNumberPortableRegion, forKey: "mobileNumberPortableRegion")
    }
    
    required init?(coder: NSCoder) {
        generalDesc = (coder.decodeObject(forKey: "generalDesc") as? PhoneNumberDesc)
        fixedLine = (coder.decodeObject(forKey: "fixedLine") as? PhoneNumberDesc)
        mobile = (coder.decodeObject(forKey: "mobile") as? PhoneNumberDesc)
        tollFree = (coder.decodeObject(forKey: "tollFree") as? PhoneNumberDesc)
        premiumRate = (coder.decodeObject(forKey: "premiumRate") as? PhoneNumberDesc)
        sharedCost = (coder.decodeObject(forKey: "sharedCost") as? PhoneNumberDesc)
        personalNumber = (coder.decodeObject(forKey: "personalNumber") as? PhoneNumberDesc)
        voip = (coder.decodeObject(forKey: "voip") as? PhoneNumberDesc)
        pager = (coder.decodeObject(forKey: "pager") as? PhoneNumberDesc)
        uan = (coder.decodeObject(forKey: "uan") as? PhoneNumberDesc)
        emergency = (coder.decodeObject(forKey: "emergency") as? PhoneNumberDesc)
        voicemail = (coder.decodeObject(forKey: "voicemail") as? PhoneNumberDesc)
        shortCode = (coder.decodeObject(forKey: "shortCode") as? PhoneNumberDesc)
        standardRate = (coder.decodeObject(forKey: "standardRate") as? PhoneNumberDesc)
        carrierSpecific = (coder.decodeObject(forKey: "carrierSpecific") as? PhoneNumberDesc)
        smsServices = (coder.decodeObject(forKey: "smsServices") as? PhoneNumberDesc)
        noInternationalDialling = (coder.decodeObject(forKey: "noInternationalDialling") as? PhoneNumberDesc)

        codeID = (coder.decodeObject(forKey: "codeID") as! String)
        countryCode = (coder.decodeObject(forKey: "countryCode") as? Int32)
        internationalPrefix = (coder.decodeObject(forKey: "internationPrefix") as? String)
        preferredInternationalPrefix = (coder.decodeObject(forKey: "preferredInternationalPrefix") as? String)
        nationalPrefix = (coder.decodeObject(forKey: "nationalPrefix") as? String)
        preferredExtnPrefix = (coder.decodeObject(forKey: "preferredExtnPrefix") as? String)
        nationalPrefixForParsing = (coder.decodeObject(forKey: "nationalPrefixForParsing") as? String)
        nationalPrefixTransformRule = (coder.decodeObject(forKey: "nationalPrefixTransformRule") as? String)
        sameMobileAndFixedLinePattern = (coder.decodeObject(forKey: "sameMobileAndFixedLinePattern") as? Bool)
        numberFormats = (coder.decodeObject(forKey: "numberFormats") as! [NumberFormat])
        intlNumberFormats = (coder.decodeObject(forKey: "intlNumberFormats") as! [NumberFormat])
        mainCountryForCode = (coder.decodeObject(forKey: "mainCountryForCode") as? Bool)
        leadingDigits = (coder.decodeObject(forKey: "leadingDigits") as? String)
        leadingZeroPossible = (coder.decodeObject(forKey: "leadingZeroPossible") as? Bool)
        mobileNumberPortableRegion = (coder.decodeObject(forKey: "mobileNumberPortableRegion") as? Bool)
    }
    
    override init() {
        codeID = ""
    }
    
    var generalDesc: PhoneNumberDesc?
    var fixedLine: PhoneNumberDesc?
    var mobile: PhoneNumberDesc?
    var tollFree: PhoneNumberDesc?
    var premiumRate: PhoneNumberDesc?
    var sharedCost: PhoneNumberDesc?
    var personalNumber: PhoneNumberDesc?
    var voip: PhoneNumberDesc?
    var pager: PhoneNumberDesc?
    var uan: PhoneNumberDesc?
    var emergency: PhoneNumberDesc?
    var voicemail: PhoneNumberDesc?
    var shortCode: PhoneNumberDesc?
    var standardRate: PhoneNumberDesc?
    var carrierSpecific: PhoneNumberDesc?
    var smsServices: PhoneNumberDesc?
    var noInternationalDialling: PhoneNumberDesc?
    
    var codeID: String!
    var countryCode: Int32?
    var internationalPrefix: String?
    var preferredInternationalPrefix: String?
    var nationalPrefix: String?
    var preferredExtnPrefix: String?
    var nationalPrefixForParsing: String?
    var nationalPrefixTransformRule: String?
    var sameMobileAndFixedLinePattern: Bool? = false
    var numberFormats: [NumberFormat] = []
    var intlNumberFormats: [NumberFormat] = []
    var mainCountryForCode: Bool? = false
    var leadingDigits: String?
    var leadingZeroPossible: Bool? = false
    var mobileNumberPortableRegion: Bool? = false
}

class PhoneMetadataCollection: NSObject, NSCoding, Codable {
    var metadata: [PhoneMetadata]

    func encode(with coder: NSCoder) {
        coder.encode(metadata, forKey: "metadata")
    }
    
    required init?(coder: NSCoder) {
        metadata = (coder.decodeObject(forKey: "metadata") as! [PhoneMetadata])
    }
    
    override init() {
        metadata = []
    }
}

struct PhoneNumber {
    var countryCode: Int32!
    var nationalNumber: UInt64!
    var `extension`: String?
    var italianLeadingZero: Bool?
    var numberOfLeadingZeros: Int32?
    var rawInput: String?
    
    enum CountryCodeSource {
        case UNSPECIFIED
        case FROM_NUMBER_WITH_PLUS_SIGN
        case FROM_NUMBER_WITH_IDD
        case FROM_NUMBER_WITHOUT_PLUS_SIGN
        case FROM_DEFAULT_COUNTRY
    }
    
    var countryCodeSource: CountryCodeSource?
    var preferredDomesticCarrierCode: String?
}
