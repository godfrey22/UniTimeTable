//
//  ClassViewController.swift
//  UniTimeTable
//
//  Created by Godfrey Gao on 16/5/13.
//  Copyright © 2016年 Godfrey Gao. All rights reserved.
//

import UIKit
import CoreData

class ClassViewController: UIViewController, addClassDelegate {
    
    var selectedCourse: Course!
    var selectedType: Type!
    var selectedTeacher: Teacher!
    
    @IBOutlet var courseCodeLabel: UILabel!
    var classList: NSMutableArray = []
    var managedObjectContext: NSManagedObjectContext
    
    @IBOutlet var classTableView: UITableView!
    
    required init?(coder aDecoder: NSCoder) {
        self.classList = NSMutableArray()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.managedObjectContext = appDelegate.managedObjectContext
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        courseCodeLabel.text = "  " + selectedCourse.course_code!
        
        //Register the table view
        classTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "ClassCell")
        
        //Request all the objects in the "Semester" table
        let request = NSFetchRequest(entityName: "Class")
        request.returnsObjectsAsFaults = false
        
        //Put all the semester into the semesterList
        do{
            let result: NSArray = try managedObjectContext.executeFetchRequest(request)
            if result.count != 0
            {
                self.classList = NSMutableArray(array: (selectedCourse!.hasClass?.allObjects as! [Class]))
            }
        }catch
        {
            let fetchError = error as NSError
            print(fetchError)
        }
        classTableView.reloadData()
    }
    
    //Table View Overrides
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ClassCellIdentifier", forIndexPath: indexPath) as! ClassCell
        let c: Class = self.classList[indexPath.row] as! Class
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        cell.timeLabel.text = dateFormatter.stringFromDate(c.startTime!) + "-" + dateFormatter.stringFromDate(c.endTime!)
        cell.locationLabel.text = c.location
        
        cell.typeLabel.text = c.hasType?.type_name
        cell.teacherLabel.text = c.hasTeacher?.name
        var weekString = ""
        switch(c.week! as NSNumber)
        {
        case 0:
            weekString = "Sunday"
            break
        case 1:
            weekString = "Monday"
            break
        case 2:
            weekString = "Tuesday"
            break
        case 3:
            weekString = "Wednesday"
            break
        case 4:
            weekString = "Thursday"
            break
        case 5:
            weekString = "Friday"
            break
        case 6:
            weekString = "Saturday"
            break
        default:
            weekString = "N/A"
            break
        }
        cell.weekLabel.text = weekString
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            managedObjectContext.deleteObject(classList.objectAtIndex(indexPath.row) as! NSManagedObject)
            self.classList.removeObjectAtIndex(indexPath.row)
            classTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            self.classTableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Fade)
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
        if segue.identifier == "AddClass"
        {
            let controller: AddClassViewController = segue.destinationViewController as! AddClassViewController
            controller.managedObjectContext = self.managedObjectContext
            controller.delegate = self
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func addClass(_class: Class, type: Type, teacher: Teacher) {
        _class.hasType = type
        _class.hasTeacher = teacher
        self.selectedCourse!.addClass(_class)
        self.classList = NSMutableArray(array: (selectedCourse!.hasClass?.allObjects as! [Class]))
        self.classTableView.reloadData()
        do
        {
            try self.managedObjectContext.save()
            selectedType = type
            selectedTeacher = teacher
            print("A Class has been added!")
        }
        catch let error
        {
            print("Could not save Deletion \(error)")
        }
    }
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
