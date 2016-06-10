//
//  FocusUCAssignmentTableViewController.swift
//  UniTimeTable
//
//  Created by Godfrey Gao on 16/6/4.
//  Copyright © 2016年 Godfrey Gao. All rights reserved.
//

import UIKit
import CoreData

class FocusUCAssignmentTableViewController: UITableViewController {
    
    var managedObjectContext: NSManagedObjectContext
    var upcomingAssignmentList: NSMutableArray = []
    var containerViewController: FocusUCAssignmentTableViewController?
    
    var semesterList: NSMutableArray = []
    var currentSemester: Semester?
    
    required init?(coder aDecoder: NSCoder) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.managedObjectContext = appDelegate.managedObjectContext
        super.init(coder: aDecoder)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //get all the semester from the core date
        let request = NSFetchRequest(entityName: "Semester")
        request.returnsObjectsAsFaults = false
        do{
            let result:NSArray = try managedObjectContext.executeFetchRequest(request)
            if result.count > 0 {
                self.semesterList = NSMutableArray(array: (result as! [Semester]))
            }
        }catch
        {
            let fetchError = error as NSError
            print(fetchError)
        }
        
        //if there is "semester" in the list
        if(semesterList.count > 0){
            //by default, the first one will be considered as the current semester
            currentSemester = semesterList[0] as? Semester
            for semester in semesterList {
                //but if, the current date is within another semester, it will change
                if((semester as! Semester).startYear?.timeIntervalSinceNow<0){
                    if((semester as! Semester).endYear?.timeIntervalSinceNow > 0){
                        currentSemester = semester as? Semester
                    }
                }
            }
            //remove all the objects in upcoming assignmentlist
            upcomingAssignmentList.removeAllObjects()
            
            //get all the courses in current semester
            let courseList = (NSArray(array: (currentSemester!.hasCourse?.allObjects as! [Course])))
            for course in (courseList as! [Course]) {
                for assignment in (course.hasAssignment?.allObjects as! [Assignment]){
                    //if there are assignments that are due in the next 7 days, it will be added into the assignment list
                    let calendar = NSCalendar.currentCalendar()
                    let components = calendar.components([.Day], fromDate: (assignment.assignment_due)!, toDate: NSDate(), options: [])
                    if (components.day < 7){
                        self.upcomingAssignmentList.addObject(assignment)
                    }
                }
            }
        }

        self.tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return upcomingAssignmentList.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UCAssignmentCell", forIndexPath: indexPath) as! UCAssignmentCell
        
        // Configure the cell...
        let a: Assignment = self.upcomingAssignmentList[indexPath.row] as! Assignment
        cell.courseCode.text = a.belongs_to_Course?.course_code
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        
        cell.dueDate.text = dateFormatter.stringFromDate(a.assignment_due!)
        
        //by default, the color is red, assume the assignment is not finished
        cell.percentage.textColor = UIColor.redColor()
        
        if(Int(a.assignment_status!)!<100){
            //if the percentage is less than 100, it means it is not finished, and the cell will indicate the percentage
            cell.percentage.text = "\(a.assignment_status!)%"
        }else if(Int(a.assignment_status!)!==100){
            //if the percentage is 100, it means the assignment is finished, but not submitted yet
            cell.percentage.text = "Not Submitted"
        }else{
            //if the percentage is more than 100(when user submit assignment, system will add 100 to this percentage), it means submitted, and color will become green
            cell.percentage.text = "Submitted"
            cell.percentage.textColor = UIColor.greenColor()
        }
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "UCATVC" {
            //create the segue and display the cell
            let connectContainerViewController = segue.destinationViewController as! FocusUCAssignmentTableViewController
            containerViewController = connectContainerViewController
            containerViewController!.managedObjectContext = self.managedObjectContext
            containerViewController?.viewWillAppear(true)
        }
    }

}
