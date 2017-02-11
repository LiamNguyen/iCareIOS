//
//  CartBookingInfoTableViewCell.swift
//  DrQMuller
//
//  Created by Cao Do Nguyen on /11/02/2017.
//  Copyright © 2017 LetsDev. All rights reserved.
//

import UIKit

class CartBookingInfoTableViewCell: UITableViewCell {
    @IBOutlet weak var lbl_Voucher: UILabel!
    @IBOutlet weak var lbl_Location: UILabel!
    @IBOutlet weak var lbl_StartDate: UILabel!
    @IBOutlet weak var lbl_EndDate: UILabel!
    @IBOutlet weak var view_TableRow: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        view_TableRow.layer.shadowColor = UIColor.black.cgColor
        view_TableRow.layer.shadowOffset = CGSize.zero
        view_TableRow.layer.shadowOpacity = 0.7
        view_TableRow.layer.shadowRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
