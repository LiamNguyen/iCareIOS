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
    @IBOutlet weak var lbl_Status: UILabel!
    @IBOutlet weak var view_TableRow: UIView!
    
    @IBOutlet weak var lbl_Voucher_Title: UILabel!
    @IBOutlet weak var lbl_Location_Title: UILabel!
    @IBOutlet weak var lbl_StartDate_Title: UILabel!
    @IBOutlet weak var lbl_EndDate_Title: UILabel!
    @IBOutlet weak var lbl_Status_Title: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
