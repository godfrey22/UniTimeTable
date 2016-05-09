//
//  SemesterViewController.swift
//  UniTimeTable
//
//  Created by Godfrey Gao on 16/5/9.
//  Copyright © 2016年 Godfrey Gao. All rights reserved.
//

import UIKit
import CoreData

class SemesterViewController: UIViewController, UITableViewDataSource {
    
    var semesterList: NSMutableArray = []

    @IBOutlet var semesterTableView: UITableView!
    var semester = [Semester]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Register the table view
        semesterTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "SemesterCell")
        
        //Create the delegate and prepare for the fetch
        let appDel: AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context: NSManagedObjectContext = appDel.managedObjectContext
        
        //Request all the objects in the "Semester" table
        let request = NSFetchRequest(entityName: "Semester")
        request.returnsObjectsAsFaults = false
        
        //Put all the semester into the semesterList
        do{
            let result: NSArray = try context.executeFetchRequest(request)
            if result.count > 0{
                self.semesterList = NSMutableArray(array: (result as! [Semester]))
            }
        }catch
        {
            let fetchError = error as NSError
            print(fetchError)
        }
        self.semesterTableView.reloadData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return semesterList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SemesterCellIdentifier", forIndexPath: indexPath) as! SemesterCell
        //Create a date formatter
        let dateFormatter = NSDateFormatter()
        let s: Semester = self.semesterList[indexPath.row] as! Semester
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        
        //Config the cell
        cell.timeLabel.text = dateFormatter.stringFromDate(s.startYear!) + " ~ " + dateFormatter.stringFromDate(s.endYear!)
        return cell
    }
    
    
    //Delete data purpose
    func deleteAllData(entity: String)
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            for managedObject in results
            {
                let managedObjectData: NSManagedObject = managedObject as! NSManagedObject
                managedContext.deleteObject(managedObjectData)
            }
        }catch let error as NSError
        {
            print("Delete all data in \(entity) error: \(error)")
        }
        
    }

}
