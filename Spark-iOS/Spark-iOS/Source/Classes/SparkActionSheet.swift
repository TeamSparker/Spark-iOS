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

/// Section : StackView를 생성해주며, Action을 SubView로 받을 수 있다.
public class SparkSection {
    
    // MARK: - Properties
    
    public var actions = [SparkAction]()
    
    // MARK: - Initializer
    
    public init() {}
    
    // MARK: - Methods
    
    /// Section에 맞는 StackView를 반환
    fileprivate func makeStackView() -> UIStackView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 0
        stack.layer.borderWidth = 1
        stack.layer.cornerRadius = 2
        stack.layer.borderColor = UIColor.sparkLightGray.cgColor
        return stack
    }
    
    /// Section 사이에 빈 공간을 추가하는 UIView 반환
    fileprivate func makeSectionSpacer() -> UIView {
        let spacer = UIView()
        spacer.backgroundColor = .clear
        spacer.snp.makeConstraints { make in
            make.height.equalTo(13)
        }
        return spacer
    }
}

// MARK: - SparkAction Class

/// Action :  Section으로부터 만들어진 StackView에 들어가는 Button생성
public class SparkAction {
    
    // MARK: - Properties
    
    public enum SparkActionTitleType {
        case blackMediumTitle
        case pinkMediumTitle
        case blackBoldTitle
    }
    
    public var data: String
    public var buttonType: SparkActionTitleType
    public var handler: (() -> Void)?
    public var buttonFont: UIFont?
    
    // MARK: - Initializer
    
    public init(_ data: String, titleType: SparkActionTitleType = .blackMediumTitle, buttonFont: UIFont? = nil, handler: (() -> Void)?) {
        self.data = data
        self.buttonType = titleType
        self.buttonFont = buttonFont
        self.handler = handler
    }
    
    // MARK: - Methods
    
    /// Action Data에 맞는 버튼 반환
    fileprivate func makeButton() -> UIButton {
        let button = UIButton(type: .system)
        
        button.setTitle("\(data)", for: .normal)
        button.titleLabel?.font = .krMediumFont(ofSize: 16)

        switch buttonType {
        case .blackMediumTitle:
            button.setTitleColor(.sparkDeepGray, for: .normal)
        case .pinkMediumTitle:
            button.setTitleColor(.sparkPinkred, for: .normal)
        case . blackBoldTitle:
            button.setTitleColor(.sparkDeepGray, for: .normal)
            button.titleLabel?.font = .krBoldFont(ofSize: 16)
        }
        
        button.backgroundColor = .sparkWhite
        button.layer.cornerRadius = 2

        button.isEnabled = true
        
        button.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        return button
    }
    
    /// Action 사이를 구분하는 UIView 반환
    fileprivate func makeActionSpacer() -> UIView {
        let spacer = UIView()
        spacer.backgroundColor = .sparkLightGray
        spacer.snp.makeConstraints { make in
            make.height.equalTo(0.5)
        }
        return spacer
    }
    
    // MARK: - objc Methods
    
    @objc
    private func buttonAction() {
        self.handler?()
    }
}

// MARK: - SparkActionMainStackView Class

/// SparkActionMainStackView
/// - Section과 Action에서 만든 StackView와 Button을 SubView로 가지는 StackView
class SparkActionMainStackView: UIStackView {
    
    // MARK: - Initializer
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.axis = .vertical
        self.spacing = 0
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    /// StackView에 존재하는 SubViews를 모두 제거
    public func reset() {
        self.arrangedSubviews.forEach({ $0.removeFromSuperview() })
    }
    
}

// MARK: - SparkActionSheet

/// SparkActionSheet
/// - SparkActionMainStackView로 구성한 커스텀 액션 시트를 띄울 ViewController
class SparkActionSheet: UIViewController {
    
    // MARK: - Properties
    
    private var sections = [SparkSection]()
    
    private lazy var backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        return backgroundView
    }()
    
    private lazy var sparkActionMainStackView = SparkActionMainStackView()
    
    private lazy var tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureDidRecognize(_:)))
    
    // MARK: - Initializer
    
    // xib파일 사용
    override init(nibName nibNameOrNil: String?,
                  bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setUI()
    }
    
    // 코드베이스 사용
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUI()
    }
    
    // MARK: - Life Cycles
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setLayout()
        makeActionSheet()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        sparkActionMainStackView.reset()
        sections = [SparkSection]()
    }
    
    // MARK: - Methods
    
    /// addAction으로 액션을 추가해준다.
    /// _section이 비었을 경우 먼저 section을 추가한 다음 action을 추가한다.
    public func addAction(_ action: SparkAction) {
        if let section = sections.last {
            section.actions.append(action)
        } else {
            let section = SparkSection()
            addSection(section)
            section.actions.append(action)
        }
    }
    
    /// addSection으로 섹션을 추가해준다.
    public func addSection(_ section: SparkSection = SparkSection()) {
        sections.append(section)
    }
    
    // MARK: - Objc Methods
    
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
        
        backgroundView.isUserInteractionEnabled = true
        backgroundView.addGestureRecognizer(tapRecognizer)
    }
    
    private func setLayout() {
        view.addSubviews([backgroundView, sparkActionMainStackView])
        
        backgroundView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        sparkActionMainStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(54)
        }
    }
    
    /// _sections에 존재하는 Section과 action을 기준으로 sparkActionMainStackView를 구성한다.
    private func makeActionSheet() {
        let sectionIndex = (sections.count == 0 ? 0 : sections.count-1)
        
        // 섹션의 수만큼 stackView를 추가한다.
        for i in 0...sectionIndex {
            let stack = sections[i].makeStackView()
            sparkActionMainStackView.addArrangedSubview(stack)
            
            let actionIndex = (sections[i].actions.count == 0 ? 0 : sections[i].actions.count-1)
            
            // 각 섹션에 존재하는 액션의 수만큼 button을 추가한다.
            for j in 0...actionIndex {
                let button = sections[i].actions[j].makeButton()
                stack.addArrangedSubview(button)
                
                // 마지막 액션이 아니면 spacer를 추가하여 액션 사이를 구분한다.
                if j != actionIndex {
                    let actionSpacer = sections[i].actions[j].makeActionSpacer()
                    stack.addArrangedSubview(actionSpacer)
                }
            }
            
            // 마지막 섹션이 아니면 spacer를 추가해준다.
            if i != sectionIndex {
                let spacer = sections[i].makeSectionSpacer()
                sparkActionMainStackView.addArrangedSubview(spacer)
            }
        }
    }
}
