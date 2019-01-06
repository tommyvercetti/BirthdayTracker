//
//  ViewController.swift
//  BirthdayTracker
//
//  Created by Andrian Kryk on 12/13/18.
//  Copyright © 2018 Andrian Kryk. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class AddBirthdayViewController: UIViewController {
	
	@IBOutlet var firstNameTextField: UITextField!
	@IBOutlet var lastNameTextField: UITextField!
	@IBOutlet var birthdatePicker: UIDatePicker!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		birthdatePicker.maximumDate = Date ()
		
	}
	
	@IBAction func saveTapped(_ sender: UIBarButtonItem){
		print("SAVE button tapped")
		
		let firstName = firstNameTextField.text ?? ""
		let lastName = lastNameTextField.text ?? ""
		print("My name is \(firstName) \(lastName).")
		let birthdate = birthdatePicker.date
		print("My birthdate is \(birthdate)")
		
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		let context = appDelegate.persistentContainer.viewContext
		
		let newBirthday = Birthday(context: context)
		newBirthday.firstName = firstName
		newBirthday.lastName = lastName
		newBirthday.birthdate = birthdate as Date?
		newBirthday.birthdayId = UUID().uuidString
		
		if let uniqueId = newBirthday.birthdayId {
			print("birthdayID: \(uniqueId)")
		}
		
		do {
			try context.save()
			let message = "Wish \(firstName) \(lastName) a Happy Birthday today!"
			let content = UNMutableNotificationContent()
			content.body = message
			content.sound = UNNotificationSound.default
			
			var dateComponents = Calendar.current.dateComponents([.month, .day], from: birthdate)
			dateComponents.hour = 20
			dateComponents.minute = 35
			
			let trigger = UNCalendarNotificationTrigger (dateMatching: dateComponents, repeats: true)
			if let identifier = newBirthday.birthdayId {
				let request = UNNotificationRequest (identifier: identifier, content: content, trigger: trigger)
				let center = UNUserNotificationCenter.current()
				center.add(request, withCompletionHandler: nil)
			}
			
		} catch let error {
			print("can't save because of error \(error).")
		}
		
		
		
		
		
		
		dismiss(animated: true, completion: nil)
		
	}
	
	@IBAction func cancelTapped(_ sender: UIBarButtonItem) {
		dismiss (animated: true, completion: nil)
	}
}


