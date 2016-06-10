//
//  AddTaskViewController.swift
//  UniTimeTable
//
//  Created by Godfrey Gao on 16/5/20.
//  Copyright © 2016年 Godfrey Gao. All rights reserved.
//

import UIKit
import CoreData

protocol addTaskDelegate {
    func addTask(task: Task)
}

protocol deleteTaskDelegate {
    func deleteTask(index: Int)
}


class AddTaskViewController: UIViewController {

    @IBOutlet var taskTitleLabel: UILabel!
    @IBOutlet var taskDescriptionField: UITextView!
    @IBOutlet var taskWorth: UITextField!
    @IBOutlet var completeButton: UIButton!
    @IBOutlet var deleteButton: UIButton!
    @IBOutlet var taskTitleInput: UITextField!
    
    var selectedTask: Task?
    var selectedIndex: Int?
    
    var selectedAssignment: Assignment!
    
    var delegate: addTaskDelegate!
    var deleteDelegate: deleteTaskDelegate?
    var managedObjectContext: NSManagedObjectContext
    
    @IBAction func deleteTask(sender: UIButton) {
        //if user wants to delete a completed task, the status of the whole assignment will be influenced too, therefore, an additional action of subtract current percentage of task from the assignment percentage is necessary
        if(selectedTask?.task_status==true){
             self.selectedAssignment.assignment_status = String(Int(self.selectedAssignment.assignment_status!)!-Int(selectedTask!.task_percentage!))
        }
        //delete task
        self.deleteDelegate!.deleteTask(selectedIndex!)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func AddTask(sender: UIBarButtonItem) {
        
        do{
            let titleCondition = (taskTitleInput.text != "")
            let descriptionCondition = (taskDescriptionField.text != "")
            let taskWorthCondition = ((taskWorth.text != "" && Int(taskWorth.text!) >= 0))
            let pass = titleCondition && descriptionCondition && taskWorthCondition
            
            //if not all the fields are filled in
            if(!pass){
                let alertController = UIAlertController(title: "Empty fields", message:
                    "Please fill in necessary information", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
                return
            }
        }

            if(selectedTask != nil){
                //modify task detected
                
                if(Int(selectedAssignment.assignment_status!)!-Int((selectedTask?.task_percentage)!) + Int(taskWorth.text!)! <= 100){
                    //if user modify the task and makes the whole percentage under 100, it is valid, and will be recorded
                    selectedTask!.task_title = taskTitleLabel.text
                    selectedTask!.task_details = taskDescriptionField.text
                    
                    //if user is editing an completed task, the percentage will be subtract original one first and then add
                    if(selectedTask?.task_status == true){
                        selectedAssignment.assignment_status = String(Int(selectedAssignment.assignment_status!)! - Int((selectedTask?.task_percentage)!) + Int(taskWorth.text!)!)
                    }
                    
                    selectedTask!.task_percentage = Int(taskWorth.text!)
                    do
                    {
                        try self.managedObjectContext.save()
                        print("A Task has been modified!")
                    }
                    catch let error
                    {
                        print("Could not save Deletion \(error)")
                    }
                    self.navigationController?.popViewControllerAnimated(true)
                }else{
                    //user makes the percentage over 100, show alert
                    let alertController = UIAlertController(title: "Total percentage invalid", message:
                        "By adding this task, the overall percentage of this assignment will go over 100%", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
               
            }else{
                //user is creating a new task
                //check if the percentage is under 100
                if(Int(selectedAssignment.assignment_status!)!+Int(taskWorth.text!)! <= 100){
                    let newTask: Task = (NSEntityDescription.insertNewObjectForEntityForName("Task", inManagedObjectContext: self.managedObjectContext)as! Task)
                    newTask.setValue(taskTitleInput.text, forKey: "task_title")
                    newTask.setValue(taskDescriptionField.text, forKey: "task_details")
                    newTask.setValue(Int(taskWorth.text!), forKey: "task_percentage")
                    newTask.setValue(false, forKey: "task_status")
                    self.delegate!.addTask(newTask)
                    self.navigationController?.popViewControllerAnimated(true)
                }else{
                    let alertController = UIAlertController(title: "Total percentage invalid", message:
                        "By adding this task, the overall percentage of this assignment will go over 100%", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
                    
                }
            }
    }

    
    @IBAction func markComplete(sender: UIButton) {
        //mark the task as complete, if the assignment status is not finished
        if(selectedTask?.task_status == false){
            //make it true
            selectedTask?.task_status = true
            //add assignment percentage by the task worth
             self.selectedAssignment.assignment_status = String(Int(self.selectedAssignment.assignment_status!)!+Int(selectedTask!.task_percentage!))
        }else{
            //mark a task as unfinished
            selectedTask?.task_status = false
            //subtract percentage by the task worth
            self.selectedAssignment.assignment_status = String(Int(self.selectedAssignment.assignment_status!)!-Int(selectedTask!.task_percentage!))
        }
        do
        {
            try self.managedObjectContext.save()
            print("A Task has changed status!")
        }
        catch let error
        {
            print("Could not save Deletion \(error)")
        }
        self.navigationController?.popViewControllerAnimated(true)
    }
    required init?(coder aDecoder: NSCoder) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.managedObjectContext = appDelegate.managedObjectContext
        super.init(coder: aDecoder)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        completeButton.hidden = true
        deleteButton.hidden = true
        //if create a new task, mark as complete and delete button will not be shown.
        if((selectedTask != nil)){
            taskTitleInput.text = selectedTask?.task_title
            taskDescriptionField.text = selectedTask?.task_details
            taskWorth.text = String(selectedTask!.task_percentage!)
            completeButton.hidden = false
            deleteButton.hidden = false
            if((selectedTask?.task_status == true)){
                completeButton.setTitle("Mark as Incomplete", forState: UIControlState.Normal)
            }else{
                completeButton.setTitle("Mark as Complete", forState: UIControlState.Normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


}
