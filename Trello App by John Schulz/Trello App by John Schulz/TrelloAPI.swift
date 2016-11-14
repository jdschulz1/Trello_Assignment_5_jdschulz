//
//  TrelloAPI.swift
//  Trello App by John Schulz
//
//  Created by admin on 11/13/16.
//  Copyright © 2016 edu.oc.eagles. All rights reserved.
//

import Foundation

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
}