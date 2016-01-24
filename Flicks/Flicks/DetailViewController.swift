//
//  DetailViewController.swift
//  Flicks
//
//  Created by Chase McCoy on 1/15/16.
//  Copyright © 2016 Chase McCoy. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UIScrollViewDelegate {
  
  @IBOutlet var posterImageView: UIImageView!
  @IBOutlet var titleLabel: UILabel!
  @IBOutlet var overviewLabel: UILabel!
  @IBOutlet var scrollView: UIScrollView!
  @IBOutlet var infoView: UIView!
  @IBOutlet var contentViewHeighConstraint: NSLayoutConstraint!
  @IBOutlet var posterImageViewHeightConstraint: NSLayoutConstraint!
  
  var movie: NSDictionary!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    scrollView.delegate = self

    let title = movie["title"] as! String
    let overview = movie["overview"] as! String
    
    let baseURL = "http://image.tmdb.org/t/p/w500"
    if let posterPath = movie["poster_path"] as? String {
      let imageURL = NSURL(string: baseURL + posterPath)
      posterImageView.setImageWithURL(imageURL!)
    }
    else {
      posterImageView.image = UIImage()
    }
    
    titleLabel.text = title
    overviewLabel.text = overview
    
    navigationItem.title = title
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }
  
  func scrollViewDidScroll(scrollView: UIScrollView) {
    posterImageViewHeightConstraint.constant = self.view.frame.height - (self.navigationController?.navigationBar.frame.height)! - 20
    contentViewHeighConstraint.constant = posterImageViewHeightConstraint.constant + infoView.frame.height
  }
  
  override func viewWillDisappear(animated: Bool) {
    scrollView.delegate = nil
  }
  
  override func viewWillAppear(animated: Bool) {
    scrollView.delegate = self
  }
  
}
