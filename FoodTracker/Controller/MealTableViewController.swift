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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
        
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
        return DataService.sharedInstance.mocMeals.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "MealTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MealTableViewCell else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let meal = DataService.sharedInstance.mocMeals[indexPath.row]
        
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
        if let mealDetailViewController = segue.destination as? MealViewController {
            if let selectedMeal = tableView.indexPathForSelectedRow {
                mealDetailViewController.indexPath = selectedMeal
                mealDetailViewController.food = DataService.sharedInstance.mocMeals[selectedMeal.row]
            }
        }
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            DataService.sharedInstance.remove(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
    
}
