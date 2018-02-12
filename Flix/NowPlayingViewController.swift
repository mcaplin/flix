//
//  NowPlayingViewController.swift
//  Flix
//
//  Created by Michelle Caplin on 2/3/18.
//  Copyright © 2018 Michelle Caplin. All rights reserved.
//

import UIKit
import AlamofireImage


class NowPlayingViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var movies: [[String:Any]] = []
    var refreshControl: UIRefreshControl!
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    var filteredData: [String]! = []
    var data: [String]! = []
    var movieData:[String:[String]]! = [:]
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(NowPlayingViewController.didPullToRefresh(_:)), for: .valueChanged)
        refreshControl.tintColor = UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0)
        tableView.insertSubview(refreshControl, at: 0)
        
        
        tableView.dataSource = self
    
        
        fetchMovies()
        

        searchBar.delegate = self

        
    }
    
    @objc func didPullToRefresh(_ refreshControl: UIRefreshControl) {
        self.searchBarCancelButtonClicked(self.searchBar)
        fetchMovies()
    }
    
    func fetchData() {
        
    }
    
    func fetchMovies() {
        
        self.activityIndicator.startAnimating()
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                self.refreshControl.endRefreshing()
                self.activityIndicator.stopAnimating()
                
                let alertController = UIAlertController(title: "Cannot Get Movies", message: "The Internet connection appears to be offline.", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                    // handle cancel response here. Doing nothing will dismiss the view.
                }
                // add the cancel action to the alertController
                alertController.addAction(cancelAction)
                let OKAction = UIAlertAction(title: "Try Again", style: .default) { (action) in
                    self.fetchMovies()
                }
                alertController.addAction(OKAction)
                self.present(alertController, animated: true)
                print(error.localizedDescription)
            }
            else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                let movies = dataDictionary["results"] as! [[String: Any]]
                self.movies = movies
                self.data = []
                self.movieData = [:]
                for movie in movies {
                    self.data.append(movie["title"] as! String)
                    let title = movie["title"] as! String
                    let overview = movie["overview"] as! String
                    let posterPathString = movie["poster_path"] as! String
                    var rating = String(describing: movie["vote_average"])
                    rating = String(rating)
                    self.movieData[title] = [overview, posterPathString, rating]
                }
                self.filteredData = self.data

                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
                self.activityIndicator.stopAnimating()
                
                
                
                
            }
        }
        
        task.resume()
        
    }
    
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return filteredData.count
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell

        let title = self.filteredData[indexPath.row]
        let overview = movieData[title]?[0]
        let posterPathString = movieData[title]?[1]
        let baseURLString = "https://image.tmdb.org/t/p/w500"
        
        let posterURL = URL(string: baseURLString + posterPathString!)!
        
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        cell.posterImageView.af_setImage(withURL: posterURL)
        
        return cell
    }
    
        
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        searchBarTextDidBeginEditing(searchBar)
        
        filteredData = searchText.isEmpty ? data : data.filter { (item: String) -> Bool in
            // If dataItem matches the searchText, return true to include it
            return item.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
            }
        
        tableView.reloadData()
 
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        self.view.endEditing(true)
        filteredData = data
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
 
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        if let indexPath = tableView.indexPath(for: cell) {
            let movie = movies[indexPath.row]
            let detailsViewController = segue.destination as! DetailsViewController
            detailsViewController.movie = movie
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let index = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: index, animated: true)
        }
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
