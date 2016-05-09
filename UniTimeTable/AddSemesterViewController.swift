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
    
    @IBAction func saveSemester(sender: UIButton) {
        let appDel: AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context: NSManagedObjectContext = appDel.managedObjectContext
        
        let newSemester = NSEntityDescription.insertNewObjectForEntityForName("Semester", inManagedObjectContext: context)
        newSemester.setValue(semesterNameInput.text, forKey: "name")
        newSemester.setValue(startDate, forKey: "startYear")
        newSemester.setValue(endDate, forKey: "endYear")
        print(newSemester)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
