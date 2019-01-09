//
//  main.swift
//  TinyJSONPath
//
//  Created by Andi on 09.01.19.
//  Copyright © 2019 Andreas Binner. All rights reserved.
//

import Foundation

if let testfile = Bundle.main.url(forResource: "test", withExtension: "json") {
    do {
        let json = try Data(contentsOf: testfile)
        let jsonPath = TinyJSONPath(json: json)
        if jsonPath.isValid {
            if let res = jsonPath.evalPath(path: "store.book.*.author") {
                print(res)
            }
            if let res = jsonPath.evalPath(path: "store.book.[0].author") {
                print(res)
            }
            if let res = jsonPath.evalPath(path: "store.book.[1,3].author") {
                print(res)
            }
            if let res = jsonPath.evalPath(path: "store.*") {
                print(res)
            }
            if let res = jsonPath.evalPath(path: "store.@keys") {
                print(res)
            }
            if let res = jsonPath.evalPath(path: "store.@count") {
                print(res)
            }
            if let res = jsonPath.evalPath(path: "store.book.@count") {
                print(res)
            }
            if let res = jsonPath.evalPath(path: "coords.1.*") {
                print(res)
            }
        } else {
            print("JSON parsing failed: \(jsonPath.lastError ?? "")")
        }
    } catch {
        print("Failed to load test.json")
    }
} else {
    print("test.json not found")
}
