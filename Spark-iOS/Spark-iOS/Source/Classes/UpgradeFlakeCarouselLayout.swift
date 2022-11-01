//
//  UpgradeFlakeCarouselLayout.swift
//  Spark-iOS
//
//  Created by kimhyungyu on 2022/10/11.
//

import UIKit

class UpgradeFlakeCarouselLayout: UICollectionViewFlowLayout {
    
    public var sideItemScale: CGFloat = 80 / 120
    public var spacing: CGFloat = 30
    public var leftDay: Int?
    
    private var isSetup: Bool = false
    
    private let flakeSize: CGFloat = 120
    private let itemPadding: CGFloat = 53
    
    override public func prepare() {
        super.prepare()
        if isSetup == false {
            setupLayout()
            isSetup = true
        }
    }
    
    private func setupLayout() {
        guard let collectionView = self.collectionView else {return}
        let collectionViewSize = collectionView.bounds.size
        
        self.itemSize = CGSize(width: flakeSize, height: itemPadding + flakeSize + itemPadding)
        
        let insets: CGFloat = (collectionViewSize.width - flakeSize) / 2
        self.sectionInset = UIEdgeInsets(top: 0, left: insets, bottom: collectionViewSize.height - (itemPadding + flakeSize + itemPadding), right: insets)
        
        self.minimumLineSpacing = collectionViewSize.width / 10
        self.scrollDirection = .horizontal
        self.collectionView?.isPagingEnabled = false
        
        let index: CGFloat
        guard let leftDay else { return }

        if 65 >= leftDay && leftDay > 62 {
            index = 0
        } else if 62 >= leftDay && leftDay > 58 {
            index = 1
        } else if 58 >= leftDay && leftDay > 32 {
            index = 2
        } else if 32 >= leftDay && leftDay > 6 {
            index = 3
        } else if 6 >= leftDay && leftDay > 0 {
            index = 4
        } else {
            index = 5
        }
        
        let contentOffset: CGPoint = CGPoint(x: index * (120 + collectionViewSize.width / 10), y: collectionView.frame.minY)
        
        DispatchQueue.main.async {
            self.collectionView?.setContentOffset(contentOffset, animated: false)
        }
    }
    
    public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let superAttributes = super.layoutAttributesForElements(in: rect),
            let attributes = NSArray(array: superAttributes, copyItems: true) as? [UICollectionViewLayoutAttributes] else { return nil }
        
        return attributes.map { self.transformLayoutAttributes(attributes: $0) }
    }
    
    private func transformLayoutAttributes(attributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        guard let collectionView = self.collectionView else { return attributes }
        let collectionCenter = collectionView.frame.size.width / 2
        let contentOffset = collectionView.contentOffset.x
        let center = attributes.center.x - contentOffset
        
        let maxDistance = self.itemSize.width + self.minimumLineSpacing
        let distance = min(abs(collectionCenter - center), maxDistance)
        let ratio = (maxDistance - distance) / maxDistance
        let scale = ratio * (1 - sideItemScale) + sideItemScale
        let transform = CATransform3DScale(CATransform3DIdentity, scale, scale, 1)
        attributes.transform3D = transform
        
        return attributes
    }
    
    // MARK: paging
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
            guard let collectionView = self.collectionView else {
                let latestOffset = super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
                return latestOffset
            }
        
        let targetRect = CGRect(x: proposedContentOffset.x, y: 0, width: collectionView.frame.width, height: collectionView.frame.height)
        let horizontalCenter = proposedContentOffset.x + collectionView.frame.width / 2
        guard let rectAttributes = super.layoutAttributesForElements(in: targetRect) else { return .zero }
        var offsetAdjustment = CGFloat.greatestFiniteMagnitude
        
        for layoutAttributes in rectAttributes {
            let itemHorizontalCenter = layoutAttributes.center.x
                if (itemHorizontalCenter - horizontalCenter).magnitude < offsetAdjustment.magnitude {
                    offsetAdjustment = itemHorizontalCenter - horizontalCenter
                }
            }
        
            return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
        }
}
