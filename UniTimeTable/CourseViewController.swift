//
//  CourseViewController.swift
//  UniTimeTable
//
//  Created by Godfrey Gao on 16/5/11.
//  Copyright © 2016年 Godfrey Gao. All rights reserved.
//

import UIKit
import CoreData

class CourseViewController: UIViewController, addCourseDelegate {

    //MARK: Variable initiations
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var unitTableView: UITableView!
    
    var selectedSemester: Semester!
    var courseList: NSMutableArray = []
    var managedObjectContext: NSManagedObjectContext
    
    required init?(coder aDecoder: NSCoder) {
        self.courseList = NSMutableArray()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.managedObjectContext = appDelegate.managedObjectContext
        super.init(coder: aDecoder)
    }

    
    //View Controller Overrides
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        unitTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        timeLabel.text = "  " + dateFormatter.stringFromDate(selectedSemester!.startYear!) + " ~ " + dateFormatter.stringFromDate(selectedSemester!.endYear!)
        
        
        //Register the table view
        unitTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "CourseCell")
        
        //Request all the objects in the "Semester" table
        let request = NSFetchRequest(entityName: "Course")
        request.returnsObjectsAsFaults = false
        
        //Put all the semester into the semesterList
        do{
            let result: NSArray = try managedObjectContext.executeFetchRequest(request)
            if result.count != 0
            {
                self.courseList = NSMutableArray(array: (selectedSemester!.hasCourse?.allObjects as! [Course]))
            }
        }catch
        {
            let fetchError = error as NSError
            print(fetchError)
        }
        unitTableView.reloadData()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Table View Overrides
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courseList.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CourseCellIdentifier", forIndexPath: indexPath) as! CourseCell
        let c: Course = self.courseList[indexPath.row] as! Course
        cell.courseCode.text = c.course_code
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            managedObjectContext.deleteObject(courseList.objectAtIndex(indexPath.row) as! NSManagedObject)
            self.courseList.removeObjectAtIndex(indexPath.row)
            unitTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            self.unitTableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Fade)
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
        if segue.identifier == "AddUnit"
        {
            let controller: AddCourseViewController = segue.destinationViewController as! AddCourseViewController
            controller.managedObjectContext = self.managedObjectContext
            controller.delegate = self
        }
    }
    
    func addCourse(course: Course) {
        self.selectedSemester!.addCourse(course)
        self.courseList = NSMutableArray(array: (selectedSemester!.hasCourse?.allObjects as! [Course]))
        self.unitTableView.reloadData()
        do
        {
            try self.managedObjectContext.save()
            print("A Course has been added!")
        }
        catch let error
        {
            print("Could not save Deletion \(error)")
        }
    }
}
