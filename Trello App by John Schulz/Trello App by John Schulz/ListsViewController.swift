//
//  ListsViewController.swift
//  Trello App by John Schulz
//
//  Created by admin on 11/16/16.
//  Copyright © 2016 edu.oc.eagles. All rights reserved.
//

import UIKit

class ListsViewController: UICollectionViewController {
    
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
            
            let result = processGetListsRequest(data: data, error: error)
            completion(result)
        }
        task.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView!.dataSource = listDataSource
    
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
                self.collectionView!.reloadSections(NSIndexSet(index: 0))
            }
        }
    }
    
    //UICollectionViewDelegate
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cardSegue = "ShowCards"
        let list = listDataSource.lists[indexPath.row]
        self.performSegueWithIdentifier(cardSegue, sender: list)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowCards" {
            let cardsViewController = segue.destinationViewController as! CardsViewController
            let list = sender as! List
            cardsViewController.listid = list.id
        }
    }
}
