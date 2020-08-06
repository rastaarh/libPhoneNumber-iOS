
//
//  metadataGenerator.swift
//  libPhoneNumber-iOS
//
//  Created by Paween Itthipalkul on 2/16/18.
//  Copyright © 2018 Google LLC. All rights reserved.
//

import Foundation

enum GeneratorError: Error {
  case dataNotString
  case genericError
}

func synchronouslyFetchMetadata(from url: URL) throws -> Data {
  let session = URLSession(configuration: .default)
  var resultData: Data?
  var resultError: Error?
  let semaphore = DispatchSemaphore(value: 0)

  let dataTask = session.dataTask(with: url) { data, _, error in
    resultData = data
    resultError = error
    semaphore.signal()
  }
  dataTask.resume()
  semaphore.wait()
    
  if let error = resultError {
    throw error
  }

  if let data = resultData {
    return data
  }
  throw GeneratorError.genericError
}

// Load metadata file from GitHub.
let phoneMetadata = URL(string: "https://raw.githubusercontent.com/google/libphonenumber/master/resources/PhoneNumberMetadata.xml")!
let phoneMetadataForTesting = URL(string: "https://raw.githubusercontent.com/googlei18n/libphonenumber/master/javascript/i18n/phonenumbers/metadatafortesting.js")!
let shortNumberMetadata = URL(string: "https://raw.githubusercontent.com/googlei18n/libphonenumber/master/javascript/i18n/phonenumbers/shortnumbermetadata.js")!

let currentDir = FileManager.default.currentDirectoryPath
let baseURL = URL(fileURLWithPath: currentDir).appendingPathComponent("generatedJSON")
try? FileManager.default.createDirectory(at: baseURL, withIntermediateDirectories: true)

// Phone metadata.
do {
    let metadata = try synchronouslyFetchMetadata(from: phoneMetadata)
    // Parse the file into XML Document using DOM
    let parser1 = XMLParser(data: metadata)
    parser1.parse()
    
}


struct territory {
    var id: String?
    var countryCode: String?
    var internationalPrefix: String?
    var fixedLine: fixedLine?
    var mobileLine: mobile?
}

struct generalDesc {
    var nationalNumberPattern: String
}

struct fixedLine {
    var nationalLength: String
    var exampleNumber: String
    var nationalNumberPattern: String
}

struct mobile {
    var nationalLength: String
    var exampleNumber: String
    var nationalNumberPattern: String
}

func parser(parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
    print(attributeDict)
    print("HERE")
    if elementName == "territory" {
        var tempTag: territory  = territory()
        if let name = attributeDict["id"] {
            tempTag.id = name;
        }
        if let c = attributeDict["countryCode"] {
            tempTag.countryCode = c
        }
        if let internationPrefix = attributeDict["internationalPrefix"] {
            tempTag.internationalPrefix = internationPrefix
        }
        print("Territory: \(tempTag)")
    }
}
