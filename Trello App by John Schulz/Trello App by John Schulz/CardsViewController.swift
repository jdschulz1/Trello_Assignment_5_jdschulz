//
//  CardsViewController.swift
//  Trello App by John Schulz
//
//  Created by admin on 11/17/16.
//  Copyright © 2016 edu.oc.eagles. All rights reserved.
//

import UIKit

class CardsViewController: UICollectionViewController {
    
    @IBOutlet var addcard: UIButton!
    
    let cardDataSource = CardDataSource()
    var listid: String!
    var editdata = EditedCardData()
    var createdata = CreatedCardData()
    
    let session: NSURLSession = {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        return NSURLSession(configuration: config)
    }()
    
    func getCards(listid listid: String, completion: (CardsResult) -> Void) {
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
        self.createdata.cardDataSource = self.cardDataSource
        self.createdata.listid = self.listid
        self.editdata.deleted = false
        
        getCards(listid: self.listid){
            (listsResult) -> Void in
            
            NSOperationQueue.mainQueue().addOperationWithBlock() {
                switch listsResult {
                case let .Success(cards):
                    print("Successfully found \(cards.count) cards.")
                    self.cardDataSource.cards = cards
                case let .Failure(error):
                    self.cardDataSource.cards.removeAll()
                    print("Error fetching cards: \(error)")
                }
                self.collectionView!.reloadSections(NSIndexSet(index: 0))
            }
        }
    }
    
    //UICollectionViewDelegate
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cardSegue = "ShowCardEdit"
        let card = cardDataSource.cards[indexPath.row]
        self.performSegueWithIdentifier(cardSegue, sender: card)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowCardEdit" {
            let cardEditViewController = segue.destinationViewController as! CardEditViewController
            let editcard = sender as! Card
            self.editdata = cardEditViewController.data
            cardEditViewController.data.id = editcard.id
            cardEditViewController.data.newdesc = editcard.desc
            cardEditViewController.data.newname = editcard.name
            cardEditViewController.data.idList = self.listid
        }
        if segue.identifier == "ShowCardCreate" {
            let cardCreateViewController = segue.destinationViewController as! CardCreateViewController
            self.createdata = cardCreateViewController.data
            cardCreateViewController.data.cardDataSource = self.cardDataSource
            cardCreateViewController.data.listid = self.listid
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.collectionView?.setNeedsDisplay()
    }
}
