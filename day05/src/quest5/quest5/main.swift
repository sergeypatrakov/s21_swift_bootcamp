//
//  main.swift
//  quest5
//
//  Created by Sergey Patrakov on 16.09.2024.
//

import Foundation
import RxSwift

//Реализуй функцию, проверяющую отсутствие пустых строк в firstCollection.

let firstCollection = Observable.of("first", "second", "third")

func someFunc(_ firstCollection: Observable<String>) -> Observable<Bool> {
    return firstCollection
        .map { !$0.isEmpty }
        .reduce(true) { $0 && $1 } // Применяем оператор редукции для вычисления общего результата
}

func main() async {
    let filtredStrings = someFunc(firstCollection)
    
    filtredStrings.subscribe(onNext: { value in
        print(value)
    }).disposed(by: DisposeBag())
}


await main()
