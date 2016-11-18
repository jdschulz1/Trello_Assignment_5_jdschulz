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
