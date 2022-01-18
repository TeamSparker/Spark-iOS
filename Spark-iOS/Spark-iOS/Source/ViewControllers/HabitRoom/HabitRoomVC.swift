//
//  HabitRoomVC.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/01/19.
//

import UIKit

class HabitRoomVC: UIViewController {
    
    // MARK: - Properties

    var roomID: Int?
    var leftDay: Int = 0
    var life: Int = 2
    var list: [String] = []
    
    // MARK: - @IBOutlet Properties
    
    @IBOutlet weak var flakeImageView: UIImageView!
    @IBOutlet weak var habitTitleLabel: UILabel!
    @IBOutlet weak var ddayTitleLabel: UILabel!
    @IBOutlet weak var progessView: UIProgressView!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var firstLifeImage: UIImageView!
    @IBOutlet weak var secondLifeImage: UIImageView!
    @IBOutlet weak var thirdLifeImage: UIImageView!
    @IBOutlet weak var mainCollectionView: UICollectionView!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setDelegate()
        registerXib()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // TODO: - 서버통신
        setUIByData()
    }
}

// MARK: - Methods

extension HabitRoomVC {
    private func setUI() {
        habitTitleLabel.font = .h3Subtitle
        habitTitleLabel.textColor = .sparkWhite
        
        flakeImageView.contentMode = .scaleToFill
        
        ddayTitleLabel.font = .h1BigtitleEng
        ddayTitleLabel.textColor = .sparkWhite
        
        progessView.trackTintColor = .sparkDeepGray
        
        startDateLabel.font = .captionEng
        startDateLabel.textColor = .sparkWhite
        
        endDateLabel.font = .captionEng
        endDateLabel.textColor = .sparkWhite
        
        bgView.layer.borderColor = UIColor.sparkDarkGray.cgColor
        bgView.layer.borderWidth = 1
        bgView.layer.cornerRadius = 2
        
        timeLabel.font = .p2Subtitle
        goalLabel.font = .p2Subtitle
        
        
    }
    
    // TODO: - 서버통신 이후 세팅
    
    private func setUIByData() {
        habitTitleLabel.text = "예시"

        if leftDay == 0 {
            ddayTitleLabel.text = "D-day"
        } else {
            ddayTitleLabel.text = "D-\(leftDay)"
        }
        
        let sparkFlake = SparkFlake(leftDay: leftDay)
        flakeImageView.image = sparkFlake.sparkFlakeHabitBackground()
        progessView.progressTintColor = sparkFlake.sparkFlakeColor()
        // 맞나..?
        progessView.setProgress(Float(1), animated: false)
        
        startDateLabel.text = "2021.12.23"
        endDateLabel.text = "2022.02.26"
        
        timeLabel.text = "잠자기 전에"
        goalLabel.text = "일단 책부터 펴고 보자!"
        
        // 방 생명 이미지 구현
        let lifeImgaeList = [firstLifeImage, secondLifeImage, thirdLifeImage]
        
        if life >= 3 {
            lifeImgaeList.forEach { $0?.image = UIImage(named: "icRoomlifeFullWhite")}
        } else if life == 0 {
            lifeImgaeList.forEach { $0?.image = UIImage(named: "icRoomlifeEmpty")}
        } else {
            for index in 0..<life {
                lifeImgaeList[index]?.image = UIImage(named: "icRoomlifeFullWhite")
            }
            for index in life...2 {
                lifeImgaeList[index]?.image = UIImage(named: "icRoomlifeEmpty")
            }
        }
    }
    
    private func setDelegate() {
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
    }
    
    private func registerXib() {
        mainCollectionView.register(UINib(nibName: Const.Xib.NibName.habitRoomMemeberCVC, bundle: nil), forCellWithReuseIdentifier: Const.Xib.NibName.habitRoomMemeberCVC)
    }
}

// MARK: - UICollectionViewDelegate

extension HabitRoomVC: UICollectionViewDelegate {
}

// MARK: - UICollectionViewDataSource

extension HabitRoomVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Const.Xib.NibName.habitRoomMemeberCVC, for: indexPath) as? HabitRoomMemberCVC else { return UICollectionViewCell() }
//        cell.initCell()
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension HabitRoomVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 13, left: 0, bottom: 13, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.frame.width
        let cellHeight = cellWidth * (128 / 375)
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
