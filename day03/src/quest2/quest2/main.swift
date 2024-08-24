//
//  main.swift
//  quest2
//
//  Created by Sergey Patrakov on 25.08.2024.
//

import Foundation

enum Caliber: Int {
    case c22 = 22
    case c38 = 38
    case c45 = 45
}

class Patron {
    enum PatronType: Int {
        case damp = 0 // холостой
        case charged = 1
    }
    
    let patronType: PatronType
    let id = UUID()
    let caliber: Caliber
    
    init(patronType: PatronType = .damp, caliber: Caliber = .c22) {
        self.patronType = patronType
        self.caliber = caliber
    }
    
    func shoot() {
        print("Bang")
        print("Caliber = \(caliber.rawValue)\n")
    }
}

class Revolver {
    
    var clip: [Patron?]
    let caliber: Caliber
    var pointer: Patron? {
        return clip[0]
    }
    static var bulletID = [UUID]()
    
    init(caliber: Caliber = .c22) {
        self.clip = Array(repeating: nil, count: 6)
        self.caliber = caliber
    }
    
}

extension Revolver {
    
    func add(_ bullet: Patron) -> Bool {
        if bullet.caliber != caliber || Revolver.bulletID.contains(bullet.id) { return false }
        
        for (i, slot) in clip.enumerated() {
            if slot == nil {
                clip[i] = bullet
                Revolver.bulletID.append(bullet.id)
                self.scroll(i)
                return true
            }
        }
        
        return false
    }
    
    func addMany(_ bullets: [Patron]) -> Bool {
        var matchPatrons = [Patron]()
        var tempPatronsID = [UUID]()
        for now in bullets {
            if now.caliber == caliber && !Revolver.bulletID.contains(now.id) && !tempPatronsID.contains(now.id) {
                tempPatronsID.append(now.id)
                matchPatrons.append(now)
            }
        }
        
        if matchPatrons.isEmpty { return false }
        
        var bulletsInt: Int = 0
        var i: Int = 0
        
        while i < clip.count {
            if clip[i] == nil {
                if bulletsInt < matchPatrons.count {
                    clip[i] = matchPatrons[bulletsInt]
                    Revolver.bulletID.append(matchPatrons[bulletsInt].id)
                    bulletsInt += 1
                    self.scroll(i)
                    i = 0
                }
            }
            i += 1
        }
        
        return true
    }
    
    func shoot() -> Patron? {
        if clip[0] == nil { print("Click\n") }
        else if clip[0]?.patronType == .charged { clip[0]?.shoot() }
        
        let newBulletsID = Revolver.bulletID.filter { $0 != clip[0]?.id }
        Revolver.bulletID = newBulletsID
        
        let shootedPatron = clip.removeFirst()
        clip.append(nil)
        
        return shootedPatron
    }
    
    func unload(_ index: Int) -> Patron? {
        if index < 0 || index >= clip.count { return nil }
        
        let newPatronsID = Revolver.bulletID.filter { $0 != clip[index]?.id }
        Revolver.bulletID = newPatronsID
        
        let unloadedPatron = clip.remove(at: index)
        clip.insert(nil, at: index)
        
        return unloadedPatron
    }
    
    func unloadAll() -> [Patron?] {
        let result = clip
        clip = [nil, nil, nil, nil, nil, nil]
        Revolver.bulletID.removeAll()
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
    
    func countPatronsInClip() -> Int {
        var count: Int = 0
        for now in clip {
            if now != nil { count += 1 }
        }
        return count
    }
    
    func toStringDescription() {
        print("Class: Revolver \(caliber) caliber")
        
        var line = "["
        for (i, now) in clip.enumerated() {
            if now == nil && i < clip.count - 1 { line += "nil, " }
            else if now == nil && i == clip.count - 1 { line += "nil]" }
            else if now != nil && i < clip.count - 1 {
                line += "Patron(id\(findIndexOfId(now!.id)), \(now!.patronType), \(now!.caliber)), "
            } else {
                line += "Patron(id\(findIndexOfId(now!.id)), \(now!.patronType), \(now!.caliber))]"
            }
        }
        print("Objects: \(line)")
        line = ""
        
        let ptr = pointer
        if ptr == nil { line += "nil" }
        else {
            line += "Patron(id\(findIndexOfId(ptr!.id)), \(ptr!.patronType), \(ptr!.caliber))"
        }
        print("Pointer: \(line)\n")
    }
    
    private func findIndexOfId(_ id: UUID) -> Int {
        for (i, now) in Revolver.bulletID.enumerated() {
            if now == id { return i }
        }
        return 0
    }
    
    subscript(index: Int) -> Patron? {
        if index < 0 || index >= clip.count { fatalError("Index out of range") }
        return clip[index]
    }
    
}

func p(_ rev: Revolver) {
    print(Revolver.bulletID)
    print(rev.clip)
    print()
}

func myTest() {
    let pb1 = Patron(patronType: .damp)
    let pl1 = Patron(patronType: .charged)
    let pb2 = Patron(patronType: .charged)
    let pl2 = Patron(patronType: .damp)
    let pAnotherCaliber = Patron(caliber: .c38)
    let rev = Revolver()
    var cnt = 0
    
    _ = rev.add(pb1)
    _ = rev.add(pb1)
    if Revolver.bulletID.count == 1 && rev.countPatronsInClip() == 1  {
        cnt += 1
    }
    
    _ = rev.addMany([pb1, pl1, pb2, pAnotherCaliber])
    if Revolver.bulletID.count == 3 && rev.countPatronsInClip() == 3 {
        cnt += 1
    }
    
    _ = rev.shoot()
    if Revolver.bulletID.count == 2 && rev.countPatronsInClip() == 2 {
        cnt += 1
    }
    
    _ = rev.unload(3)
    if Revolver.bulletID.count == 1 && rev.countPatronsInClip() == 1 {
        cnt += 1
    }
    
    _ = rev.add(pl2)
    _ = rev.unloadAll()
    if Revolver.bulletID.count == 0 && rev.countPatronsInClip() == 0 {
        cnt += 1
    }

    if cnt == 5 {
        print("myTest +")
    }
}
myTest()

func test() {
    let pd1 = Patron(patronType: .damp)
    let pc1 = Patron(patronType: .charged)
    let pc2 = Patron(patronType: .charged)
    let pd2 = Patron(patronType: .damp)
    let p = Patron()
    let pAnotherCaliber = Patron(caliber: .c38)
    let r1 = Revolver()
    let r2 = Revolver()
    
    _ = r1.addMany([pd1, pc1, pAnotherCaliber])
    _ = r2.addMany([pc2, pd2, pAnotherCaliber])
    
    print("1.1 Shoot of damp rev1")
    r1.toStringDescription()
    print("Shoot activated")
    _ = r1.shoot()
    r1.toStringDescription()

    print("1.2 Shoot of damp rev2")
    r2.toStringDescription()
    print("Shoot activated\n")
    _ = r2.shoot()
    r2.toStringDescription()
    
    _ = r1.unloadAll()
    _ = r2.unloadAll()
    print("2. One patron in two revolvers")
    print("rev1 = \(r1.add(p))")
    r1.toStringDescription()
    print("rev2 = \(r2.add(p))")
    r2.toStringDescription()

    _ = r1.unloadAll()
    _ = r2.unloadAll()
    let c1 = [p, pd1, pd2]
    let c2 = [p, pc1, pc2]
    print("3. Add collections to revolvers")
    print("rev1:")
    _ = r1.addMany(c1)
    r1.toStringDescription()
    print("rev2:")
    _ = r2.addMany(c2)
    r2.toStringDescription()
}

test()
