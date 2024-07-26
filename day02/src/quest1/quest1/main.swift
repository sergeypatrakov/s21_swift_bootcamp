//
//  main.swift
//  quest1
//
//  Created by Sergey Patrakov on 14.07.2024.
//

import Foundation

class Company {
    let name: String
    let activity: String // (IT, Banking, Public services)
    let description: String
    var vacancies: [Vacancy] // (Developer, QA, Project Manager, Analyst, Designer), level (junior, middle, senior)
    var requiredSkills: [String] // ["swift", "CoreData", "Realm"]
    let contacts: String

    init(name: String, activity: String, description: String, vacancies: [Vacancy], requiredSkills: [String], contacts: String) {
        self.name = name
        self.activity = activity
        self.description = description
        self.vacancies = vacancies
        self.requiredSkills = requiredSkills
        self.contacts = contacts
    }
    
    func interview(vacancyNumber: Int, candidate: Candidate) -> Bool {
        let matching = Set(candidate.skills).intersection(Set(requiredSkills)).count
        return Double(matching) / Double(requiredSkills.count) < 0.5 ? false : Bool.random()
    }

}

class Vacancy {
    let profession: String // (Developer, QA, Project Manager, Analyst, Designer)
    let level: String // level (junior, middle, senior)
    let salary: Double
    
    init(profession: String, level: String, salary: Double) {
        self.profession = profession
        self.level = level
        self.salary = salary
    }
}

class Candidate {
    let name: String
    let profession: String // (Developer, QA, Project Manager, Analyst, Designer)
    let level: String // (junior, middle, senior)
    let salary: Double
    let skills: [String]

    init(name: String, profession: String, level: String, salary: Double, skills: [String]) {
        self.name = name
        self.profession = profession
        self.level = level
        self.salary = salary
        self.skills = skills
    }
}

let companies = [
    Company(name: "SBER", activity: "Banking", description: "Russian majority state-owned banking and financial services company headquartered in Moscow", vacancies: [
    Vacancy(profession: "Developer", level: "junior", salary: 100_000),
    Vacancy(profession: "QA", level: "junior", salary: 70_000),
    Vacancy(profession: "Project Manager", level: "middle", salary: 250_000)
], requiredSkills: ["Swift", "SwiftUI", "algorithms"], contacts: "88005555550"),
    
    Company(name: "Yandex", activity: "IT", description: "Russian multinational technology company", vacancies: [
    Vacancy(profession: "Developer", level: "junior", salary: 100_000),
    Vacancy(profession: "Developer", level: "middle", salary: 250_000),
    Vacancy(profession: "Analyst", level: "junior", salary: 70_000),
    Vacancy(profession: "Designer", level: "middle", salary: 220_000)
], requiredSkills: ["Swift", "C", "SwiftUI", "algorithms"], contacts: "88002509639"),
    
    Company(name: "Apple", activity: "IT", description: "American multinational technology company", vacancies: [
    Vacancy(profession: "Developer", level: "junior", salary: 190_000),
    Vacancy(profession: "QA", level: "junior", salary: 80_000)
], requiredSkills: ["Swift", "Objective-C", "C++", "C"], contacts: "18008543680"),
    
    Company(name: "VK", activity: "IT", description: "Social network from Aeroport and Pavel Durov", vacancies: [
    Vacancy(profession: "Developer", level: "senior", salary: 300_000),
    Vacancy(profession: "Developer", level: "middle", salary: 100_000),
    Vacancy(profession: "Project Manager", level: "middle", salary: 150_000)
], requiredSkills: ["Swift", "SwiftUI", "Objective-C"], contacts: "office@vk.company"),
    Company(name: "Avito", activity: "IT", description: "Russian classified advertisements website with sections devoted to general goods for sale, jobs, real estate, personals", vacancies: [
    Vacancy(profession: "Developer", level: "middle", salary: 210_000),
    Vacancy(profession: "Developer", level: "senor", salary: 340_000),
    Vacancy(profession: "QA", level: "junior", salary: 80_000)
], requiredSkills: ["Swift", "UIKit", "algorithms"], contacts: "https://support.avito.ru")]

let candidate = Candidate(name: "Sergey", profession: "Developer", level: "junior", salary: 60_000, skills: ["Swift", "algorithms", "C", "Docker", "CICD"])

func findSuitableVacancies(for candidate: Candidate) -> [(Company, Vacancy)] {
    var suitableVacancies: [(Company, Vacancy)] = []
    
    for company in companies {
        for vacancy in company.vacancies {
            if vacancy.profession == candidate.profession && vacancy.level == candidate.level && vacancy.salary >= candidate.salary {
                suitableVacancies.append((company, vacancy))
            }
        }
    }
    
    return suitableVacancies
}

// Выводим подходящие вакансии
let suitableVacancies = findSuitableVacancies(for: candidate)

print("""
      Candidate:
      - Name: \(candidate.name)
      - Profession: \(candidate.profession)
      - Level: \(candidate.level)
      - Salary: \(candidate.salary)
      - Skills: \(candidate.skills)
      """)

print("\nСписок подходящих вакансий:")
for (index, (company, vacancy)) in suitableVacancies.enumerated() {
    print("\(index + 1). \(vacancy.level) \(vacancy.profession) --- >= \(vacancy.salary)\n  \(company.name)\n  \(company.activity)\n  \(company.requiredSkills)\n---------------------------------------")
}

// Обработка ввода номера вакансии
while true {
    print("Enter a vacancy number:")
    if let input = readLine(), let vacancyNumber = Int(input), vacancyNumber > 0 && vacancyNumber <= suitableVacancies.count {
        let (selectedCompany, selectedVacancy) = suitableVacancies[ vacancyNumber - 1 ]
        
        print("Processing Interview...\n")
        if selectedCompany.interview(vacancyNumber: vacancyNumber - 1, candidate: candidate) { print("Success, candidate was applied.") }
        else { print("Unfortunately, the candidate did not pass the interview.") }
        break
    } else { print("It doesn't look like a correct input.") }
}
