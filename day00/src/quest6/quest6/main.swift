//
//  main.swift
//  quest6
//
//  Created by Sergey Patrakov on 08.07.2024.
//

import Foundation

let numberWords: [String] = ["zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten",
                   "eleven", "twelve", "thirteen", "fourteen", "fifteen", "sixteen", "seventeen", "eighteen", "nineteen"]

let tensWords: [String] = ["","", "twenty", "thirty", "forty", "fifty", "sixty", "seventy", "eighty", "ninety"]

func numberToWords(_ number: Int) -> String {
    if number == 0 { return "zero" }
    else if number < 0 { return "minus \(numberToWords(-number))" }
    else if number < 20 { return numberWords[number] }
    else if number < 100 {
        let tens = number / 10
        let remainder = number % 10
        var words = tensWords[tens]
        if remainder > 0 { words += "-\(numberWords[remainder])" }
        return words
    } else if number < 1000 {
        let hundreds = number / 100
        let remainder = number % 100
        var words = numberWords[hundreds] + " hundred"
        if remainder > 0 { words += " and \(numberToWords(remainder))" }
        return words
    } else if number < 1_000_000 {
        let thousands = number / 1000
        let remainder = number % 1000
        var words = numberToWords(thousands) + " thousand"
        if remainder > 0 { words += " \(numberToWords(remainder))" }
        return words
    } else { return "The number is out of bounds" }
}

var count = 0

print("The program is running. Enter a number or type \"exit\" to stop:")

while let input = readLine() {
    if input == "exit" {
        print("Bye!")
        break
    }
    
    if let number = Int(input) {
        count % 5 == 0 ? print("Enter a number or type \"exit\" to stop:") : print("Enter a number:")
        
        print(numberToWords(number))
        count += 1
    } else { print("Incorrect format, try again.\nEnter a number:") }
}
