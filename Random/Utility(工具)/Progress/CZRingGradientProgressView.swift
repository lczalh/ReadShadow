//
//  CZRingGradientProgressView.swift
//  Random
//
//  Created by yu mingming on 2019/12/9.
//  Copyright © 2019 刘超正. All rights reserved.
//

import UIKit

class CZRingGradientProgressView: UIView {
    // 进度条宽度
    let lineWidth: CGFloat = 3
    
    //进度槽颜色
    let trackColor = UIColor(red: 238/255.0, green: 238/255.0, blue: 238/255.0, alpha: 0.5)
    
    //进度条颜色
    let progressColoar = UIColor.orange

    /// 头部圆点
    lazy var headerDotView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: lineWidth, height: lineWidth))
        let dotPath = UIBezierPath(ovalIn:
            CGRect(x: 0,y: 0, width: lineWidth, height: lineWidth)).cgPath
        let arc = CAShapeLayer()
        arc.lineWidth = 0
        arc.path = dotPath
        arc.strokeStart = 0
        arc.strokeEnd = 1
        arc.strokeColor = progressColoar.cgColor
        arc.fillColor = progressColoar.cgColor
        view.layer.addSublayer(arc)
        return view
    }()
    
    /// 尾部圆点
    lazy var footerDotView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: lineWidth, height: lineWidth))
        let dotPath = UIBezierPath(ovalIn:
            CGRect(x: 0,y: 0, width: lineWidth, height: lineWidth)).cgPath
        let arc = CAShapeLayer()
        arc.lineWidth = 0
        arc.path = dotPath
        arc.strokeStart = 0
        arc.strokeEnd = 1
        arc.strokeColor = progressColoar.cgColor
        arc.fillColor = progressColoar.cgColor
        view.layer.position = calcCircleCoordinateWithCenter(progressCenter, radius: radius, angle: 90)
        view.layer.addSublayer(arc)
        return view
    }()
     
    //进度条圆环中点
    var progressCenter:CGPoint {
        get{
            return CGPoint(x: bounds.midX, y: bounds.midY)
        }
    }
     
    //进度条圆环中点
    var radius:CGFloat{
        get{
            return bounds.size.width / 2 - lineWidth
        }
    }
     
    //当前进度
    var progress: Int = 0 {
        didSet {
            if progress > 100 {
                progress = 100
            }else if progress < 0 {
                progress = 0
            }
        }
    }
    
    /// 进度条路径（整个圆圈）
    lazy var bezierPath: UIBezierPath = {
        let path = UIBezierPath()
        path.addArc(withCenter: self.progressCenter,
                    radius: radius,
                    startAngle: angleToRadian(-90),
                    endAngle: angleToRadian(270),
                    clockwise: true)
        return path
    }()
    
    /// 进度槽
    lazy var trackLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.frame = self.bounds
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = trackColor.cgColor
        layer.lineWidth = lineWidth
        layer.path = bezierPath.cgPath
        return layer
    }()
    
    /// 进度条
    lazy var progressLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.frame = bounds
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = progressColoar.cgColor
        layer.lineWidth = lineWidth
        layer.path = bezierPath.cgPath
        layer.strokeStart = 0
        layer.strokeEnd = CGFloat(progress)/100.0
        return layer
    }()
     
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
     
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
     
    override func draw(_ rect: CGRect) {
        layer.addSublayer(trackLayer)
        layer.addSublayer(progressLayer)
        addSubview(footerDotView)
        addSubview(headerDotView)
        //设置圆点位置
        headerDotView.layer.position = calcCircleCoordinateWithCenter(progressCenter,
            radius: radius, angle: CGFloat(-progress) / 100 * 360 + 90)
    }
     
    //设置进度（可以设置是否播放动画）
    func setProgress(_ pro: Int,animated anim: Bool) {
        setProgress(pro, animated: anim, withDuration: 0.55)
    }
     
    //设置进度（可以设置是否播放动画，以及动画时间）
    func setProgress(_ pro: Int,animated anim: Bool, withDuration duration: Double) {
//        let oldProgress = progress
        progress = pro
         
        //进度条动画
        CATransaction.begin()
        CATransaction.setDisableActions(!anim)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name:
            CAMediaTimingFunctionName.easeInEaseOut))
        CATransaction.setAnimationDuration(duration)
        progressLayer.strokeEnd = CGFloat(progress)/100.0
        CATransaction.commit()
    }
     
    //将角度转为弧度
    fileprivate func angleToRadian(_ angle: Double)->CGFloat {
        return CGFloat(angle / Double(180.0) * .pi)
    }
     
    //计算圆弧上点的坐标
    func calcCircleCoordinateWithCenter(_ center:CGPoint, radius:CGFloat, angle:CGFloat)
        -> CGPoint {
            let x2 = radius * CGFloat(cosf(Float(angle) * .pi / Float(180)))
            let y2 = radius * CGFloat(sinf(Float(angle) * .pi / Float(180)))
            return CGPoint(x: center.x + x2, y: center.y - y2);
    }

}
