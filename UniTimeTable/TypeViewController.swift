//
//  TypeViewController.swift
//  UniTimeTable
//
//  Created by Godfrey Gao on 16/5/15.
//  Copyright © 2016年 Godfrey Gao. All rights reserved.
//

import UIKit
import CoreData

class TypeViewController: UIViewController {

    @IBOutlet var typeInput: UITextField!
    @IBOutlet var typeTableView: UITableView!
    
    var selectedClass: Class!
    var typeList: NSMutableArray = []
    var managedObjectContext: NSManagedObjectContext
    
    required init?(coder aDecoder: NSCoder) {
        self.typeList = NSMutableArray()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.managedObjectContext = appDelegate.managedObjectContext
        super.init(coder: aDecoder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Register the table view
        typeTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "TypeCell")
        
        //Request all the objects in the "Semester" table
        let request = NSFetchRequest(entityName: "Type")
        request.returnsObjectsAsFaults = false
        
        //Put all the semester into the semesterList
        do{
            let result: NSArray = try managedObjectContext.executeFetchRequest(request)
            if result.count != 0
            {
                self.typeList = NSMutableArray(array: (result as! [Type]))
            }
        }catch
        {
            let fetchError = error as NSError
            print(fetchError)
        }
        typeTableView.reloadData()
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //Table View Overrides
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return typeList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TypeCellIdentifier", forIndexPath: indexPath) as! TypeCell
        let t: Type = self.typeList[indexPath.row] as! Type
        
        //Config the cell
        cell.typeLabel.text = t.type_name
        return cell
    }
    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            managedObjectContext.deleteObject(typeList.objectAtIndex(indexPath.row) as! NSManagedObject)
            self.typeList.removeObjectAtIndex(indexPath.row)
            typeTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            self.typeTableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Fade)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
