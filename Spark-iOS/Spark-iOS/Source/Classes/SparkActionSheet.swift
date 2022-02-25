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
    
    public func makeStackView() -> UIStackView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 0
        stack.layer.borderWidth = 1
        stack.layer.cornerRadius = 2
        stack.layer.borderColor = UIColor.systemGray.cgColor
        return stack
    }
    
    public func makeSectionSpacer() -> UIView {
        let spacer = UIView()
        spacer.backgroundColor = .clear
        spacer.snp.makeConstraints { make in
            make.height.equalTo(13)
        }
        return spacer
    }
}

// MARK: SparkAction Class

public class SparkAction {
    
    public enum sparkActionTitleType {
        case normalTitle
        case pinkTitle
    }
    
    public var data: String
    public var buttonType: sparkActionTitleType
    public var handler: (() -> Void)?
    
    public init(_ data: String, titleType: sparkActionTitleType = .normalTitle, handler: (() -> Void)?) {
        self.data = data
        self.buttonType = titleType
        self.handler = handler
    }
    
    fileprivate func makeButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("\(data)", for: .normal)
        switch buttonType {
        case .normalTitle:
            button.setTitleColor(.black, for: .normal)
        case .pinkTitle:
            button.setTitleColor(.systemPink, for: .normal)
        }
        button.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        button.layer.cornerRadius = 2
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.isEnabled = true
        
        button.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        return button
    }
    
    fileprivate func makeActionSpacer() -> UIView {
        let spacer = UIView()
        spacer.backgroundColor = .black
        spacer.snp.makeConstraints { make in
            make.height.equalTo(0.5)
        }
        return spacer
    }
    
    @objc
    private func buttonAction() {
        self.handler?()
    }
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setLayout()
        makeActionSheet()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        sparkActionMainStackView.reset()
        _sections = [SparkSection]()
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
    
    private func setLayout() {
        view.addSubview(backgroundView)
        view.addSubview(sparkActionMainStackView)
        sparkActionMainStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(54)
        }
    }
    
    private func makeActionSheet() {
        let sections = _sections
        let sectionIndex = (sections.count == 0 ? 0 : sections.count-1)
        
        for i in 0...sectionIndex {
            let stack = sections[i].makeStackView()
            sparkActionMainStackView.addArrangedSubview(stack)
            
            let actionIndex = (sections[i].actions.count == 0 ? 0 : sections[i].actions.count-1)
            for j in 0...actionIndex {
                let button = sections[i].actions[j].makeButton()
                stack.addArrangedSubview(button)
                
                if j != actionIndex {
                    let actionSpacer = sections[i].actions[j].makeActionSpacer()
                    stack.addArrangedSubview(actionSpacer)
                }
            }
            
            if i != sectionIndex {
                let spacer = sections[i].makeSectionSpacer()
                sparkActionMainStackView.addArrangedSubview(spacer)
            }
        }
    }
}
