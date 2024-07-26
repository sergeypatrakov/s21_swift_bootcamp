//
//  main.swift
//  quest5
//
//  Created by Sergey Patrakov on 26.07.2024.
//

import Foundation

func readFileContents(atPath path: String) -> String? {
    do {
        let contents = try String(contentsOfFile: path, encoding: .utf8)
        return contents
    } catch {
        print("Ошибка чтения файла: \(error)")
        return nil
    }
}

func compareResumes(importedResumePath: String, exportedResumePath: String) {
    guard let importedResume = readFileContents(atPath: importedResumePath) else {
        print("Не удалось прочитать импортированное резюме.")
        return
    }
    
    guard let exportedResume = readFileContents(atPath: exportedResumePath) else {
        print("Не удалось прочитать экспортированное резюме.")
        return
    }
    
    importedResume == exportedResume ? print("Text comparator: resumes are identical") : print("Text comparator: resumes are different")
}

let importedResumePath = "/Users/sergeypatrakov/Dev/school21/Swift_bootcamp/Swift_Bootcamp.Day02-1/src/quest2/quest2/resume.txt"
let exportedResumePath = "/Users/sergeypatrakov/Dev/school21/Swift_bootcamp/Swift_Bootcamp.Day02-1/src/quest2/quest2/export.txt"

compareResumes(importedResumePath: importedResumePath, exportedResumePath: exportedResumePath)
