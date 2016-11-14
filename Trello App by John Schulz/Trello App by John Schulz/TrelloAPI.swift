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

enum CardResult {
    case Success([Card])
    case Failure(ErrorType)
}

func processGetCardsRequest(data data: NSData?, error: NSError?) -> CardResult {
    guard let jsonData = data else {
        return .Failure(error!)
    }
    
    return TrelloAPI.cardsFromJSONData(jsonData)
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
            "fields": "name,desc",
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
                         parameters: [:])
    }
    
    static func allListsForBoard(boardid boardid: String) -> NSURL {
        return trelloURL(method: "boards/\(boardid)/lists",
                         parameters: [:])
    }
    
    static func allCardsForList(listid listid: String) -> NSURL {
        return trelloURL(method: "lists/\(listid)/cards",
                         parameters: [:])
    }
    
    static func createCard (cardid cardid: String, name: String, desc: String) -> NSURL {
        return trelloURL(method: "",
                         parameters: [:])
    }
    
    static func removeCard (boardid boardid: String, listid: String, cardid: String) -> NSURL {
        return trelloURL(method: "",
                         parameters: [:])
    }
    
    static func editCard (boardid boardid: String, listid: String, cardid: String, name: String, desc: String) -> NSURL {
        return trelloURL(method: "",
                         parameters: [:])
    }
    
    static func moveCard (boardid boardid: String, oldlistid: String, newlistid: String, cardid: String) -> NSURL {
        return trelloURL(method: "",
                         parameters: [:])
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
                jsonDictionary = jsonObject as? [NSObject:AnyObject],
                lists = jsonDictionary["lists"] as? [String:AnyObject],
                listsArray = lists["list"] as? [[String:AnyObject]] else {
                    
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
            name = json["name"] as? String,
            desc = json["desc"] as? String else {
                
                // Don't have enough information to construct a List
                return nil
        }
        
        return List(id: id, name: name, desc: desc)
    }
    
    static func cardsFromJSONData(data: NSData) -> CardResult {
        do {
            let jsonObject: AnyObject
                = try NSJSONSerialization.JSONObjectWithData(data, options: [])
            
            guard let
                jsonDictionary = jsonObject as? [NSObject:AnyObject],
                cards = jsonDictionary["cards"] as? [String:AnyObject],
                cardsArray = cards["card"] as? [[String:AnyObject]] else {
                    
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