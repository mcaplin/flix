//
//  DetailsViewController.swift
//  Flix
//
//  Created by Michelle Caplin on 2/4/18.
//  Copyright © 2018 Michelle Caplin. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {


    @IBOutlet weak var backDropImageView: UIImageView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var OverviewTextView: UITextView!
    
    var movie: [String:Any]?
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let movie = movie {
            titleLabel.text = movie["title"] as? String
            releaseDateLabel.text = movie["release_date"] as? String
            OverviewTextView.text = movie["overview"] as? String
            let avg = movie["vote_average"] as! CGFloat
            ratingLabel.text = String(describing: avg) + " ⭐️"
            let backdropPathString = movie["backdrop_path"] as! String
            let posterPathString = movie["poster_path"] as! String
            let baseURLString = "https://image.tmdb.org/t/p/w500"
            let backdropURL = URL(string: baseURLString + backdropPathString)!
            backDropImageView.af_setImage(withURL: backdropURL)
            let posterURL = URL(string: baseURLString + posterPathString)!
            posterImageView.af_setImage(withURL: posterURL)

        
            
            
        }
        
    }
        
    
    @IBAction func didTap(_ sender: Any) {
        performSegue(withIdentifier: "web", sender: nil)
    }
    
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
                let WebViewController = segue.destination as! WebViewController
    
            let id = movie!["id"] as! Int
   
            WebViewController.id = id
            
        }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
