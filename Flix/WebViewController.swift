//
//  WebViewController.swift
//  Flix
//
//  Created by Michelle Caplin on 2/11/18.
//  Copyright © 2018 Michelle Caplin. All rights reserved.
//

import UIKit

class WebViewController: UIViewController  {
    
    
    @IBOutlet weak var webView: UIWebView!
    let urla = "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
    var id: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        print(id)
        
        let url1 = "https://api.themoviedb.org/3/movie/"
        let url2 = "/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US"
        let url = URL(string: url1 + String(id) + url2)!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            }
            else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                let trailers = dataDictionary["results"] as! [[String: Any]]
                let key = trailers[0]["key"] as! String
                let youtubeURL = URL(string: "https://www.youtube.com/watch?v=" + key)!
                let youtubeRequest = URLRequest(url: youtubeURL)
                self.webView.loadRequest(youtubeRequest)

                
            }
            
        }
        task.resume()
        
    }
    
    
    @IBAction func closeView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
