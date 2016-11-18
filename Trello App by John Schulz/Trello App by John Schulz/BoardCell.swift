//
//  Board.swift
//  Trello App by John Schulz
//
//  Created by admin on 11/13/16.
//  Copyright © 2016 edu.oc.eagles. All rights reserved.
//

import UIKit

class BoardCell: UICollectionViewCell {
    @IBOutlet var boardname : UILabel!
    @IBOutlet var boardlistView: UICollectionView!
    
    func updateBoard(name: String?) {
        if let bname = name {
            boardname.text = bname
        }
        else {
            boardname.text = ""
        }
    }
}

class BoardDataSource: NSObject, UICollectionViewDataSource {
    
    var boards = [Board] ()
    var lists = [List] ()
    var listDataSource = ListDataSource()
    
    func collectionView(collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return boards.count
    }
    
    func collectionView(collectionView: UICollectionView,
                        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let identifier = "UICollectionViewCell"
        let cell =
            collectionView.dequeueReusableCellWithReuseIdentifier(identifier,
                                                                  forIndexPath: indexPath) as! BoardCell
        
        let board = boards[indexPath.row]
        cell.updateBoard(board.name)
        
        
//        cell.boardlistView.dataSource = listDataSource
//        
//                getLists(boardid: board.id){
//                    (listsResult) -> Void in
//        
//                    NSOperationQueue.mainQueue().addOperationWithBlock() {
//                        switch listsResult {
//                        case let .Success(lists):
//                            print("Successfully found \(lists.count) lists.")
//                            self.listDataSource.lists = lists
//                        case let .Failure(error):
//                            self.listDataSource.lists.removeAll()
//                            print("Error fetching lists: \(error)")
//                        }
//                        cell.boardlistView.reloadSections(NSIndexSet(index: 0))
//                    }
//                }
        
        return cell
    }
}

class Board {
    let id: String
    let name: String
    let desc: String
    
    init(id: String, name: String, desc: String) {
        self.id = id
        self.name = name
        self.desc = desc
    }
}

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
