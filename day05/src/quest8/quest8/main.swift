//
//  main.swift
//  quest8
//
//  Created by Sergey Patrakov on 16.09.2024.
//

import Foundation
import RxSwift

// Реализуй функцию, возвращающую массив строк (полей text) из secondCollection.

struct Sample {
    let id: Int
    let text: String
}

let secondCollection = Observable.of(
        Sample(id: 1, text: "some text"),
        Sample(id: 1, text: "any text"),
        Sample(id: 2, text: "more text"),
        Sample(id: 2, text: "other text"),
        Sample(id: 3, text: "too text")
)

func someFunc(_ secondCollection: Observable<Sample>) -> Observable<[String]> {
    secondCollection.map { $0.text }
        .reduce([]) { (accumulator: [String], text: String) in
            return accumulator + [text]
        }
}

func main() async {
    someFunc(secondCollection)
        .subscribe(onNext: { value in
        print(value)
    }).disposed(by: DisposeBag())
}

await main()
