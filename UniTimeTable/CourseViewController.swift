//
//  CourseViewController.swift
//  UniTimeTable
//
//  Created by Godfrey Gao on 16/5/11.
//  Copyright © 2016年 Godfrey Gao. All rights reserved.
//

import UIKit
import CoreData

class CourseViewController: UIViewController {

    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var unitTableView: UITableView!
    
    var selectedSemester: Semester?
    var managedObjectContext: NSManagedObjectContext
    
    required init?(coder aDecoder: NSCoder) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.managedObjectContext = appDelegate.managedObjectContext
        super.init(coder: aDecoder)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        timeLabel.text = "  " + dateFormatter.stringFromDate(selectedSemester!.startYear!) + " ~ " + dateFormatter.stringFromDate(selectedSemester!.endYear!)
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
