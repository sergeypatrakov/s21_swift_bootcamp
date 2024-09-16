//
//  main.swift
//  quest6
//
//  Created by Sergey Patrakov on 16.09.2024.
//

import Foundation
import RxSwift

// Реализуй функцию, считающую общую длину строк в firstCollection.

let firstCollection = Observable.of("first", "second", "third")

func stringsCount(_ firstCollection: Observable<String>) -> Observable<Int> {
    firstCollection.map { $0.count }
        .reduce(0, accumulator: +)
}

func main() async {
    let result = stringsCount(firstCollection)
    result.subscribe(onNext: { value in
        print(value)
    }).disposed(by: DisposeBag())
}

await main()
