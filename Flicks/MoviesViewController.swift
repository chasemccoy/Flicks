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
  
  var movies: [NSDictionary]?
  var filteredMovies: [NSDictionary]?
  var refreshControl: UIRefreshControl!
  var searchBar: UISearchBar!
  var accentColor = UIColor(red:0.943, green:0.77, blue:0.007, alpha:1)
  var endPoint: String! = "now_playing"
  
  override func viewDidLoad() {
    tableView.dataSource = self
        
    refreshControl = UIRefreshControl()
    refreshControl.attributedTitle = NSAttributedString(string: "Loading...", attributes: [NSForegroundColorAttributeName: accentColor])
    refreshControl.tintColor = accentColor
    refreshControl.addTarget(self, action: "updateMovieData", forControlEvents: UIControlEvents.ValueChanged)
    self.tableView.insertSubview(refreshControl, atIndex: 0)
    
    searchBar = UISearchBar()
    searchBar.barStyle = UIBarStyle.BlackTranslucent
    searchBar.keyboardAppearance = UIKeyboardAppearance.Dark
    tableView.keyboardDismissMode = .Interactive
    searchBar.sizeToFit()
    navigationItem.titleView = searchBar
    searchBar.delegate = self
    
    navigationController?.navigationBar.tintColor = accentColor
    
    // For some reason, this fixes the refresh spinner not having the set tint color on first launch
    tableView.contentOffset = CGPointMake(0, -self.refreshControl.frame.size.height)
    
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
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    let cell = sender as! UITableViewCell
    let indexPath = tableView.indexPathForCell(cell)
    let movie = movies![indexPath!.row]
    
    let detailViewController = segue.destinationViewController as! DetailViewController
    detailViewController.movie = movie
    
  }
}




  extension MoviesViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      if let movies = filteredMovies {
        return movies.count
      }
      return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
      
      cell.posterView.image = UIImage()
      
      let movie = filteredMovies![indexPath.row]
      let title = movie["title"] as! String
      let overview = movie["overview"] as! String
      
      let baseURL = "http://image.tmdb.org/t/p/w500"
      if let posterPath = movie["poster_path"] as? String {
        let imageURL = NSURL(string: baseURL + posterPath)
        cell.posterView.setImageWithURL(imageURL!)
      }
      else {
        cell.posterView.image = UIImage()
      }
      
      cell.titleLabel.text = title
      cell.overviewLabel.text = overview
      
      return cell
    }

  }




extension MoviesViewController: UISearchBarDelegate {
  func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
    filteredMovies = searchText.isEmpty ? movies : movies!.filter({(movie: NSDictionary) -> Bool in
      let movieTitle = movie["title"] as! String
      return movieTitle.lowercaseString.containsString(searchText.lowercaseString)
    })
    
    tableView.reloadData()
  }

}

  
  
  
  
  
  
  
  
  
  
  
  
  
  

