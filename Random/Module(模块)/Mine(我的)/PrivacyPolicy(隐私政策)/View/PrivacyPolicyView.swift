//
//  PrivacyPolicyView.swift
//  Random
//
//  Created by yu mingming on 2020/6/1.
//  Copyright © 2020 刘超正. All rights reserved.
//

import UIKit

class PrivacyPolicyView: BaseView {
    
    lazy var contentTextView: UITextView = {
        let view = UITextView(frame: .zero, textContainer: .none)
            .cz
            .font(UIFont.cz_systemFont(14))
            .isEditable(false)
            .build
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentTextView.cz.addSuperView(self).makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
