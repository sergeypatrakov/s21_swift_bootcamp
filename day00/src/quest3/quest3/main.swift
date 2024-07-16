//
//  main.swift
//  quest3
//
//  Created by Sergey Patrakov on 08.07.2024.
//

let sensor: String? = readLine() ?? ""
let season: String? = readLine() ?? ""
var temperature: Double = getInput()

func getInput() -> Double {
    guard let input = readLine(), let value = Double(input) else {
        print("Incorrect input. Enter a temperature:")
        return getInput()
    }
    return value
}

func actuallyTemperature() -> String {
    var result: Double = 0
    var message: String = ""
    switch sensor {
    case "Celsius": 
        result = temperature
        message = "\(result) °C"
        temperature = result
    case "Fahrenheit":
        result = temperature * 1.8 + 32
        message = "\(result) F"
        temperature = result
    case "Kelvin":
        result = temperature + 273.15
        message = "\(result) K"
        temperature = result
    default:
        return "You enter incorrect temperature sensor."
    }
    return message
}

func comfortableTemperature() -> String {
    var message: String = ""
    if season == "S" {
        switch sensor {
        case "Celsius": message = "from 22 to 25 °C"
        case "Fahrenheit": message = "from 71.6 to 77 F"
        case "Kelvin": message = "from 295.15 to 298.15 K"
        default: break
        }
    } else if season == "W" {
        switch sensor {
        case "Celsius": message = "from 20 to 22 °C"
        case "Fahrenheit": message = "from 68 to 71.6 F"
        case "Kelvin": message = "from 293.15 to 295.15 K"
        default: break
        }
    } else {
        print("Incorrect season.")
    }
    return message
}

func whatsNeed() -> String {
    var message: String = ""
    if season == "S" {
        switch sensor {
        case "Celsius":
            if temperature >= 22 && temperature <= 25 {
                message = "The temperature is comfortable."
            } else if temperature < 22 {
                message = "Please, make it warmer by \(22 - temperature) degrees."
            } else {
                message = "Please, make it colder by \(temperature - 25) degrees."
            }
        case "Fahrenheit":
            if temperature >= 71.6 && temperature <= 77 {
                message = "The temperature is comfortable."
            } else if temperature < 71.6 {
                message = "Please, make it warmer by \(71.6 - temperature) degrees."
            } else {
                message = "Please, make it colder by \(temperature - 77) degrees."
            }
        case "Kelvin":
            if temperature >= 295.15 && temperature <= 298.15 {
                message = "The temperature is comfortable."
            } else if temperature < 295.15 {
                message = "Please, make it warmer by \(295.15 - temperature) degrees."
            } else {
                message = "Please, make it colder by \(temperature - 298.15) degrees."
            }
        default: break
        }
    } else if season == "W" {
        switch sensor {
        case "Celsius":
            if temperature >= 20 && temperature <= 22 {
                message = "The temperature is comfortable."
            } else if temperature < 20 {
                message = "Please, make it warmer by \(20 - temperature) degrees."
            } else {
                message = "Please, make it colder by \(temperature - 22) degrees."
            }
        case "Fahrenheit":
            if temperature >= 68 && temperature <= 71.6 {
                message = "The temperature is comfortable."
            } else if temperature < 68 {
                message = "Please, make it warmer by \(68 - temperature) degrees."
            } else {
                message = "Please, make it colder by \(temperature - 71.6) degrees."
            }
        case "Kelvin":
            if temperature >= 293.15 && temperature <= 295.15 {
                message = "The temperature is comfortable."
            } else if temperature < 293.15 {
                message = "Please, make it warmer by \(293.15 - temperature) degrees."
            } else {
                message = "Please, make it colder by \(temperature - 295.15) degrees."
            }
        default: break
        }
    } else {
        print("Incorrect season.")
    }
    return message
}

func output() {
    print("""
          The temperature is \(actuallyTemperature())
          The comfortable temperature is \(comfortableTemperature()).
          \(whatsNeed())
          """)
}

output()
