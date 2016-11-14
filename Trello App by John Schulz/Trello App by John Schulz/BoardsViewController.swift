//
//  BoardsViewController.swift
//  Trello App by John Schulz
//
//  Created by admin on 11/13/16.
//  Copyright © 2016 edu.oc.eagles. All rights reserved.
//

import UIKit

class BoardsViewController: UIViewController {
    
    @IBOutlet var boardView: UICollectionView!
    
    let session: NSURLSession = {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        return NSURLSession(configuration: config)
    }()
    
    func getBoards() {
        let url = TrelloAPI.allBoardsURL()
        let request = NSURLRequest(URL: url)
        let task = session.dataTaskWithRequest(request) {
            (data, response, error) -> Void in
            
            if let jsonData = data {
                if let jsonString = NSString(data: jsonData,
                                             encoding: NSUTF8StringEncoding) {
                    print(jsonString)
                }
            }
            else if let requestError = error {
                print("Error fetching Trello Boards: \(requestError)")
            }
            else {
                print("Unexpected error with the request")
            }
        }
        task.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getBoards()
    }
}