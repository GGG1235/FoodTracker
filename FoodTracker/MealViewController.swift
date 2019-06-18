//
//  MealViewController.swift
//  FoodTracker
//
//  Created by GGG1235 on 2019/4/23.
//  Copyright © 2019 顾旭凯. All rights reserved.
//

import UIKit
import os.log

class MealViewController: UIViewController,UITextFieldDelegate,
UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    //MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingcontrol: Ratingcontroll!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var meal: Meal?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Handle the text field's user input through delegate callbacks.
        nameTextField.delegate = self
        
        // Set up view if editing an existing Meal.
        if let meal = meal {
            navigationItem.title = meal.name
            nameTextField.text = meal.name
            photoImageView.image = meal.photo
            ratingcontrol.rating = meal.rating
        }
        
        // Enable the save button only if the textfield has a valid Meal name
        updateSaveButtonState()
    }
    //Mark: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the save button whike editing
        saveButton.isEnabled = false
    }
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // The info dictionary may contain multiple representation of the image.You want to use the original.
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("Expected a dictionary an image,but was provided the following:\(info)")
        }
        // Set photoImageView to display the selected image.
        photoImageView.image = selectedImage
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Navigation
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        if isPresentingInAddMealMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        } else {
            fatalError("The MealViewController is not inside a naviagation controller.")
        }
    }
    // This method lets you configure a view controller before it's presented
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem,button === saveButton else {
            os_log("The save button was not pressed. cancelling", log: OSLog.default,type:.debug)
            return
        }
        let name = nameTextField.text ?? ""
        let photo = photoImageView.image
        let rating = ratingcontrol.rating
        
        meal = Meal(name: name, photo: photo, rating: rating)
    }
    
    //MARK: Actions
    @IBAction func selectimageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        // Hide the keyboard
        nameTextField.resignFirstResponder()
        // UIImagePickerController is a view controller that lets a user pick media from their photo library
        let imagePickerController = UIImagePickerController()
        // Only allow photos to be picked,not taken
        imagePickerController.sourceType = .photoLibrary
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true,completion: nil)
    }
    
    // MARK: Private Methods
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
}

