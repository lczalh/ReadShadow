//
//  MainTabBarController.swift
//  Random
//
//  Created by 刘超正 on 2019/10/1.
//  Copyright © 2019 刘超正. All rights reserved.
//

import UIKit

class MainTabBarController: BaseTabBarController {
    
    /// 影源
    var videoSourceModels: Array<ReadShadowVideoResourceModel> {
        do {
            var models: Array<ReadShadowVideoResourceModel> = []
            let files = try FileManager().contentsOfDirectory(atPath: videoResourceFolderPath).filter{ $0.pathExtension == "plist" }
            for file in files {
                let model = CZObjectStore.standard.cz_unarchiver(filePath: "\(videoResourceFolderPath)/\(file)") as? ReadShadowVideoResourceModel
                models.append(model!)
            }
            return models
        } catch  {
            return []
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configBookResources()
        configshadowResources()
        configshadowParsings()
//        let majorVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
//        // 获取当前版本状态
//        let readShadowBasicConfigModel = getApplicationConfigModel()?.basicConfig?.filter{ $0.version == majorVersion }.first
        if videoSourceModels.count > 0 {
            setTabBarItem(viewController: BookReadController(), tabBarTitle: "小说", image: UIImage(named: "Icon_Fiction"), selectImage: UIImage(named: "Icon_Fiction"), tag: 1)
            setTabBarItem(viewController: VideoHomeController(), tabBarTitle: "视频", image: UIImage(named: "Icon_Video"), selectImage: UIImage(named: "Icon_Video"), tag: 2)
            setTabBarItem(viewController: MineController(), tabBarTitle: "我的", image: UIImage(named: "Icon_Mine"), selectImage: UIImage(named: "Icon_Mine"), tag: 4)
        } else {
            setTabBarItem(viewController: BookReadController(), tabBarTitle: "小说", image: UIImage(named: "Icon_Fiction"), selectImage: UIImage(named: "Icon_Fiction"), tag: 1)
            setTabBarItem(viewController: MineController(), tabBarTitle: "我的", image: UIImage(named: "Icon_Mine"), selectImage: UIImage(named: "Icon_Mine"), tag: 2)
        }
        tabBar.tintColor = cz_selectedColor
        tabBar.unselectedItemTintColor = cz_unselectedColor
        
//        CZTimer.execTask({
//            cz_print(111)
//        }, start: 0, interval: 1, repeating: true, async: true)
//        
//        CZTimer.execTask({
//            cz_print(222)
//        }, start: 0, interval: 1, repeating: true, async: true)
    }
    
    /// 配置书资源
    func configBookResources() {

        let newPenBoringPavilion = ReadShadowBookRuleResourceModel()
        newPenBoringPavilion.bookSourceName = "新笔趣阁"
        newPenBoringPavilion.bookSourceUrl = "https://www.xsbiquge.com"
        newPenBoringPavilion.bookSearchEncoding = "0"
        newPenBoringPavilion.bookSearchUrl = "https://www.xsbiquge.com/search.php?keyword="
        newPenBoringPavilion.bookSearchListNameRule = "//div[@class='result-game-item-detail']/h3/a/span"
        newPenBoringPavilion.bookSearchListDetailUrlRule = "//div[@class='result-game-item-detail']/h3/a"
        newPenBoringPavilion.bookSearchListLatestChapterNameRule = "//a[@cpos='newchapter']"
        newPenBoringPavilion.bookSearchListCategoryNameRule = "//div[@class='result-game-item-detail']/div[@class='result-game-item-info']/p[2]/span[2]"
        newPenBoringPavilion.bookDetailPageEncoding = "0"
        newPenBoringPavilion.bookDetailImageUrlRule = "//*[@id='fmimg']/img"
        newPenBoringPavilion.bookDetailAuthorRule = "//*[@id='info']/p[1]"
        newPenBoringPavilion.bookDetailIntroductionRule = "//div[@id='maininfo']/div[@id='intro']/p"
        newPenBoringPavilion.bookDetailSerialStateRule = "//*[@id='info']/p[2]"
        newPenBoringPavilion.bookChapterDetailUrlRule = "//*[@id='list']/dl/dd/a"
        newPenBoringPavilion.bookChapterDetailContentRule = "//div[@class='content_read']/div[@class='box_con']/div[@id='content']"
        newPenBoringPavilion.bookDetailRecommendReadRule = "//*[@id='listtj']/a"
        
        let penBoringNest = ReadShadowBookRuleResourceModel()
        penBoringNest.bookSourceName = "笔趣窝"
        penBoringNest.bookSourceUrl = "http://www.biquwo.org"
        penBoringNest.bookSearchEncoding = "0"
        penBoringNest.bookSearchUrl = "http://www.biquwo.org/searchbook.php?keyword="
        penBoringNest.bookSearchListNameRule = "//*[@id='main']/div[@class='novelslist2']/ul/li[position()>1]/span[@class='s2']/a"
        penBoringNest.bookSearchListDetailUrlRule = "//*[@id='main']/div[@class='novelslist2']/ul/li[position()>1]/span[@class='s2']/a"
        penBoringNest.bookSearchListLatestChapterNameRule = "//*[@id='main']/div[@class='novelslist2']/ul/li[position()>1]/span[@class='s3']/a"
        penBoringNest.bookSearchListCategoryNameRule = "//*[@id='main']/div[@class='novelslist2']/ul/li[position()>1]/span[@class='s1']"
        penBoringNest.bookSearchListSerialStateRule = "//*[@id='main']/div[@class='novelslist2']/ul/li[position()>1]/span[@class='s7']"
        penBoringNest.bookDetailPageEncoding = "0"
        penBoringNest.bookDetailImageUrlRule = "//*[@id='fmimg']/img"
        penBoringNest.bookDetailAuthorRule = "//*[@id='info']/p[1]"
        penBoringNest.bookDetailIntroductionRule = "//*[@id='intro']"
        penBoringNest.bookDetailSerialStateRule = ""
        penBoringNest.bookChapterDetailUrlRule = "//*[@id='list']/dl/dd/a"
        penBoringNest.bookChapterDetailContentRule = "//*[@id='content']"
        penBoringNest.bookDetailRecommendReadRule = ""
        
        let vertexNovel = ReadShadowBookRuleResourceModel()
        vertexNovel.bookSourceName = "顶点小说"
        vertexNovel.bookSourceUrl = "https://www.dingdiann.com"
        vertexNovel.bookSearchEncoding = "0"
        vertexNovel.bookSearchUrl = "https://www.dingdiann.com/searchbook.php?keyword="
        vertexNovel.bookSearchListNameRule = "//*[@id='main']/div[@class='novelslist2']/ul/li[position()>1]/span[@class='s2']/a"
        vertexNovel.bookSearchListDetailUrlRule = "//*[@id='main']/div[@class='novelslist2']/ul/li[position()>1]/span[@class='s2']/a"
        vertexNovel.bookSearchListLatestChapterNameRule = "//*[@id='main']/div[@class='novelslist2']/ul/li[position()>1]/span[@class='s3']/a"
        vertexNovel.bookSearchListCategoryNameRule = "//*[@id='main']/div[@class='novelslist2']/ul/li[position()>1]/span[@class='s1']"
        vertexNovel.bookSearchListSerialStateRule = "//*[@id='main']/div[@class='novelslist2']/ul/li[position()>1]/span[@class='s7']"
        vertexNovel.bookDetailPageEncoding = "0"
        vertexNovel.bookDetailImageUrlRule = "//*[@id='fmimg']/img"
        vertexNovel.bookDetailAuthorRule = "//*[@id='info']/p[1]"
        vertexNovel.bookDetailIntroductionRule = "//*[@id='intro']"
        vertexNovel.bookDetailSerialStateRule = ""
        vertexNovel.bookChapterDetailUrlRule = "//div[@id='list']/dl/dd/a"
        vertexNovel.bookChapterDetailContentRule = "//div[@id='content']"
        vertexNovel.bookDetailRecommendReadRule = ""
        
        let penBoringPavilionTwo = ReadShadowBookRuleResourceModel()
        penBoringPavilionTwo.bookSourceName = "笔趣阁2"
        penBoringPavilionTwo.bookSourceUrl = "http://www.biquger.com"
        penBoringPavilionTwo.bookSearchEncoding = "0"
        penBoringPavilionTwo.bookSearchUrl = "http://www.biquger.com/modules/article/search.php?searchkey="
        penBoringPavilionTwo.bookSearchListNameRule = "//*/tr/td[1]/a"
        penBoringPavilionTwo.bookSearchListDetailUrlRule = "//*/tr/td[1]/a"
        penBoringPavilionTwo.bookSearchListLatestChapterNameRule = "//*/tr/td[2]/a"
        penBoringPavilionTwo.bookSearchListCategoryNameRule = ""
        penBoringPavilionTwo.bookSearchListSerialStateRule = "//*/tr/td[6]"
        penBoringPavilionTwo.bookDetailPageEncoding = "0"
        penBoringPavilionTwo.bookDetailImageUrlRule = "//*[@id='fmimg']/img"
        penBoringPavilionTwo.bookDetailCategoryNameRule = "//*[@id='wrapper']/div[@class='box_con']/div[@class='con_top']/a[2]"
        penBoringPavilionTwo.bookDetailAuthorRule = "//*[@id='info']/p[1]"
        penBoringPavilionTwo.bookDetailIntroductionRule = "//*[@id='list']/p"
        penBoringPavilionTwo.bookDetailSerialStateRule = ""
        penBoringPavilionTwo.bookChapterDetailUrlRule = "//*[@id='list']/dl/dd/a"
        penBoringPavilionTwo.bookChapterDetailContentRule = "//*[@id='booktext']"
        penBoringPavilionTwo.bookDetailRecommendReadRule = "//*[@id='listtj']/a"
        
        let greenFiction = ReadShadowBookRuleResourceModel()
        greenFiction.bookSourceName = "绿色小说网"
        greenFiction.bookSourceUrl = "https://www.lvsetxt.com"
        greenFiction.bookSearchEncoding = "0"
        greenFiction.bookSearchUrl = "https://so.biqusoso.com/s.php?ie=gbk&siteid=lvsetxt.com&s=2758772450457967865&q="
        greenFiction.bookSearchListNameRule = "//*[@id='search-main']/div[@class='search-list']/ul/li[position()>1]/span[@class='s2']/a"
        greenFiction.bookSearchListDetailUrlRule = "//*[@id='search-main']/div[@class='search-list']/ul/li[position()>1]/span[@class='s2']/a"
        greenFiction.bookSearchListLatestChapterNameRule = ""
        greenFiction.bookSearchListCategoryNameRule = ""
        greenFiction.bookSearchListSerialStateRule = ""
        greenFiction.bookDetailPageEncoding = "1"
        greenFiction.bookDetailImageUrlRule = "//div[@class='book']/div[@class='info']/div[@class='cover']/img"
        greenFiction.bookDetailCategoryNameRule = "//div[@class='small']/span[2]"
        greenFiction.bookDetailAuthorRule = "//div[@class='book']/div[@class='info']/h2"
        greenFiction.bookDetailIntroductionRule = "//div[@class='intro']"
        greenFiction.bookDetailSerialStateRule = "//div[@class='small']/span[3]"
        greenFiction.bookChapterDetailUrlRule = "//div[@class='listmain']/dl/dd/a"
        greenFiction.bookChapterDetailContentRule = "//*[@id='content']"
        greenFiction.bookDetailRecommendReadRule = "//div[@class='link']/span/a"
        
        // 创建书源文件夹
        let _ = CZObjectStore.standard.cz_createFolder(folderPath: bookSourceRuleFolderPath)
//        guard state else {
//            return
//        }


        let _ = CZObjectStore.standard.cz_archiver(object: newPenBoringPavilion, filePath: bookSourceRuleFolderPath + "/" + (newPenBoringPavilion.bookSourceName ?? "") + ".plist")
        let _ = CZObjectStore.standard.cz_archiver(object: penBoringNest, filePath: bookSourceRuleFolderPath + "/" + (penBoringNest.bookSourceName ?? "") + ".plist")
        let _ = CZObjectStore.standard.cz_archiver(object: vertexNovel, filePath: bookSourceRuleFolderPath + "/" + (vertexNovel.bookSourceName ?? "") + ".plist")
        let _ = CZObjectStore.standard.cz_archiver(object: penBoringPavilionTwo, filePath: bookSourceRuleFolderPath + "/" + (penBoringPavilionTwo.bookSourceName ?? "") + ".plist")
        let _ = CZObjectStore.standard.cz_archiver(object: greenFiction, filePath: bookSourceRuleFolderPath + "/" + (greenFiction.bookSourceName ?? "") + ".plist")


    }
    
    /// 配置影资源
    func configshadowResources() {
        
        // 创建影源文件夹
        let _ = CZObjectStore.standard.cz_createFolder(folderPath: videoResourceFolderPath)
     //   guard state else { return }
        
//        let coolCloud = ReadShadowVideoResourceModel()
//        coolCloud.name = "酷云"
//        coolCloud.baseUrl = "http://caiji.kuyun98.com"
//        coolCloud.path = "/inc/s_feifeikkm3u8"
//        coolCloud.downloadPath = "/inc/feifei3down"
//        let _ = CZObjectStore.standard.cz_archiver(object: coolCloud, filePath: videoResourceFolderPath + "/" + (coolCloud.name ?? "") + ".plist")
//
//        let ok = ReadShadowVideoResourceModel()
//        ok.name = "OK"
//        ok.baseUrl = "https://cj.okzy.tv"
//        ok.path = "/inc/feifei3ckm3u8s"
//        ok.downloadPath = "/inc/feifei3down"
//        let _ = CZObjectStore.standard.cz_archiver(object: ok, filePath: videoResourceFolderPath + "/" + (ok.name ?? "") + ".plist")
        
//        let qt = ReadShadowVideoResourceModel()
//        qt.name = "QT"
//        qt.baseUrl = "http://zy.potatost.xyz"
//        qt.path = "/api.php/provide/vod"
//        let _ = CZObjectStore.standard.cz_archiver(object: qt, filePath: videoResourceFolderPath + "/" + (qt.name ?? "") + ".plist")
//        
//        
//        let moka = ReadShadowVideoResourceModel()
//        moka.name = "摩卡"
//        moka.baseUrl = "https://cj.heiyap.com"
//        moka.path = "/api.php/provide/vod"
//        let _ = CZObjectStore.standard.cz_archiver(object: moka, filePath: videoResourceFolderPath + "/" + (moka.name ?? "") + ".plist")

        let max = ReadShadowVideoResourceModel()
        max.name = "最大"
        max.baseUrl = "http://www.zdziyuan.com"
        max.path = "/inc/s_feifei3zuidam3u8"
        max.downloadPath = "/inc/feifeidown"
        let _ = CZObjectStore.standard.cz_archiver(object: max, filePath: videoResourceFolderPath + "/" + (max.name ?? "") + ".plist")

//        let twistCloud = ReadShadowVideoResourceModel()
//        twistCloud.name = "麻花云"
//        twistCloud.baseUrl = "https://www.mhapi123.com"
//        twistCloud.path = "/inc/feifei3"
//        let _ = CZObjectStore.standard.cz_archiver(object: twistCloud, filePath: videoResourceFolderPath + "/" + (twistCloud.name ?? "") + ".plist")


        
        /* X
         http://cangtianzy10.com/api.php/provide/vod
         http://balezy3.com/api.php/provide/vod
         https://jialiapi.com/api.php/provide/vod
         https://www.jikzy.com/inc/feifei3/
         */
        
        
    }
    
    /// 配置影源解析
    func configshadowParsings() {
        // 创建解析文件夹
        let _ = CZObjectStore.standard.cz_createFolder(folderPath: parsingInterfaceFolderPath)
        //guard state else { return }
        
        let quanming = ParsingInterfaceModel()
        quanming.parsingName = "quanmingjiexi"
        quanming.parsingInterface = "https://jx.quanmingjiexi.com/?url="
        let _ = CZObjectStore.standard.cz_archiver(object: quanming, filePath: parsingInterfaceFolderPath + "/" + (quanming.parsingName ?? "") + ".plist")
        
        let moon = ParsingInterfaceModel()
        moon.parsingName = "月亮"
        moon.parsingInterface = "https://api.yueliangjx.com/?url="
        let _ = CZObjectStore.standard.cz_archiver(object: moon, filePath: parsingInterfaceFolderPath + "/" + (moon.parsingName ?? "") + ".plist")
        
        let dreamCloudTwo = ParsingInterfaceModel()
        dreamCloudTwo.parsingName = "集梦云2"
        dreamCloudTwo.parsingInterface = "https://ys.ys520.club/?url="
        let _ = CZObjectStore.standard.cz_archiver(object: dreamCloudTwo, filePath: parsingInterfaceFolderPath + "/" + (dreamCloudTwo.parsingName ?? "") + ".plist")
        
        
    }
    
    /// 设置控制器
    ///
    /// - Parameters:
    ///   - viewController: 视图控制器
    ///   - navigationTitle: 导航标题
    ///   - tabBarTitle: 标签标题
    ///   - image: 默认图片
    ///   - selectImage: 选择图片
    public func setTabBarItem(viewController: UIViewController?, tabBarTitle: String?, image: UIImage?, selectImage: UIImage?, tag: Int) {
        let navigationController = BaseNavigationController(rootViewController: viewController!)
        let tabbarItem = UITabBarItem()
        tabbarItem.title = tabBarTitle
        tabbarItem.image = image
        tabbarItem.tag = tag
        tabbarItem.selectedImage = selectImage
        navigationController.tabBarItem = tabbarItem
        addChild(navigationController)
    }

}
