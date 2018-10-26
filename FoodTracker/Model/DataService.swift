//
//  DataService.swift
//  FoodTracker
//
//  Created by Hiếu Nguyễn on 8/16/18.
//  Copyright © 2018 Hiếu Nguyễn. All rights reserved.
//

import UIKit
import os.log
import CoreData

class DataService {
    static let sharedInstance: DataService = DataService()
    private var _mocMeals: [Food]?
    
    var mocMeals: [Food] {
        get {
            if _mocMeals == nil {
                loadDataEntity()
            }
            return _mocMeals ?? []
        }
        set {
            _mocMeals = newValue
        }
    }
    
    
    func loadDataEntity()  {
        _mocMeals = []
        do {
            _mocMeals = try AppDelegate.context.fetch(Food.fetchRequest()) as? [Food]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    
    func addData(food: Food)  {
        _mocMeals?.append(food)
        saveData()
    }
    func edit(at index: Int, and food: Food) {
        _mocMeals?[index] = food
        saveData()
    }
    
    func remove(at indexPath: IndexPath)  {
        guard let food = _mocMeals else { return}
        AppDelegate.context.delete(food[indexPath.row])
        loadDataEntity()
        saveData()
    }
    
    private func saveData()  {
        AppDelegate.saveContext()
    }
}
