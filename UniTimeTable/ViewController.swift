//
//  ViewController.swift
//  UniTimeTable
//
//  Created by Godfrey Gao on 16/4/30.
//  Copyright © 2016年 Godfrey Gao. All rights reserved.
//

import UIKit

extension UIViewController {
    //copied from http://stackoverflow.com/questions/24126678/close-ios-keyboard-by-touching-anywhere-using-swift
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

