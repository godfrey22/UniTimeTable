//
//  CourseSelectViewController.swift
//  UniTimeTable
//
//  Created by Godfrey Gao on 16/5/18.
//  Copyright © 2016年 Godfrey Gao. All rights reserved.
//

import UIKit
import CoreData

protocol courseSelectionDelegate {
    func didSelectCourse(course: Course)
}

class CourseSelectViewController: UIViewController {
    
    var selectedSemester: Semester!
    var delegate: courseSelectionDelegate! = nil
    var courseList: NSMutableArray = []
    var managedObjectContext: NSManagedObjectContext
    
    @IBOutlet var unitTableView: UITableView!
    
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
        
        //Register the table view
        unitTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "SelectCourseIdentifier")
        
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
        // Do any additional setup after loading the view.
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
        let cell = tableView.dequeueReusableCellWithIdentifier("CourseSelectIdentifier", forIndexPath: indexPath) as! CourseCell
        let c: Course = self.courseList[indexPath.row] as! Course
       cell.courseCode.text = c.course_code!
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let c:Course = self.courseList[indexPath.row] as! Course
        delegate.didSelectCourse(c)
        self.navigationController?.popViewControllerAnimated(true)
    }

    
    /*func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            performSegueWithIdentifier("ViewClass", sender: self)
    }*/

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
