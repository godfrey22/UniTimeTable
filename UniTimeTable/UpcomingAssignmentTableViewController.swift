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
    var assignmentList: NSMutableArray = []
    var delegate: addAssignmentDelegate!
    
    var semesterList: NSMutableArray = []
    var currentSemester: Semester!

    
    required init?(coder aDecoder: NSCoder) {
        self.assignmentList = NSMutableArray()
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
        print(semesterList[0])
        currentSemester = semesterList[0] as! Semester

        
        //Clear the assignment list
        assignmentList.removeAllObjects()
        
        //Put all the assignment into the assignmentList
        print(currentSemester)
        let courseList = (NSArray(array: (currentSemester.hasCourse?.allObjects as! [Course])))
        for course in (courseList as! [Course]){
            for assignment in (course.hasAssignment?.allObjects as! [Assignment]) {
                assignmentList.addObject(assignment)
            }
        }

        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        return assignmentList.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UpcomingAssignmentCellIdentifier", forIndexPath: indexPath) as! UpcomingAssignmentCell
        
        let a: Assignment = self.assignmentList[indexPath.row] as! Assignment
        
        cell.courseCode.text = a.belongs_to_Course?.course_code
        cell.assignmentTitle.text = a.assignment_title
        cell.percentage.text = a.assignment_status

        // Configure the cell...
        
        

        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            managedObjectContext.deleteObject(assignmentList.objectAtIndex(indexPath.row) as! NSManagedObject)
            self.assignmentList.removeObjectAtIndex(indexPath.row)
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
            controller.selectedAssignment = assignmentList.objectAtIndex(selectedIndexPath.row) as! Assignment
             
        }
    }

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("ViewAssignment", sender: self)
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
