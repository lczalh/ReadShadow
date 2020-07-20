//
//  ShareViewController.swift
//  Share
//
//  Created by yu mingming on 2020/7/15.
//  Copyright © 2020 刘超正. All rights reserved.
//

import UIKit
import Social

class ShareViewController: SLComposeServiceViewController {

    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }

    override func didSelectPost() {
        if let item = extensionContext?.inputItems.first as? NSExtensionItem {
            if let itemProvider = item.attachments?.first {
                if itemProvider.hasItemConformingToTypeIdentifier("public.url") {
                    itemProvider.loadItem(forTypeIdentifier: "public.url", options: nil, completionHandler: { (url, error) -> Void in
                        if let shareURL = url as? NSURL {
                         //   print(shareURL.absoluteString)
                            let scheme = "ReadShadow://\(shareURL.absoluteString ?? "")"
                            let url: URL = URL(string: scheme)!
                            let context = NSExtensionContext()
                            context.open(url, completionHandler: nil)
                            var responder = self as UIResponder?
                            let selectorOpenURL = sel_registerName("openURL:")
                            while (responder != nil) {
                                if responder!.responds(to: selectorOpenURL) {
                                    responder!.perform(selectorOpenURL, with: url)
                                    break
                                }
                                responder = responder?.next
                            }
                        }
                        self.extensionContext?.completeRequest(returningItems: [], completionHandler:nil)
                    })
                }
            }
        }
       // jumpBackToMainApplication()
       // self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }

    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }
    
    
    /// 跳回主应用
    func jumpBackToMainApplication() {
        
        var responder: UIResponder? = self as UIResponder
        
      //  UIApplication.op
        while responder != nil {
            if responder is UIApplication {
                print(111)
            }
//            let selector = NSSelectorFromString("openURL:")
//            if (responder?.responds(to: selector)) != nil {
//                responder?.perform(selector, with: URL(string: "ReadShadow://"), afterDelay: 0.1)
//                break
//            }
            responder = responder?.next
        }
    }
}
