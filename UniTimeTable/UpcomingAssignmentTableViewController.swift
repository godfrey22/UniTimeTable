//
//  UpcomingAssignmentTableViewController.swift
//  UniTimeTable
//
//  Created by Godfrey Gao on 16/5/17.
//  Copyright © 2016年 Godfrey Gao. All rights reserved.
//

import UIKit
import CoreData

class UpcomingAssignmentTableViewController: UITableViewController {
    
    var managedObjectContext: NSManagedObjectContext
    var UnfinishedAssignmentList: NSMutableArray = []

    var delegate: addAssignmentDelegate!
    
    var semesterList: NSMutableArray = []
    var currentSemester: Semester?

    
    required init?(coder aDecoder: NSCoder) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.managedObjectContext = appDelegate.managedObjectContext
        super.init(coder: aDecoder)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //Get current semester
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
            UnfinishedAssignmentList.removeAllObjects()
            
            //Put all the assignment into the assignmentList
            let courseList = (NSArray(array: (currentSemester!.hasCourse?.allObjects as! [Course])))
            for course in (courseList as! [Course]){
                for assignment in (course.hasAssignment?.allObjects as! [Assignment]) {
                    if(Int(assignment.assignment_status!)!<100){
                        UnfinishedAssignmentList.addObject(assignment)
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
        return UnfinishedAssignmentList.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UpcomingAssignmentCellIdentifier", forIndexPath: indexPath) as! UpcomingAssignmentCell
        
        let a: Assignment = self.UnfinishedAssignmentList[indexPath.row] as! Assignment
        cell.courseCode.text = a.belongs_to_Course?.course_code
        cell.assignmentTitle.text = a.assignment_title
        cell.percentage.text = "\(a.assignment_status!)%"
        cell.percentage.textColor = UIColor.redColor()
        
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        
        cell.dueDate.text = dateFormatter.stringFromDate(a.assignment_due!)

        // Configure the cell...
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            managedObjectContext.deleteObject(UnfinishedAssignmentList.objectAtIndex(indexPath.row) as! NSManagedObject)
            self.UnfinishedAssignmentList.removeObjectAtIndex(indexPath.row)
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Fade)
            do
            {
                try self.managedObjectContext.save()
            }
            catch let error
            {
                print("Could not save Deletion \(error)")
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ViewAssignment"
        {
            let selectedIndexPath: NSIndexPath = self.tableView.indexPathForSelectedRow!
            let controller: TaskViewController = segue.destinationViewController as! TaskViewController
            controller.managedObjectContext = self.managedObjectContext
            controller.selectedAssignment = UnfinishedAssignmentList.objectAtIndex(selectedIndexPath.row) as! Assignment
             
        }
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("ViewAssignment", sender: self)
    }
    
}
