//
//  AddSemesterViewController.swift
//  UniTimeTable
//
//  Created by Godfrey Gao on 16/5/8.
//  Copyright © 2016年 Godfrey Gao. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class AddSemesterViewController: UIViewController {
    
    var managedObjectContext: NSManagedObjectContext
    var startDate = NSDate()
    var endDate = NSDate()
    
    @IBOutlet var semesterNameInput: UITextField!
    @IBOutlet var semesterStartDate: UITextField!
    @IBOutlet var semesterEndDate: UITextField!
    
    //Start Datepicker
    @IBAction func editStartDate(sender: UITextField) {
        let datePickerView: UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.Date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(AddSemesterViewController.startdatePickerValueChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
    }
    func startdatePickerValueChanged(sender: UIDatePicker){
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        startDate = sender.date
        semesterStartDate.text = dateFormatter.stringFromDate(sender.date)
    }
    
    //End Datepicker
    @IBAction func editEndDate(sender: UITextField) {
        let datePickerView: UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.Date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(AddSemesterViewController.enddatePickerValueChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
    }
    func enddatePickerValueChanged(sender: UIDatePicker){
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        endDate = sender.date
        semesterEndDate.text = dateFormatter.stringFromDate(sender.date)
    }
    
    @IBAction func clearContent(sender: UITextField) {
        var stringCache: String
        stringCache = semesterNameInput.text!
        if (stringCache == " Input Semester Name")
        {
            semesterNameInput.text = ""
        }
        semesterNameInput.textColor = UIColor.blackColor()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.managedObjectContext = appDelegate.managedObjectContext
        super.init(coder: aDecoder)
    }
    
    //Button function
    @IBAction func saveSemester(sender: UIButton) {
        
        //Create delegate and NSManagedObjectContext
        let appDel: AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context: NSManagedObjectContext = appDel.managedObjectContext
        
        //Add a newSemester Object into the Semester table
        let newSemester = NSEntityDescription.insertNewObjectForEntityForName("Semester", inManagedObjectContext: context)
        //Edit the value of the object and save into the core data
        newSemester.setValue(semesterNameInput.text, forKey: "name")
        newSemester.setValue(startDate, forKey: "startYear")
        newSemester.setValue(endDate, forKey: "endYear")
        do{
            try context.save()
        }catch
        {
            let fetchError = error as NSError
            print(fetchError)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
