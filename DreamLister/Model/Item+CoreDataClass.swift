//
//  Item+CoreDataClass.swift
//  DreamLister
//
//  Created by Andy Vainauskas on 1/10/18.
//  Copyright © 2018 Andy Vainauskas. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Item)
public class Item: NSManagedObject {
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        self.created = NSDate()
    }
    
}
