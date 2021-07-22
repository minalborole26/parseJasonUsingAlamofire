//
//  photosTableViewCell.swift
//  swiftAlamofirepractice
//
//  Created by minal borole on 20/07/21.
//

import UIKit

class photosTableViewCell: UITableViewCell {

    @IBOutlet weak var photoImgView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
