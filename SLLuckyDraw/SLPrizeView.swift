//
//  SLPrizeView.swift
//  SLLuckyDraw
//
//  Created by skill on 2019/4/10.
//  Copyright © 2019 skillLan. All rights reserved.
//
//  奖品UI

import UIKit

class SLPrizeView: UIView {

    @IBOutlet weak var prizeTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layoutIfNeeded()
        prizeTitleLabel.transform = CGAffineTransform(rotationAngle: CGFloat(.pi / 2.0))
    }
}

extension SLPrizeView {
    class func prizeView() -> SLPrizeView {
        let item = Bundle.main.loadNibNamed("SLPrizeView", owner: nil, options: nil)?.first as! SLPrizeView
        return item
    }
}
