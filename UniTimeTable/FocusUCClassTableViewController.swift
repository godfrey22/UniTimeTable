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
    //extend NSDate to return which weekday of the week is, by given date
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
    var containerViewController: FocusUCClassTableViewController!
    
    var semesterList: NSMutableArray = []
    var currentSemester: Semester?
    
    required init?(coder aDecoder: NSCoder) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.managedObjectContext = appDelegate.managedObjectContext
        super.init(coder: aDecoder)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //get all the semester
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
        
        //if there is semester in the list
        if(semesterList.count > 0){
            //by default, the first semester will be considered as current semester
            currentSemester = semesterList[0] as? Semester
            for semester in semesterList {
                //but if current date is within another semseter, it will change
                if((semester as! Semester).startYear?.timeIntervalSinceNow<0){
                    if((semester as! Semester).endYear?.timeIntervalSinceNow > 0){
                        currentSemester = semester as? Semester
                    }
                }
            }
            
            //clear the list
            upcomingClassList.removeAllObjects()
            
            let courseList = (NSArray(array: (currentSemester!.hasCourse?.allObjects as! [Course])))
            for course in (courseList as! [Course]) {
                for _class in (course.hasClass?.allObjects as! [Class]){
                    //if the course happens on the current weekday, it will be added into the list
                    if (Int(_class.week!) + 1 == NSDate().dayOfWeek()){
                        upcomingClassList.addObject(_class)
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
        return upcomingClassList.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UCClassCell", forIndexPath: indexPath) as! UCClassCell
        
        // Configure the cell...
        let c: Class = self.upcomingClassList[indexPath.row] as! Class
        cell.courseCode.text = c.belongs_to_Course?.course_code
        cell.courseLocation.text = c.location
        cell.courseType.text = c.hasType?.type_name
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
         cell.courseTime.text = dateFormatter.stringFromDate(c.startTime!) + "-" + dateFormatter.stringFromDate(c.endTime!)
        
        return cell
    }
    
    //prepare the segue to display the list in table view controller
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "UCCTVC" {
            let connectContainerViewController = segue.destinationViewController as! FocusUCClassTableViewController
            containerViewController = connectContainerViewController
            containerViewController!.managedObjectContext = self.managedObjectContext
            containerViewController?.viewWillAppear(true)
        }
    }
    

}
