//
//  main.swift
//  quest1
//
//  Created by Sergey Patrakov on 26.09.2024.
//

import Foundation
import RealmSwift

class Recipe: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String = ""
    @Persisted var instructions: String = ""
    @Persisted var imageURL: String = ""
}

let config = Realm.Configuration(
    schemaVersion: 1, // Увеличьте номер версии, если вы изменяете модель
    migrationBlock: { migration, oldSchemaVersion in
        if (oldSchemaVersion < 1) {
            // Никакой миграции не требуется, так как мы только что добавили первичный ключ.
        }
    }
)

// Установка конфигурации
Realm.Configuration.defaultConfiguration = config

class RecipeDataSource {
    private var realm: Realm
    
    init() {
        realm = try! Realm()
    }
    
    // CREATE
    func createRecipe(title: String, instructions: String, imageURL: String) {
        let recipe = Recipe()
        recipe.title = title
        recipe.instructions = instructions
        recipe.imageURL = imageURL
        
        try! realm.write {
            realm.add(recipe)
        }
    }
    
    // READ
    func readRecipe() -> [Recipe] {
        Array(realm.objects(Recipe.self))
    }
    
    // UPDATE
    func updateRecipe(id: ObjectId, newTitle: String, newInstructions: String, newImageURL: String) {
        if let recipe = realm.object(ofType: Recipe.self, forPrimaryKey: id) {
            try! realm.write {
                recipe.title = newTitle
                recipe.instructions = newInstructions
                recipe.imageURL = newImageURL
            }
        }
    }
    
    // DELETE
    func deleteRecipe(id: ObjectId) {
        if let recipe = realm.object(ofType: Recipe.self, forPrimaryKey: id) {
            try! realm.write {
                realm.delete(recipe)
            }
        }
    }
    
    // SEARCH
    func searchRecipe(title: String) -> [Recipe] {
        let result = realm.objects(Recipe.self).filter("title CONTAINS[cd] %@", title)
        return Array(result)
    }
    
}

let dataSource = RecipeDataSource()

// Заполнение базы данных
dataSource.createRecipe(title: "Пельмени", instructions: "1. Замесите тесто... 2. Сформируйте пельмени...", imageURL: "https://eda.ru/images/RecipePhoto/390x390/pelmeni-s-kuricey_175426_photo_183146.jpg")
dataSource.createRecipe(title: "Борщ", instructions: "1. Вскипятите воду... 2. Добавьте свеклу...", imageURL: "https://s1.eda.ru/StaticContent/Photos/120131085552/171206075835/p_O.jpg")

// Получение и вывод данных
let recipes = dataSource.readRecipe()
print("Список рецептов:")
recipes.forEach { recipe in
    print("\(recipe.title) - \(recipe.instructions) [\(recipe.imageURL)]")
}

// Удаление первого элемента
if let firstRecipe = recipes.first {
    dataSource.deleteRecipe(id: firstRecipe.id)
}

// Проверяем оставшиеся рецепты
print("\nПосле удаления первого рецепта:")
let updatedRecipes = dataSource.readRecipe()
updatedRecipes.forEach { recipe in
    print("\(recipe.title) - \(recipe.instructions) [\(recipe.imageURL)]")
}

// Обновление первого рецепта
if let firstRecipe = updatedRecipes.first {
    dataSource.updateRecipe(id: firstRecipe.id, newTitle: "Обновленный Борщ", newInstructions: "На самом деле вот так!", newImageURL: "https://primebeef.ru/images/cms/data/3-501.jpg")
}

// Поиск рецепта
let searchResults = dataSource.searchRecipe(title: "Обновленный Борщ")
print("\nРезультаты поиска:")
searchResults.forEach { recipe in
    print("\(recipe.title) - \(recipe.instructions) [\(recipe.imageURL)]")
}
