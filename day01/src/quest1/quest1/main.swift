//
//  main.swift
//  quest1
//
//  Created by Sergey Patrakov on 09.07.2024.
//

import Foundation

struct Accident {
    let x: Int
    let y: Int
}

enum AccidentType: String {
    case FIRE = "Fire"
    case GAS = "Gas leak"
    case CAT = "Cat on the tree"
}

class Zone {
    let phoneNumber: String
    let name: String
    let departmentCode: String
    let probabilityLevel: String
    let typeOfZone: String
    
    init(phoneNumber: String, name: String, departmentCode: String, probabilityLevel: String, typeOfZone: String) {
        self.phoneNumber = phoneNumber
        self.name = name
        self.departmentCode = departmentCode
        self.probabilityLevel = probabilityLevel
        self.typeOfZone = typeOfZone
    }
    
    func accidentInsideZone(accident: Accident) -> Bool {
        return false
    }
}

class Circle: Zone {
    let center: (x: Int, y: Int)
    let radius: Double
    
    init(phoneNumber: String, name: String, departmentCode: String, probabilityLevel: String, typeOfZone: String , center: (Int, Int), radius: Double) {
        self.center = center
        self.radius = radius
        super.init(phoneNumber: phoneNumber, name: name, departmentCode: departmentCode, probabilityLevel: probabilityLevel, typeOfZone: "Circle")
    }
    
    override func accidentInsideZone(accident: Accident) -> Bool {
        let distance: Double = sqrt(Double(((accident.x - self.center.x) * (accident.x - self.center.x)) + ((accident.y - self.center.y) * (accident.y - self.center.y))))
        return distance <= self.radius
      }
}

class Triangle: Zone {
    let a: (Int, Int)
    let b: (Int, Int)
    let c: (Int, Int)
    
    init(phoneNumber: String, name: String, departmentCode: String, probabilityLevel: String, typeOfZone: String, a: (Int, Int), b: (Int, Int), c: (Int, Int)) {
        self.a = a
        self.b = b
        self.c = c
        super.init(phoneNumber: phoneNumber, name: name, departmentCode: departmentCode, probabilityLevel: probabilityLevel, typeOfZone: "Triangle")
    }
    
    override func accidentInsideZone(accident: Accident) -> Bool {
        let side1 = (self.b.0 - self.a.0) * (accident.y - self.a.1) - (self.b.1 - self.a.1) * (accident.x - self.a.0)
        let side2 = (self.c.0 - self.b.0) * (accident.y - self.b.1) - (self.c.1 - self.b.1) * (accident.x - self.b.0)
        let side3 = (self.a.0 - self.c.0) * (accident.y - self.c.1) - (self.a.1 - self.c.1) * (accident.x - self.c.0)
        
        return (side1 >= 0 && side2 >= 0 && side3 >= 0) || (side1 <= 0 && side2 <= 0 && side3 <= 0)
    }
}

class Quadrangular: Zone {
    let a: (Int, Int)
    let b: (Int, Int)
    let c: (Int, Int)
    let d: (Int, Int)
    
    init(phoneNumber: String, name: String, departmentCode: String, probabilityLevel: String, typeOfZone: String, a: (Int, Int), b: (Int, Int), c: (Int, Int), d: (Int, Int)) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
        super.init(phoneNumber: phoneNumber, name: name, departmentCode: departmentCode, probabilityLevel: probabilityLevel, typeOfZone: "Quadrangular")
    }
    
    override func accidentInsideZone(accident: Accident) -> Bool {
        // Проверяем, находится ли точка инцидента внутри четырехугольника при помощи пересечения прямых сторон фигуры
        let abSide = (self.b.0 - self.a.0) * (accident.y - self.a.1) - (self.b.1 - self.a.1) * (accident.x - self.a.0)
        let bcSide = (self.c.0 - self.b.0) * (accident.y - self.b.1) - (self.c.1 - self.b.1) * (accident.x - self.b.0)
        let cdSide = (self.d.0 - self.c.0) * (accident.y - self.c.1) - (self.d.1 - self.c.1) * (accident.x - self.c.0)
        let daSide = (self.a.0 - self.d.0) * (accident.y - self.d.1) - (self.a.1 - self.d.1) * (accident.x - self.d.0)
        
        return (abSide >= 0 && bcSide >= 0 && cdSide >= 0 && daSide >= 0) || (abSide <= 0 && bcSide <= 0 && cdSide <= 0 && daSide <= 0)
    }
}

func getNameOfZone() -> String {
    print("Enter name:")
    return readLine() ?? ""
}

func getPhoneOfZone() -> String {
    print("Enter phone number:")
    return readLine() ?? ""
}

func getDepartmentCode() -> String {
    print("Enter emergency dept:")
    return readLine() ?? ""
}

func getProbabilityLevel() -> String {
    print("Enter danger level:")
    return readLine() ?? ""
}

func getDescription() -> String {
    print("Enter description:")
    return readLine() ?? ""
}

func getType() -> String {
    print("Enter type:")
    return readLine() ?? ""
}

func processInput() {
    print("Enter zone parameters:")
    
    let zoneInfo = readLine() ?? ""
    let zoneParams = zoneInfo.components(separatedBy: " ")
    
    var zone: Zone
    
    print("Enter the zone info:")
    
    switch zoneParams.count {
    case 2: // Circle
        let centerCoords = zoneParams[0].components(separatedBy: ";").compactMap { Int($0) }
        let radius = Double(zoneParams[1]) ?? 0.0
        zone = Circle(phoneNumber: getPhoneOfZone(), name: getNameOfZone(), departmentCode: getDepartmentCode(), probabilityLevel: getProbabilityLevel(), typeOfZone: "Circle", center: (centerCoords[0], centerCoords[1]), radius: radius)
    case 3: // Triangle
        let points = zoneParams.map { $0.components(separatedBy: ";").compactMap { Int($0) } }
        zone = Triangle(phoneNumber: getPhoneOfZone(), name: getNameOfZone(), departmentCode: getDepartmentCode(), probabilityLevel: getProbabilityLevel(), typeOfZone: "Triangle", a: (points[0][0], points[0][1]), b: (points[1][0], points[1][1]), c: (points[2][0], points[2][1]))
    case 4: // Quadrangular
        let points = zoneParams.map { $0.components(separatedBy: ";").compactMap { Int($0) } }
        zone = Quadrangular(phoneNumber: getPhoneOfZone(), name: getNameOfZone(), departmentCode: getDepartmentCode(), probabilityLevel: getProbabilityLevel(), typeOfZone: "Quadrangular", a: (points[0][0], points[0][1]), b: (points[1][0], points[1][1]), c: (points[2][0], points[2][1]), d: (points[3][0], points[3][1]))
    default:
        print("Неверные данные для параметров зоны.")
        return
    }
    
    print("Enter an accident coordinates:")
    let accidentCoords = readLine() ?? ""
    let accidentCoordinates = accidentCoords.components(separatedBy: ";").compactMap { Int($0) }
    let accident = Accident(x: accidentCoordinates[0], y: accidentCoordinates[1])
    
    print("Enter the accident info:")
    
    let description = getDescription()
    let phone = getPhoneOfZone()
    let type = getType()
    
    if zone.typeOfZone == "Circle" {
        zone.accidentInsideZone(accident: accident) ? printZoneParams() : printAccidentNotInZone()
    } else if zone.typeOfZone == "Triangle" {
        zone.accidentInsideZone(accident: accident) ? printZoneParams() : printAccidentNotInZone()
    } else if zone.typeOfZone == "Quadrangular" {
        zone.accidentInsideZone(accident: accident) ? printZoneParams() : printAccidentNotInZone()
    }
    
    func printZoneParams() {
        print("""
              An accident is in \(zone.name)
              The shape of area: \(zone.typeOfZone)
              Phone number of zone: \(zone.phoneNumber)
              Emergency dept: \(zone.departmentCode)
              Danger level: \(zone.probabilityLevel)
              Type of accident: \(type)
              Description of accident: \(description)
              Phone number of people: \(phone)
              """)
    }
    
    func printAccidentNotInZone() {
        print("An accident is not in \(zone.name)")
        print("Switch the applicant to the common number: 88008473824")
    }

}

processInput()
