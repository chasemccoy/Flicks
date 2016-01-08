//
//  MovieCell.swift
//  Flicks
//
//  Created by Chase McCoy on 1/6/16.
//  Copyright © 2016 Chase McCoy. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {

  @IBOutlet var titleLabel: UILabel!
  @IBOutlet var overviewLabel: UILabel!
  @IBOutlet var posterView: UIImageView!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
