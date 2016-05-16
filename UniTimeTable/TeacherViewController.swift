//
//  TeacherViewController.swift
//  UniTimeTable
//
//  Created by Godfrey Gao on 16/5/16.
//  Copyright © 2016年 Godfrey Gao. All rights reserved.
//

import UIKit
import CoreData

protocol teacherSelectionDelegate {
    func didSelectType(teacher: Teacher)
}

class TeacherViewController: UIViewController {
    
    var teacherList: NSMutableArray = []
    var managedObjectContext: NSManagedObjectContext
    var delegate: teacherSelectionDelegate! = nil
    
    required init?(coder aDecoder: NSCoder) {
        self.teacherList = NSMutableArray()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.managedObjectContext = appDelegate.managedObjectContext
        super.init(coder: aDecoder)
    }

    @IBOutlet var nameInput: UITextField!
    @IBOutlet var emailInput: UITextField!
    @IBOutlet var phoneInput: UITextField!
    @IBOutlet var officeInput: UITextField!
    @IBOutlet var teacherTableView: UITableView!
    
    
    
    
    @IBAction func saveTeacher(sender: AnyObject) {
        let newTeacher: Teacher = (NSEntityDescription.insertNewObjectForEntityForName("Teacher", inManagedObjectContext: self.managedObjectContext)as! Teacher)
        newTeacher.setValue(nameInput.text, forKey: "name")
        newTeacher.setValue(emailInput.text, forKey: "email")
        newTeacher.setValue(phoneInput.text, forKey: "phone")
        newTeacher.setValue(officeInput.text, forKey: "office")
        teacherList.addObject(newTeacher)
        self.teacherTableView.reloadData()
        do
        {
            try self.managedObjectContext.save()
            print("A Type has been added!")
        }
        catch let error
        {
            print("Could not save Deletion \(error)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Register the table view
        teacherTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "TeacherCell")
        
        let request = NSFetchRequest(entityName: "Teacher")
        request.returnsObjectsAsFaults = false
        
        //Put all the semester into the semesterList
        do{
            let result: NSArray = try managedObjectContext.executeFetchRequest(request)
            if result.count != 0
            {
                self.teacherList = NSMutableArray(array: (result as! [Type]))
            }
        }catch
        {
            let fetchError = error as NSError
            print(fetchError)
        }
        teacherTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Table View Overrides
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teacherList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TeacherCellIdentifier", forIndexPath: indexPath) as! TeacherCell
        let t: Teacher = self.teacherList[indexPath.row] as! Teacher
        
        cell.nameLabel.text = t.name
        cell.emailLabel.text = t.email

        return cell
    }
    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            managedObjectContext.deleteObject(teacherList.objectAtIndex(indexPath.row) as! NSManagedObject)
            self.teacherList.removeObjectAtIndex(indexPath.row)
            teacherTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            self.teacherTableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Fade)
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
        let t:Teacher = self.teacherList[indexPath.row] as! Teacher
        delegate.didSelectType(t)
        //self.navigationController?.popToRootViewControllerAnimated(true)
        
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
