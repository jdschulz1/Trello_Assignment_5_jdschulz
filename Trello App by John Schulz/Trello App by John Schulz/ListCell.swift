//
//  List.swift
//  Trello App by John Schulz
//
//  Created by admin on 11/13/16.
//  Copyright © 2016 edu.oc.eagles. All rights reserved.
//

import UIKit

class ListCell: UICollectionViewCell {
    
    @IBOutlet var cardView: UICollectionView!
    @IBOutlet var listname : UILabel!
    
    func updateList(name: String?, desc: String?, id: String?) {
        if let lname = name {
            listname.text = lname
        }
        else {
            listname.text = ""
        }
    }
}

class ListDataSource: NSObject, UICollectionViewDataSource {
    
    var lists = [List] ()
    
    func collectionView(collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return lists.count
    }
    
    func collectionView(collectionView: UICollectionView,
                        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let identifier = "UICollectionViewCell"
        let cell =
            collectionView.dequeueReusableCellWithReuseIdentifier(identifier,
                                                                  forIndexPath: indexPath) as! ListCell
        
        let list = lists[indexPath.row]
        cell.updateList(list.name, desc: list.desc, id: list.id)
        
        return cell
    }
}

class List {
    let id: String
    let name: String
    let desc: String
    
    init(id: String, name: String, desc: String) {
        self.id = id
        self.name = name
        self.desc = desc
    }
}