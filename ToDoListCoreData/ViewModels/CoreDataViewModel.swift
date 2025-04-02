//
//  CoreDataViewModel.swift
//  ToDoListCoreData
//
//  Created by Ahmed Hamza on 3/10/25.
//

import Foundation
import CoreData


class CoreDataViewModel: ObservableObject{
    @Published var savedEntities: [ToDoListItem] = []
    init() {
        fetchList()
    }
    func fetchList() {
        savedEntities = CoreDataManager.shared.fetchList()
    }
    func addItem(item: String) {
        CoreDataManager.shared.addItem(item: item)
        fetchList()
    }
    
    func deleteItem(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        let item = savedEntities[index]
        CoreDataManager.shared.deleteItem(item: item)
        fetchList()
    }
    
    func updateItem(item: ToDoListItem, newText: String) {
        CoreDataManager.shared.updateItem(item: item, newText: newText)
        fetchList()
    }
    
    func deleteAll() {
        CoreDataManager.shared.deleteAll()
        savedEntities.removeAll()
    }
    
    func toggleCompletion(item: ToDoListItem) {
        CoreDataManager.shared.toggleCompletion(item: item)
        fetchList()
    }
}

