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
    func addClass(_class: Class, type: Type, teacher: Teacher)
}

class AddClassViewController: UIViewController, typeSelectionDelegate, teacherSelectionDelegate {
    
    
    var delegate: addClassDelegate!
    var managedObjectContext: NSManagedObjectContext
    var selectedType: Type!
    var selectedTeacher: Teacher!
    var selectedClass: Class?
    
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
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var teacherLabel: UILabel!
    
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
        self.hideKeyboardWhenTappedAround() 
        if((selectedClass) != nil)
        {
            selectedType = selectedClass?.hasType
            selectedTeacher = selectedClass?.hasTeacher
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        if((selectedClass) != nil)
        {
            typeLabel.text = selectedClass?.hasType?.type_name
            teacherLabel.text = selectedClass?.hasTeacher?.name
            locationInput.text = selectedClass?.location
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
            dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
            startDate = (selectedClass?.startDate)!
            startDateInput.text = dateFormatter.stringFromDate(startDate)
            endDate = (selectedClass?.endDate)!
            endDateInput.text = dateFormatter.stringFromDate(endDate)
            
            dateFormatter.dateStyle = NSDateFormatterStyle.NoStyle
            dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
            startTime = (selectedClass?.startTime)!
            startTimeInput.text = dateFormatter.stringFromDate(startTime)
            endTime = (selectedClass?.endTime)!
            endTimeInput.text = dateFormatter.stringFromDate(endTime)
            
            weekSelection.selectedSegmentIndex = selectedClass?.week as! Int
        }
        
        if((selectedType) != nil)
        {
            typeLabel.text = selectedType.type_name
        }
        if((selectedTeacher) != nil)
        {
            teacherLabel.text = selectedTeacher.name
        }
        
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
    }else if segue.identifier == "ViewTeacher"
    {
        let teacherViewController: TeacherViewController = segue.destinationViewController as! TeacherViewController
        teacherViewController.managedObjectContext = self.managedObjectContext
        teacherViewController.delegate = self
        }
    }
    
    @IBAction func addClass(sender: AnyObject) {
        
        let dateCondition = (startDateInput.text != "" && endDateInput.text != "")
        let timeCondition = (startTimeInput.text != "" && endTimeInput.text != "")
        let typeCondition = typeLabel.text != ""
        
        let pass = (dateCondition && timeCondition && typeCondition)
        
        if(!pass){
            let alertController = UIAlertController(title: "Empty fields", message:
                "Please fill in necessary information", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        }
        
        
        if((selectedClass) != nil)
        {
            selectedClass!.setValue(selectedType, forKey: "hasType")
            selectedClass!.setValue(selectedTeacher, forKey: "hasTeacher")
            selectedClass!.setValue(startDate, forKey: "startDate")
            selectedClass!.setValue(endDate, forKey: "endDate")
            selectedClass!.setValue(startTime, forKey: "startTime")
            selectedClass!.setValue(endTime, forKey: "endTime")
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
            selectedClass!.setValue(week, forKey: "week")
            selectedClass!.setValue(locationInput.text, forKey: "location")
            do
            {
                try self.managedObjectContext.save()
                print("A Course has been added!")
            }
            catch let error
            {
                print("Could not save Deletion \(error)")
            }
            self.navigationController?.popViewControllerAnimated(true)
            
        }else{
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
            self.delegate!.addClass(newClass, type: selectedType, teacher: selectedTeacher)
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    func didSelectType(type: Type) {
        selectedType = type
    }
    
    func didSelectTeacher(teacher: Teacher) {
        selectedTeacher = teacher
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
