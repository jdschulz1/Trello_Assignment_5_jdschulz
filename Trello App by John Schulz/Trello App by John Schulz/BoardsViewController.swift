//
//  BoardsViewController.swift
//  Trello App by John Schulz
//
//  Created by admin on 11/13/16.
//  Copyright © 2016 edu.oc.eagles. All rights reserved.
//

import UIKit

class BoardsViewController: UIViewController {
    
    @IBOutlet var boardView: UICollectionView!
    
    let boardDataSource = BoardDataSource()
    
    let session: NSURLSession = {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        return NSURLSession(configuration: config)
    }()
    
    func getBoards(completion completion: (BoardResult) -> Void) {
        let url = TrelloAPI.allBoardsURL()
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
                            print("Error fetching Trello Boards: \(requestError)")
                        }
                        else {
                            print("Unexpected error with the request")
                        }
            let result = processGetBoardsRequest(data: data, error: error)
            completion(result)
        }
        task.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        boardView.dataSource = boardDataSource
        
        getBoards(){
            (boardsResult) -> Void in
            
            NSOperationQueue.mainQueue().addOperationWithBlock() {
                switch boardsResult {
                case let .Success(boards):
                    print("Successfully found \(boards.count) boards.")
                    self.boardDataSource.boards = boards
                case let .Failure(error):
                    self.boardDataSource.boards.removeAll()
                    print("Error fetching boards: \(error)")
                }
                self.boardView.reloadSections(NSIndexSet(index: 0))
            }
        }
        
//        getLists(self.boardDataSource.boards.){
//            (listsResult) -> Void in
//            
//            NSOperationQueue.mainQueue().addOperationWithBlock() {
//                switch listsResult {
//                case let .Success(lists):
//                    print("Successfully found \(lists.count) lists.")
//                    self.listDataSource.lists = lists
//                case let .Failure(error):
//                    self.listDataSource.lists.removeAll()
//                    print("Error fetching lists: \(error)")
//                }
//                self.listView.reloadSections(NSIndexSet(index: 0))
//            }
//        }
    }
}