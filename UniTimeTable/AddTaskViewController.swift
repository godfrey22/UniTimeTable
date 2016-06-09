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
        if(selectedTask?.task_status==true){
             self.selectedAssignment.assignment_status = String(Int(self.selectedAssignment.assignment_status!)!-Int(selectedTask!.task_percentage!))
        }
        self.deleteDelegate!.deleteTask(selectedIndex!)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func AddTask(sender: UIBarButtonItem) {
        
        do{
            let titleCondition = (taskTitleInput.text != "")
            let descriptionCondition = (taskDescriptionField.text != "")
            let taskWorthCondition = ((taskWorth.text != "" && Int(taskWorth.text!) >= 0))
            let pass = titleCondition && descriptionCondition && taskWorthCondition
            
            if(!pass){
                let alertController = UIAlertController(title: "Empty fields", message:
                    "Please fill in necessary information", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                
                self.presentViewController(alertController, animated: true, completion: nil)
                
                print(titleCondition)
                print(descriptionCondition)
                print(taskWorthCondition)
                return
            }
            
        }

        
            if(selectedTask != nil){
                if(Int(selectedAssignment.assignment_status!)!-Int((selectedTask?.task_percentage)!) + Int(taskWorth.text!)! <= 100){
                    selectedTask!.task_title = taskTitleLabel.text
                    selectedTask!.task_details = taskDescriptionField.text
                    
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
                    let alertController = UIAlertController(title: "Total percentage invalid", message:
                        "By adding this task, the overall percentage of this assignment will go over 100%", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
               
            }else{
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
        if(selectedTask?.task_status == false){
            selectedTask?.task_status = true
             self.selectedAssignment.assignment_status = String(Int(self.selectedAssignment.assignment_status!)!+Int(selectedTask!.task_percentage!))
        }else{
            selectedTask?.task_status = false
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

        // Do any additional setup after loading the view.
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

}
