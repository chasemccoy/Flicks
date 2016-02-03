//
//  MovieCell.swift
//  Flicks
//
//  Created by Chase McCoy on 1/6/16.
//  Copyright © 2016 Chase McCoy. All rights reserved.
//

import UIKit

class MovieCell: UICollectionViewCell {

  @IBOutlet var posterView: UIImageView!
  @IBOutlet var dimView: UIView!
  
  override var highlighted: Bool {
    didSet {
      if self.highlighted {
        dimView.hidden = false
      }
      else {
        dimView.hidden = true
      }
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
}
