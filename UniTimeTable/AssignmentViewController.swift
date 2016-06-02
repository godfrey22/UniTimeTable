//
//  AssignmentViewController.swift
//  UniTimeTable
//
//  Created by Godfrey Gao on 16/5/17.
//  Copyright © 2016年 Godfrey Gao. All rights reserved.
//

import UIKit
import CoreData

class AssignmentViewController: UIViewController, addAssignmentDelegate {
    
    var managedObjectContext: NSManagedObjectContext
    var containerViewController: UpcomingAssignmentTableViewController?
    var containerViewController2: FinishedAssignmentTableViewController?
    
    @IBOutlet var upcomingAssignment: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.managedObjectContext = appDelegate.managedObjectContext
        super.init(coder: aDecoder)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "UATVC" {
            let connectContainerViewController = segue.destinationViewController as! UpcomingAssignmentTableViewController
            containerViewController = connectContainerViewController
            containerViewController!.managedObjectContext = self.managedObjectContext
            containerViewController!.delegate = self
            containerViewController?.viewWillAppear(true)
        }
        if segue.identifier == "FATVC"{
            let connectContainerViewController = segue.destinationViewController as! FinishedAssignmentTableViewController
            containerViewController2 = connectContainerViewController
            containerViewController2!.managedObjectContext = self.managedObjectContext
            
            containerViewController2?.viewWillAppear(true)
        }
        if segue.identifier == "AddAssignment"
        {
            let controller: AddAssignmentViewController = segue.destinationViewController as! AddAssignmentViewController
            controller.managedObjectContext = self.managedObjectContext
            controller.delegate = self
        }
    }
    
    func addAssignment(assignment: Assignment, course: Course) {
        assignment.belongs_to_Course = course
        containerViewController?.UnfinishedAssignmentList.addObject(assignment)
        do
        {
            try self.managedObjectContext.save()
            print("An assignment has been added!")
        }
        catch let error
        {
            print("Could not add assignment \(error)")
        }
        self.navigationController?.popViewControllerAnimated(true)
        containerViewController?.tableView.reloadData()
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
