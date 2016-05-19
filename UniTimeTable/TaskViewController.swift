//
//  TaskViewController.swift
//  UniTimeTable
//
//  Created by Godfrey Gao on 16/5/18.
//  Copyright © 2016年 Godfrey Gao. All rights reserved.
//

import UIKit
import CoreData

class TaskViewController: UIViewController {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         taskTabelView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "TaskCell")
        
        assignmentTitleLabel.text = selectedAssignment.assignment_title
        courseCodeLabel.text = selectedAssignment.belongs_to_Course?.course_code
        
        //teacherLabel.text
        //To-Do Need to fix logic here
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TaskCellIdentifier", forIndexPath: indexPath) as! TaskCell
        //Create a date formatter

        let t: Task = self.taskList[indexPath.row] as! Task
    
        //Config the cell
        
        return cell
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
