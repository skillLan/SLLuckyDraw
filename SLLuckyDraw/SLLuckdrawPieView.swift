//
//  SLLuckdrawPieView.swift
//  SLLuckyDraw
//
//  Created by skill on 2019/4/2.
//  Copyright © 2019 skillLan. All rights reserved.
//

import UIKit

class SLLuckdrawPieView: UIView {
    
    var colors = [UIColor]()
    var statusBool:Bool = false
    fileprivate var radius: CGFloat = 100
    var chartDatas: [ChartData] = [] {
        didSet {
            setDrawPie()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.radius = self.frame.width / 2
    }
    
    convenience init(frame: CGRect, chartDatas: [ChartData]) {
        self.init(frame: frame)
//        self.frame = frame
        self.chartDatas = chartDatas
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.radius = self.frame.width / 2
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setDrawPie()
    }
    
    fileprivate func setDrawPie() {
        let angleStart: Double = .pi / Double(chartDatas.count)
        var angle = angleStart
        for data in chartDatas {
            drawPie(color: data.color, startAngle: angle, percent: data.percent)
            angle += 2 * Double.pi * data.percent
        }
        angle = angleStart
    }
    
    fileprivate func drawPie(color: UIColor, startAngle: Double, percent: Double) {
        if percent == 0 {
            return
        }
        let bezierPathMergin = UIBezierPath()
        let center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        bezierPathMergin.lineWidth = 0
        let endAngle = CGFloat(startAngle + 2 * Double.pi * percent)
        bezierPathMergin.addArc(withCenter: center, radius: radius, startAngle: CGFloat(startAngle), endAngle: endAngle, clockwise: true)
        bezierPathMergin.addLine(to: center)
        bezierPathMergin.close()
        bezierPathMergin.fill()
        
        let shapeLayerMergin:CAShapeLayer = CAShapeLayer()
        shapeLayerMergin.lineWidth = 0
        
        if percent == 1 {
            shapeLayerMergin.strokeColor = UIColor.clear.cgColor
        }else{
            shapeLayerMergin.strokeColor = UIColor.white.cgColor
        }
        shapeLayerMergin.fillColor = color.cgColor
        shapeLayerMergin.path = bezierPathMergin.cgPath;
        layer.insertSublayer(shapeLayerMergin, at: 0)
    }
}
