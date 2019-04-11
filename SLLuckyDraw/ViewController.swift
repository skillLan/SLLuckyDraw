//
//  ViewController.swift
//  SLLuckyDraw
//
//  Created by skill on 2019/4/1.
//  Copyright © 2019 skillLan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    /// 奖品内容
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var borderImageView: UIImageView!
    
    var titls = ["谢谢参与", "电影票", "小台灯", "现金1元", "流量1G", "充值卡50元"]
    var icons = ["ic_Smilingface", "ic_orange", "ic_orange", "ic_orange", "ic_orange", "ic_orange"]
    /// 内容
    var contentDatas = [SLContentModel]()
    var luckdrawView: SLLuckdrawView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for index in 0..<6 {
            let data = SLContentModel()
            data.color = UIColor.randomColor
            data.title = titls[index]
            data.icon = icons[index]
            self.contentDatas.append(data)
        }
        let luckdrawView = SLLuckdrawView.viewForConfirm()
        luckdrawView.frame = view.bounds
        luckdrawView.createUI(datas: contentDatas)
        self.view.addSubview(luckdrawView)
        
    }
}

extension UIColor {
    /// 返回随机颜色
    class var randomColor: UIColor {
        get {
            let red = CGFloat(arc4random()%256)/255.0
            let green = CGFloat(arc4random()%256)/255.0
            let blue = CGFloat(arc4random()%256)/255.0
            return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
    }
}
 extension Int {
    /*这是一个内置函数
     lower : 内置为 0，可根据自己要获取的随机数进行修改。
     upper : 内置为 UInt32.max 的最大值，这里防止转化越界，造成的崩溃。
     返回的结果： [lower,upper) 之间的半开半闭区间的数。
     */
    public static func randomIntNumber(lower: Int = 0,upper: Int = Int(UInt32.max)) -> Int {
        return lower + Int(arc4random_uniform(UInt32(upper - lower)))
    }
    /**
     生成某个区间的随机数
     */
    public static func randomIntNumber(range: Range<Int>) -> Int {
        return randomIntNumber(lower: range.lowerBound, upper: range.upperBound)
    }
}


