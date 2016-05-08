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

protocol addSemesterDelegate {
    func addSemester(semester: Semester)
}

class AddSemesterViewController: UIViewController {
    
    var allSemester: NSArray?
    var delegate: addSemesterDelegate!
    var managedObjectContext: NSManagedObjectContext
    
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
        //dateInput = sender.date
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
        //dateInput = sender.date
        semesterEndDate.text = dateFormatter.stringFromDate(sender.date)
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.managedObjectContext = appDelegate.managedObjectContext
        super.init(coder: aDecoder)
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
