//
//  main.swift
//  quest3
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

protocol PlayerAction {
    func findOpponent() -> Profile?
}

enum Status {
    case inPlay
    case search
    case idle
    case offline
}

class Server: PlayerAction {
    func findOpponent() -> Profile? {
        for now in gamers {
            if now.status == .search { return now }
        }
        return nil
    }
    
    var adress: String
    var gamers: [Profile]
    
    init(adress: String = "default", gamers: [Profile] = []) {
        self.adress = adress
        self.gamers = gamers
    }
}

class Profile {
    var id: UUID
    var nickname: String
    var age: Int
    var name: String
    var rev: Revolver
    let profileCreatingDate: String
    var status: Status
    lazy var reference = {
        return "http://gameserver.com/\(id)-\(nickname)"
    }()
    var playerActionDelegate: PlayerAction?
    
    init(id: UUID = UUID(), nickname: String = "ilyansky", age: Int = 131, name: String = "Ilya", rev: Revolver = Revolver(), profileCreatingDate: String = "01.01.1001", status: Status = .offline) {
        self.id = id
        self.nickname = nickname
        self.age = age
        self.name = name
        self.rev = rev
        self.profileCreatingDate = profileCreatingDate
        self.status = status
    }
    
    func changeStatus(newStatus: Status) {
        self.status = newStatus
    }
}

var p1 = Profile(status: .idle)
var p2 = Profile(status: .inPlay)
var p3 = Profile(status: .offline)
var p4 = Profile(status: .search)
var myp = Profile(status: .idle)
var s = Server(gamers: [p1, p2, p3, p4, myp])

p1.playerActionDelegate = s
p2.playerActionDelegate = s
p3.playerActionDelegate = s
p4.playerActionDelegate = s
myp.playerActionDelegate = s

print(myp.status)
print(p4.status)
print()

myp.changeStatus(newStatus: .search)
if let opponent = myp.playerActionDelegate?.findOpponent() {
    opponent.changeStatus(newStatus: .inPlay)
    myp.changeStatus(newStatus: .inPlay)
    print("Opponent has been searched\n")
} else {
    print("There is no opponent in search right now\n")
}

print(myp.status)
print(p4.status)
