//
//  ShimmerTableViewCell.swift
//  GitClient
//
//  Created by Mozhgan on 9/26/21.
//

import UIKit

class ShimmerTableViewCell: UITableViewCell {

    @IBOutlet weak var shimmerView : ShimmerView?
    override func awakeFromNib() {
        super.awakeFromNib()
        shimmerView?.startAnimating()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
