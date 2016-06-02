//
//  UpcomingAssignmentCell.swift
//  UniTimeTable
//
//  Created by Godfrey Gao on 16/5/17.
//  Copyright © 2016年 Godfrey Gao. All rights reserved.
//

import UIKit

class UpcomingAssignmentCell: UITableViewCell {

    @IBOutlet var courseCode: UILabel!
    @IBOutlet var assignmentTitle: UILabel!
    @IBOutlet var dueDate: UILabel!
    @IBOutlet var percentage: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
