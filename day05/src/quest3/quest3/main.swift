//
//  main.swift
//  quest3
//
//  Created by Sergey Patrakov on 16.09.2024.
//

import Foundation
import RxSwift

// Реализуй функцию, проверяющую, все ли строки из firstCollection длиннее 5 символов.

let firstCollection = Observable.of("first", "second", "third")

func someFunc1(_ firstCollection: Observable<String>) -> Observable<Bool> {
    firstCollection.map { $0.count > 5 }
        .reduce(true) { $0 && $1 }
}

func main() async {
    let filtredStrings1 = someFunc1(firstCollection)
    
    filtredStrings1.subscribe(onNext: { value in
        print(value)
    }).disposed(by: DisposeBag())
}

await main()
