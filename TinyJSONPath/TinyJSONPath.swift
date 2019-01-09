//
//  TinyJSONPath.swift
//  TinyJSONPath
//
//  Created by Andi on 09.01.19.
//  Copyright © 2019 Andreas Binner. All rights reserved.
//

import Foundation

extension String {
    func chopPrefix(_ count: Int = 1) -> String {
        return count>self.count ? self : String(self[index(self.startIndex, offsetBy: count)...])
    }
    func chopSuffix(_ count: Int = 1) -> String {
        return count>self.count ? self : String(self[..<index(self.endIndex, offsetBy: -count)])
    }
}

class TinyJSONPath {
    var jsonObject: Any?
    var lastError: String?
    var isValid = false
    
    init(json: Data) {
        do {
            isValid = true
            jsonObject = try JSONSerialization.jsonObject(with: json, options: [])
        } catch let error {
            isValid = false
            lastError = error.localizedDescription
        }
    }
    
    private func parsePath(obj: Any, path: String) -> Any? {
        self.lastError = nil
        var object = obj
        var remaining = path.components(separatedBy: ".")
        for comp in path.components(separatedBy: ".") {
            remaining.remove(at: 0)
            if comp == "@keys" {
                if let dict = object as? [String: Any] {
                    return Array(dict.keys)
                } else {
                    lastError = "JSONPath Error: Expected object"
                    return nil
                }
            } else if comp == "@count" {
                if let array = object as? [Any] {
                    return array.count
                }
                if let dict = object as? [String: Any] {
                    return dict.keys.count
                } else {
                    lastError = "JSONPath Error: Expected object"
                    return nil
                }
            } else if comp == "*" {
                if let dict = object as? [String: Any] {
                    return dict
                }
                if let array = object as? [Any] {
                    var res: [Any] = []
                    for a in array {
                        if let o = parsePath(obj: a, path: remaining.joined(separator: ".")) {
                            res.append(o)
                        }
                    }
                    return res
                } else {
                    lastError = "JSONPath Error: Expected array"
                    return nil
                }
            } else if comp.hasPrefix("[") && comp.hasSuffix("]") {
                if let array = object as? [Any] {
                    let inner = comp.chopPrefix().chopSuffix()
                    let list = inner.components(separatedBy: ",")
                    if list.count > 1 {
                        var sel:[Any] = []
                        for s in list {
                            if let i = Int(s) {
                                sel.append(array[i])
                            }
                        }
                        var res: [Any] = []
                        for a in sel {
                            if let o = parsePath(obj: a, path: remaining.joined(separator: ".")) {
                                res.append(o)
                            }
                        }
                        return res
                    } else if let n = Int(inner) {
                        object = array[n]
                    } else {
                        lastError = "JSONPath Error: Expected array index or index list"
                        return nil
                    }
                } else {
                    lastError = "JSONPath Error: Expected array"
                    return nil
                }
            } else {
                if let dict = object as? [String: Any] {
                    if let o = dict[comp] {
                        object = o
                    } else {
                        lastError = "JSONPath Error: Expected object named '\(comp)'"
                        return nil
                    }
                } else {
                    lastError = "JSONPath Error: Expected object, got \(object)"
                    return nil
                }
            }
        }
        return object
    }
    
    func evalPath(path: String) -> Any? {
        if let o = jsonObject {
            return parsePath(obj: o, path: path)
        }
        return nil
    }
}
