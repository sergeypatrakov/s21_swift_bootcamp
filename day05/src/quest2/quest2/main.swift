//
//  main.swift
//  quest2
//
//  Created by Sergey Patrakov on 16.09.2024.
//

import Foundation
import RxSwift

// Реализуй функцию, которая будет возвращать первый элемент из firstCollection, начинающийся на th.

let firstCollection = Observable.of("first", "second", "third")

func someFunc(_ firstCollection: Observable<String>) -> Observable<String> {
    firstCollection.filter { $0.hasPrefix("th") }
}

func main() async {
    let filtredStrings = someFunc(firstCollection)
    
    filtredStrings.subscribe(onNext: { value in
        print(value)
    }).disposed(by: DisposeBag())
}

Task {
    await main()
}

RunLoop.current.run(until: Date(timeIntervalSinceNow: 3))
