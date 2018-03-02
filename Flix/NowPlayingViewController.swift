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
    
    @IBOutlet weak var movieControl: UISegmentedControl!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var refreshControl: UIRefreshControl!
    @IBOutlet weak var searchBar: UISearchBar!
    
    

    var movies: [Movie] = []
    var filteredMovies: [Movie]! = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(NowPlayingViewController.didPullToRefresh(_:)), for: .valueChanged)
        refreshControl.tintColor = UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0)
        tableView.insertSubview(refreshControl, at: 0)
        
        tableView.dataSource = self
        searchBar.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50

        fetchMovies()
    }
    
    @objc func didPullToRefresh(_ refreshControl: UIRefreshControl) {
        self.searchBarCancelButtonClicked(self.searchBar)
        fetchMovies()
    }
    
    
    func fetchMovies() {
        
        self.activityIndicator.startAnimating()
        
        let defaults = UserDefaults.standard
        let nowPlaying = defaults.integer(forKey: "Now Playing")
        var type = "Popular"
        
        if  movieControl.selectedSegmentIndex == nowPlaying {
            self.title = "Now Playing"
            self.tabBarItem.title = "Now Playing"
            type = "Now Playing"
        }
        else {
            self.title = "Popular"
            self.tabBarItem.title = "Popular"
        }
        MovieApiManager().getMovies(type: type) { ( movies: [Movie]?, error: Error?) in
            if let movies = movies {
                
                
                self.movies = movies
                self.filteredMovies = self.movies
                //self.tableView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                
                self.tableView.reloadData()
                
                self.refreshControl.endRefreshing()
                self.activityIndicator.stopAnimating()
            }
            else if let error = error{
                self.refreshControl.endRefreshing()
                self.activityIndicator.stopAnimating()
                
                let alertController = UIAlertController(title: "Cannot Get Movies", message: "The Internet connection appears to be offline.", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
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
        
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        cell.movie = filteredMovies[indexPath.row]
        
        return cell
    }
    
        
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        searchBarTextDidBeginEditing(searchBar)
        if searchText.isEmpty == true {
            filteredMovies = movies
        }
        else{
        filteredMovies = movies.filter{ ($0.title.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil)}
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
        filteredMovies = movies
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
    
    @IBAction func tapCategory(_ sender: Any) {
        
        fetchMovies()
        searchBarCancelButtonClicked(searchBar)
        let indexPath = IndexPath(row: 0, section: 0)
        self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }


    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
