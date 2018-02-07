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
    //var text:String = "test1"
    
    
    /*@IBAction func detailsButton(_ sender: Any) {
        let vc = DetailsViewController(nibName: "DetailsViewController", bundle: nil)
        vc.text = "test"
        self.showViewController(destination, sender: self)
        
        //rootViewController?.pushViewController(vc, animated: true)
    }*/
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
