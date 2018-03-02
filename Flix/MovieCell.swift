//
//  MovieCell.swift
//  Flix
//
//  Created by Michelle Caplin on 2/3/18.
//  Copyright © 2018 Michelle Caplin. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
    var movie: Movie! {
        didSet {
            titleLabel.text = movie?.title
            overviewLabel.text = movie?.overview
            let baseURLString = "https://image.tmdb.org/t/p/w500"
            let posterPathString = movie?.posterUrl
            let posterURL = URL(string: baseURLString + posterPathString!)!
            posterImageView.af_setImage(withURL: posterURL)
            titleLabel.preferredMaxLayoutWidth = titleLabel.frame.size.width
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
