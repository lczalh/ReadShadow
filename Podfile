source 'https://github.com/CocoaPods/Specs.git'
platform :ios, ‘11.0’
use_frameworks!

target 'Random' do
    pod 'Alamofire', '~> 5.0.5'
    # 上下刷新
    pod 'MJRefresh', '~> 3.2.3'
    # 自动布局
    pod 'SnapKit', '~> 5.0.1'
    #
    pod 'Kingfisher', '~> 5.8.3'
    pod 'Moya/RxSwift', '~> 14.0.0'
    #Rx
    pod 'RxSwift', '~> 5.1.1'
    pod 'RxCocoa', '~> 5.1.1'
    pod 'NSObject+Rx', '~> 5.0.2'
    #pod 'RxDataSources', '~> 4.0.1'
    #pod 'RxSwiftExt', '~> 5.1.1'
    # 键盘自动处理
    pod 'IQKeyboardManagerSwift', '~> 6.5.6'
    #
    pod 'SVProgressHUD', '~> 2.2.5'
    #pod 'NVActivityIndicatorView'
    # 轮播图
    pod 'FSPagerView', '~> 0.8.3'
    # 常用扩展
    pod 'SwifterSwift', '~> 5.2.0'
    # 皮肤管理器主题
    #pod 'SwiftTheme', '~> 0.4.7'
    # 分段
    pod 'JXSegmentedView', '~> 1.0.6'
    # 搜索
    #pod 'PYSearch', '~> 0.9.1'
    # 二维码扫描
    #pod 'swiftScan'#, '~> 1.1.5'
    # 骨架y图
    #pod 'SkeletonView', '~> 1.8.2'
    # JSON解析
    pod 'ObjectMapper', '~> 3.5.3'
    # XML/HTML解析
    #pod 'Ono', '~> 2.1.2'
    pod 'Kanna', '~> 5.2.2'
    # 加密库
    pod 'CryptoSwift', '~> 1.3.1'
    # Keychain
    #pod 'KeychainAccess'
    # 引导标记
    #pod 'Instructions', '~> 2.0.0'
    # 调试工具
    #pod 'FLEX', '~> 3.1.2', :configurations => ['Debug']
    # UI
    pod 'QMUIKit', '4.2.0'
    # 在Swift项目中获得强大的类型化，自动完成的资源，例如图像，字体和序列
    #pod 'R.swift', '~> 5.2.2'
    # 二维码生成 / 扫描
    #pod 'EFQRCode', '~> 5.1.6'
    # 腾讯云超级播放器
    pod 'SuperPlayer'
    # 任务下载
    pod 'Tiercel', '~> 3.2.0'
    # 极光推送
    pod 'JCore', '~> 2.1.8'
    pod 'JPush', '~> 3.2.8'
    #FFmpeg脚本 https://github.com/kewlbear/FFmpeg-iOS-build-script
    # 转场动画库
    #pod 'Hero', '~> 1.5.0'
    # 消息弹窗
    #pod 'SwiftMessages'
    # cell滑动删除
    pod 'SwipeCellKit', '~> 2.7.1'
    # 谷歌广告 https://developers.google.com/admob/ios/quick-start，https://apps.admob.com/v2/apps/list?pli=1
    pod 'Google-Mobile-Ads-SDK', '~> 7.53.1'
    # 音频播放
    #pod 'StreamingKit'
    # 常用的选择器组件，主要包括：日期选择器、时间选择器（DatePickerView）、地址选择器（AddressPickerView）、自定义字符串选择器（StringPickerView
    #pod 'BRPickerView'
    # 使用GCD制作的Swift，Debouncer和Throttler的现代计时器
    #pod 'Repeat'
    # OCR
    #pod 'SwiftOCR'
    # 权限
    #pod 'SPPermissions'
    # 时间表，电子表格，分页
    #pod "G3GridView"
    # 格式化和验证国际电话号码
    #pod 'PhoneNumberKit'
    # 用于提醒用户给你的 APP 打分的工具
    #pod "Appirater"
    # 支持多选、选原图和视频的图片选择器，同时有预览功能
    #pod 'TZImagePickerController'
    #pod 'TZImagePreviewController'
    # 图片裁剪
    #pod 'CropViewController'
    # 特别完整、强大的日期时间操作管理类库
    pod 'SwiftDate', '~> 6.1.0'
    # 强大的媒体缓存框架
    #pod 'KTVHTTPCache', '~> 2.0.1'
    # 微软的暗黑模式适配框架
    #pod "FluentDarkModeKit"
    # 空白页
    #pod 'DZNEmptyDataSet'
    # 浮动面板
    #pod 'FloatingPanel'
    # VasSonic是由腾讯VAS团队开发的轻量级高性能混合框架，旨在加快可在Android和iOS平台上运行的网站的首屏显示
    #pod 'VasSonic', '3.0.0'
    # 数据库
    #pod 'RealmSwift', '5.0.1'
    #pod 'WCDB'
    # 电视资源：https://github.com/iptv-org/iptv
    # p2p加速
    pod 'CDNByeSDK', '~> 1.8.0'
    #
    pod "ViewAnimator"

end
post_install do |installer|
    installer.pods_project.targets.each do |target|
        if target.name == 'Random'
            target.build_configurations.each do |config|                            
                config.build_settings['SWIFT_VERSION'] = '5.2'
            end
        end
    end
end
