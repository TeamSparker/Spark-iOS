//
//  AuthUploadVC.swift
//  Spark-iOS
//
//  Created by Junho Lee on 2022/01/16.
//

import UIKit

class AuthUploadVC: UIViewController {

    @IBOutlet weak var uploadImageView: UIImageView!
    
    var uploadImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uploadImageView.image = uploadImage
    }
}
