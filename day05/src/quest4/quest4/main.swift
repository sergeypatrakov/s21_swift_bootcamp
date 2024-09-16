//
//  main.swift
//  quest4
//
//  Created by Sergey Patrakov on 16.09.2024.
//

import Foundation
import RxSwift

// Реализуй функцию, проверяющую, присутствуют ли строки длиннее 5 символов в firstCollection.

let firstCollection = Observable.of("first", "second", "third")

let semaphore = DispatchSemaphore(value: 0)

func someFunc(_ firstCollection: Observable<String>) -> Observable<String> {
    firstCollection.filter { $0.count > 5 }
}

Thread.detachNewThread {
    let filtredStrings = someFunc(firstCollection)
    
    filtredStrings.subscribe(onNext: { value in
        print(value)
    }).disposed(by: DisposeBag())
    semaphore.signal()
}

semaphore.wait()
