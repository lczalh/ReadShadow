//
//  ViewController.swift
//  Random
//
//  Created by 刘超正 on 2019/9/20.
//  Copyright © 2019 刘超正. All rights reserved.
//

import UIKit

class RootClass : NSObject, NSCoding, Mappable{

    var msg : String?
    var result : [String]?
    var status : Int?


    class func newInstance(map: Map) -> Mappable?{
        return RootClass()
    }
    required init?(map: Map){}
    private override init(){}

    func mapping(map: Map)
    {
        msg <- map["msg"]
        result <- map["result"]
        status <- map["status"]
        
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
         msg = aDecoder.decodeObject(forKey: "msg") as? String
         result = aDecoder.decodeObject(forKey: "result") as? [String]
         status = aDecoder.decodeObject(forKey: "status") as? Int

    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
    {
        if msg != nil{
            aCoder.encode(msg, forKey: "msg")
        }
        if result != nil{
            aCoder.encode(result, forKey: "result")
        }
        if status != nil{
            aCoder.encode(status, forKey: "status")
        }

    }

}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "1234"
       // moyaProvider.rx.request(<#MultiTarget#>)
        //vm.output.section.sub
//        UIColor.init(rgba: <#T##String#>)
      // UIColor.cz.qqq()
        
    
//        a.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
//        a.backgroundColor = UIColor.red
      //  SVProgressHUD.showProgress(<#T##progress: Float##Float#>, status: <#T##String?#>)
      //  self.present(QMUIImagePickerPreviewViewController(), animated: true, completion: nil)
        
    }
    
    func print1(_ items: Any..., file: String = #file, method: String = #function, line: Int = #line) {
        #if DEBUG
        print("类名:\((file as NSString).lastPathComponent),方法名:\(method),第\(line)行,内存地址:\(Unmanaged.passUnretained(items as AnyObject).toOpaque()),打印内容:\(items)")
        #endif
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        moyaProvider
//            .rx
//            .request(MultiTarget(HighSpeedDataNetworkServices.getNewsTypeList(appkey: "ac0f7297750aa010")))
//            .map{
//                let a = try! $0.mapJSON() as? [String : Any] ?? [:]
//                return Mapper<RootClass>().map(JSON: a) ?? [:]
//            }
//            .subscribe(onSuccess: { (r) in
//                    CZCommon.printf(r)
//            }) { (r) in
//                    CZCommon.printf(r)
//            }.disposed(by: rx.disposeBag)
    }
}

