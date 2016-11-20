//
//  CardEditViewController.swift
//  Trello App by John Schulz
//
//  Created by admin on 11/18/16.
//  Copyright © 2016 edu.oc.eagles. All rights reserved.
//

import UIKit

class CardEditViewController: UIViewController{
    
    @IBOutlet var nameedit: UITextField!
    @IBOutlet var descedit: UITextField!
    @IBOutlet var listedit: UITextField!
    @IBOutlet var posedit: UITextField!
    @IBOutlet var deletebtn: UIButton!
    
    @IBAction func deleteCard(sender: AnyObject) {
        print("Deleted card named \"\(data.newname)\" with description \"\(data.newdesc)\".")
        data.deleted = true
    }
    
    var data = EditedCardData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nameedit.text = data.newname
        self.descedit.text = data.newdesc
        self.listedit.text = data.idList
        self.data.deleted = false
    }
    
    let session: NSURLSession = {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        return NSURLSession(configuration: config)
    }()
    
    func editCard(cardid cardid: String, name: String, desc: String, completion: (CardResult) -> Void) {
        let url = TrelloAPI.editCard(cardid: cardid, name: name, desc: desc)
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "PUT"
        let task = session.dataTaskWithRequest(request) {
            (data, response, error) -> Void in
            
            let result = processEditCardRequest(data: data, error: error)
            completion(result)
        }
        task.resume()
    }
    
    func moveCard(listid listid: String, cardid: String, name: String, desc: String, idx: String, completion: (CardResult) -> Void) {
        
        var url: NSURL!
        if let index = Int(idx) as Int!
        {
            self.data.idx = String(index)
            if index > 0 {
                url = TrelloAPI.moveCard(listid: listid, cardid: cardid, name: name, desc: desc,idx: String(index))
            }
            else {
                url = TrelloAPI.moveCard(listid: listid, cardid: cardid, name: name, desc: desc,idx: "top")
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
            
            url = TrelloAPI.moveCard(listid: listid, cardid: cardid, name: name, desc: desc, idx: index)
        }
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "PUT"
        let task = session.dataTaskWithRequest(request) {
            (data, response, error) -> Void in
            
            let result = processMoveCardRequest(data: data, error: error)
            completion(result)
        }
        task.resume()
    }
    
    func deleteCard(cardid cardid: String, completion: (CardResult) -> Void) {
        let url = TrelloAPI.deleteCard(cardid: cardid)
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "DELETE"
        let task = session.dataTaskWithRequest(request) {
            (data, response, error) -> Void in
            
            let result = processDeleteCardRequest(data: data, error: error)
            completion(result)
        }
        task.resume()
    }
    
    override func viewWillDisappear(animated: Bool) {
        data.newname = self.nameedit.text ?? ""
        data.newdesc = self.descedit.text ?? ""
        data.idx = self.posedit.text ?? ""
        data.idList = self.listedit.text ?? ""

        if data.id != nil && data.newname != nil && data.newdesc != nil && data.deleted != nil{
            if data.deleted == false{
                if self.posedit != nil && self.posedit != "" && self.listedit != nil && self.listedit != "" {
                    if let idx = self.posedit.text {
                        self.data.idx = idx
                    }
                    else {
                        self.data.idx = "bottom"
                    }
                    
                    moveCard(listid: data.idList, cardid: data.id, name: data.newname, desc: data.newdesc, idx: data.idx) {
                        (cardResult) -> Void in
                        
                        NSOperationQueue.mainQueue().addOperationWithBlock() {
                            switch cardResult {
                            case let .Success(card):
                                print("Successfully moved Card# \(card.id) to with name \(card.name) a description of \(card.desc)")
                            case let .Failure(error):
                                print("Error editing card: \(error)")
                            }
                        }
                    }
                }
                else {
                    editCard(cardid: data.id, name: data.newname, desc: data.newdesc) {
                        (cardResult) -> Void in
                        
                        NSOperationQueue.mainQueue().addOperationWithBlock() {
                            switch cardResult {
                            case let .Success(card):
                                print("Successfully edited Card# \(card.id) to be named \(card.name) with a description of \(card.desc)")
                            case let .Failure(error):
                                print("Error editing card: \(error)")
                            }
                        }
                    }
                }
            }
            else if data.deleted == true{
                deleteCard(cardid: data.id) {
                    (cardResult) -> Void in
                    
                    NSOperationQueue.mainQueue().addOperationWithBlock() {
                        switch cardResult {
                        case let .Success(card):
                            print("Successfully deleted Card# \(card.id)")
                        case let .Failure(error):
                            print("Error editing card: \(error)")
                        }
                    }
                }
            }
        }
    }
}

class EditedCardData {
    var id: String!
    var newname: String!
    var newdesc: String!
    var deleted: Bool!
    var idx: String!
    var idList: String!
}

