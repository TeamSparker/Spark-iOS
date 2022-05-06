//
//  LineAnimationView.swift
//  Spark-iOS
//
//  Created by Junho Lee on 2022/01/15.
//

import UIKit

class LineAnimationView: UIView {
    override func draw(_ rect: CGRect) {
        // 선 그리기
        let aPath = UIBezierPath()
        aPath.move(to: CGPoint(x: CGFloat(0), y: 0))
        aPath.addLine(to: CGPoint(x: CGFloat(16), y: 0))
        
        let shape = CAShapeLayer()
        shape.lineWidth = 2 // 라인 굵기는 2
        shape.path = aPath.cgPath // 해당 경로는 위 aPath을 사용
        shape.strokeColor = UIColor.sparkDarkPinkred.cgColor // 외부 경계선의 색상 지정
        shape.fillColor = UIColor.clear.cgColor // 내부 색은 비우고
        self.layer.addSublayer(shape) // 해당 레이어를 서브로 추가
        
        // 애니메이션 추가
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        // 그린 선의 어디서부터 시작할지
        animation.fromValue = 0
        // 애니메이션 그리는 시간
        animation.duration = 0.2
        // 그려진 레이어에 애니메이션을 추가
        shape.add(animation, forKey: "PinkLineAnimation")
    }
}
