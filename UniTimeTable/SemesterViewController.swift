//
//  SemesterViewController.swift
//  UniTimeTable
//
//  Created by Godfrey Gao on 16/5/9.
//  Copyright © 2016年 Godfrey Gao. All rights reserved.
//

import UIKit
import CoreData

class SemesterViewController: UIViewController, UITableViewDataSource, addSemesterDelegate{
    
    var semesterList: NSMutableArray = []
    var managedObjectContext: NSManagedObjectContext
    
    var editMode = false

    @IBOutlet var semesterTableView: UITableView!
    @IBOutlet var editButton: UIButton!
    @IBAction func editSemester(sender: UIButton) {
        //allow user to edit semester
        if (editMode == false)
        {
            editMode = true
            editButton.setTitle("Finished", forState: UIControlState.Normal)
        }else{
            editMode = false
            editButton.setTitle("Edit", forState: UIControlState.Normal)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.semesterList = NSMutableArray()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.managedObjectContext = appDelegate.managedObjectContext
        super.init(coder: aDecoder)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        semesterTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Register the table view
        semesterTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "SemesterCell")
        
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
        semesterTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return semesterList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SemesterCellIdentifier", forIndexPath: indexPath) as! SemesterCell
        //Create a date formatter
        let dateFormatter = NSDateFormatter()
        let s: Semester = self.semesterList[indexPath.row] as! Semester
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        
        //Config the cell
        cell.timeLabel.text = dateFormatter.stringFromDate(s.startYear!) + " ~ " + dateFormatter.stringFromDate(s.endYear!)
        cell.numberOfClassesLabel.text = "\(s.hasCourse!.count)"
        return cell
    }
    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            managedObjectContext.deleteObject(semesterList.objectAtIndex(indexPath.row) as! NSManagedObject)
            self.semesterList.removeObjectAtIndex(indexPath.row)
            semesterTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            self.semesterTableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Fade)
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //if user is not in edit mode, then user will be brought to all the courses in selected semester
        if editMode==false {
            performSegueWithIdentifier("ViewCourse", sender: self)
        }else{
            //otherwise, use will be brought to edit semester to modify selected semester
            performSegueWithIdentifier("EditSemester", sender: self)
        }
    }

    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AddSemester"
        {
            let controller: AddSemesterViewController = segue.destinationViewController as! AddSemesterViewController
            controller.managedObjectContext = self.managedObjectContext
            controller.delegate = self
        }else if segue.identifier == "ViewCourse"
        {
            let selectedIndexPath: NSIndexPath = self.semesterTableView.indexPathForSelectedRow!
            let courseViewController: CourseViewController = segue.destinationViewController as! CourseViewController
            courseViewController.managedObjectContext = self.managedObjectContext
            courseViewController.selectedSemester = semesterList.objectAtIndex(selectedIndexPath.row) as! Semester
        }else if segue.identifier == "EditSemester"
        {
            let selectedIndexPath: NSIndexPath = self.semesterTableView.indexPathForSelectedRow!
            let controller: AddSemesterViewController = segue.destinationViewController as! AddSemesterViewController
            controller.managedObjectContext = self.managedObjectContext
            controller.selectedSemester = semesterList.objectAtIndex(selectedIndexPath.row) as? Semester
        }
    }
    
    
    func addSemester(semester: Semester) {
        self.semesterList.addObject(semester)
        self.semesterTableView.reloadData()
        do
        {
            print("A Semester has been added!")
            try self.managedObjectContext.save()
        }
        catch let error
        {
            print("Could not save Deletion \(error)")
        }
    }
    
    //Delete data purpose, testing only..
    func deleteAllData(entity: String)
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            for managedObject in results
            {
                let managedObjectData: NSManagedObject = managedObject as! NSManagedObject
                managedContext.deleteObject(managedObjectData)
            }
        }catch let error as NSError
        {
            print("Delete all data in \(entity) error: \(error)")
        }
        
    }

}
