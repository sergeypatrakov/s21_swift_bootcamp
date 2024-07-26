//
//  main.swift
//  quest2
//
//  Created by Sergey Patrakov on 22.07.2024.
//

import Foundation

class Candidate {
    let fullName: String
    let profession: String
    let gender: String
    let dateOfBirth: String
    let contact: String
    let education: [Education]
    let workExperience: [WorkExperience]
    let about: String
    
    init(fullName: String, profession: String, gender: String, dateOfBirth: String, contact: String, education: [Education], workExperience: [WorkExperience], about: String) {
        self.fullName = fullName
        self.profession = profession
        self.gender = gender
        self.dateOfBirth = dateOfBirth
        self.contact = contact
        self.education = education
        self.workExperience = workExperience
        self.about = about
    }
}

class Education {
    let type: String
    let years: String
    let description: String

    init(type: String, years: String, description: String) {
        self.type = type
        self.years = years
        self.description = description
    }
}

class WorkExperience {
    let period: String
    let nameOfCompany: String
    let contacts: String?
    let description: String
    
    init(period: String, nameOfCompany: String, contacts: String?, description: String) {
        self.period = period
        self.nameOfCompany = nameOfCompany
        self.contacts = contacts
        self.description = description
    }
}

func parseResume(filePath: String) -> Candidate? {
    guard let resumeContent = try? String(contentsOfFile: filePath) else {
        print("Не удалось прочитать файл резюме")
        return nil
    }
    
    let lines = resumeContent.components(separatedBy: "\n").filter { !$0.isEmpty }
    
    guard lines.count > 5 else {
        print("Недостаточно данных в резюме")
        return nil
    }
    let fullName = lines[1]
    let profession = lines[2]
    let gender = lines[3]
    let birthDate = lines[4]
    let contacts = lines[5]
    
    var education = [Education]()
    var workExperience = [WorkExperience]()
    var about = ""
    
    // Считывание информации об образовании
    let educationStartIndex = 7 // Начало информации об образовании
    while educationStartIndex < lines.count, lines[educationStartIndex] != "# Job experience" {
        let educationType = lines[educationStartIndex]
        let educationYears = lines[educationStartIndex + 1]
        let educationDescription = lines[educationStartIndex + 2]
        education.append(Education(type: educationType, years: educationYears, description: educationDescription))
        break
    }
    
    // Считывание информации о опыте работы
    let workExperienceStartIndex = 11
    while workExperienceStartIndex < lines.count, lines[workExperienceStartIndex] != "О себе" {
        let workPeriod = lines[workExperienceStartIndex]
        let companyName = lines[workExperienceStartIndex + 1]
        let companyContacts = lines[workExperienceStartIndex + 2]
        let workDescription = lines[workExperienceStartIndex + 3]
        workExperience.append(WorkExperience(period: workPeriod, nameOfCompany: companyName, contacts: companyContacts, description: workDescription))
        break
    }
    
    // Считывание информации о себе
    if workExperienceStartIndex < lines.count {
        about = lines[17]
    }
    
    return Candidate(fullName: fullName, profession: profession, gender: gender, dateOfBirth: birthDate, contact: contacts, education: education, workExperience: workExperience, about: about)
}

func analyzeResume(resume: Candidate, tags: [String]) -> (wordCount: [String: Int], matchedTags: [String]) {
    var wordCount = [String: Int]()
    var matchedTags = [String]()

    let entireText = [resume.fullName, resume.profession, resume.gender, resume.dateOfBirth, resume.contact] +
                     resume.education.map { $0.description } +
                     resume.workExperience.map { $0.description } +
                     [resume.about]
    
    let words = entireText.joined(separator: " ").split(separator: " ")
    
    for word in words {
        let lowercasedWord = word.lowercased()
        wordCount[lowercasedWord] = (wordCount[lowercasedWord] ?? 0) + 1
    }
    
    for tag in tags {
        if wordCount[tag.lowercased()] != nil, !matchedTags.contains(tag) { matchedTags.append(tag) }
    }
    
    return (wordCount, matchedTags)
}

func exportResume(candidate: Candidate, filePath: String) {
    var exportContent = """
    # Candidate info
    \(candidate.fullName)
    \(candidate.profession)
    \(candidate.gender)
    \(candidate.dateOfBirth)
    \(candidate.contact)
    
    # Education\n
    """
    
    for education in candidate.education {
        exportContent += """
        \(education.type)
        \(education.years)
        \(education.description)\n
        """
    }
    
    exportContent += "\n# Job experience\n"
    
    for experience in candidate.workExperience {
        exportContent += """
        \(experience.period)
        \(experience.nameOfCompany)
        \(experience.contacts ?? "No cantacts")
        \(experience.description)\n...\n
        """
    }
    
    exportContent += "\n# Free block\n\(candidate.about)\n...\n"
    
    do {
        try exportContent.write(toFile: filePath, atomically: true, encoding: .utf8)
        print("Данные успешно экспортированы в \(filePath)")
    } catch {
        print("Ошибка записи в файл: \(error)")
    }
}

func writeAnalysis(wordCount: [String: Int], matchedTags: [String], filePath: String) {
    var analysisContent = "# Words:\n"
    
    let sortedWords = wordCount.sorted { $0.value > $1.value }
    for (word, count) in sortedWords { analysisContent += "\(word) - \(count)\n" }
    
    analysisContent += "\n# Matched tags\n"
    for tag in matchedTags { analysisContent += "\(tag)\n" }
    
    do {
        try analysisContent.write(toFile: filePath, atomically: true, encoding: .utf8)
        print("Анализ успешно записан в \(filePath)")
    } catch {
        print("Ошибка записи в файл: \(error)")
    }
}

func main() {
    let resumeFilePath = "/Users/sergeypatrakov/Dev/school21/Swift_bootcamp/Swift_Bootcamp.Day02-1/src/quest2/quest2/resume.txt"
    let tagsFilePath = "/Users/sergeypatrakov/Dev/school21/Swift_bootcamp/Swift_Bootcamp.Day02-1/src/quest2/quest2/tags.txt"
    
    guard let candidate = parseResume(filePath: resumeFilePath) else { return }
    guard let tagsContent = try? String(contentsOfFile: tagsFilePath) else {
        print("Не удалось прочитать файл тегов")
        return
    }
    
    let tags = tagsContent.components(separatedBy: "\n").filter { !$0.isEmpty }
    let (wordCount, matchedTags) = analyzeResume(resume: candidate, tags: tags)

    exportResume(candidate: candidate, filePath: "/Users/sergeypatrakov/Dev/school21/Swift_bootcamp/Swift_Bootcamp.Day02-1/src/quest2/quest2/export.txt")
    writeAnalysis(wordCount: wordCount, matchedTags: matchedTags, filePath: "/Users/sergeypatrakov/Dev/school21/Swift_bootcamp/Swift_Bootcamp.Day02-1/src/quest2/quest2/analysis.txt")
}

main()
