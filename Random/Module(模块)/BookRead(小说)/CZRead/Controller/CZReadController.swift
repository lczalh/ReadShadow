//
//  CZReadController.swift
//  Random
//
//  Created by yu mingming on 2020/4/30.
//  Copyright © 2020 刘超正. All rights reserved.
//

import UIKit

class CZReadController: BaseController {
    
    // 仿真
    var simulationPageViewController: CZBasePageController!
    
    // 平滑
    var smoothPageViewController: CZBasePageController!
    
    /// 控制器数量
    var controllers: Array<UIViewController> = []
    
    /// 是否隐藏状态栏
    var isStatusBarHidden: Bool = true {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    /// 书阅读模型
    @objc dynamic var bookReadModel: BookReadModel?
    
    /// 导航条
    lazy var readNavigationView: CZReadNavigationView = {
        let view = CZReadNavigationView(frame: CGRect(x: 0, y: -(CZCommon.cz_navigationHeight + CZCommon.cz_statusBarHeight), width: CZCommon.cz_screenWidth, height: CZCommon.cz_navigationHeight + CZCommon.cz_statusBarHeight))
        return view
    }()
    
    /// 标签栏
    lazy var readTabBarView: CZReadTabBarView = {
        let view = CZReadTabBarView(frame: CGRect(x: 0, y: CZCommon.cz_screenHeight, width: CZCommon.cz_screenWidth, height: CZCommon.cz_navigationHeight + CZCommon.cz_safeAreaHeight))
        return view
    }()
    
    /// 亮度
    lazy var readBrightnessView: CZReadBrightnessView = {
        let view = CZReadBrightnessView(frame: CGRect(x: 0, y: CZCommon.cz_screenHeight, width: CZCommon.cz_screenWidth, height: CZCommon.cz_navigationHeight + 50))
        view.bookReadModel = bookReadModel
        return view
    }()
    
    // 字号
    lazy var readWordSizeView: CZReadWordSizeView = {
        let view = CZReadWordSizeView(frame: CGRect(x: 0, y: CZCommon.cz_screenHeight, width: CZCommon.cz_screenWidth, height: CZCommon.cz_navigationHeight + 50))
        view.bookReadModel = bookReadModel
        return view
    }()
    
    // 目录
    lazy var readDirectoryView: CZReadDirectoryView = {
        let view = CZReadDirectoryView(frame: CGRect(x: 0, y: CZCommon.cz_screenHeight, width: CZCommon.cz_screenWidth, height: CZCommon.cz_screenHeight - CZCommon.cz_navigationHeight * 2 - CZCommon.cz_statusBarHeight - CZCommon.cz_safeAreaHeight))
        view.bookReadModel = bookReadModel
        return view
    }()
    
    // 字体
    lazy var readFontView: CZReadFontView = {
        let view = CZReadFontView(frame: CGRect(x: 0, y: CZCommon.cz_screenHeight, width: CZCommon.cz_screenWidth, height: CZCommon.cz_screenHeight - CZCommon.cz_navigationHeight * 2 - CZCommon.cz_statusBarHeight - CZCommon.cz_safeAreaHeight))
        view.bookReadModel = bookReadModel
        return view
    }()
    
    /// 书架modes
   // var bookcaseModels: Array<BookReadModel> = CZObjectStore.standard.cz_readObjectInPlist(filePath: bookcasePath, key: bookcaseKey) as? Array<BookReadModel> ?? []
    
    /// 历史浏览modes
//    var bookBrowsingRecordModels: Array<BookReadModel> = CZObjectStore.standard.cz_readObjectInPlist(filePath: bookBrowsingRecordPath, key: bookBrowsingRecordKey) as? Array<BookReadModel> ?? []
    
    
    /// 单机手势  需要过滤的视图
    private var needFilterViews: Array<String> {
        return [
            "UIControl",
            "CZReadNavigationView",
            "CZReadBrightnessView",
            "CZReadTabBarView",
            "CZReadBrightnessView",
            "CZReadWordSizeView",
            "CZReadDirectoryView",
            "CZReadFontView",
            "UIView",
            "UIButton",
            "UITableViewCellContentView",
            "UISlider",
        ]
    }
    
    // MARK: - 仿真模式 使用
    
    /// 记录当前章节索引
    private var recordCurrentChapterIndex: Int = 0
    
    /// 记录当前章节分页索引
    private var recordCurrentChapterPagingIndex: Int = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.cz_interactivePopDisabled(isEnabled: false)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.cz_interactivePopDisabled(isEnabled: true)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    /// 隐藏状态栏
    override var prefersStatusBarHidden: Bool {
        return isStatusBarHidden
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        createReadController()
        
        
        

        // 单机手势
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureRecognizerAction))
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.delegate = self
        view.addGestureRecognizer(tapGestureRecognizer)
        
        readNavigationView.cz.addSuperView(view)
        readDirectoryView.cz.addSuperView(view)
        readBrightnessView.cz.addSuperView(view)
        readWordSizeView.cz.addSuperView(view)
        readFontView.cz.addSuperView(view)
        readTabBarView.cz.addSuperView(view)
        
        // 返回按钮事件
        readNavigationView.returnButton.rx.tap.subscribe(onNext: {[weak self] () in
            DispatchQueue.main.async {
                self?.navigationController?.popViewController(animated: true, {
                    //self?.updateLocalData()
                })
            }
        }).disposed(by: rx.disposeBag)
        
        
        // 目录按钮事件
        readTabBarView.directoryButton.rx.tap.subscribe(onNext: {[weak self] () in
            self?.readDirectoryView.tableView.reloadData()
            self?.isHiddenBrightnessView(isHidden: false)
            self?.isHiddenWordSizeView(isHidden: false)
            self?.isHiddenFontView(isHidden: false)
            self?.isHiddenDirectoryView(isHidden: !(self?.readTabBarView.directoryButton.isSelected)!)
        }).disposed(by: rx.disposeBag)
        
        // 亮度按钮事件
        readTabBarView.brightnessButton.rx.tap.subscribe(onNext: {[weak self] () in
            self?.isHiddenWordSizeView(isHidden: false)
            self?.isHiddenDirectoryView(isHidden: false)
            self?.isHiddenFontView(isHidden: false)
            self?.isHiddenBrightnessView(isHidden: !(self?.readTabBarView.brightnessButton.isSelected)!)
        }).disposed(by: rx.disposeBag)
        
        // 亮度调节事件
        readBrightnessView.brightnessSlider.rx.value.skip(1).subscribe(onNext: { (value) in
            UIScreen.main.brightness = CGFloat(value)
        }).disposed(by: rx.disposeBag)
        
        // 主题选择事件
        readBrightnessView.tapThemeBlock = {[weak self] in
            BookReadParsing.filterLoadedChapterContentAndPaging(bookReadModel: self!.bookReadModel!)
            self?.simulationPageViewController?.setViewControllers([self!.getSpecifyController(chapterIndex: self?.bookReadModel?.bookLastReadChapterIndex ?? 0, chapterPagingIndex: self?.bookReadModel?.bookLastReadChapterPagingIndex ?? 0)], direction: .forward, animated: false, completion: nil)
        }
        
        // 字号按钮事件
        readTabBarView.wordSizeButton.rx.tap.subscribe(onNext: {[weak self] () in
            self?.isHiddenBrightnessView(isHidden: false)
            self?.isHiddenDirectoryView(isHidden: false)
            self?.isHiddenFontView(isHidden: false)
            self?.isHiddenWordSizeView(isHidden: !(self?.readTabBarView.wordSizeButton.isSelected)!)
        }).disposed(by: rx.disposeBag)
        
        // 字体大小滚动调节事件
        readWordSizeView.highWordSizeSlider.rx.value.skip(1).subscribe(onNext: {[weak self] (value) in
            CZObjectStore.standard.cz_objectWriteUserDefault(object: value, key: "bookReadFontSize")
            BookReadParsing.filterLoadedChapterContentAndPaging(bookReadModel: self!.bookReadModel!)
            self?.simulationPageViewController?.setViewControllers([self!.getSpecifyController(chapterIndex: self?.bookReadModel?.bookLastReadChapterIndex ?? 0, chapterPagingIndex: self?.bookReadModel?.bookLastReadChapterPagingIndex ?? 0)], direction: .forward, animated: false, completion: nil)
        }).disposed(by: rx.disposeBag)
        // 目录点击章节事件
        readDirectoryView.tapChapterBlock = {[weak self] in
            // 获取章节模型
            let chapterModel = self?.bookReadModel?.bookReadChapter?[self?.bookReadModel?.bookLastReadChapterIndex ?? 0]
            // 判断是否存在分页数据
            if chapterModel?.chapterPaging?.count ?? 0 > 0 { // 存在分页数据
                self?.simulationPageViewController?.setViewControllers([self!.getSpecifyController(chapterIndex: self?.bookReadModel?.bookLastReadChapterIndex ?? 0, chapterPagingIndex: self?.bookReadModel?.bookLastReadChapterPagingIndex ?? 0)], direction: .forward, animated: false, completion: { _ in
                    self?.isHiddenDirectoryView(isHidden: false)
                    self?.isHiddenReadNavigationView(isHidden: false)
                    self?.isHiddenReadTabBarView(isHidden: false)
                })
            } else { // 不存在
                CZHUD.show("解析中")
                BookReadParsing.chapterContentParsing(currentChapterIndex: self?.bookReadModel?.bookLastReadChapterIndex ?? 0, bookReadModel: self!.bookReadModel!) {[weak self] state in
                    DispatchQueue.main.async {
                        if state == true {
                            CZHUD.dismiss()
                            self?.simulationPageViewController?.setViewControllers([self!.getSpecifyController(chapterIndex: self?.bookReadModel?.bookLastReadChapterIndex ?? 0, chapterPagingIndex: self?.bookReadModel?.bookLastReadChapterPagingIndex ?? 0)], direction: .forward, animated: false, completion: { _ in
                                self?.isHiddenDirectoryView(isHidden: false)
                                self?.isHiddenReadNavigationView(isHidden: false)
                                self?.isHiddenReadTabBarView(isHidden: false)
                            })
                        } else {
                            CZHUD.showError("解析失败")
                        }
                    }
                }
            }
        }
        
        // 字体点击事件
        readTabBarView.fontButton.rx.tap.subscribe(onNext: {[weak self] () in
            self?.isHiddenBrightnessView(isHidden: false)
            self?.isHiddenDirectoryView(isHidden: false)
            self?.isHiddenWordSizeView(isHidden: false)
            self?.isHiddenFontView(isHidden: !(self?.readTabBarView.fontButton.isSelected)!)
        }).disposed(by: rx.disposeBag)
        
        // 点击字体名称事件
        readFontView.tapFamilyNameBlock = {[weak self] in
            BookReadParsing.filterLoadedChapterContentAndPaging(bookReadModel: self!.bookReadModel!)
            self?.simulationPageViewController?.setViewControllers([self!.getSpecifyController(chapterIndex: self?.bookReadModel?.bookLastReadChapterIndex ?? 0, chapterPagingIndex: self?.bookReadModel?.bookLastReadChapterPagingIndex ?? 0)], direction: .forward, animated: false, completion: { _ in
                self?.isHiddenFontView(isHidden: false)
                self?.isHiddenReadNavigationView(isHidden: false)
                self?.isHiddenReadTabBarView(isHidden: false)
            })
        }
        
        // 切换风格回调
        readWordSizeView.tapBookReadStyleNameBlock = {[weak self] in
            self?.createReadController()
        }
        
        CZHUD.show("解析中")
        BookReadParsing.chapterContentParsing(currentChapterIndex: self.bookReadModel?.bookLastReadChapterIndex ?? 0, bookReadModel: bookReadModel!) {[weak self] state in
            DispatchQueue.main.async {
                if state == true {
                    CZHUD.dismiss()
                    if bookReadStyleName == "仿真" { // 仿真
                        // 初始化索引
                        self?.recordCurrentChapterPagingIndex = self?.bookReadModel?.bookLastReadChapterPagingIndex ?? 0
                        self?.recordCurrentChapterIndex = self?.bookReadModel?.bookLastReadChapterIndex ?? 0
                        self?.simulationPageViewController?.setViewControllers([self!.getSpecifyController(chapterIndex: self?.bookReadModel?.bookLastReadChapterIndex ?? 0, chapterPagingIndex: self?.bookReadModel?.bookLastReadChapterPagingIndex ?? 0)], direction: .forward, animated: false, completion: nil)
                    } else if bookReadStyleName == "平移" {
                        self?.smoothPageViewController?.setViewControllers([self!.getSpecifyController(chapterIndex: self?.bookReadModel?.bookLastReadChapterIndex ?? 0, chapterPagingIndex: self?.bookReadModel?.bookLastReadChapterPagingIndex ?? 0)], direction: .forward, animated: false, completion: nil)
                    }
                } else {
                    CZHUD.showError("解析失败")
                }
            }
        }
    }
    
    /// 创建阅读控制器
    private func createReadController() {
        clearAllReadControllers()
        if bookReadStyleName == "仿真" { // 仿真
            simulationPageViewController = CZBasePageController(transitionStyle: .pageCurl, navigationOrientation: .horizontal, options: [UIPageViewController.OptionsKey.spineLocation : NSNumber(value: UIPageViewController.SpineLocation.min.rawValue)])
            simulationPageViewController.view.frame = view.frame
            simulationPageViewController.cz_isOpenCustomTapGesture = true
            simulationPageViewController.cz_delegate = self
            simulationPageViewController.dataSource = self
            simulationPageViewController.delegate = self
            addChild(simulationPageViewController)
            view.insertSubview(simulationPageViewController.view, at: 0)
            // 获取章节模型
            let chapterModel = bookReadModel?.bookReadChapter?[bookReadModel?.bookLastReadChapterIndex ?? 0]
            // 判断是否存在分页数据
            if chapterModel?.chapterPaging?.count ?? 0 > 0 { // 存在分页数据
                simulationPageViewController?.setViewControllers([getSpecifyController(chapterIndex: bookReadModel?.bookLastReadChapterIndex ?? 0, chapterPagingIndex: bookReadModel?.bookLastReadChapterPagingIndex ?? 0)], direction: .forward, animated: false, completion: nil)
            }
        } else if bookReadStyleName == "覆盖" {
            
        } else if bookReadStyleName == "平移" {
            smoothPageViewController = CZBasePageController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: [UIPageViewController.OptionsKey.spineLocation : NSNumber(value: UIPageViewController.SpineLocation.min.rawValue)])
            smoothPageViewController.view.frame = view.frame
            smoothPageViewController.cz_isOpenCustomTapGesture = true
            smoothPageViewController.cz_delegate = self
            smoothPageViewController.dataSource = self
            smoothPageViewController.delegate = self
            addChild(smoothPageViewController)
            view.insertSubview(smoothPageViewController.view, at: 0)
            // 获取章节模型
            let chapterModel = bookReadModel?.bookReadChapter?[bookReadModel?.bookLastReadChapterIndex ?? 0]
            // 判断是否存在分页数据
            if chapterModel?.chapterPaging?.count ?? 0 > 0 { // 存在分页数据
                smoothPageViewController?.setViewControllers([getSpecifyController(chapterIndex: bookReadModel?.bookLastReadChapterIndex ?? 0, chapterPagingIndex: bookReadModel?.bookLastReadChapterPagingIndex ?? 0)], direction: .forward, animated: false, completion: nil)
            }
        } else if bookReadStyleName == "滚动" {
                   
        } else if bookReadStyleName == "无" {
                          
        }
    }
    
    /// 清理所有阅读控制器
    private func clearAllReadControllers() {
        if simulationPageViewController != nil {
            simulationPageViewController?.view.removeFromSuperview()
            simulationPageViewController?.removeFromParent()
            simulationPageViewController = nil
        }
        if smoothPageViewController != nil {
            smoothPageViewController?.view.removeFromSuperview()
            smoothPageViewController?.removeFromParent()
            smoothPageViewController = nil
        }
    }
    
    /// 是否显示导航视图
    /// - Parameter isHidden: true: 显示 false: 隐藏
    private func isHiddenReadNavigationView(isHidden: Bool) {
        UIView.animate(withDuration: 0.3, animations: {
            if isHidden == true {
                self.readNavigationView.frame.origin.y = 0
            } else {
                self.readNavigationView.frame.origin.y  = -(CZCommon.cz_navigationHeight + CZCommon.cz_statusBarHeight)
            }
        }) { (state) in
           self.isStatusBarHidden = !self.isStatusBarHidden
        }
    }
    
    /// 是否显示标签栏视图
    /// - Parameter isHidden: true: 显示 false: 隐藏
    private func isHiddenReadTabBarView(isHidden: Bool) {
        UIView.animate(withDuration: 0.3, animations: {
            if isHidden == true {
                self.readTabBarView.frame.origin.y = CZCommon.cz_screenHeight - (CZCommon.cz_safeAreaHeight + CZCommon.cz_navigationHeight)
            } else {
                self.readTabBarView.frame.origin.y = CZCommon.cz_screenHeight
            }
        }) { (state) in
           
        }
    }
    
    /// 是否显示亮度视图
    /// - Parameter isHidden: true: 显示 false: 隐藏
    private func isHiddenBrightnessView(isHidden: Bool) {
        UIView.animate(withDuration: 0.3, animations: {
            if isHidden == true {
                self.readBrightnessView.frame.origin.y = CZCommon.cz_screenHeight - CZCommon.cz_navigationHeight * 2 - CZCommon.cz_safeAreaHeight - 50
                self.readTabBarView.brightnessButton.isSelected = true
            } else {
                self.readBrightnessView.frame.origin.y = CZCommon.cz_screenHeight
                self.readTabBarView.brightnessButton.isSelected = false
            }
        }) { (state) in
           
        }
    }
    
    /// 是否显示字号视图
    /// - Parameter isHidden: true: 显示 false: 隐藏
    private func isHiddenWordSizeView(isHidden: Bool) {
        UIView.animate(withDuration: 0.3, animations: {
            if isHidden == true {
                self.readWordSizeView.frame.origin.y =  CZCommon.cz_screenHeight - CZCommon.cz_navigationHeight * 2 - CZCommon.cz_safeAreaHeight - 50
                self.readTabBarView.wordSizeButton.isSelected = true
            } else {
                self.readWordSizeView.frame.origin.y = CZCommon.cz_screenHeight
                self.readTabBarView.wordSizeButton.isSelected = false
            }
        }) { (state) in
           
        }
    }
    
    /// 是否显示目录视图
    /// - Parameter isHidden: true: 显示 false: 隐藏
    private func isHiddenDirectoryView(isHidden: Bool) {
        UIView.animate(withDuration: 0.3, animations: {
            if isHidden == true {
                self.readDirectoryView.frame.origin.y = CZCommon.cz_navigationHeight + CZCommon.cz_statusBarHeight
                self.readTabBarView.directoryButton.isSelected = true
            } else {
                self.readDirectoryView.frame.origin.y = CZCommon.cz_screenHeight
                self.readTabBarView.directoryButton.isSelected = false
            }
        }) { (state) in
           
        }
    }
    
    /// 是否显示字体视图
    /// - Parameter isHidden: true: 显示 false: 隐藏
    private func isHiddenFontView(isHidden: Bool) {
        UIView.animate(withDuration: 0.3, animations: {
            if isHidden == true {
                self.readFontView.frame.origin.y = CZCommon.cz_navigationHeight + CZCommon.cz_statusBarHeight
                self.readTabBarView.fontButton.isSelected = true
            } else {
                self.readFontView.frame.origin.y = CZCommon.cz_screenHeight
                self.readTabBarView.fontButton.isSelected = false
            }
        }) { (state) in
           
        }
    }
    
    @objc func tapGestureRecognizerAction(sender: UITapGestureRecognizer) {
        self.isHiddenReadNavigationView(isHidden: self.isStatusBarHidden)
        self.isHiddenReadTabBarView(isHidden: self.isStatusBarHidden)
        self.isHiddenBrightnessView(isHidden: false)
        self.isHiddenDirectoryView(isHidden: false)
        self.isHiddenWordSizeView(isHidden: false)
        self.isHiddenFontView(isHidden: false)
    }
    
    // MARK: - 更新本地数据
    func updateLocalData() {
        bookReadModel?.browseTime = Date().string(withFormat: "yyyy-MM-dd HH:mm:ss")
        // 书架
        let bookcaseModel = CZObjectStore.standard.cz_readObjectInPlist(filePath: "\(bookcaseFolderPath)/\(bookReadModel?.bookName ?? "").plist", key: (self.bookReadModel?.bookName)!) as? BookReadModel
        // 在书架
        if bookcaseModel != nil {
            let _ = CZObjectStore.standard.cz_objectWritePlist(object: self.bookReadModel!, filePath: "\(bookcaseFolderPath)/\(bookReadModel?.bookName ?? "").plist", key: (self.bookReadModel?.bookName)!)
        }
        // 更新历史记录
        _ = CZObjectStore.standard.cz_archiver(object: bookReadModel!, filePath: "\(bookBrowsingRecordFolderPath)/\(bookReadModel?.bookName ?? "").plist")
    }
    
    deinit {
        cz_print("销毁了")
    }
}

extension CZReadController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    // 前一页
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var currentChapterIndex = recordCurrentChapterIndex
        var currentChapterPagingIndex = recordCurrentChapterPagingIndex
        // 第一章 && 第一页
        if currentChapterIndex == 0, currentChapterPagingIndex == 0 {
            return nil
        }
        // 判断是否是第一页
        if currentChapterPagingIndex == 0 {
            // 修改章节索引
            currentChapterIndex -= 1
            // 获取章节模型
            let chapterModel = bookReadModel?.bookReadChapter?[currentChapterIndex]
            // 判断是否存在分页数据
            if chapterModel?.chapterPaging?.count ?? 0 > 0 { // 存在分页数据
                // 页号为前一章的最大页数
                currentChapterPagingIndex = (chapterModel?.chapterPaging!.count)! - 1
                return getSpecifyController(chapterIndex: currentChapterIndex, chapterPagingIndex: currentChapterPagingIndex)
            } else { // 不存在则解析数据
                CZHUD.show("解析中")
                BookReadParsing.chapterContentParsing(currentChapterIndex: currentChapterIndex, bookReadModel: bookReadModel!) {[weak self] state in
                    DispatchQueue.main.async {
                        if state == true {
                            CZHUD.dismiss()
                            self?.bookReadModel?.bookLastReadChapterIndex! -= 1
                            let beforeChapterModel = self?.bookReadModel?.bookReadChapter?[self?.bookReadModel?.bookLastReadChapterIndex ?? 0]
                            // 页号为前一章的最大页数
                            self?.bookReadModel?.bookLastReadChapterPagingIndex = (beforeChapterModel?.chapterPaging!.count)! - 1
                            if bookReadStyleName == "仿真" {  // 仿真
                                self?.simulationPageViewController?.setViewControllers([self!.getSpecifyController(chapterIndex: self?.bookReadModel?.bookLastReadChapterIndex ?? 0, chapterPagingIndex: self?.bookReadModel?.bookLastReadChapterPagingIndex ?? 0)], direction: .reverse, animated: true, completion: nil)
                            } else if bookReadStyleName == "平移" { // 平移
                                self?.smoothPageViewController?.setViewControllers([self!.getSpecifyController(chapterIndex: self?.bookReadModel?.bookLastReadChapterIndex ?? 0, chapterPagingIndex: self?.bookReadModel?.bookLastReadChapterPagingIndex ?? 0)], direction: .reverse, animated: true, completion: nil)
                            }
                            self?.updateLocalData()
                        } else {
                            CZHUD.showError("解析失败")
                        }
                    }
                }
                return nil
            }
        } else {
            currentChapterPagingIndex -= 1
            return getSpecifyController(chapterIndex: currentChapterIndex, chapterPagingIndex: currentChapterPagingIndex)
        }
    }
    
    // 后一页
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        //cz_print(bookReadModel?.bookLastReadChapterIndex,bookReadModel?.bookLastReadChapterPagingIndex)
        var currentChapterIndex = recordCurrentChapterIndex
        var currentChapterPagingIndex = recordCurrentChapterPagingIndex
        
        // 获取章节模型
        let chapterModel = bookReadModel?.bookReadChapter?[currentChapterIndex]
        
        // 最后一章 && 最后一页
        if currentChapterIndex == (bookReadModel?.bookReadChapter!.count)! - 1, currentChapterPagingIndex == (chapterModel?.chapterPaging!.count)! - 1 {
            return nil
        }
        
        // 判断是否是最后页
        if currentChapterPagingIndex == (chapterModel?.chapterPaging!.count)! - 1 {
            // 修改章节索引
            currentChapterIndex += 1
            // 页号为前一章的最大页数
            currentChapterPagingIndex = 0
            // 获取下一章模型
            let nextChapterModel = bookReadModel?.bookReadChapter?[currentChapterIndex]
            // 判断是否存在分页数据
            if nextChapterModel?.chapterPaging?.count ?? 0 > 0 { // 存在分页数据
                return getSpecifyController(chapterIndex: currentChapterIndex, chapterPagingIndex: currentChapterPagingIndex)
            } else { // 不存在则解析数据
                CZHUD.show("解析中")
                BookReadParsing.chapterContentParsing(currentChapterIndex: currentChapterIndex, bookReadModel: bookReadModel!) {[weak self] state in
                    DispatchQueue.main.async {
                        if state == true {
                            CZHUD.dismiss()
                            // 修改章节索引
                            self?.bookReadModel?.bookLastReadChapterIndex! += 1
                            // 修改章节分页索引
                            self?.bookReadModel?.bookLastReadChapterPagingIndex = 0
                            if bookReadStyleName == "仿真" {  // 仿真
                                self?.simulationPageViewController?.setViewControllers([self!.getSpecifyController(chapterIndex: self?.bookReadModel?.bookLastReadChapterIndex ?? 0, chapterPagingIndex: self?.bookReadModel?.bookLastReadChapterPagingIndex ?? 0)], direction: .forward, animated: true, completion: nil)
                            } else if bookReadStyleName == "平移" { // 平移
                                self?.smoothPageViewController?.setViewControllers([self!.getSpecifyController(chapterIndex: self?.bookReadModel?.bookLastReadChapterIndex ?? 0, chapterPagingIndex: self?.bookReadModel?.bookLastReadChapterPagingIndex ?? 0)], direction: .forward, animated: true, completion: nil)
                            }
                            self?.updateLocalData()
                        } else {
                            CZHUD.showError("解析失败")
                        }
                    }
                }
                return nil
            }
        } else {
            currentChapterPagingIndex += 1
            return getSpecifyController(chapterIndex: currentChapterIndex, chapterPagingIndex: currentChapterPagingIndex)
        }
    }
    
    /// 开始滚动或翻页的时候触发
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        let vc = pendingViewControllers.first as! CZReadContentController
        recordCurrentChapterPagingIndex = vc.chapterPagingCurrentIndex! - 1
        recordCurrentChapterIndex = vc.chapterCurrentIndex!
    }
    
    
    /// 结束滚动或翻页的时候触发
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed == true && finished == true { // 成功翻页在修改 章节索引和分页索引
            bookReadModel?.bookLastReadChapterIndex = recordCurrentChapterIndex
            bookReadModel?.bookLastReadChapterPagingIndex = recordCurrentChapterPagingIndex
            updateLocalData()
        } else { // 未成功翻页 则重置页码
            recordCurrentChapterPagingIndex = bookReadModel!.bookLastReadChapterPagingIndex!
            recordCurrentChapterIndex = bookReadModel!.bookLastReadChapterIndex!
        }
    }
    
    
    /// 获取指定的分页控制器
    /// - Parameters:
    ///   - chapterIndex: 章节索引
    ///   - chapterPagingIndex: 章节分页索引
    /// - Returns: 章节控制器
    func getSpecifyController(chapterIndex: Int, chapterPagingIndex: Int) -> CZReadContentController {
        // 获取章节模型
        let chapterModel = bookReadModel?.bookReadChapter?[chapterIndex]
        // 获取分页模型
        let chapterPagingModel = chapterModel?.chapterPaging?[chapterPagingIndex]
        let vc = CZReadContentController()
        // 设置章节名
        vc.chapterName = chapterModel?.chapterName
        // 设置分页内容
        vc.chapterContent = chapterPagingModel?.pagingContent
        // 设置当前章节索引
        vc.chapterCurrentIndex = chapterIndex
        /// 章节当前分页索引
        vc.chapterPagingCurrentIndex = chapterPagingIndex + 1
        /// 章节分页总索引
        vc.chapterPagingTotalIndex = chapterModel?.chapterPaging?.count ?? 0
        return vc
    }
    
}

extension CZReadController: CZBasePageControllerDelegate {
    
    /// 获取上一页
    func pageViewController(_ pageViewController: CZBasePageController, getViewControllerBefore viewController: UIViewController!) {
        // 第一章 && 第一页
        if (bookReadModel?.bookLastReadChapterIndex ?? 0) == 0, (bookReadModel?.bookLastReadChapterPagingIndex ?? 0) == 0 {
            return
        }
        // 判断是否是第一页
        if (bookReadModel?.bookLastReadChapterPagingIndex ?? 0) == 0 {
            // 修改章节索引
            bookReadModel?.bookLastReadChapterIndex! -= 1
            // 获取章节模型
            let chapterModel = bookReadModel?.bookReadChapter?[bookReadModel?.bookLastReadChapterIndex ?? 0]
            // 判断是否存在分页数据
            if chapterModel?.chapterPaging?.count ?? 0 > 0 { // 存在分页数据
                // 页号为前一章的最大页数
                bookReadModel?.bookLastReadChapterPagingIndex! = (chapterModel?.chapterPaging!.count)! - 1
                if bookReadStyleName == "仿真" {  // 仿真
                    self.simulationPageViewController?.setViewControllers([self.getSpecifyController(chapterIndex: bookReadModel?.bookLastReadChapterIndex ?? 0, chapterPagingIndex: bookReadModel?.bookLastReadChapterPagingIndex ?? 0)], direction: .reverse, animated: true, completion: nil)
                } else if bookReadStyleName == "平移" {  // 平移
                    self.smoothPageViewController?.setViewControllers([self.getSpecifyController(chapterIndex: bookReadModel?.bookLastReadChapterIndex ?? 0, chapterPagingIndex: bookReadModel?.bookLastReadChapterPagingIndex ?? 0)], direction: .reverse, animated: true, completion: nil)
                }
                updateLocalData()
            } else { // 不存在则解析数据
                CZHUD.show("解析中")
                BookReadParsing.chapterContentParsing(currentChapterIndex: bookReadModel?.bookLastReadChapterIndex ?? 0, bookReadModel: bookReadModel!) {[weak self] state in
                    DispatchQueue.main.async {
                        if state == true {
                            CZHUD.dismiss()
                            // 页号为前一章的最大页数
                            self?.bookReadModel?.bookLastReadChapterPagingIndex! = (chapterModel?.chapterPaging!.count)! - 1
                            if bookReadStyleName == "仿真" {  // 仿真
                                self?.simulationPageViewController?.setViewControllers([self!.getSpecifyController(chapterIndex: self?.bookReadModel?.bookLastReadChapterIndex ?? 0, chapterPagingIndex: self?.bookReadModel?.bookLastReadChapterPagingIndex ?? 0)], direction: .reverse, animated: true, completion: nil)
                            } else if bookReadStyleName == "平移" {  // 平移
                                self?.smoothPageViewController?.setViewControllers([self!.getSpecifyController(chapterIndex: self?.bookReadModel?.bookLastReadChapterIndex ?? 0, chapterPagingIndex: self?.bookReadModel?.bookLastReadChapterPagingIndex ?? 0)], direction: .reverse, animated: true, completion: nil)
                            }
                            self?.updateLocalData()
                        } else {
                            CZHUD.showError("解析失败")
                        }
                    }
                }
            }
        } else {
            bookReadModel?.bookLastReadChapterPagingIndex! -= 1
            if bookReadStyleName == "仿真" {  // 仿真
                self.simulationPageViewController?.setViewControllers([self.getSpecifyController(chapterIndex: bookReadModel?.bookLastReadChapterIndex ?? 0, chapterPagingIndex: bookReadModel?.bookLastReadChapterPagingIndex ?? 0)], direction: .reverse, animated: true, completion: nil)
            } else if bookReadStyleName == "平移" {  // 平移
                self.smoothPageViewController?.setViewControllers([self.getSpecifyController(chapterIndex: bookReadModel?.bookLastReadChapterIndex ?? 0, chapterPagingIndex: bookReadModel?.bookLastReadChapterPagingIndex ?? 0)], direction: .reverse, animated: true, completion: nil)
            }
            updateLocalData()
        }
    }
    
    /// 获取下一页
    func pageViewController(_ pageViewController: CZBasePageController, getViewControllerAfter viewController: UIViewController!) {
        // 获取章节模型
        let chapterModel = bookReadModel?.bookReadChapter?[bookReadModel?.bookLastReadChapterIndex ?? 0]
        
        // 最后一章 && 最后一页
        if bookReadModel?.bookLastReadChapterIndex ?? 0 == (bookReadModel?.bookReadChapter!.count)! - 1, (bookReadModel?.bookLastReadChapterPagingIndex ?? 0) == (chapterModel?.chapterPaging!.count)! - 1 {
            return
        }
        
        // 判断是否是最后页
        if (bookReadModel?.bookLastReadChapterPagingIndex ?? 0) == (chapterModel?.chapterPaging!.count)! - 1 {
            // 修改章节索引
            bookReadModel?.bookLastReadChapterIndex! += 1
            // 页号为前一章的最大页数
            bookReadModel?.bookLastReadChapterPagingIndex! = 0
            // 获取下一章模型
            let nextChapterModel = bookReadModel?.bookReadChapter?[bookReadModel?.bookLastReadChapterIndex ?? 0]
            // 判断是否存在分页数据
            if nextChapterModel?.chapterPaging?.count ?? 0 > 0 { // 存在分页数据
                if bookReadStyleName == "仿真" {  // 仿真
                    self.simulationPageViewController?.setViewControllers([self.getSpecifyController(chapterIndex: bookReadModel?.bookLastReadChapterIndex ?? 0, chapterPagingIndex: bookReadModel?.bookLastReadChapterPagingIndex ?? 0)], direction: .forward, animated: true, completion: nil)
                } else if bookReadStyleName == "平移" {  // 平移
                    self.smoothPageViewController?.setViewControllers([self.getSpecifyController(chapterIndex: bookReadModel?.bookLastReadChapterIndex ?? 0, chapterPagingIndex: bookReadModel?.bookLastReadChapterPagingIndex ?? 0)], direction: .forward, animated: true, completion: nil)
                }
                updateLocalData()
            } else { // 不存在则解析数据
                CZHUD.show("解析中")
                BookReadParsing.chapterContentParsing(currentChapterIndex: bookReadModel?.bookLastReadChapterIndex ?? 0, bookReadModel: bookReadModel!) {[weak self] state in
                    DispatchQueue.main.async {
                        if state == true {
                            CZHUD.dismiss()
                            if bookReadStyleName == "仿真" {  // 仿真
                                self?.simulationPageViewController?.setViewControllers([self!.getSpecifyController(chapterIndex: self?.bookReadModel?.bookLastReadChapterIndex ?? 0, chapterPagingIndex: self?.bookReadModel?.bookLastReadChapterPagingIndex ?? 0)], direction: .forward, animated: true, completion: nil)
                            } else if bookReadStyleName == "平移" {  // 平移
                                self?.smoothPageViewController?.setViewControllers([self!.getSpecifyController(chapterIndex: self?.bookReadModel?.bookLastReadChapterIndex ?? 0, chapterPagingIndex: self?.bookReadModel?.bookLastReadChapterPagingIndex ?? 0)], direction: .forward, animated: true, completion: nil)
                            }
                            self?.updateLocalData()
                        } else {
                            CZHUD.showError("解析失败")
                        }
                    }
                }
            }
        } else {
            bookReadModel?.bookLastReadChapterPagingIndex! += 1
            if bookReadStyleName == "仿真" {  // 仿真
                self.simulationPageViewController?.setViewControllers([self.getSpecifyController(chapterIndex: bookReadModel?.bookLastReadChapterIndex ?? 0, chapterPagingIndex: bookReadModel?.bookLastReadChapterPagingIndex ?? 0)], direction: .forward, animated: true, completion: nil)
            } else if bookReadStyleName == "平移" {  // 平移
                self.smoothPageViewController?.setViewControllers([self.getSpecifyController(chapterIndex: bookReadModel?.bookLastReadChapterIndex ?? 0, chapterPagingIndex: bookReadModel?.bookLastReadChapterPagingIndex ?? 0)], direction: .forward, animated: true, completion: nil)
            }
            updateLocalData()
        }
        
    }
}

// MARK: - UIGestureRecognizerDelegate
extension CZReadController: UIGestureRecognizerDelegate {
    
    /// 手势拦截
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let classString = String(describing: type(of: touch.view!))
        if needFilterViews.contains(classString) {
            return false
        }
        return true
    }
}
