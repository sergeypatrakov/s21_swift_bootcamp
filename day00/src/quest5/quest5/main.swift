//
//  main.swift
//  quest5
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

let circle1 = Circle(x: getInput(), y: getInput(), r: getInput())
let circle2 = Circle(x: getInput(), y: getInput(), r: getInput())

let intersectionPoints = coordinateIntersection(circle1, circle2)

func checkCircleIntersection(_ circle1: Circle, _ circle2: Circle) {
    
    let distance = sqrt(pow(circle2.x - circle1.x, 2) + pow(circle2.y - circle1.y, 2))
    
    if distance <= abs(circle1.r - circle2.r) {
        print("One circle is inside another")
    } else if distance <= circle1.r + circle2.r {
        print("The circles intersect\n\(intersectionPoints)")
    } else {
        print("The circles do not intersect")
    }
}

func getInput() -> Double {
    guard let input = readLine(), let value = Double(input) else {
        print("Couldn't parse a number. Please, try again")
        return getInput()
    }
    return value
}

func coordinateIntersection(_ circle1: Circle, _ circle2: Circle) -> [[Double]] {
    let distance = sqrt(pow(circle2.x - circle1.x, 2) + pow(circle2.y - circle1.y, 2))
    
    if distance <= abs(circle1.r - circle2.r) {
        return []
    } else if distance <= circle1.r + circle2.r {
        let a = (pow(circle1.r, 2) - pow(circle2.r, 2) + pow(distance, 2)) / (2 * distance)
        let h = sqrt(pow(circle1.r, 2) - pow(a, 2))
        
        let x0 = circle1.x + a * (circle2.x - circle1.x) / distance
        let y0 = circle1.y + a * (circle2.y - circle1.y) / distance
        
        let x1 = x0 + h * (circle2.y - circle1.y) / distance
        let y1 = y0 - h * (circle2.x - circle1.x) / distance
        
        let x2 = x0 - h * (circle2.y - circle1.y) / distance
        let y2 = y0 + h * (circle2.x - circle1.x) / distance
        
        return [[x1, y1], [x2, y2]]
    } else {
        return []
    }
}

checkCircleIntersection(circle1, circle2)
