//
//  SLChartVew.swift
//  SLLuckyDraw
//
//  Created by skill on 2019/4/2.
//  Copyright © 2019 skillLan. All rights reserved.
//

import UIKit

struct ChartData {
    let percent: Double
    let color: UIColor
    let text: String
    let lineColor: UIColor
}

class SLChartVew: UIView {
    /// 记录上一个值
    /// 小于7%
    let limit: Double = 0.07
    fileprivate var radius: CGFloat = 100
    fileprivate static let fontSize = 10
    fileprivate var dataAry: [ChartData] = []
    fileprivate lazy var textAttr = {
        [NSAttributedString.Key.foregroundColor: UIColor.red, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: CGFloat(SLChartVew.fontSize))]
    }()
    var statusBool:Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
//        radius = 190/3
    }
    
    convenience init(frame: CGRect, dataAry: [ChartData]) {
        self.init(frame: frame)
        self.dataAry = dataAry
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        for index in 0 ..< dataAry.count {
            if  dataAry[index].percent != 0 {
                statusBool = true
                break;
            }
            if dataAry.count - 1 == index {
                if statusBool == false {
                    setupPieChatrs(color: UIColor(red: 242, green: 242, blue: 242, alpha: 1))
                    return;
                }
            }
        }
        
        let angleStart: Double = -0.45
        var angle = Double.pi * angleStart
        for data in dataAry {
            drawPie(color: data.color, startAngle: angle, percent: data.percent)
            angle += 2 * Double.pi * data.percent
        }
        angle = Double.pi * angleStart
        for (index,data) in dataAry.enumerated(){
            let pre = index==0 ? dataAry.last : dataAry[index-1]
            let next = index==dataAry.count-1 ? dataAry.first : dataAry[index+1]
            drawText(angle, percent: data.percent, text: data.text, color: data.color, lineColor: data.lineColor, pre: pre?.percent ?? 0, next: next?.percent ?? 0)
            angle += 2 * Double.pi * data.percent
        }
    }
    
    fileprivate func drawPie(color: UIColor, startAngle: Double, percent: Double) {
        if percent == 0 {
            return
        }
        let bezierPathMergin = UIBezierPath()
        let center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        bezierPathMergin.lineWidth = 1
        let endAngle = CGFloat(startAngle + 2 * Double.pi * percent)
        bezierPathMergin.addArc(withCenter: center, radius: radius, startAngle: CGFloat(startAngle), endAngle: endAngle, clockwise: true)
        bezierPathMergin.addLine(to: center)
        bezierPathMergin.close()
        bezierPathMergin.fill()
        
        let shapeLayerMergin:CAShapeLayer = CAShapeLayer()
        shapeLayerMergin.lineWidth = 1
        
        if percent == 1 {
            shapeLayerMergin.strokeColor = UIColor.clear.cgColor
        }else{
            shapeLayerMergin.strokeColor = UIColor.white.cgColor
        }
        shapeLayerMergin.fillColor = color.cgColor
        shapeLayerMergin.path = bezierPathMergin.cgPath;
        self.layer.addSublayer(shapeLayerMergin)
    }
    
    fileprivate func drawText(_ startAngle: Double, percent: Double, text: String, color: UIColor, lineColor:UIColor, pre: Double, next: Double) {
        if percent == 0 {
            return
        }
        let center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        let angle = -(startAngle + (Double.pi * percent))
        
        let x = center.x + radius * 0.7 * CGFloat(cos(angle))
        let y = center.y - radius * 0.7 * CGFloat(sin(angle))
        //第一个点，在圆内
        let point1 = CGPoint(x: x, y: y)
        
        var isStraight = false //是否直线
        if dataAry.count > 3 {
            //三个相邻小区间，那么当前的线肯定是直线
            isStraight = pre<limit && percent<limit && next<limit
        }
        
        //象限判断
        var right = x >= center.x
        var bottom = y >= center.y
        //第二个点，圆边上一点
        var point2 = CGPoint.zero
        if isStraight {
            //直线第二个点
            point2.x = center.x + radius * 1.05 * CGFloat(cos(angle))
            point2.y = center.y - radius * 1.05 * CGFloat(sin(angle))
        } else {
            var isLonger = false
            //相邻小区间，要么劈叉，要么比旁边更长
            switch (right, bottom) {
            case (true, false), (false, true): //一三象限
                if pre<limit {
                    if fabs(Double(y-center.y)) < 10 {
                        //是否靠y轴较近，靠近就劈叉
                        bottom = !bottom
                    }
                } else if next<limit {
                    if fabs(Double(x-center.x)) < 10 {
                        //是否靠x轴较近，靠近就劈叉
                        right = !right
                    } else if percent<limit {
                        //否则要比旁边的更长
                        isLonger = true
                    }
                }
            case (true, true), (false, false):  //二四象限
                if pre<limit {
                    if fabs(Double(x-center.x)) < 10 {
                        right = !right
                    } else if percent<limit {
                        isLonger = true
                    }
                } else if next<limit {
                    if fabs(Double(y-center.y)) < 10 {
                        bottom = !bottom
                    }
                }
            }
            if isLonger { //更长一点的线
                point2.x = right ? x+10 : x-10
                point2.y = bottom ? y+37 : y-35
            } else { //正常的线
                point2.x = right ? x+15: x-15
                point2.y = bottom ? y+25 : y-20
            }
        }
        
        // 第三个点，一般平行于X轴
        let point3X = right ? point2.x+35 : point2.x-35
        let point3Y = point2.y
        let point3 = CGPoint(x: point3X, y: point3Y)
        
        // 文字
        var txtPoint = right ? point2 : point3
        if isStraight {
            txtPoint = point2
            txtPoint.x -= 12
            txtPoint.y -= bottom ? 0:12
        } else {
            txtPoint.x += right ? 10:0
            txtPoint.y -= 12
        }
        
        let str = NSString(string: text)
        str.draw(at: txtPoint, withAttributes:[NSAttributedString.Key.foregroundColor: lineColor, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: CGFloat(SLChartVew.fontSize))])
        
        let path = UIBezierPath()
        lineColor.setStroke()
        path.move(to: point1)
        path.addLine(to: point2)
        if !isStraight {
            path.addLine(to: point3)
        }
        let shapeLayerMergin:CAShapeLayer = CAShapeLayer()
        shapeLayerMergin.lineWidth = 1;
        shapeLayerMergin.strokeColor = lineColor.cgColor
        shapeLayerMergin.fillColor = UIColor.clear.cgColor
        shapeLayerMergin.path = path.cgPath;
        self.layer.addSublayer(shapeLayerMergin)
    }
    
    func setupPieChatrs(color:UIColor) {
        // 圆
        let center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        let bezierPathMergin:UIBezierPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: true)
        bezierPathMergin.addLine(to: center)
        bezierPathMergin.close()
        // 渲染
        let shapeLayerMergin:CAShapeLayer = CAShapeLayer()
        shapeLayerMergin.fillColor = color.cgColor
        shapeLayerMergin.path = bezierPathMergin.cgPath;
        self.layer.addSublayer(shapeLayerMergin)
    }
    
}
