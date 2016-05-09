//
//  SemesterViewController.swift
//  UniTimeTable
//
//  Created by Godfrey Gao on 16/5/8.
//  Copyright © 2016年 Godfrey Gao. All rights reserved.
//

import UIKit
import CoreData

class SemesterViewController: UIViewController, addSemesterDelegate {
    
    var managedObjectContext: NSManagedObjectContext
    var semesterList: NSMutableArray
    var currentGroup: Group?
    
    @IBOutlet var semesterTableView: UITableView!
    
    required init?(coder aDecoder: NSCoder) {
        self.semesterList = NSMutableArray()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.managedObjectContext = appDelegate.managedObjectContext
        super.init(coder: aDecoder)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fetchRequest = NSFetchRequest()
        let entityDescription = NSEntityDescription.entityForName("Group", inManagedObjectContext: self.managedObjectContext)
        fetchRequest.entity = entityDescription
        
        
        var result = NSArray?()
        do
        {
            result = try self.managedObjectContext.executeFetchRequest(fetchRequest)
            if result!.count == 0
            {
                self.currentGroup = Group.init(entity: NSEntityDescription.entityForName("Group", inManagedObjectContext: self.managedObjectContext)!, insertIntoManagedObjectContext: self.managedObjectContext)
            }
            else
            {
                self.currentGroup = result![0] as? Group
                self.semesterList = NSMutableArray(array: (currentGroup!.members?.allObjects as! [Semester]))
            }
        }
        catch
        {
            let fetchError = error as NSError
            print(fetchError)
        }
        self.semesterTableView.reloadData()
    }
    
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AddSemester"
        {
            let controller: AddSemesterViewController = segue.destinationViewController as! AddSemesterViewController
            controller.managedObjectContext = self.managedObjectContext
            controller.delegate = self
        }
    }
    
    func addSemester(semester: Semester) {
        self.currentGroup!.addTask(semester)
        self.semesterList = NSMutableArray(array: (currentGroup!.members?.allObjects as! [Semester]))
        self.semesterTableView.reloadData()
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
