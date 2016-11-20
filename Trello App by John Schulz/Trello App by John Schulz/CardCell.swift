//
//  Card.swift
//  Trello App by John Schulz
//
//  Created by admin on 11/13/16.
//  Copyright © 2016 edu.oc.eagles. All rights reserved.
//

import UIKit

class CardCell: UICollectionViewCell {
    @IBOutlet var cardname: UILabel!
    @IBOutlet var carddesc: UILabel!
    @IBOutlet var addcard: UIBarButtonItem!
    @IBOutlet var editcard: UIBarButtonItem!
    
    func updateCard(name: String?, desc: String?) {
        if let cname = name{
            cardname.text = "name: " + cname
        }
        else {
            cardname.text = ""
        }
        
        if let cdesc = desc{
            carddesc.text = "description: " + cdesc
        }
        else {
            carddesc.text = ""
        }
    }
}

class CardDataSource: NSObject, UICollectionViewDataSource {
    
    var cards = [Card] ()
    
    func collectionView(collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    func collectionView(collectionView: UICollectionView,
                        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let identifier = "UICollectionViewCell"
        let cell =
            collectionView.dequeueReusableCellWithReuseIdentifier(identifier,
                                                                  forIndexPath: indexPath) as! CardCell
        
        let card = cards[indexPath.row]
        cell.updateCard(card.name, desc: card.desc)
        
        return cell
    }
}

class Card {
    let id: String
    let name: String
    let desc: String
    
    init(id: String, name: String, desc: String) {
        self.id = id
        self.name = name
        self.desc = desc
    }
}