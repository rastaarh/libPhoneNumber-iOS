//
//  PhoneMetadataProtos.swift
//  PhoneMetadataXMLParser
//
//  Created by Rastaar Haghi on 8/5/20.
//  Copyright © 2020 Google LLC. All rights reserved.
//

// class, NSCoder protocol
// use nskeyedarchiver

import Foundation

struct NumberFormat: Codable {
    var pattern: String!
    var format: String!
    var leadingDigitsPattern: [String]
    var nationalPrefixFormattingRule: String?
    var nationalPrefixOptionalWhenFormatting: Bool? = false
    var domesticCarrierCodeFormattingRule: String?
}

struct PhoneNumberDesc: Codable {
    var nationalNumberPattern: String?
    var possibleLength: [Int32?] = []
    var possibleLengthLocalOnly: [Int32?] = []
    var exampleNumber: String?
}

struct PhoneMetadata: Codable {
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

struct PhoneMetadataCollection: Codable {
    var metadata: [PhoneMetadata] = []
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
