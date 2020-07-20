//
//  PrivacyPolicyController.swift
//  Random
//
//  Created by yu mingming on 2020/6/1.
//  Copyright © 2020 刘超正. All rights reserved.
//

import UIKit

class PrivacyPolicyController: BaseController {
    
    lazy var privacyPolicyView: PrivacyPolicyView = {
        let view = PrivacyPolicyView()
        return view
    }()
    
    /// 文件路径
    var fileURLWithPath: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        privacyPolicyView.cz.addSuperView(view).makeConstraints { (make) in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        privacyPolicyView.contentTextView.text = try! String(contentsOf: URL(fileURLWithPath: fileURLWithPath))
    }

}
