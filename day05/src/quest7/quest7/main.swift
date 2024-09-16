//
//  main.swift
//  quest7
//
//  Created by Sergey Patrakov on 16.09.2024.
//

import Foundation
import RxSwift

// Реализуй функцию, считающую количество строк в firstCollection.

let firstCollection = Observable.of("first", "second", "third")

func countOfStrings(_ firstCollection: Observable<String>) -> Observable<Int> {
    firstCollection.reduce(0) { count, _ in count + 1 }
}

func main() async {
    countOfStrings(firstCollection)
        .subscribe(onNext: { value in
            print(value)
        }).disposed(by: DisposeBag())
}

await main()
