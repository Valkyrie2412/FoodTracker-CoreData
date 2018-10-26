//
//  MealViewController.swift
//  FoodTracker
//
//  Created by Hiếu Nguyễn on 7/26/18.
//  Copyright © 2018 Hiếu Nguyễn. All rights reserved.
//

import UIKit
import os.log

class MealViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //MARK: Properties
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    /*
     This value is either passed by `MealTableViewController` in `prepare(for:sender:)`
     or constructed as part of adding a new meal.
     */
    var indexPath: IndexPath!
    var food: Food?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Xử lý đầu vào nội dung trường văn bản của người dùng thông qua gọi lại delegate
        nameTextField.delegate = self
        if indexPath != nil {
            navigationItem.title = DataService.sharedInstance.mocMeals[indexPath.row].name
            nameTextField.text = DataService.sharedInstance.mocMeals[indexPath.row].name
            photoImageView.image = DataService.sharedInstance.mocMeals[indexPath.row].photo as? UIImage
            ratingControl.rating = Int(DataService.sharedInstance.mocMeals[indexPath.row].rating)
        }
        
        // Enable the Save button only if the text field has a valid Meal name.
        updateSaveButtonState()
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Loại bỏ bộ chọn nếu người dùng đã huỷ
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        // Set photoImageView to display the selected image.
        photoImageView.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    
    
    // MARK: Navigation
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func sendingData(_ sender: Any) {
        guard let name = nameTextField.text  else {
            return
        }
        guard let photo = photoImageView.image else {return}
        
        let rating = ratingControl.rating
        
        if food == nil {
            food = Food(context: AppDelegate.context)
        }
        
        food?.name = name
        food?.rating = Int16(Int(rating) )
        food?.photo = photo
        
        if indexPath != nil {
            DataService.sharedInstance.edit(at: indexPath.row, and: food!)
        } else {
            DataService.sharedInstance.addData(food: food!)
        }
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        // Hide the keyboard
        nameTextField.resignFirstResponder()
        
        // UIImagePickerController là một view controller cho phép một người dùng chọn phương tiện từ thư viện ảnh của họ.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    //MARK: Private Methods
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
    
}

