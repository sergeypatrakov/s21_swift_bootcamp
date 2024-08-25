//
//  main.swift
//  quest02
//
//  Created by Sergey Patrakov on 25.08.2024.
//

import Foundation

func main() {
    let coffeeMenu = [
        Coffee(name: "Cappuccino", andPrice: 1.8),
        Coffee(name: "Americano", andPrice: 1.35),
        Coffee(name: "Latte", andPrice: 2.07)
    ]
    
    print("""
          Choose barista:
          1. Man
          2. Machine
          """)
    
    if let choice = readLine() {
        if choice == "1" {
            let baristaMan = BaristaMachine(modelName: "SuperBarista", brewingTime: 60)
            
            print("Choose coffee in menu:")
            for (index, coffee) in coffeeMenu.enumerated() {
                print("\(index + 1). \(String(describing: coffee!.name!)) \(String(format: "%.2f", coffee!.price))$")
            }
            if let coffeeChoice = readLine(), let coffeeIndex = Int(coffeeChoice), coffeeIndex > 0, coffeeIndex <= coffeeMenu.count {
                let selectedCoffee = coffeeMenu[coffeeIndex - 1]
                baristaMan.brew(coffee: selectedCoffee!)
            } else { 
                print("Try again!")
                main()
            }
            
        } else if choice == "2" {
            let baristaMachine = BaristaMachine(modelName: "SuperCoffee 3000", brewingTime: 60)
            
            print("Choose coffee in menu:")
            for (index, coffee) in coffeeMenu.enumerated() {
                // Применяем скидку 10%
                let discountedPrice = coffee!.price * 0.9
                print("\(index + 1). \(String(describing: coffee!.name!)) \(String(format: "%.2f", discountedPrice))$")
            }
            
            if let coffeeChoice = readLine(), let coffeeIndex = Int(coffeeChoice), coffeeIndex > 0, coffeeIndex <= coffeeMenu.count {
                let selectedCoffee = coffeeMenu[coffeeIndex - 1]
                baristaMachine.brew(coffee: selectedCoffee!)
            } else {
                print("Try again!")
                main()
            }
        } else {
            print("Try again!")
            main()
        }
    }
}

main()

