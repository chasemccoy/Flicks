//
//  MoviesViewController.swift
//  Flicks
//
//  Created by Chase McCoy on 1/6/16.
//  Copyright © 2016 Chase McCoy. All rights reserved.
//

import UIKit
import AFNetworking

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
  
  @IBOutlet var tableView: UITableView!
  
  var movies: [NSDictionary]?
  var filteredMovies: [NSDictionary]?
  var refreshControl: UIRefreshControl!
  var searchBar: UISearchBar!
  
  override func viewDidLoad() {
    tableView.delegate = self
    tableView.dataSource = self
        
    refreshControl = UIRefreshControl()
    refreshControl.attributedTitle = NSAttributedString(string: "Loading...", attributes: [NSForegroundColorAttributeName: UIColor(red:0.943, green:0.77, blue:0.007, alpha:1)])
    refreshControl.tintColor = UIColor(red:0.943, green:0.77, blue:0.007, alpha:1)
    refreshControl.addTarget(self, action: "updateMovieData", forControlEvents: UIControlEvents.ValueChanged)
    self.tableView.insertSubview(refreshControl, atIndex: 0)
    
    searchBar = UISearchBar()
    searchBar.barStyle = UIBarStyle.BlackTranslucent
    searchBar.keyboardAppearance = UIKeyboardAppearance.Dark
    tableView.keyboardDismissMode = .Interactive
    searchBar.sizeToFit()
    navigationItem.titleView = searchBar
    searchBar.delegate = self
    
    refreshControl.beginRefreshing()
    updateMovieData()
  }
  
  func updateMovieData() {
    UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    
    let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
    let url = NSURL(string:"https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
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
              self.tableView.reloadData()
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
  
  // MARK: - UITableViewDataSource Methods
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let movies = filteredMovies {
      return movies.count
    }
    return 0
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
    
    let movie = filteredMovies![indexPath.row]
    let title = movie["title"] as! String
    let overview = movie["overview"] as! String
    
    let baseURL = "http://image.tmdb.org/t/p/w500"
    let posterPath: String? = movie["poster_path"] as? String
    if posterPath != nil {
      let imageURL = NSURL(string: baseURL + posterPath!)
      cell.posterView.setImageWithURL(imageURL!)
    }
    else {
      cell.posterView.image = UIImage()
    }
    
    cell.titleLabel.text = title
    cell.overviewLabel.text = overview
    
    return cell
  }
  
  // MARK: - UITableViewDelegate Methods
  
  
  
  
  // MARK: - UISearchBarDelegate Methods
  
  func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
    filteredMovies = searchText.isEmpty ? movies : movies!.filter({(movie: NSDictionary) -> Bool in
      let movieTitle = movie["title"] as! String
      return movieTitle.lowercaseString.containsString(searchText.lowercaseString)
    })
    
    tableView.reloadData()
  }
  
  
  
  
  
  
  
  
  
  
  
  
  
  
}
