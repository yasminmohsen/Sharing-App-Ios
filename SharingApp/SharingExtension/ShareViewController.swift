////
////  ShareViewController.swift
////  SharingExtension
////
////  Created by yasmin mohsen on 8/13/20.
////  Copyright © 2020 yasmin mohsen. All rights reserved.
////
//
//import UIKit
//import Social
//
//class ShareViewController: SLComposeServiceViewController {
//
//    override func isContentValid() -> Bool {
//        // Do validation of contentText and/or NSExtensionContext attachments here
//        return true
//    }
//
//    override func didSelectPost() {
//        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
//
//        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
//        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
//    }
//
//    override func configurationItems() -> [Any]! {
//        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
//        return []
//    }
//
//}


import UIKit
import Social
import PDFKit




class ShareViewController:UIViewController  {
    
    override func viewDidLoad() {
  
        
            let alert = UIAlertController(title: "Share File", message: "Do you want to share this file with sharing app", preferredStyle: .alert)
        
                alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) -> () in
//                self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
                    let x = self.extensionContext?.inputItems.description
                    print(x)
                    if let item = self.extensionContext?.inputItems.first as? NSExtensionItem,
                        let itemProvider = item.attachments?.first as? NSItemProvider,
                        itemProvider.hasItemConformingToTypeIdentifier("public.file-url") {
                        itemProvider.loadItem(forTypeIdentifier: "public.file-url", options: nil) { (url, error) in
                            if let shareURL = url as? URL {
                                print(shareURL.lastPathComponent)
                            
                                var x = shareURL.lastPathComponent
                                
                           let fileManager = FileManager.default
                            print(fileManager.fileExists(atPath:shareURL.path))
                            let myData = NSData(contentsOfFile: shareURL.path)
                                let newStr = myData!.base64EncodedString(options: NSData.Base64EncodingOptions())
                               
                                var defaults = UserDefaults(suiteName: "group.com.yasminmhosen.SharingApp")
                                defaults?.set(newStr, forKey: "pdfData")
                                defaults?.set(x, forKey: "fileName")
                                
                                defaults?.synchronize()
                           
                            }
                            self.extensionContext?.completeRequest(returningItems: [], completionHandler:nil)
                        }
                    }
                }))
        
        
        alert.addAction(UIAlertAction(title: "cancel", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) -> () in
           self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
                           
                        }))
        
        
            self.present(alert, animated: true, completion: nil)
    
    
    
    
}
    
    
    
    
    
}

