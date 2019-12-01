//
//  ToDoTableViewCell.swift
//  To Do (Minimalistic Design)
//
//  Created by Roy Akash on 10/12/18.
//  Copyright © 2018 The Roy Akash Software, Company. All rights reserved.
//

import UIKit

class ToDoTableViewCell: UITableViewCell {

    @IBOutlet weak var todoLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if #available(iOS 13.0, *) {
            self.contentView.backgroundColor = UIColor.systemBackground
        } else {
            self.contentView.backgroundColor = UIColor.white
        }
        
        
    }

}
