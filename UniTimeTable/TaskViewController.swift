//
//  TaskViewController.swift
//  UniTimeTable
//
//  Created by Godfrey Gao on 16/5/18.
//  Copyright © 2016年 Godfrey Gao. All rights reserved.
//

import UIKit
import CoreData

class TaskViewController: UIViewController, addTaskDelegate, deleteTaskDelegate {
    
    var selectedAssignment: Assignment!
    var taskList: NSMutableArray = []
    var managedObjectContext: NSManagedObjectContext

    @IBOutlet var assignmentTitleLabel: UILabel!
    @IBOutlet var courseCodeLabel: UILabel!
    @IBOutlet var dueDateLabel: UILabel!
    @IBOutlet var taskTabelView: UITableView!
    @IBOutlet var submitButton: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        self.taskList = NSMutableArray()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.managedObjectContext = appDelegate.managedObjectContext
        super.init(coder: aDecoder)
    }
    
    
    @IBAction func submit(sender: UIButton) {
        
        //if task is finished(sum of percentage is 100), perform submit.
        if(Int(self.selectedAssignment.assignment_status!) == 100){
            self.selectedAssignment.assignment_status = String(Int(self.selectedAssignment.assignment_status!)! + 101)
        }else if(Int(self.selectedAssignment.assignment_status!) < 100){
            //detect unfinished assignment, but user insist to submit, show an alert diaolog
            let submitAlert = UIAlertController(title: "Unfinished Assignment", message: "It seems you have not complete all the task, are you sure you submitted them?", preferredStyle: UIAlertControllerStyle.Alert)
            submitAlert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action: UIAlertAction!) in
                //user insist, perform submit
                self.selectedAssignment.assignment_status = String(Int(self.selectedAssignment.assignment_status!)! + 101)
                self.navigationController?.popViewControllerAnimated(true)
            }))
            
            submitAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction!) in
            }))
            
            presentViewController(submitAlert, animated: true, completion: nil)
        }else if(Int(self.selectedAssignment.assignment_status!) > 100){
            //if the percentage is already greater than 100, it means, user maybe want to change it back
            self.selectedAssignment.assignment_status = String(Int(self.selectedAssignment.assignment_status!)! - 101)
        }
        self.navigationController?.popViewControllerAnimated(true)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        taskTabelView.reloadData()
        //determine the button title is "submit" or "unsubmit" depending on the assignment percentage status
        if(Int(selectedAssignment.assignment_status!)!>100){
            submitButton.setTitle("Unsubmit", forState: UIControlState.Normal)
        }else{
            submitButton.setTitle("Submit", forState: UIControlState.Normal)

        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //register the table view
        taskTabelView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "TaskCell")
        
        assignmentTitleLabel.text = selectedAssignment.assignment_title
        courseCodeLabel.text = selectedAssignment.belongs_to_Course?.course_code
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
    
        dueDateLabel.text = dateFormatter.stringFromDate(selectedAssignment.assignment_due!)
        
        
        //get all the task from selected assignment
        let request = NSFetchRequest(entityName: "Task")
        request.returnsObjectsAsFaults = false
        do{
            let result: NSArray = try managedObjectContext.executeFetchRequest(request)
            if result.count != 0
            {
                self.taskList = NSMutableArray(array: (selectedAssignment!.hasTask?.allObjects as! [Task]))
            }
        }catch
        {
            let fetchError = error as NSError
            print(fetchError)
        }
        
        //reorder the task order by its percentage, from small to big (finished taskes will always display at last)
        //modified from http://stackoverflow.com/questions/14928793/sorting-an-array-of-nsindexpaths
        taskList.sortUsingComparator {
            let task1 = $0 as! Task
            let task2 = $1 as! Task
            if(task2.task_status == true){
                return .OrderedAscending
            }else if(task1.task_status == true)
            {
                return .OrderedDescending
            }else if (Int(task1.task_percentage!) < Int(task2.task_percentage!))
            {
                return .OrderedAscending
            }else{
                return .OrderedDescending
            }
        }
        
        taskTabelView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TaskCellIdentifier", forIndexPath: indexPath) as! TaskCell
        //Create a date formatter
        let t: Task = self.taskList[indexPath.row] as! Task
        
        cell.taskTitle.text = t.task_title
        cell.taskStatus.text = "\(t.task_percentage!)%"
        
        //if the task is completed, it will show green, else, red
        if(t.task_status == false)
        {
            cell.taskStatus.textColor = UIColor.redColor()
        }else
        {
             cell.taskStatus.textColor = UIColor.greenColor()
        }
        //Config the cell
        return cell
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "AddTask")
        {
            let controller: AddTaskViewController = segue.destinationViewController as! AddTaskViewController
            controller.managedObjectContext = self.managedObjectContext
            controller.delegate = self
            controller.selectedAssignment = self.selectedAssignment

        }
        if(segue.identifier == "EditTask")
        {
            let selectedIndexPath: NSIndexPath = self.taskTabelView.indexPathForSelectedRow!
            let controller: AddTaskViewController = segue.destinationViewController as! AddTaskViewController
            controller.managedObjectContext = self.managedObjectContext
            controller.deleteDelegate = self
            controller.selectedTask = taskList.objectAtIndex(selectedIndexPath.row) as? Task
            controller.selectedIndex = selectedIndexPath.row
            controller.selectedAssignment = self.selectedAssignment
        }
    }
    
    func addTask(task: Task) {
        self.selectedAssignment!.addTask(task)
        self.taskList = NSMutableArray(array: (selectedAssignment!.hasTask?.allObjects as! [Task]))
        self.taskTabelView.reloadData()
        do
        {
            try self.managedObjectContext.save()
            print("A Task has been added!")
        }
        catch let error
        {
            print("Could not save Deletion \(error)")
        }
    }

    func deleteTask(index: Int) {
        managedObjectContext.deleteObject(taskList.objectAtIndex(index) as! NSManagedObject)
        do
        {
            try self.managedObjectContext.save()
            print("A Task has been added!")
        }
        catch let error
        {
            print("Could not save Deletion \(error)")
        }
        self.taskList.removeObjectAtIndex(index)
        self.taskTabelView.reloadData()
    }

}
