//
//  BaristaMachine.swift
//  quest02
//
//  Created by Sergey Patrakov on 25.08.2024.
//

import Foundation

class BaristaMachine: IBarista {
    let modelName: String
    let brewingTime: Int // Время в секундах
    
    init(modelName: String, brewingTime: Int) {
        self.modelName = modelName
        self.brewingTime = brewingTime
    }
    
    func brew(coffee: Coffee) {
        print("Coffee is brewing. One minute — time left")
        sleep(UInt32(self.brewingTime))
        print("Coffee is ready!")
    }
}
