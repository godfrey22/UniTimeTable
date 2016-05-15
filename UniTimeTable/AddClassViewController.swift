//
//  AddClassViewController.swift
//  UniTimeTable
//
//  Created by Godfrey Gao on 16/5/13.
//  Copyright © 2016年 Godfrey Gao. All rights reserved.
//

import UIKit
import CoreData

protocol addClassDelegate {
    func addClass(_class: Class)
}

class AddClassViewController: UIViewController, typeSelectionDelegate {
    
    
    var delegate: addClassDelegate!
    var managedObjectContext: NSManagedObjectContext
    var selectedType: Type!
    
    var startDate = NSDate()
    var endDate = NSDate()
    var startTime = NSDate()
    var endTime = NSDate()
    var timeCheck = true
    var dateCheck = true

    @IBOutlet var typeInput: UITextField!
    @IBOutlet var startDateInput: UITextField!
    @IBOutlet var endDateInput: UITextField!
    @IBOutlet var startTimeInput: UITextField!
    @IBOutlet var endTimeInput: UITextField!
    @IBOutlet var durationLabel: UILabel!
    @IBOutlet var weekSelection: UISegmentedControl!
    @IBOutlet var locationInput: UITextField!
    
    required init?(coder aDecoder: NSCoder) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.managedObjectContext = appDelegate.managedObjectContext
        super.init(coder: aDecoder)
    }
    
    //Start Datepicker
    @IBAction func editStartDate(sender: UITextField) {
        let datePickerView: UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.Date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(AddClassViewController.startdatePickerValueChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
    }
    func startdatePickerValueChanged(sender: UIDatePicker){
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        startDate = sender.date
        startDateInput.text = dateFormatter.stringFromDate(sender.date)
    }
    //End Datepicker
    @IBAction func editEndDate(sender: UITextField) {
        let datePickerView: UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.Date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(AddClassViewController.enddatePickerValueChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
    }
    func enddatePickerValueChanged(sender: UIDatePicker){
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        endDate = sender.date
        endDateInput.text = dateFormatter.stringFromDate(sender.date)
    }
    //Start time input picker
    @IBAction func editStartTime(sender: UITextField) {
        let datePickerView: UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.Time
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(AddClassViewController.startTimePickerValueChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
    }
    func startTimePickerValueChanged(sender: UIDatePicker){
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.NoStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        startTime = sender.date
        startTimeInput.text = dateFormatter.stringFromDate(sender.date)
        calcNShowDuration()
    }
    //End time input picker
    @IBAction func editEndTime(sender: UITextField) {
        let datePickerView: UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.Time
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(AddClassViewController.endTimePickerValueChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
    }
    func endTimePickerValueChanged(sender: UIDatePicker){
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.NoStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        endTime = sender.date
        endTimeInput.text = dateFormatter.stringFromDate(sender.date)
        calcNShowDuration()
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "ViewType"
        {
            let typeViewController: TypeViewController = segue.destinationViewController as! TypeViewController
            typeViewController.managedObjectContext = self.managedObjectContext
            typeViewController.delegate = self
        }
    }
    
    @IBAction func addClass(sender: AnyObject) {
        let newClass: Class = (NSEntityDescription.insertNewObjectForEntityForName("Class", inManagedObjectContext: self.managedObjectContext) as! Class)
                var week: Int
                switch(weekSelection.selectedSegmentIndex)
                {
                case 0:
                    week = 7
                    break
                case 1:
                    week = 1
                    break
                case 2:
                    week = 2
                    break
                case 3:
                    week = 3
                    break
                case 4:
                    week = 4
                    break
                case 5:
                    week = 5
                    break
                case 6:
                    week = 6
                    break
                default:
                    week = 1
                }
        newClass.setValue(startDate, forKey: "startDate")
        newClass.setValue(endDate, forKey: "endDate")
        newClass.setValue(startTime, forKey: "startTime")
        newClass.setValue(endTime, forKey: "endTime")
        newClass.setValue(week, forKey: "week")
        newClass.setValue(locationInput.text, forKey: "location")
        self.delegate!.addClass(newClass)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func didSelectType(type: Type) {
        selectedType = type
    }
    
    func calcNShowDuration(){
        let cal = NSCalendar.currentCalendar()
        let unit:NSCalendarUnit = NSCalendarUnit.Minute
        let time = cal.components(unit, fromDate: startTime, toDate: endTime, options: [])
        let hour = time.minute/60
        let min = time.minute - hour * 60
        if(hour<0||min<0){
            durationLabel.text = "End time is too early"
            timeCheck = false
        }
        else
        {
            if !(min==0)
            {
                durationLabel.text = "\(hour) Hour(s) \(min) Minutes"
            }else{
                 durationLabel.text = "\(hour) Hour(s)"
            }
            if (hour==0)
            {
                durationLabel.text = "\(min) Minutes"
            }
            timeCheck = true
        }
    }

}
