//
//  SparkActionSheet.swift
//  Spark-iOS
//
//  Created by Junho Lee on 2022/02/25.
//

import Foundation
import UIKit

import SnapKit

// MARK: - SparkSection class

public class SparkSection {
    public var actions = [SparkAction]()
    
    public init() {}
}

// MARK: SparkAction Class

public class SparkAction {
    public var data: String
    public var buttonType: sparkActionTitleType
    public var handler: (() -> Void)?
}

class SparkActionMainStackView: UIStackView {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.axis = .vertical
        self.spacing = 0
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func reset() {
        self.arrangedSubviews.forEach({ $0.removeFromSuperview() })
    }
    
}

class SparkActionSheet: UIViewController {
    
    private var _sections = [SparkSection]()
    
    private lazy var backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return backgroundView
    }()
    
    private lazy var sparkActionMainStackView = SparkActionMainStackView()
    
    private lazy var tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureDidRecognize(_:)))
    
    override init(nibName nibNameOrNil: String?,
                  bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUI()
    }
    // addAction으로 액션을 추가해준다.
    public func addAction(_ action: SparkAction) {
        if let section = _sections.last {
            section.actions.append(action)
        } else {
            let section = SparkSection()
            addSection(section)
            section.actions.append(action)
        }
    }
    
    // section은 action 사이에 공간을 만들어 준다.
    public func addSection(_ section: SparkSection = SparkSection()){
        _sections.append(section)
    }
    
    @objc
    private func tapGestureDidRecognize(_ gesture: UITapGestureRecognizer) {
        self.dismiss(animated: true)
    }
}

// MARK: - SparkActionSheet UI & Layout

extension SparkActionSheet {
    
    private func setUI() {
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .crossDissolve
        
        backgroundView.frame = view.bounds
        backgroundView.isUserInteractionEnabled = true
        backgroundView.addGestureRecognizer(tapRecognizer)
    }
}
