//
//  MealTableViewController.swift
//  FoodTracker
//
//  Created by Hiếu Nguyễn on 7/30/18.
//  Copyright © 2018 Hiếu Nguyễn. All rights reserved.
//

import UIKit
import os.log
import CoreData

class MealTableViewController: UITableViewController {
    // MARK: Properties
    
    var meals = DataService.sharedInstance.mocMeals
    var filteredMeals = [Food]()
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
        
        //Bằng việc gán protocol searchResultsUpdater, chúng ta có thể xác định mỗi khi ô text trong search bar được thay đổi.
        searchController.searchResultsUpdater = self
        // set là false để trong quá trình search, tableView của chúng ta không bị che khuất
        searchController.dimsBackgroundDuringPresentation = false
        // Ẩn/ hiện Navigation khi nút search active
        searchController.hidesNavigationBarDuringPresentation = false
        // true để search bar của chúng ta không bị lỗi layout khi sử dụng
        definesPresentationContext = true
        //hien thi
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Meal"
        navigationItem.searchController = searchController
        filteredMeals = meals
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMeals.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "MealTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MealTableViewCell else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let meal = filteredMeals[indexPath.row]
        
        cell.nameLabel.text = meal.name
        cell.photoImageView.image = meal.photo as? UIImage
        cell.ratingControl.rating = Int(meal.rating)
        
        return cell
    }
    
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let mealViewController = segue.destination as? MealViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            mealViewController?.food = filteredMeals[indexPath.row]
        }
    }
    
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? MealViewController, let meal = sourceViewController.food {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                if let index = meals.index(of: filteredMeals[selectedIndexPath.row]) {
                    meals[index] = meal
                    filteredMeals = meals
                }
            }
            else {
                // Add a new meal
                meals.append(meal)
                filteredMeals = meals
            }
            tableView.reloadData()
            // Save the meals
            DataService.sharedInstance.saveData()
        }
    }
    
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            
            let meal = filteredMeals[indexPath.row]
            filteredMeals.remove(at: indexPath.row)
            DataService.sharedInstance.remove(food: meal)
            tableView.deleteRows(at: [indexPath], with: .fade)
        default:
            print("Something")
        }
        tableView.reloadData()
    }
}

extension MealTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        filteredMeals = searchText.isEmpty ? (meals) : (meals.filter({ (data) -> Bool in
            return (data.name?.lowercased().contains(searchText.lowercased()))!
        }))
        tableView.reloadData()
    }
}
