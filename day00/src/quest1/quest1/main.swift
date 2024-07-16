//
//  main.swift
//  quest1
//
//  Created by Sergey Patrakov on 08.07.2024.
//

import Foundation

class Circle {
    let x: Double
    let y: Double
    let r: Double
    
    init(x: Double, y: Double, r: Double) {
        self.x = x
        self.y = y
        self.r = r
    }
}

func checkCircleIntersection() {
    let circle1 = Circle(x: getInput(), y: getInput(), r: getInput())
    let circle2 = Circle(x: getInput(), y: getInput(), r: getInput())
    
    let distance = sqrt(pow(circle2.x - circle1.x, 2) + pow(circle2.y - circle1.y, 2))
    
    if distance <= abs(circle1.r - circle2.r) { print("One circle is inside another") }
    else if distance <= circle1.r + circle2.r { print("The circles intersect") }
    else { print("The circles do not intersect") }
}

func getInput() -> Double {
    guard let input = readLine(), let value = Double(input) else {
        print("Couldn't parse a number. Please, try again")
        return getInput()
    }
    return value
}

checkCircleIntersection()
