//
//  TrelloAPI.swift
//  Trello App by John Schulz
//
//  Created by admin on 11/13/16.
//  Copyright © 2016 edu.oc.eagles. All rights reserved.
//

import Foundation

enum BoardResult {
    case Success([Board])
    case Failure(ErrorType)
}

func processGetBoardsRequest(data data: NSData?, error: NSError?) -> BoardResult {
    guard let jsonData = data else {
        return .Failure(error!)
    }
    
    return TrelloAPI.boardsFromJSONData(jsonData)
}

enum ListResult {
    case Success([List])
    case Failure(ErrorType)
}

func processGetListsRequest(data data: NSData?, error: NSError?) -> ListResult {
    guard let jsonData = data else {
        return .Failure(error!)
    }
    
    return TrelloAPI.listsFromJSONData(jsonData)
}

enum CardsResult {
    case Success([Card])
    case Failure(ErrorType)
}

enum CardResult {
    case Success(Card)
    case Failure(ErrorType)
}

func processGetCardsRequest(data data: NSData?, error: NSError?) -> CardsResult {
    guard let jsonData = data else {
        return .Failure(error!)
    }
    
    return TrelloAPI.cardsFromJSONData(jsonData)
}

func processEditCardRequest(data data: NSData?, error: NSError?) -> CardResult {
    guard let jsonData = data else {
        return .Failure(error!)
    }
    
    return TrelloAPI.cardFromJSONData(jsonData)
}

func processMoveCardRequest(data data: NSData?, error: NSError?) -> CardResult {
    guard let jsonData = data else {
        return .Failure(error!)
    }
    
    return TrelloAPI.cardFromJSONData(jsonData)
}

func processDeleteCardRequest(data data: NSData?, error: NSError?) -> CardResult {
    guard let jsonData = data else {
        return .Failure(error!)
    }
    
    return TrelloAPI.cardFromJSONData(jsonData)
}

func processCreateCardRequest(data data: NSData?, error: NSError?) -> CardResult {
    guard let jsonData = data else {
        return .Failure(error!)
    }
    
    return TrelloAPI.cardFromJSONData(jsonData)
}

enum TrelloError: ErrorType {
    case InvalidJSONData
}

struct TrelloAPI {
    private static let baseURLString = "https://api.trello.com/1/"
    private static let APIKey = "132aad469a37d57ccff8413bf0a76c3f"
    private static let token = "87c400bb81415903e1280f1f1ad43f9f33b746c84596482e1a90e4cb52d4d025"
    
    private static func trelloURL(method method: String,
                                         parameters: [String:String]?) -> NSURL {
        
        let components = NSURLComponents(string: baseURLString + method)!
        
        var queryItems = [NSURLQueryItem]()
        
        let baseParams = [
            "key": APIKey,
            "token": token
        ]
        
        for (key, value) in baseParams {
            let item = NSURLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        
        if let additionalParams = parameters {
            for (key, value) in additionalParams {
                let item = NSURLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
        }
        components.queryItems = queryItems
        
        return components.URL!
    }
    
    static func allBoardsURL() -> NSURL {
        return trelloURL(method: "members/johnschulz9/boards",
                         parameters: ["fields": "name,desc"])
    }
    
    static func allListsForBoard(boardid boardid: String) -> NSURL {
        return trelloURL(method: "boards/\(boardid)/lists",
                         parameters: ["fields": "name,desc"])
    }
    
    static func allCardsForList(listid listid: String) -> NSURL {
        return trelloURL(method: "lists/\(listid)/cards",
                         parameters: ["fields": "name,desc,idList,pos"])
    }
    
    static func createCard (listid listid: String, name: String, desc: String, idx: String) -> NSURL {
        return trelloURL(method: "cards/",
                         parameters: ["name":name,"desc":desc,"idList":listid,"pos":idx])
    }
    
    static func moveCard (listid listid: String, cardid: String, name: String, desc: String, idx: String) -> NSURL {
        return trelloURL(method: "cards/" + cardid,
                         parameters: ["name":name,"desc":desc,"idList":listid,"pos":idx])
    }
    
    static func deleteCard (cardid cardid: String) -> NSURL {
        return trelloURL(method: "cards/" + cardid,
                         parameters: [:])
    }
    
    static func editCard (cardid cardid: String, name: String, desc: String) -> NSURL {
        return trelloURL(method: "cards/" + cardid,
                         parameters: ["name":name,"desc":desc])
    }
    
    static func editCard (cardid cardid: String, name: String, desc: String, loc: String) -> NSURL {
        return trelloURL(method: "cards/" + cardid,
                         parameters: ["name":name,"desc":desc, "idList":loc])
    }
    
    static func boardsFromJSONData(data: NSData) -> BoardResult {
        do {
            let jsonObject: AnyObject
                = try NSJSONSerialization.JSONObjectWithData(data, options: [])
            
            guard let
                boardsArray = jsonObject as? [[String:AnyObject]] else {
                    
                    // The JSON structure doesn't match our expectations
                    return .Failure(TrelloError.InvalidJSONData)
            }
            
            var finalBoards = [Board]()
            for boardJSON in boardsArray {
                if let board = boardFromJSONObject(boardJSON) {
                    finalBoards.append(board)
                }
            }
            
            if finalBoards.count == 0 && boardsArray.count > 0 {
                // We weren't able to parse any of the boards
                // Maybe the JSON format for boards has changed
                return .Failure(TrelloError.InvalidJSONData)
            }
            return .Success(finalBoards)
        }
        catch let error {
            return .Failure(error)
        }
    }
    
    private static func boardFromJSONObject(json: [String : AnyObject]) -> Board? {
        guard let
            id = json["id"] as? String,
            name = json["name"] as? String,
            desc = json["desc"] as? String else {
                
                // Don't have enough information to construct a Board
                return nil
        }
        
        return Board(id: id, name: name, desc: desc)
    }
    
    static func listsFromJSONData(data: NSData) -> ListResult {
        do {
            let jsonObject: AnyObject
                = try NSJSONSerialization.JSONObjectWithData(data, options: [])
            
            guard let
                listsArray = jsonObject as? [[String:AnyObject]] else {
                    
                    // The JSON structure doesn't match our expectations
                    return .Failure(TrelloError.InvalidJSONData)
            }
            
            var finalLists = [List]()
            for listJSON in listsArray {
                if let list = listFromJSONObject(listJSON) {
                    finalLists.append(list)
                }
            }
            
            if finalLists.count == 0 && listsArray.count > 0 {
                // We weren't able to parse any of the lists
                // Maybe the JSON format for lists has changed
                return .Failure(TrelloError.InvalidJSONData)
            }
            return .Success(finalLists)
        }
        catch let error {
            return .Failure(error)
        }
    }
    
    private static func listFromJSONObject(json: [String : AnyObject]) -> List? {
        guard let
            id = json["id"] as? String,
            name = json["name"] as? String else {
                
                // Don't have enough information to construct a List
                return nil
        }
        
        return List(id: id, name: name)
    }
    
    static func cardsFromJSONData(data: NSData) -> CardsResult {
        do {
            let jsonObject: AnyObject
                = try NSJSONSerialization.JSONObjectWithData(data, options: [])
            
            guard let
                cardsArray = jsonObject as? [[String:AnyObject]] else {
                    
                    // The JSON structure doesn't match our expectations
                    return .Failure(TrelloError.InvalidJSONData)
            }
            
            var finalCards = [Card]()
            for cardJSON in cardsArray {
                if let card = cardFromJSONObject(cardJSON) {
                    finalCards.append(card)
                }
            }
            
            if finalCards.count == 0 && cardsArray.count > 0 {
                // We weren't able to parse any of the cards
                // Maybe the JSON format for cards has changed
                return .Failure(TrelloError.InvalidJSONData)
            }
            return .Success(finalCards)
        }
        catch let error {
            return .Failure(error)
        }
    }
    
    static func cardFromJSONData(data: NSData) -> CardResult {
        do {
            let jsonObject: AnyObject
                = try NSJSONSerialization.JSONObjectWithData(data, options: [])
            
            guard let
                singlecard = jsonObject as? [String:AnyObject] else {
                    
                    // The JSON structure doesn't match our expectations
                    return .Failure(TrelloError.InvalidJSONData)
            }
            
            if let card = cardFromJSONObject(singlecard){
                // We weren't able to parse any of the cards
                // Maybe the JSON format for cards has changed
                return .Success(card)
            }
            
            return .Failure(TrelloError.InvalidJSONData)
        }
        catch let error {
            return .Failure(error)
        }
    }
    
    private static func cardFromJSONObject(json: [String : AnyObject]) -> Card? {
        guard let
            id = json["id"] as? String,
            name = json["name"] as? String,
            desc = json["desc"] as? String else {
                
                // Don't have enough information to construct a Card
                return nil
        }
        
        return Card(id: id, name: name, desc: desc)
    }
}