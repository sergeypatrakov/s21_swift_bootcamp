//
//  main.swift
//  quest2
//
//  Created by Sergey Patrakov on 08.07.2024.
//

enum InputErrors: Error {
    case Exception
}

let rule: String? = readLine() ?? ""
let number: Int?

func getInput() throws -> Int? {
    guard let input = readLine(), let number = Int(input) else { throw InputErrors.Exception }
    return number
}

do {
    if let num = try getInput() {
        number = Int(num)

        let resNumber: String = String(number!)
        var result: String = ""
        if rule == "lower" {
            for i in resNumber {
                if i != "-" {
                    result += String(i)
                    print(result)
                } else { result += String(i) }
            }
        } else if rule == "higher" {
            if resNumber.first != "-" {
                for i in stride(from: resNumber.count - 1, through: 0, by: -1) {
                    let index = resNumber.index(resNumber.startIndex, offsetBy: i)
                    if resNumber[index] == "0" && result.isEmpty { print(0) }
                    else if resNumber[index] == "0" && result.contains("0") { }
                    else {
                        result.append(resNumber[index])
                        print(result)
                    }
                }
            } else {
                for i in stride(from: resNumber.count - 1, through: 1, by: -1) {
                    let index = resNumber.index(resNumber.startIndex, offsetBy: i)
                    if resNumber[index] == "0" && result.isEmpty { print(0) }
                    else if resNumber[index] == "0" && result.contains("0") { }
                    else {
                        result.append(resNumber[index])
                        print("-\(result)")
                    }
                }
            }
        }
    } else { number = nil }
} catch { print("Incorrect number. Please try again and input Int.") }
