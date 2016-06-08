//
//  AddAssignmentViewController.swift
//  UniTimeTable
//
//  Created by Godfrey Gao on 16/5/17.
//  Copyright © 2016年 Godfrey Gao. All rights reserved.
//

import UIKit
import CoreData

protocol addAssignmentDelegate {
    func addAssignment(assignment: Assignment, course: Course)
}

class AddAssignmentViewController: UIViewController, courseSelectionDelegate{
    
    
    var managedObjectContext: NSManagedObjectContext
    var dueDate = NSDate()
    var selectedCourse: Course?
    var selectedSemester: Semester!
    var semesterList: NSMutableArray = []
    var delegate: addAssignmentDelegate!
    
    required init?(coder aDecoder: NSCoder) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.managedObjectContext = appDelegate.managedObjectContext
        super.init(coder: aDecoder)
    }
    
    @IBOutlet var assignmentTitle: UITextField!
    @IBOutlet var assignmentDue: UITextField!
    @IBOutlet var assignmentCourseCode: UILabel!
    
    @IBAction func editDueDate(sender: UITextField) {
        let datePickerView: UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.Date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(AddAssignmentViewController.duedatePickerValueChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
    }
    func duedatePickerValueChanged(sender: UIDatePicker){
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        dueDate = sender.date
        assignmentDue.text = dateFormatter.stringFromDate(sender.date)
    }

    @IBAction func saveAssignment(sender: UIButton) {
        
        let assignmentTitleCondition = (assignmentTitle.text != "")
        let assignmentDueCondition = (assignmentDue.text != "")
        let assignmentcourseCondition = assignmentCourseCode.text != ""
        
        let pass = (assignmentDueCondition && assignmentTitleCondition && assignmentcourseCondition)
        
        if(!pass){
            let alertController = UIAlertController(title: "Empty fields", message:
                "Please fill in necessary information", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        }
        
        let newAssignment: Assignment = (NSEntityDescription.insertNewObjectForEntityForName("Assignment", inManagedObjectContext: self.managedObjectContext)as! Assignment)
        newAssignment.setValue(assignmentTitle.text, forKey: "assignment_title")
        newAssignment.setValue(dueDate, forKey: "assignment_due")
        newAssignment.setValue("0", forKey: "assignment_status")
        self.delegate!.addAssignment(newAssignment, course: selectedCourse!)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SelectCourse"
        {
            let controller: CourseSelectViewController = segue.destinationViewController as! CourseSelectViewController
            controller.managedObjectContext = self.managedObjectContext
            controller.selectedSemester = self.selectedSemester
            controller.delegate = self
        }
    }
    

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //Request all the objects in the "Semester" table
        let request = NSFetchRequest(entityName: "Semester")
        request.returnsObjectsAsFaults = false
        
        //Put all the semester into the semesterList
        do{
            let result: NSArray = try managedObjectContext.executeFetchRequest(request)
            if result.count > 0{
                self.semesterList = NSMutableArray(array: (result as! [Semester]))
            }
        }catch
        {
            let fetchError = error as NSError
            print(fetchError)
        }
        
        if(semesterList.count > 0){
            selectedSemester = semesterList[0] as! Semester
            for semester in (semesterList) {
                if ((semester as! Semester).startYear?.timeIntervalSinceNow < 0){
                    if((semester as! Semester).endYear?.timeIntervalSinceNow > 0){
                        selectedSemester = semester as! Semester
                    }
                }
            }
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
    
    func didSelectCourse(course: Course) {
        selectedCourse = course
        assignmentCourseCode.text = selectedCourse?.course_code
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
