//
//  FinishedAssignmentTableViewController.swift
//  UniTimeTable
//
//  Created by Godfrey Gao on 16/5/17.
//  Copyright © 2016年 Godfrey Gao. All rights reserved.
//

import UIKit
import CoreData

class FinishedAssignmentTableViewController: UITableViewController {
    
    var managedObjectContext: NSManagedObjectContext
    var FinishedAssignmentList: NSMutableArray = []
    
    var semesterList: NSMutableArray = []
    var currentSemester: Semester?
    
    required init?(coder aDecoder: NSCoder)
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.managedObjectContext = appDelegate.managedObjectContext
        super.init(coder: aDecoder)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
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
            currentSemester = semesterList[0] as? Semester
            for semester in (semesterList) {
                if ((semester as! Semester).startYear?.timeIntervalSinceNow < 0){
                    if((semester as! Semester).endYear?.timeIntervalSinceNow > 0){
                        currentSemester = semester as? Semester
                    }
                }
            }
            
            //Clear the assignment list
            FinishedAssignmentList.removeAllObjects()
            
            //Put all the assignment into the assignmentList
            let courseList = (NSArray(array: (currentSemester!.hasCourse?.allObjects as! [Course])))
            for course in (courseList as! [Course]){
                for assignment in (course.hasAssignment?.allObjects as! [Assignment]) {
                    if(Int(assignment.assignment_status!) >= 100){
                        FinishedAssignmentList.addObject(assignment)
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
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FinishedAssignmentList.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FinishedAssignmentCell", forIndexPath: indexPath) as! FinishedAssignmentCell
        let a: Assignment = self.FinishedAssignmentList[indexPath.row] as! Assignment
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        
        cell.assignment_title.text = a.assignment_title
        cell.due_date.text = dateFormatter.stringFromDate(a.assignment_due!)
        cell.assignment_code.text = a.belongs_to_Course?.course_code
        
        //if the status of the assignment is 100, it means it has not been submitted
        if(Int(a.assignment_status!) == 100){
            cell.status.text = "Not Submitted"
            cell.status.textColor = UIColor.redColor()
        }else{
            cell.status.text = "Submitted"
            cell.status.textColor = UIColor.greenColor()
        }

        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ViewAssignment"
        {
            let selectedIndexPath: NSIndexPath = self.tableView.indexPathForSelectedRow!
            let controller: TaskViewController = segue.destinationViewController as! TaskViewController
            controller.managedObjectContext = self.managedObjectContext
            controller.selectedAssignment = FinishedAssignmentList.objectAtIndex(selectedIndexPath.row) as! Assignment
            
        }
    }

}
