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
        
        semesterTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "SemesterCell")
        
        //self.deleteAllData("Semester")
        
        let appDel: AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context: NSManagedObjectContext = appDel.managedObjectContext
        
        let request = NSFetchRequest(entityName: "Semester")
        request.returnsObjectsAsFaults = false
        
        

      
        
        do{
            let result: NSArray = try context.executeFetchRequest(request)
            print(result.count)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return semesterList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SemesterCellIdentifier", forIndexPath: indexPath) as! SemesterCell
        let dateFormatter = NSDateFormatter()
        let s: Semester = self.semesterList[indexPath.row] as! Semester
        print(s)
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        cell.timeLabel.text = dateFormatter.stringFromDate(s.startYear!) + " ~ " + dateFormatter.stringFromDate(s.endYear!)
        return cell
    }
    
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
