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

class AddTaskViewController: UIViewController {

    @IBOutlet var taskTitleLabel: UILabel!
    @IBOutlet var taskDescriptionField: UITextView!
    @IBOutlet var taskWorth: UITextField!
    
    
    var delegate: addTaskDelegate!
    var managedObjectContext: NSManagedObjectContext
    
    
    @IBAction func AddTask(sender: UIBarButtonItem) {
        let newTask: Task = (NSEntityDescription.insertNewObjectForEntityForName("Task", inManagedObjectContext: self.managedObjectContext)as! Task)
        newTask.setValue(taskTitleLabel.text, forKey: "task_title")
        newTask.setValue(taskDescriptionField.text, forKey: "task_details")
        newTask.setValue(Int(taskWorth.text!), forKey: "task_percentage")
        newTask.setValue(false, forKey: "task_status")
        self.delegate!.addTask(newTask)
        self.navigationController?.popViewControllerAnimated(true)
    }

    required init?(coder aDecoder: NSCoder) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.managedObjectContext = appDelegate.managedObjectContext
        super.init(coder: aDecoder)
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
