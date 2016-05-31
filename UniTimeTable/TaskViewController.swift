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
    @IBOutlet var teacherLabel: UILabel!
    @IBOutlet var taskTabelView: UITableView!
    
    required init?(coder aDecoder: NSCoder) {
        self.taskList = NSMutableArray()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.managedObjectContext = appDelegate.managedObjectContext
        super.init(coder: aDecoder)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        taskTabelView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        taskTabelView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "TaskCell")
        
        assignmentTitleLabel.text = selectedAssignment.assignment_title
        courseCodeLabel.text = selectedAssignment.belongs_to_Course?.course_code
        
        //teacherLabel.text
        //To-Do Need to fix logic here
        
        
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
        
        if(t.task_status == false)
        {
            cell.taskStatus.text = "\(t.task_percentage!)%"
        }else
        {
            cell.taskStatus.text = "Completed"
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

        }
        if(segue.identifier == "EditTask")
        {
            let selectedIndexPath: NSIndexPath = self.taskTabelView.indexPathForSelectedRow!
            let controller: AddTaskViewController = segue.destinationViewController as! AddTaskViewController
            controller.managedObjectContext = self.managedObjectContext
            controller.deleteDelegate = self
            controller.selectedTask = taskList.objectAtIndex(selectedIndexPath.row) as? Task
            controller.selectedIndex = selectedIndexPath.row
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
