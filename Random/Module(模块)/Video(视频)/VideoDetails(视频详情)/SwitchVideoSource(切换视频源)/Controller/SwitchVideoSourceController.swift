//
//  SwitchVideoSourceController.swift
//  Random
//
//  Created by yu mingming on 2020/7/23.
//  Copyright © 2020 刘超正. All rights reserved.
//

import UIKit

class SwitchVideoSourceController: BaseController {
    
    lazy var switchVideoSourceView: SwitchVideoSourceView = {
        var height = 0
        if allPlayerSourceNames.count > 5 {
            height = Int(CZCommon.cz_dynamicFitHeight(30) * 5) + Int(CZCommon.cz_dynamicFitHeight(30))
        } else {
            height = Int(CZCommon.cz_dynamicFitHeight(30)) * allPlayerSourceNames.count + Int(CZCommon.cz_dynamicFitHeight(30))
        }
        let view = SwitchVideoSourceView(frame: CGRect(x: 0, y: 0, width: Int(CZCommon.cz_screenWidth) / 2, height: height))
        view.center = self.view.center
        view.transform = CGAffineTransform(scaleX: 0, y: 0)
        view.tableView.delegate = self
        view.tableView.dataSource = self
        return view
    }()
    
    /// 标题名称
    var titleName: String?
    
    /// 所有源名称
    var allPlayerSourceNames: Array<String> = []
    
    /// 点击播放源回调
    var didSelectRowBlock: ((Int) -> Void)?
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
            self.view.backgroundColor = UIColor.cz_rgbColor(0, 0, 0, 0.3)
            self.switchVideoSourceView.transform = CGAffineTransform.identity
        }, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cz_rgbColor(0, 0, 0, 0)
        switchVideoSourceView.cz.addSuperView(view)
        
        switchVideoSourceView.titleLabel.text = titleName
        
        switchVideoSourceView.closeButton.rx.tap.subscribe(onNext: {[weak self] () in
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
                self?.view.backgroundColor = UIColor.cz_rgbColor(0, 0, 0, 0)
                self?.switchVideoSourceView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            }, completion: { (state) in
                DispatchQueue.main.async {
                    self!.dismiss(animated: false, completion: nil)
                }
            })
        }).disposed(by: rx.disposeBag)
    }
    

    override var modalPresentationStyle: UIModalPresentationStyle {
        get {
            return .overFullScreen
        }
        set{}
    }

}

extension SwitchVideoSourceController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allPlayerSourceNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SwitchVideoSourceTableViewCell.identifier, for: indexPath) as! SwitchVideoSourceTableViewCell
        let sourceName = allPlayerSourceNames[indexPath.row]
        cell.sourceNameLabel.text = sourceName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: false, completion: nil)
        if didSelectRowBlock != nil {
            didSelectRowBlock!(indexPath.row)
        }
    }
    
}
