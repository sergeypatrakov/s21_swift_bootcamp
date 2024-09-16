//
//  main.swift
//  quest9
//
//  Created by Sergey Patrakov on 16.09.2024.
//

import Foundation
import RxSwift

// Реализуй функцию, группирующую значения по id в secondCollection.

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

func someFunc(_ secondCollection: Observable<Sample>) -> any Disposable {
    secondCollection
        .groupBy { $0.id }
        .flatMap { groupedObservable in
            groupedObservable.toArray() // Получаем массив элементов в группе
                .map { (groupedObservable.key, $0) } // Создаем кортеж с ключом и массивом значений
        }
        .subscribe(onNext: { (id, samples) in
            print("Group ID: \(id)")
            for sample in samples {
                print(" - \(sample.text)")
            }
        })
}

func main() async {
    someFunc(secondCollection).disposed(by: DisposeBag())
}

await main()
