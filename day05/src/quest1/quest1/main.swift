//
//  main.swift
//  quest1
//
//  Created by Sergey Patrakov on 12.09.2024.
//

import Foundation
import RxSwift

// Реализуй функцию, которая будет фильтровать firstCollection и сохранять только строки, где есть буква e.

let firstCollection = Observable.of("first", "second", "third")

func someFunc(_ firstCollection: Observable<String>) -> Observable<String> {
    firstCollection.filter { $0.contains("e") || $0.contains("E") }
}

func main() async {
    let filtredStrings = someFunc(firstCollection)
    
    filtredStrings.subscribe(onNext: { value in
        print(value)
    }).disposed(by: DisposeBag()) // Используется для управления жизненным циклом подписок, чтобы избежать утечек памяти
}

Task {
    await main()
}

RunLoop.current.run(until: Date(timeIntervalSinceNow: 3))
