//
//  FocusUCClassTableViewController.swift
//  UniTimeTable
//
//  Created by Godfrey Gao on 16/6/3.
//  Copyright © 2016年 Godfrey Gao. All rights reserved.
//

import UIKit
import CoreData

extension NSDate {
    func dayOfWeek() -> Int? {
        if
            let cal: NSCalendar = NSCalendar.currentCalendar(),
            let comp: NSDateComponents = cal.components(.Weekday, fromDate: self) {
            return comp.weekday
        } else {
            return nil
        }
    }
}

class FocusUCClassTableViewController: UITableViewController {

    
    var managedObjectContext: NSManagedObjectContext
    var upcomingClassList: NSMutableArray = []
    var containerViewController: FocusUCClassTableViewController?
    
    var semesterList: NSMutableArray = []
    var currentSemester: Semester!
    
    required init?(coder aDecoder: NSCoder) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.managedObjectContext = appDelegate.managedObjectContext
        super.init(coder: aDecoder)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
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
        
        currentSemester = semesterList[0] as! Semester
        for semester in semesterList {
            if((semester as! Semester).startYear?.timeIntervalSinceNow<0){
                if((semester as! Semester).endYear?.timeIntervalSinceNow > 0){
                    currentSemester = semester as! Semester
                }
            }
        }
        
        upcomingClassList.removeAllObjects()
        
        let courseList = (NSArray(array: (currentSemester.hasCourse?.allObjects as! [Course])))
        for course in (courseList as! [Course]) {
            for _class in (course.hasClass?.allObjects as! [Class]){
                if (Int(_class.week!) + 1 == NSDate().dayOfWeek()){
                    upcomingClassList.addObject(_class)
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
        return upcomingClassList.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UCClassCell", forIndexPath: indexPath) as! UCClassCell
        
        let c: Class = self.upcomingClassList[indexPath.row] as! Class
        cell.courseCode.text = c.belongs_to_Course?.course_code
        cell.courseLocation.text = c.location
        cell.courseType.text = c.hasType?.type_name
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
         cell.courseTime.text = dateFormatter.stringFromDate(c.startTime!) + "-" + dateFormatter.stringFromDate(c.endTime!)
        
        // Configure the cell...

        return cell
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "UCCTVC" {
            let connectContainerViewController = segue.destinationViewController as! FocusUCClassTableViewController
            containerViewController = connectContainerViewController
            containerViewController!.managedObjectContext = self.managedObjectContext
            containerViewController?.viewWillAppear(true)
        }
    }
    

}
