//
//  ListsViewController.swift
//  Trello App by John Schulz
//
//  Created by admin on 11/16/16.
//  Copyright © 2016 edu.oc.eagles. All rights reserved.
//

import UIKit

class ListsViewController: UIViewController {
    
    @IBOutlet var listView: UICollectionView!
    
    let listDataSource = ListDataSource()
    var boardid: String!
    
    let session: NSURLSession = {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        return NSURLSession(configuration: config)
    }()
    
    func getLists(boardid boardid: String, completion: (ListResult) -> Void) {
        let url = TrelloAPI.allListsForBoard(boardid: boardid)
        let request = NSURLRequest(URL: url)
        let task = session.dataTaskWithRequest(request) {
            (data, response, error) -> Void in
            
            if let jsonData = data {
                do {
                    let jsonObject: AnyObject
                        = try NSJSONSerialization.JSONObjectWithData(jsonData,
                                                                     options: [])
                    print(jsonObject[0])
                    print(jsonObject[1])
                    print(jsonObject[2])
                }
                catch let error {
                    print("Error creating JSON object: \(error)")
                }
            }
            else if let requestError = error {
                print("Error fetching Trello Lists: \(requestError)")
            }
            else {
                print("Unexpected error with the request")
            }
            let result = processGetListsRequest(data: data, error: error)
            completion(result)
        }
        task.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listView.dataSource = listDataSource
    
        getLists(boardid: self.boardid){
            (listsResult) -> Void in
            
            NSOperationQueue.mainQueue().addOperationWithBlock() {
                switch listsResult {
                case let .Success(lists):
                    print("Successfully found \(lists.count) lists.")
                    self.listDataSource.lists = lists
                case let .Failure(error):
                    self.listDataSource.lists.removeAll()
                    print("Error fetching lists: \(error)")
                }
                self.listView.reloadSections(NSIndexSet(index: 0))
            }
        }
    }
}
