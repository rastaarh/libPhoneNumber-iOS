//
//  main.swift
//  PhoneMetadataXMLParser
//
//  Created by Rastaar Haghi on 8/5/20.
//  Copyright © 2020 Google LLC. All rights reserved.
//

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

struct Stack {
    private var elements: [NSObject] = []
    
    func top() -> NSObject {
        guard let top = elements.first else { fatalError("This stack is empty")}
        return top
    }
    
    mutating func pop() {
        elements.removeFirst()
        print("Updated stack size: \(elements.count)")
    }
    
    mutating func push(_ element: NSObject) {
        elements.insert(element, at: 0)
        print("Updated stack size: \(elements.count)")
    }
}

//var phoneNumberDesc: PhoneNumberDesc?
//var stack = Stack()

let xmlParser = XMLParserClass()
