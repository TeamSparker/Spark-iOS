//
//  CarouselLayout.swift
//  Spark-iOS
//
//  Created by Junho Lee on 2022/01/13.
//

import UIKit

class CarouselLayout: UICollectionViewFlowLayout {
    
    public var sideItemScale: CGFloat = 0.5
    public var sideItemAlpha: CGFloat = 0.5
    public var spacing: CGFloat = 10

    public var isPagingEnabled: Bool = false
    
    private var isSetup: Bool = false
    
    // MARK: prepare는 사용자가 스크롤 시 매번 호출된다고 한다. setupLayout()은 초기에 한 번만 호출되도록 한 것이다.
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
        
        let xInset = (collectionViewSize.width - self.itemSize.width) / 2
        let yInset = (collectionViewSize.height - self.itemSize.height) / 2
        
        self.sectionInset = UIEdgeInsets(top: yInset, left: xInset, bottom: yInset, right: xInset)
        
        let itemWidth = self.itemSize.width
        
        let scaledItemOffset =  (itemWidth - itemWidth*self.sideItemScale) / 2
        self.minimumLineSpacing = spacing - scaledItemOffset

        self.scrollDirection = .horizontal
    }
    
    public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    /// 모든 셀과 뷰에 대한 속성을 UICollectionViewLayoutAttributes의 배열로 반환해준다고 한다.
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let superAttributes = super.layoutAttributesForElements(in: rect),
            let attributes = NSArray(array: superAttributes, copyItems: true) as? [UICollectionViewLayoutAttributes]
            else { return nil }
        
        /// transformLayoutAttributes() 함수를 이용해 기존 attributes 속성들을 원하는 대로 변환하고
        /// 이를 attributes에 다시 매핑하여 UICollectionViewLayoutAttributes로 반환한다
        return attributes.map({ self.transformLayoutAttributes(attributes: $0) })
    }
    
    private func transformLayoutAttributes(attributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        
        guard let collectionView = self.collectionView else {return attributes}
        
        let collectionCenter = collectionView.frame.size.width / 2
        let contentOffset = collectionView.contentOffset.x
        let center = attributes.center.x - contentOffset
        
        let maxDistance = self.itemSize.width + self.minimumLineSpacing
        let distance = min(abs(collectionCenter - center), maxDistance)
        
        let ratio = (maxDistance - distance)/maxDistance

        // 아래에 있는 1을 바꿔서 중심으로 올수록 흐려지거나, 작게 만들 수 있다.
        let alpha = ratio * (1 - self.sideItemAlpha) + self.sideItemAlpha
        let scale = ratio * (1 - self.sideItemScale) + self.sideItemScale
        
        attributes.alpha = alpha
        
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        let dist = attributes.frame.midX - visibleRect.midX
        var transform = CATransform3DScale(CATransform3DIdentity, scale, scale, 1)
        
        transform = CATransform3DTranslate(transform, 0, 0, -abs(dist/1000))
        attributes.transform3D = transform
        
        return attributes
    }
    
    // MARK: 페이징 가능하게 해주는 코드
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {

            guard let collectionView = self.collectionView else {
                let latestOffset = super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
                print(latestOffset)
                return latestOffset
            }
        
            let targetRect = CGRect(x: proposedContentOffset.x, y: 0, width: collectionView.frame.width, height: collectionView.frame.height)
        
            guard let rectAttributes = super.layoutAttributesForElements(in: targetRect) else { return .zero }
        
            var offsetAdjustment = CGFloat.greatestFiniteMagnitude
        
            let horizontalCenter = proposedContentOffset.x + collectionView.frame.width / 2

            for layoutAttributes in rectAttributes {
                let itemHorizontalCenter = layoutAttributes.center.x
                if (itemHorizontalCenter - horizontalCenter).magnitude < offsetAdjustment.magnitude {
                    offsetAdjustment = itemHorizontalCenter - horizontalCenter
                }
            }
        
            return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
        }
}
