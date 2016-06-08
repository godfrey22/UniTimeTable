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
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
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
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
