//
//  main.swift
//  quest1
//
//  Created by Sergey Patrakov on 30.07.2024.
//

import Foundation

class Revolver<T: Equatable> {
    
    var clip: [T?]
    var pointer: T? {
        return clip[0]
    }
    
    init(clip: [T?] = Array(repeating: nil, count: 6)) {
        self.clip = Array(repeating: nil, count: 6)
        for i in 0 ... 5 {
            self.clip[i] = clip[i]
        }
    }
    
    func add(_ bullet: T) -> Bool {
        for (i, slot) in clip.enumerated() {
            if slot == nil {
                clip[i] = bullet
                self.scroll(i)
                return true
            }
        }
        return false
    }
    
    func addMany(_ bullets: [T]) -> Bool {
        if bullets.isEmpty { return false }
        
        var bulletsInt: Int = 0
        var i: Int = 0
        
        while i < clip.count {
            if clip[i] == nil {
                if bulletsInt < bullets.count {
                    clip[i] = bullets[bulletsInt]
                    bulletsInt += 1
                    self.scroll(i)
                    i = 0
                }
            }
            i += 1
        }
        
        return true
    }
    
    func shoot() -> T? {
        let result = clip.removeFirst()
        clip.append(nil)
        return result
    }
    
    func unload(_ index: Int) -> T? {
        if index < 0 || index >= clip.count { return nil }
        
        let result = clip.remove(at: index)
        clip.insert(nil, at: index)
        
        return result
    }
    
    func unloadAll() -> [T?] {
        let result = clip
        clip = [nil, nil, nil, nil, nil, nil]
        
        return result
    }
    
    func scroll(_ shift: Int = Int.random(in: 1...5)) {
        var shift = shift
        if shift < 0 || shift > 6 { shift = Int.random(in: 1...5) }
        
        let newIndexes = [
            (0 + shift) % 6,
            (1 + shift) % 6,
            (2 + shift) % 6,
            (3 + shift) % 6,
            (4 + shift) % 6,
            (5 + shift) % 6,
        ]
        
        let clipCopy = clip
        
        for i in 0 ..< clip.count {
            clip[i] = clipCopy[newIndexes[i]]
        }
    }
    
    func getSize() -> Int {
        return clip.count
    }
    
}

extension Revolver: Equatable {
    
    static func == (lhs: Revolver<T>, rhs: Revolver<T>) -> Bool {
        for _ in 0...5 {
            if lhs.clip == rhs.clip { return true }
            lhs.scroll(1)
        }
        return false
    }
    
    func toStringDescription() {
        print("Class: Revolver<\(T.self)>")
        
        let clipMas = clip.map { $0~ }
        var line = "[\(clipMas.joined(separator: ", "))]"
        print("Objects: \(line)")
        
        line = pointer~
        print("Pointer: \(line)\n")
    }
    
    subscript(index: Int) -> T? {
        if index < 0 || index >= clip.count { fatalError("Index out of range") }
        return clip[index]
    }
}

postfix operator ~
postfix func ~<T>(opt: T?) -> String {
    switch opt {
    case let val?: return String(describing: val)
    case nil: return "nil"
    }
}


func ultimateTest() {
    let rev = Revolver<Int>(clip: [nil, 54, 123, 048, 51, 6, 124, 58423, 1, 123])
    
    print("1. Common info")
    rev.toStringDescription()
    
    print("2. Subscript\n\(rev[0]~), \(rev[rev.clip.count - 1]~)\n")
    
    rev.scroll()
    print("3. Scroll")
    rev.toStringDescription()
    
    for _ in 0...3 {
        _ = rev.shoot()
    }
    print("4. Shoot x4")
    rev.toStringDescription()
    
    let mas = [1, 2, 3, 4, 5, 6, 7, 8]
    print("5. Add many")
    rev.toStringDescription()
    _ = rev.addMany(mas)
    rev.toStringDescription()
    
    print("6. Unload all")
    print(rev.unloadAll().count, (rev.clip.filter { $0 != nil } ).count)
    print()
    
    print("7. Supply collection")
    let supply = [1, 2, 3, 4]
    _ = rev.addMany(supply)
    rev.toStringDescription()
    
    let rev2 = Revolver<Int>(clip: [3, 4, nil, nil, 1, 2])
    rev2.scroll(4)
    print("rev == rev2 -> \(rev == rev2)\n")
}

func testAdd() {
    let rev = Revolver<Int>()
    var t = 0, f = 0
    
    for i in 0..<9 {
        if rev.add(i) {
            t += 1 // 6
        } else {
            f += 1 // 3
        }
    }
    
    let rev2 = Revolver<Int>()
    rev2.clip = [1, 2, nil, 4, 5, 6]
    if rev2.add(3) && rev2.clip == [3, 4, 5, 6, 1, 2] {
        t += 1 // 7
    }
    
    rev2.clip = [nil, 2, 3, 4, 5, 6]
    if rev2.add(123) && rev2.clip == [123, 2, 3, 4, 5, 6] {
        t += 1 // 8
    }
    
    rev2.clip = [1, 2, 3, 4, 5, 6]
    if !rev2.add(123) && rev2.clip == [1, 2, 3, 4, 5, 6] {
        t += 1 // 9
    }
    
    rev2.clip = [1, nil, 3, 4, 5, 6]
    if rev2.add(1000) && rev2.clip == [1000, 3, 4, 5, 6, 1] {
        t += 1 // 10
    }
    
    rev2.clip = [1, 2, 3, 4, 5, nil]
    if rev2.add(987) && rev2.clip == [987, 1, 2, 3, 4, 5] {
        t += 1 // 11
    }
    
    if t == 11 && f == 3 {
        print("add +")
    }
}

func testAddMany() {
    let rev = Revolver<Int>()
    var cnt = 0
    
    if !rev.addMany([]) {
        cnt += 1 // 1
    }
    
    rev.clip = [1, 2, 3, 4, 5, nil]
    if rev.addMany([23, 24, 45, 65]) && rev.clip == [23, 1, 2, 3, 4, 5] {
        cnt += 1 // 2
    }
    
    rev.clip = [1, nil, nil, nil, nil, nil]
    if rev.addMany([100]) && rev.clip == [100, nil, nil, nil, nil, 1] {
        cnt += 1 // 3
    }
    
    rev.clip = [1, nil, 2, nil, 3, nil]
    if rev.addMany([4, 5, 6]) && rev.clip == [6, 1, 4, 2, 5, 3] {
        cnt += 1 // 4
    }
    
    rev.clip = [1, nil, 2, nil, nil, nil]
    if rev.addMany([4, 5, 6]) && rev.clip == [6, nil, 1, 4, 2, 5] {
        cnt += 1 // 5
    }
    
    if cnt == 5 {
        print("addMany +")
    }
    
}

func testPointer() {
    let rev = Revolver<Int>()
    var cnt = 0
    
    if rev.pointer == nil {
        cnt += 1
    }
    
    _ = rev.add(123)
    if rev.pointer == 123 {
        cnt += 1
    }
    
    _ = rev.add(421)
    if rev.pointer == 421 {
        cnt += 1
    }
    
    _ = rev.shoot()
    if rev.pointer == nil && rev.clip == [nil, nil, nil, nil, 123, nil] {
        cnt += 1
    }
    
    if cnt == 4 {
        print("pointer +")
    }
}

func testShoot() {
    let rev = Revolver<Int>()
    var cnt = 0
    rev.clip = [1, 2, 3, 4, 5, 6]
    
    if rev.shoot() == 1 && rev.clip == [2, 3, 4, 5, 6, nil] {
        cnt += 1
    }
    
    if rev.shoot() == 2 && rev.clip == [3, 4, 5, 6, nil, nil] {
        cnt += 1
    }
    
    if rev.shoot() == 3 && rev.clip == [4, 5, 6, nil, nil, nil] {
        cnt += 1
    }
    
    if rev.shoot() == 4 && rev.clip == [5, 6, nil, nil, nil, nil] {
        cnt += 1
    }
    
    if rev.shoot() == 5 && rev.clip == [6, nil, nil, nil, nil, nil] {
        cnt += 1
    }
    
    if rev.shoot() == 6 && rev.clip == [nil, nil, nil, nil, nil, nil] {
        cnt += 1
    }
    
    if rev.shoot() == nil && rev.clip == [nil, nil, nil, nil, nil, nil] {
        cnt += 1
    }
    
    if rev.shoot() == nil && rev.clip == [nil, nil, nil, nil, nil, nil] {
        cnt += 1
    }
    
    if cnt == 8 {
        print("shoot +")
    }
}

func testUnload() {
    let rev = Revolver<String>()
    rev.clip = ["1", "2", "123", "-f", "AAA", "\n"]
    var cnt = 0
    
    if rev.unload(2) == "123" && rev.clip == ["1", "2", nil, "-f", "AAA", "\n"] {
        cnt += 1
    }
    
    if rev.unload(100) == nil && rev.clip == ["1", "2", nil, "-f", "AAA", "\n"] {
        cnt += 1
    }
    
    if rev.unload(5) == "\n" && rev.clip == ["1", "2", nil, "-f", "AAA", nil] {
        cnt += 1
    }
    
    if rev.unload(5) == nil && rev.clip == ["1", "2", nil, "-f", "AAA", nil] {
        cnt += 1
    }
    
    if cnt == 4 {
        print("unload +")
    }
}

func testUnloadAll() {
    let rev = Revolver<Int>()
    var cnt = 0
    rev.clip = [1, 123, nil, nil, 0]
    
    if rev.unloadAll() == [1, 123, nil, nil, 0] && rev.clip == [nil, nil, nil, nil, nil, nil] {
        cnt += 1
    }
    
    rev.clip = [nil, nil, nil, nil, nil, nil]
    if rev.unloadAll() == [nil, nil, nil, nil, nil, nil] && rev.clip == [nil, nil, nil, nil, nil, nil] {
        cnt += 1
    }
    
    rev.clip = [1, 2, 4, 3, 5, 6]
    if rev.unloadAll() == [1, 2, 4, 3, 5, 6] && rev.clip == [nil, nil, nil, nil, nil, nil] {
        cnt += 1
    }
    
    if cnt == 3 {
        print("unloadAll +")
    }
}

func testScroll() {
    let rev = Revolver<Int>()
    var cnt = 0
    rev.clip = [1, 2, nil, 4, nil, 6]
    
    rev.scroll(1)
    if rev.clip == [2, nil, 4, nil, 6, 1] && rev.pointer == 2 {
        cnt += 1
    }
    
    rev.scroll(2)
    if rev.clip == [4, nil, 6, 1, 2, nil] && rev.pointer == 4 {
        cnt += 1
    }
    
    rev.scroll(3)
    if rev.clip == [1, 2, nil, 4, nil, 6] && rev.pointer == 1 {
        cnt += 1
    }
    
    rev.scroll(4)
    if rev.clip == [nil, 6, 1, 2, nil, 4] && rev.pointer == nil {
        cnt += 1
    }
    
    rev.scroll(5)
    if rev.clip == [4, nil, 6, 1, 2, nil] && rev.pointer == 4 {
        cnt += 1
    }
    
    rev.scroll(0)
    if rev.clip == [4, nil, 6, 1, 2, nil] && rev.pointer == 4 {
        cnt += 1
    }
    
    rev.scroll(6)
    if rev.clip == [4, nil, 6, 1, 2, nil] && rev.pointer == 4 {
        cnt += 1
    }
    
    if cnt == 7 {
        print("scroll +")
    }
}

func testEqualOperator() {
    let rev = Revolver<Int>(clip: [1, 2, 3, 4, nil, 6])
    let rev2 = Revolver<Int>(clip: [nil, 6, 1, 2, 3, 4])
    var cnt = 0
    
    for i in 0...30 {
        if rev == rev2 {
            cnt += 1
        } else {
            print(i)
            print(rev.clip)
            print(rev2.clip)
        }
        rev.scroll(i)
    }
    
    if cnt == 31 {
        print("equalOperator +")
    }
}

func testSubscript() {
    let rev = Revolver<Int>(clip: [1, nil, nil, 100, 5342, nil])
    var cnt = 0
    
    for i in 0..<rev.clip.count {
        if rev[i] == rev.clip[i] {
            cnt += 1
        }
    }
    
    if cnt == 6 {
        print("subscript +")
    }
}

ultimateTest()
testAdd()
testAddMany()
testPointer()
testShoot()
testUnload()
testUnloadAll()
testScroll()
testEqualOperator()
testSubscript()
