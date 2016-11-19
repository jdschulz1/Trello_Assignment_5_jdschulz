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
    
    func createCard(listid listid: String, name: String, desc: String, completion: (CardResult) -> Void) {
        let url = TrelloAPI.createCard(listid: listid, name: name, desc: desc)
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
        createCard(listid: data.listid, name: nameedit.text ?? "", desc: descedit.text ?? "") {
            (cardResult) -> Void in
            
            NSOperationQueue.mainQueue().addOperationWithBlock() {
                switch cardResult {
                case let .Success(card):
                    print("Successfully created Card# \(card.id) to be named \(card.name) with a description of \(card.desc)")
                    self.data.cardDataSource.cards.insert(card, atIndex: Int(self.idxedit.text!)!)
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
}
