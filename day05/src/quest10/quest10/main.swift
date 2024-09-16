//
//  main.swift
//  quest10
//
//  Created by Sergey Patrakov on 16.09.2024.
//

import Foundation
import RxSwift

// Реализуй функцию, группирующую значения по id в secondCollection и считающую количество элементов в каждой группе.
// Пример вывода: listOf(Pair(1, 2), Pair(2, 2), Pair(3, 1).

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
        .flatMap { (group: GroupedObservable<Int, Sample>) -> PrimitiveSequence<SingleTrait, (Int, Int)> in
            return group
                .toArray()
                .map { samples in
                    return (group.key, samples.count)
                }
        }
        .subscribe(onNext: { (id: Int, count: Int) in
            print("Group ID: \(id) has \(count) elements")
        })
}

func main() async {
    someFunc(secondCollection).disposed(by: DisposeBag())
}

await main()
