//
//  main.swift
//  PhoneMetadataXMLParser
//
//  Created by Rastaar Haghi on 8/5/20.
//  Copyright © 2020 Google LLC. All rights reserved.
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

let xmlParser = XMLParserClass()
