//
//  ItemCell.swift
//  DreamLister
//
//  Created by Andy Vainauskas on 1/11/18.
//  Copyright © 2018 Andy Vainauskas. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
    
    @IBOutlet weak var thumb: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var details: UILabel!
    
    func configureCell(item: Item) {
        title.text = item.title
        let formattedPrice = String(format: "%.2f", item.price)
        price.text = "$" + formattedPrice
        details.text = item.details
        thumb.image = item.toImage?.image as? UIImage
    }
}
