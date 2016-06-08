//
//  AddCourseViewController.swift
//  UniTimeTable
//
//  Created by Godfrey Gao on 16/5/11.
//  Copyright © 2016年 Godfrey Gao. All rights reserved.
//

import UIKit
import CoreData

protocol addCourseDelegate {
    func addCourse(course: Course)
}

class AddCourseViewController: UIViewController {

    
    var delegate: addCourseDelegate!
    var managedObjectContext: NSManagedObjectContext
    var selectedCourse: Course?
    
    @IBOutlet var courseNameInput: UITextField!
    @IBOutlet var courseCodeInput: UITextField!
    
    @IBAction func addCourse(sender: AnyObject) {
        
        let courseCodeCondition = (courseCodeInput.text != "")
        let courseNameCondition = (courseNameInput.text != "")
        
        let pass = (courseCodeCondition && courseNameCondition)
        
        if(!pass){
            let alertController = UIAlertController(title: "Empty fields", message:
                "Please fill in necessary information", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        }

        
        
        if((selectedCourse) != nil)
        {
            selectedCourse?.setValue(courseNameInput.text, forKey: "course_name")
            selectedCourse?.setValue(courseCodeInput.text, forKey: "course_code")
            do
            {
                try self.managedObjectContext.save()
                print("A Course has been modified!")
            }
            catch let error
            {
                print("Could not save Deletion \(error)")
            }

            self.navigationController?.popViewControllerAnimated(true)
        }else{
            let newCourse: Course = (NSEntityDescription.insertNewObjectForEntityForName("Course", inManagedObjectContext: self.managedObjectContext)as! Course)
            newCourse.setValue(courseNameInput.text, forKey: "course_name")
            newCourse.setValue(courseCodeInput.text, forKey: "course_code")
            self.delegate!.addCourse(newCourse)
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.managedObjectContext = appDelegate.managedObjectContext
        super.init(coder: aDecoder)
    }
    
    override func viewWillAppear(animated: Bool) {
        if((selectedCourse) != nil)
        {
            courseCodeInput.text = selectedCourse?.course_code
            courseNameInput.text = selectedCourse?.course_name
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() 
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
