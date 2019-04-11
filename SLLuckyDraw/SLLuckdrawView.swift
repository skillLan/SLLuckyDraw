//
//  SLLuckdrawView.swift
//  SLLuckyDraw
//
//  Created by skill on 2019/4/2.
//  Copyright © 2019 skillLan. All rights reserved.
//
//  抽奖UI及交互

import UIKit

class SLLuckdrawView: UIView {

    /// 奖品内容
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var borderImageView: UIImageView!
    @IBOutlet weak var startRaffleButton: UIButton!
    @IBOutlet weak var resultLabel: UILabel!
    /// 内容
    var contentDatas = [SLContentModel]()
    var chartDatas = [ChartData]()

    var luckdrawPieView: SLLuckdrawPieView!
    var rNumber: Int = 0
    var isButtonEnabled: Bool = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    /// 自定义初始化方法
    class func viewForConfirm() -> SLLuckdrawView {
        let luckdrawView = Bundle.main.loadNibNamed("SLLuckdrawView", owner: nil, options: nil)?.first as! SLLuckdrawView
        return luckdrawView
    }
    
    /// 立即抽奖
    @IBAction func StartClick(_ sender: UIButton) {
        if isButtonEnabled {
            resultLabel.text = "表演中..."
            rNumber = resultNumber()
            self.routaion(index: self.rNumber, success: true)
            isButtonEnabled = false
        }
    }

    /// 图标及奖品
    func createUI(datas: [SLContentModel]) {
        self.contentDatas = datas
        for item in contentDatas {
            let shopChat = ChartData(percent: 1.0/Double(contentDatas.count), color: item.color, text: item.title, lineColor: .white)
            chartDatas.append(shopChat)
        }
        let width = UIScreen.main.bounds.width - 116
        let luckdrawPieView = SLLuckdrawPieView(frame: CGRect(x: 0, y: 0, width: width, height: width), chartDatas: chartDatas)
        luckdrawPieView.layer.cornerRadius = width / 2
        luckdrawPieView.layer.masksToBounds = true
        self.contentView.addSubview(luckdrawPieView)
        self.luckdrawPieView = luckdrawPieView
        
        let contentRadius = width / 2
        let PROPORTION = 0.8
        let w = CGFloat((1 - PROPORTION)) * contentRadius
        let centerR = contentRadius * 0.8 - w / 2
        var angel: CGFloat = 0
        
        // 添加奖品
        for i in 0..<contentDatas.count {
            angel = -CGFloat(.pi / (Double(contentDatas.count) / 2) * Double(i))
            let prizeView = SLPrizeView.prizeView()
            prizeView.frame = CGRect(x:0 , y: 0, width: w, height: w)
            prizeView.backgroundColor = .clear
            prizeView.center = CGPoint(x: contentRadius + cos(angel) * centerR, y:  sin(angel) * centerR + contentRadius)
            prizeView.transform = CGAffineTransform(rotationAngle: angel)
            prizeView.prizeTitleLabel.text = contentDatas[i].title
            prizeView.prizeTitleLabel.center = prizeView.center
            self.luckdrawPieView!.addSubview(prizeView)
        }
        self.startRaffleButton.setImage(UIImage(named: "btn_Immediatelydraw"), for: .normal)
    }

    /// 抽奖动画
    ///
    /// - Parameters:
    ///   - index: 中奖目标
    ///   - success: 是否成功抽奖
    func routaion(index: Int = 0, success: Bool = false) {
        var ange: Double = -0.1
        let numb = 360 / Double(self.contentDatas.count)
        if success {
            ange = 720 * 4 + numb * Double(index) - 90
        }
        let rotation = CGFloat(ange * Double.pi / 180)
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.duration = ange > 0 ? 3 : 200
        rotationAnimation.toValue = ange > 0 ? rotation : HUGE
        rotationAnimation.isCumulative = true
        rotationAnimation.delegate = self
        rotationAnimation.fillMode = CAMediaTimingFillMode.forwards
        rotationAnimation.isRemovedOnCompletion = false
        rotationAnimation.timingFunction =  CAMediaTimingFunction(name: ange > 0 ? CAMediaTimingFunctionName.easeOut : CAMediaTimingFunctionName.easeIn)
        self.luckdrawPieView.layer.add(rotationAnimation, forKey: "rotationAnimation")
    }
    
    /// 设定抽奖结果
    func resultNumber()->Int {
        let number = Int.randomIntNumber(range: Range(0...contentDatas.count-1))
        return number
    }
}

extension SLLuckdrawView: CAAnimationDelegate {

    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        isButtonEnabled = true
        resultLabel.textColor = self.rNumber == 0 ? UIColor.gray : UIColor.red
        resultLabel.text = self.rNumber == 0 ? "白表演了，没有奖励。" : "表演成功获得\(self.contentDatas[self.rNumber].title)。"
    }
}

class SLContentModel: NSObject {
    var icon = ""
    var title = ""
    var color: UIColor = .gray
}
