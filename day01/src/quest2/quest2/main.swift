//
//  main.swift
//  quest2
//
//  Created by Sergey Patrakov on 12.07.2024.
//

import Foundation

extension String {
    func applyPhoneMask() -> String {
        var cleanedPhoneNumber = self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        
        if cleanedPhoneNumber.count == 11, let firstDigit = cleanedPhoneNumber.first {
            switch firstDigit {
            case "8":
                if cleanedPhoneNumber.hasPrefix("8800") { return cleanedPhoneNumber.applyMask(mask: "* (***) *** ** **", replacementCharacter: "*") }
                else {
                    cleanedPhoneNumber.removeFirst()
                    return cleanedPhoneNumber.applyMask(mask: "+7 *** ***-**-**", replacementCharacter: "*")
                }
            case "7":
                if cleanedPhoneNumber.hasPrefix("7800") {
                    cleanedPhoneNumber.removeFirst()
                    return cleanedPhoneNumber.applyMask(mask: "8 (***) *** ** **", replacementCharacter: "*")
                } else {
                    cleanedPhoneNumber.removeFirst()
                    return cleanedPhoneNumber.applyMask(mask: "+* *** ***-**-**", replacementCharacter: "*")
                }
            default:
                return cleanedPhoneNumber
            }
        } else if cleanedPhoneNumber.count == 12, cleanedPhoneNumber.hasPrefix("7") {
            if cleanedPhoneNumber.hasPrefix("+7800") {
                cleanedPhoneNumber.removeFirst(2)
                return cleanedPhoneNumber.applyMask(mask: "8 (***) *** ** **", replacementCharacter: "*")
            } else {
                cleanedPhoneNumber.removeFirst(2)
                cleanedPhoneNumber = "7" + cleanedPhoneNumber
                return cleanedPhoneNumber.applyMask(mask: "+* (***) ***-**-**", replacementCharacter: "*")
            }
        }
        
        return self
    }

    private mutating func applyMask(mask: String, replacementCharacter: Character) -> String {
        var result = ""
        var maskIndex = mask.startIndex
        
        for char in mask {
            if char == replacementCharacter {
                if let phoneChar = self.first {
                    result.append(phoneChar)
                    self = String(self.dropFirst())
                }
            } else { result.append(char) }
            maskIndex = mask.index(after: maskIndex)
        }
        
        return result
    }
}

let phone = readLine() ?? ""
print(phone.applyPhoneMask())
