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
    
}
}

}
