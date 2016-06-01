//
//  ButtonTableViewCell.swift
//  BookClub
//
//  Created by Michael Mecham on 5/26/16.
//  Copyright © 2016 MichaelMecham. All rights reserved.
//

import UIKit

class ButtonTableViewCell: UITableViewCell {
    
    @IBOutlet weak var primaryLabel: UILabel!
    @IBOutlet weak var secondaryLabel: UILabel!
    @IBOutlet weak var button: UIButton!

    weak var delegate: BookTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellDesign()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateWithBook(book: Book) {
        primaryLabel.text = book.title
        secondaryLabel.text = book.author
        bookReadValueChanged(book.didRead.boolValue)
    }
    
    func bookReadValueChanged(value: Bool) {
        if value == true {
            button.imageView?.image = UIImage(named: "ClosedBook_Icon")
        } else {
            button.imageView?.image = UIImage(named: "OpenBook_Icon")
        }
    }
    
    // MARK: - Action Buttons
    
    @IBAction func buttonTapped(sender: AnyObject) {
        delegate?.buttonCellButtonTapped(self)
        
    }

}

extension ButtonTableViewCell {
    func cellDesign() {
        self.backgroundColor = UIColor.clearColor()
        self.primaryLabel.textColor = UIColor.whiteColor()
        self.secondaryLabel.textColor = UIColor.whiteColor()
        
    }
}

protocol BookTableViewCellDelegate: class {
    func buttonCellButtonTapped(cell: ButtonTableViewCell)
}
