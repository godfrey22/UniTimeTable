//
//  FinishedAssignmentCell.swift
//  UniTimeTable
//
//  Created by Godfrey Gao on 16/5/17.
//  Copyright © 2016年 Godfrey Gao. All rights reserved.
//

import UIKit

class FinishedAssignmentCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet var assignment_title: UILabel!
    @IBOutlet var assignment_code: UILabel!
    @IBOutlet var due_date: UILabel!
    @IBOutlet var status: UILabel!

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
