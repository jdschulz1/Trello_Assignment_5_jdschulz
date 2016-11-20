//
//  CardCreateViewController.swift
//  Trello App by John Schulz
//
//  Created by admin on 11/19/16.
//  Copyright © 2016 edu.oc.eagles. All rights reserved.
//

import UIKit

class CardCreateViewController: UIViewController{
    
    @IBOutlet var nameedit: UITextField!
    @IBOutlet var descedit: UITextField!
    @IBOutlet var idxedit: UITextField!
    
    var data = CreatedCardData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        idxedit.text = ""
    }
    
    let session: NSURLSession = {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        return NSURLSession(configuration: config)
    }()
    
    func createCard(listid listid: String, name: String, desc: String, idx: String, completion: (CardResult) -> Void) {
        
        var url: NSURL!
        if let index = Int(idx) as Int!
        {
            self.data.idx = String(index)
            if index > 0 {
                url = TrelloAPI.createCard(listid: listid, name: name, desc: desc,idx: String(index))
            }
            else {
                url = TrelloAPI.createCard(listid: listid, name: name, desc: desc,idx: "top")
            }
        }
        else
        {
            var index: String!
            if (idx == "bottom") || (idx == "top") {
                index = idx
            }
            else {
                index = "bottom"
            }
            self.data.idx = index
            
            url = TrelloAPI.createCard(listid: listid, name: name, desc: desc, idx: index)
        }
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        let task = session.dataTaskWithRequest(request) {
            (data, response, error) -> Void in
            
            let result = processEditCardRequest(data: data, error: error)
            completion(result)
        }
        task.resume()
    }
    
    override func viewWillDisappear(animated: Bool) {
        if let idx = self.idxedit.text {
            self.data.idx = idx
        }
        else {
            self.data.idx = "bottom"
        }
        
        createCard(listid: data.listid, name: nameedit.text ?? "", desc: descedit.text ?? "", idx: self.data.idx) {
            (cardResult) -> Void in
            
            
            NSOperationQueue.mainQueue().addOperationWithBlock() {
                switch cardResult {
                case let .Success(card):
                    print("Successfully created Card# \(card.id) to be named \(card.name) with a description of \(card.desc)")
                    if self.data.idx == "top" {
                        self.data.cardDataSource.cards.insert(card, atIndex: 1)
                    }
                    else if let index = Int(self.data.idx) as Int!
                    {
                        self.data.cardDataSource.cards.insert(card, atIndex: index)
                    }
                    else {
                        self.data.cardDataSource.cards.insert(card, atIndex: self.data.cardDataSource.cards.count)
                    }
                case let .Failure(error):
                    print("Error creating card: \(error)")
                }
            }
        }
    }
}

class CreatedCardData {
    var listid: String!
    var cardDataSource: CardDataSource!
    var idx: String!
}
