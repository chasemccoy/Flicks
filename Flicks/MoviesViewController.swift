//
//  MoviesViewController.swift
//  Flicks
//
//  Created by Chase McCoy on 1/6/16.
//  Copyright © 2016 Chase McCoy. All rights reserved.
//

import UIKit
import AFNetworking

class MoviesViewController: UIViewController {
  
  @IBOutlet var tableView: UITableView!
  @IBOutlet var collectionView: UICollectionView!
  
  var movies: [NSDictionary]?
  var filteredMovies: [NSDictionary]?
  var refreshControl: UIRefreshControl!
  var searchBar: UISearchBar!
  var accentColor = UIColor(red:0.943, green:0.77, blue:0.007, alpha:1)
  var endPoint: String! = "now_playing"
  
  override func viewDidLoad() {
    collectionView.dataSource = self
    collectionView.delegate = self
            
    refreshControl = UIRefreshControl()
    refreshControl.attributedTitle = NSAttributedString(string: "Loading...", attributes: [NSForegroundColorAttributeName: accentColor])
    refreshControl.tintColor = accentColor
    refreshControl.addTarget(self, action: "updateMovieData", forControlEvents: UIControlEvents.ValueChanged)
    refreshControl.layer.zPosition = -1
    self.collectionView.insertSubview(refreshControl, belowSubview: self.collectionView)
    
    searchBar = UISearchBar()
    searchBar.barStyle = UIBarStyle.BlackTranslucent
    searchBar.keyboardAppearance = UIKeyboardAppearance.Dark
    collectionView.keyboardDismissMode = .Interactive
    searchBar.sizeToFit()
    navigationItem.titleView = searchBar
    searchBar.delegate = self
    
    navigationController?.navigationBar.tintColor = accentColor
    
    // For some reason, this fixes the refresh spinner not having the set tint color on first launch
    collectionView.contentOffset = CGPointMake(0, -self.refreshControl.frame.size.height)
    
    refreshControl.beginRefreshing()
    updateMovieData()
  }
  
  func updateMovieData() {
    UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    
    let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
    let url = NSURL(string:"https://api.themoviedb.org/3/movie/\(endPoint)?api_key=\(apiKey)")
    let request = NSURLRequest(URL: url!)
    let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
    configuration.URLCache = nil
    let session = NSURLSession(
      configuration: configuration,
      delegate:nil,
      delegateQueue:NSOperationQueue.mainQueue()
    )
    
    let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
      completionHandler: { (dataOrNil, response, error) in
        if let data = dataOrNil {
          if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
            data, options:[]) as? NSDictionary {
              //NSLog("response: \(responseDictionary)")
              self.movies = responseDictionary["results"] as? [NSDictionary]
              self.filteredMovies = self.movies
              self.collectionView.reloadData()
          }
        }
        else {
          // Show Error Message Here
        }
        
        self.refreshControl.endRefreshing()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    });
    task.resume()
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    let cell = sender as! UICollectionViewCell
    let indexPath = collectionView.indexPathForCell(cell)
    let movie = movies![indexPath!.row]
    
    let detailViewController = segue.destinationViewController as! DetailViewController
    detailViewController.movie = movie
    
  }
}




extension MoviesViewController: UICollectionViewDataSource {
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if let movies = filteredMovies {
      return movies.count
    }
    return 0
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
    
    cell.posterView.image = UIImage()
    
    let movie = filteredMovies![indexPath.row]
    
    let baseURL = "http://image.tmdb.org/t/p/w500"
    if let posterPath = movie["poster_path"] as? String {
      let imageURL = NSURL(string: baseURL + posterPath)
      cell.posterView.setImageWithURL(imageURL!)
    }
    else {
      cell.posterView.image = UIImage()
    }
    
    return cell
  }
}




extension MoviesViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    let aspectRatio: CGFloat = 300 / 444
    let width = collectionView.frame.size.width / 2
    let height = width / aspectRatio
    return CGSizeMake(width, height)
  }
}




extension MoviesViewController: UISearchBarDelegate {
  func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
    filteredMovies = searchText.isEmpty ? movies : movies!.filter({(movie: NSDictionary) -> Bool in
      let movieTitle = movie["title"] as! String
      return movieTitle.lowercaseString.containsString(searchText.lowercaseString)
    })
    
    collectionView.reloadData()
  }

}

  
  
  
  
  
  
  
  
  
  
  
  
  
  

