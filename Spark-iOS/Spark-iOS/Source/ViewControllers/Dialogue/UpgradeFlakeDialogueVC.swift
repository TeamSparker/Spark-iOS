//
//  UpgradeFlakeDialogueVC.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/10/08.
//

import UIKit

class UpgradeFlakeDialogueVC: UIViewController {

    // MARK: - Properties
    
    private let sparkFlakes: [SparkFlake] = [
        SparkFlake(leftDay: 65),
        SparkFlake(leftDay: 62),
        SparkFlake(leftDay: 58),
        SparkFlake(leftDay: 32),
        SparkFlake(leftDay: 6),
        SparkFlake(leftDay: 0)
    ]
    private var sparkUpgradeFlakes: [UpgradeFlake] = []
    private var impactFeedbackGenerator: UIImpactFeedbackGenerator?
    
    public var leftDay: Int?
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var levelTitleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var leftGradientView: UIView!
    @IBOutlet weak var rightGradientView: UIView!
    
    private let collectionViewFlowlayout = UICollectionViewFlowLayout()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        setSparkFlakes()
        setUI()
        addTargets()
        setLayout()
        setDelegate()
        setCollectionView()
        setImpactFeedbackGenerator()
    }
}

// MARK: - Extensions

extension UpgradeFlakeDialogueVC {
    private func setUI() {
        view.backgroundColor = .sparkBlack.withAlphaComponent(0.8)
        
        collectionView.backgroundColor = .clear
        
        backgroundView.backgroundColor = .sparkWhite
        
        levelTitleLabel.textColor = .sparkPinkred
        levelTitleLabel.font = .enMediumItatlicFont(ofSize: 24)
        
        subtitleLabel.tintColor = .sparkDeepGray
        subtitleLabel.font = .p1TitleLight
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 2
        
        checkButton.setTitle("확인했어요", for: .normal)
        checkButton.setTitleColor(.sparkWhite, for: .normal)
        checkButton.backgroundColor = .sparkBlack
        checkButton.titleLabel?.font = .btn1Default
        
        levelTitleLabel.text = sparkUpgradeFlakes[0].levelText
        subtitleLabel.text = sparkUpgradeFlakes[0].upgradeText
        
        leftGradientView.backgroundColor = .clear
        rightGradientView.backgroundColor = .clear
        
        leftGradientView.isUserInteractionEnabled = false
        rightGradientView.isUserInteractionEnabled = false
    }
    }
    
    private func addTargets() {
        checkButton.addTarget(self, action: #selector(touchCheckButton), for: .touchUpInside)
    }
    
    private func setDelegate() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func setCollectionView() {
        collectionView.register(UpgradeFlakeCVC.self, forCellWithReuseIdentifier: Const.Cell.Identifier.upgradeFlakeCVC)
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        
        let collectionViewLayout = UpgradeFlakeCarouselLayout()
        collectionViewLayout.leftDay = self.leftDay
        
        collectionView.collectionViewLayout = collectionViewLayout
    }
    
    private func setSparkFlakes() {
        sparkFlakes.forEach { sparkFlake in
            sparkUpgradeFlakes.append(sparkFlake.upgrade(leftDay ?? -1))
        }
    }
    
    private func setImpactFeedbackGenerator() {
        impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
        impactFeedbackGenerator?.prepare()
    }
    
    // MARK: - @objc Methods
    
    @objc
    private func touchCheckButton() {
        dismiss(animated: true)
    }
}

// MARK: - UICollectionViewDelegate

extension UpgradeFlakeDialogueVC: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetX: CGFloat = scrollView.contentOffset.x
        let index: Int = Int(round(contentOffsetX / (120 + scrollView.frame.width / 10)))
        
        if sparkUpgradeFlakes.count > index && index >= 0 {
            if levelTitleLabel.text != sparkUpgradeFlakes[index].levelText {
                impactFeedbackGenerator?.impactOccurred()
            }
            levelTitleLabel.text = sparkUpgradeFlakes[index].levelText
            subtitleLabel.text = sparkUpgradeFlakes[index].upgradeText
        }
    }
}

// MARK: - UICollectionViewDataSource

extension UpgradeFlakeDialogueVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sparkUpgradeFlakes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Const.Cell.Identifier.upgradeFlakeCVC, for: indexPath) as? UpgradeFlakeCVC else { return UICollectionViewCell() }
        
        cell.initCell(sparkUpgradeFlakes[indexPath.item].flakeImage)
        
        return cell
    }
}
