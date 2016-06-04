//
//  UCClassCell.swift
//  UniTimeTable
//
//  Created by Godfrey Gao on 16/6/3.
//  Copyright © 2016年 Godfrey Gao. All rights reserved.
//

import UIKit

class UCClassCell: UITableViewCell {

    @IBOutlet var courseCode: UILabel!
    @IBOutlet var courseTime: UILabel!
    @IBOutlet var courseLocation: UILabel!
    @IBOutlet var courseType: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
