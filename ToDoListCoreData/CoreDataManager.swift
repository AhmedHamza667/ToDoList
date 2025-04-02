//
//  CoreDataManager.swift
//  ToDoListCoreData
//
//  Created by Ahmed Hamza on 3/11/25.
//

import Foundation
import CoreData

class CoreDataManager{
    
    static var shared = CoreDataManager()
    let container: NSPersistentContainer
    var viewContext:NSManagedObjectContext{
        container.viewContext
    }
    init(){
        
        container = NSPersistentContainer(name: "ToDoListContainer")
        container.loadPersistentStores{ description, error in
            if let error = error {
                print("Error loading core date: \(error)")
            }
        }
    }
    
    
    
    func fetchList() -> [ToDoListItem] {
        let request = NSFetchRequest<ToDoListItem>(entityName: "ToDoListItem")
        do {
            return try viewContext.fetch(request)
        } catch {
            print("Error fetching: \(error)")
            return []
        }
    }
    func addItem(item: String){
        let newToDo = ToDoListItem(context: container.viewContext)
        newToDo.item = item
        newToDo.isCompleted = false
        saveData()
    }
    func saveData(){
        do {
            try container.viewContext.save()
        } catch let error {
            print("Error saving: \(error)")
        }
    }
    func deleteItem(item: ToDoListItem) {
            viewContext.delete(item)
            saveData()
        }
    func updateItem(item: ToDoListItem, newText: String){
        item.item = newText
        saveData()
    }
    func toggleCompletion(item: ToDoListItem) {
        item.isCompleted.toggle()
        saveData()
    }
    func deleteAll(){
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "ToDoListItem")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try container.viewContext.execute(batchDeleteRequest)
            try container.viewContext.save()
        } catch let error {
            print("Error deleting all items: \(error)")
        }
    }
    
}
