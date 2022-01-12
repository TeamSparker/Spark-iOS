//
//  DoingStorageCVC.swift
//  Spark-iOS
//
//  Created by Junho Lee on 2022/01/13.
//

import UIKit

class DoingStorageCVC: UICollectionViewCell {
    
    @IBOutlet weak var gradationUIView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUIView()
    }

    func setUIView() {
        gradationUIView.setGradient(color1: UIColor.clear, color2: UIColor.black)
    }
}

extension UIView{
    func setGradient(color1:UIColor,color2:UIColor){
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [color1.cgColor,color2.cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 1.0, y: 0.8)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.0)
        gradient.frame = bounds
        layer.addSublayer(gradient)
    }
}
