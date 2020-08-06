//
//  PhoneMetadataProtos.swift
//  PhoneMetadataXMLParser
//
//  Created by Rastaar Haghi on 8/5/20.
//  Copyright © 2020 Google LLC. All rights reserved.
//

import Foundation

// phonemetadata.proto
struct NumberFormat {
    var pattern: String!
    var format: String!
    var leading_digits_pattern: String?
    var national_prefix_formatting_rule: String?
    var national_prefix_optional_when_formatting: Bool? = false
    var domestic_carrier_code_formatting_rule: String?
}

class PhoneNumberDesc {
    var national_number_pattern: String?
    var possible_length: [Int32?] = []
    var possible_length_local_only: [Int32?] = []
    var example_number: String?
}

struct PhoneMetadata {
    var id: String = "" //
    var country_code: Int32? //
    var international_prefix: String? //
    var preferred_international_prefix: String? //
    var national_prefix: String? //
    var preferred_extn_prefix: String? //
    var national_prefix_for_parsing: String? //
    var national_prefix_transform_rule: String? //
    var same_mobile_and_fixed_line_pattern: Bool? = false
    var number_format: [NumberFormat] = []
    
    var intl_number_format: [NumberFormat] = []
    var main_country_for_code: Bool? = false //
    var leading_digits: String? //
    var leading_zero_possible: Bool? = false //
    var mobile_number_portable_region: Bool? = false //
    
    var general_desc: PhoneNumberDesc?
    var fixed_line: PhoneNumberDesc?
    var mobile: PhoneNumberDesc?
    var toll_free: PhoneNumberDesc?
    var premium_rate: PhoneNumberDesc?
    var shared_cost: PhoneNumberDesc?
    var personal_number: PhoneNumberDesc?
    var voip: PhoneNumberDesc?
    var pager: PhoneNumberDesc?
    var uan: PhoneNumberDesc?
    var emergency: PhoneNumberDesc?
    var voicemail: PhoneNumberDesc?
    var short_code: PhoneNumberDesc?
    var standard_rate: PhoneNumberDesc?
    var carrier_specific: PhoneNumberDesc?
    var sms_services: PhoneNumberDesc?
    var no_international_dialling: PhoneNumberDesc?
}

struct PhoneMetadataCollection {
    var metadata: PhoneMetadata
}

// phonenumber.proto
struct PhoneNumber {
    var country_code: Int32!
    var national_number: UInt64!
    var `extension`: String?
    var italian_leading_zero: Bool?
    var number_of_leading_zeros: Int32?
    var raw_input: String?
    
    enum CountryCodeSource {
        case UNSPECIFIED
        case FROM_NUMBER_WITH_PLUS_SIGN
        case FROM_NUMBER_WITH_IDD
        case FROM_NUMBER_WITHOUT_PLUS_SIGN
        case FROM_DEFAULT_COUNTRY
    }
    
    var preferred_domestic_carrier_code: String?
}
