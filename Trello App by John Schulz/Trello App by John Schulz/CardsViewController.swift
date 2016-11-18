//
//  CardsViewController.swift
//  Trello App by John Schulz
//
//  Created by admin on 11/17/16.
//  Copyright © 2016 edu.oc.eagles. All rights reserved.
//

import UIKit

class CardsViewController: UICollectionViewController {
    
    
    let cardDataSource = CardDataSource()
    var listid: String!
    
    let session: NSURLSession = {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        return NSURLSession(configuration: config)
    }()
    
    func getCards(boardid listid: String, completion: (CardResult) -> Void) {
        let url = TrelloAPI.allCardsForList(listid: listid)
        let request = NSURLRequest(URL: url)
        let task = session.dataTaskWithRequest(request) {
            (data, response, error) -> Void in
            
            let result = processGetCardsRequest(data: data, error: error)
            completion(result)
        }
        task.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView!.dataSource = cardDataSource
        
        getCards(boardid: self.listid){
            (listsResult) -> Void in
            
            NSOperationQueue.mainQueue().addOperationWithBlock() {
                switch listsResult {
                case let .Success(lists):
                    print("Successfully found \(lists.count) lists.")
                    self.cardDataSource.cards = lists
                case let .Failure(error):
                    self.cardDataSource.cards.removeAll()
                    print("Error fetching lists: \(error)")
                }
                self.collectionView!.reloadSections(NSIndexSet(index: 0))
            }
        }
    }
}
