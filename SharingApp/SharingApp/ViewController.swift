//
//  ViewController.swift
//  SharingApp
//
//  Created by yasmin mohsen on 8/13/20.
//  Copyright © 2020 yasmin mohsen. All rights reserved.
//

import UIKit
import Firebase
import PDFKit

class ViewController: UIViewController {
    
    @IBOutlet weak var noFileLabel: UILabel!
    @IBOutlet weak var pdfView: PDFView!
    @IBOutlet weak var uploadBtn: UIButton!
    
    @IBOutlet weak var removeBtn: UIButton!
    
    var uploadsArray = [Uploads]()
    
    var ref: DatabaseReference!
    var savingFlag :Bool!
    var fileData=Data()
    var newFileName:String!
    var uploadsObj :Uploads!
    
    @IBOutlet weak var activityIndecator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        ref = Database.database().reference()
        
        activityIndecator.alpha=0;
        uploadBtn.alpha=0;
        removeBtn.alpha=0;
        
        getDataFromSharing()
    }
    
    @objc func willEnterForeground() {
        activityIndecator.alpha=0;
        uploadBtn.alpha=0;
         removeBtn.alpha=0;
        getDataFromSharing()
        
    }
    
    
    
    
    
    
    
    @IBAction func btn(_ sender: Any) {
        let groupPath = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier:"group.com.yasminmhosen.SharingApp")
        
        var defaults = UserDefaults(suiteName:"group.com.yasminmhosen.SharingApp")
        defaults?.synchronize()
        
        if savingFlag==true{
            
            
            
            activityIndecator.alpha=1
            activityIndecator.startAnimating()
            let fIRStorage = Storage.storage()
            
            // reference of the storage
            let storageRef = fIRStorage.reference()
            //
            let fileRef = storageRef.child("Uploads_Pdf/\(newFileName!)")
            
            
            
            
            
            let uploadTask = fileRef.putData(fileData, metadata: nil) { (metadata, error) in
                guard let metadata = metadata else {
                    print("meta data derror")// Uh-oh, an error occurred!
                    self.activityIndecator.stopAnimating()
                    self.activityIndecator.alpha=0
                    self.showToast(message: "Unable To Upload File!!")
                    return
                }
                // Metadata contains file metadata such as size, content-type.
                let size = metadata.size
                // You can also access to download URL after upload.
                fileRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        self.activityIndecator.stopAnimating()
                        self.activityIndecator.alpha=0
                        self.showToast(message: "Unable To Upload File!!")
                        return
                    }
                    print("url is \(url)")
                    let urlString = url?.absoluteString
                    self.uploadsObj = Uploads(name: self.newFileName, fileData: self.fileData as! Data, sharedUrl: urlString!)
                    self.uploadsObj.sharedUrl=urlString!
                    self.activityIndecator.stopAnimating()
                    self.activityIndecator.alpha=0
                    self.pdfView.alpha=0
                    self.showToast(message: "Sucessful Uploading File ✅")
                    self.noFileLabel.alpha=1
                    self.removeBtn.alpha=0
                    self.uploadBtn.alpha=0
                    
                    
                    // retrieving data from userDefaults
                    
                    if  let retrieviedPdfFiles = UserDefaults.standard.data(forKey: "files"){
                        self.uploadsArray = try! JSONDecoder().decode([Uploads].self, from: retrieviedPdfFiles)
                    }
                    
                    
                    
                    if (self.uploadsArray.count != 0){
                        for u in self.uploadsArray {
                            
                            if (u.name == self.uploadsObj.name){
                                break
                            }
                            else{
                                self.uploadsArray.append(self.uploadsObj)
                            }
                            
                        }
                    }
                    else{
                        self.uploadsArray.append(self.uploadsObj)
                    }
                    
                    
                    
                    
                    
                    // saving in user defaults
                    
                    let savedPdfFiles = try! JSONEncoder().encode(self.uploadsArray)
                    UserDefaults.standard.set(savedPdfFiles, forKey: "files")
                    
                    
                    
                    
                    
                    
                    
                    
                    // saving in fireBase :
                    
                    
                    var safeFileName=self.newFileName.replacingOccurrences(of: ".", with: "-")
                    safeFileName=safeFileName.replacingOccurrences(of: "@", with: "-")
                    let pdfObj = try! DictionaryEncoder.encode(self.uploadsObj)
                    
                    
                    
                    
                    self.ref.child("Uploads").child("\(safeFileName)").setValue(pdfObj)
                    
                    var defaults = UserDefaults(suiteName: "group.com.yasminmhosen.SharingApp")
                    defaults?.set(nil, forKey: "pdfData")
                    
                    
                }
            }
            
            
            
            
        }
        else{
            print("no items")
        }
        
        
        
        
        
    }
    
    
    
    
    
    
    
    func getDataFromSharing(){
        
        
        let groupPath = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier:"group.com.yasminmhosen.SharingApp")
        
        var defaults = UserDefaults(suiteName:"group.com.yasminmhosen.SharingApp")
        defaults?.synchronize()
        
        if let restoredValue = defaults!.string(forKey:"pdfData"){
            
            savingFlag = true
            uploadBtn.alpha=1
             removeBtn.alpha=1
            
            
            let data = NSData(base64Encoded: restoredValue, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
            
            
            pdfView.autoScales = true
            pdfView.displayMode = .singlePageContinuous
            pdfView.displayDirection = .vertical
            pdfView.document = PDFDocument(data: data as! Data)
            noFileLabel.alpha=0
            pdfView.alpha=1
            
            
            
            fileData=data as! Data
            
            
            
            let fileName = defaults!.string(forKey:"fileName")!
            newFileName=fileName
            
            // retrieving data from userDefaults
            //
            //                              if  let retrieviedPdfFiles = UserDefaults.standard.data(forKey: "files"){
            //                                   self.uploadsArray = try! JSONDecoder().decode([Uploads].self, from: retrieviedPdfFiles)
            //                               }
            //
            //                                      uploadsObj = Uploads(name: fileName, fileData: data as! Data, sharedUrl: "")
            //
            //                        if (uploadsArray.count != 0){
            //                            for u in uploadsArray {
            //
            //                                if (u.fileData == uploadsObj.fileData){
            //                                  break
            //                                }
            //                                else{
            //                                       self.uploadsArray.append(uploadsObj)
            //                                }
            //
            //                            }
            //                        }
            //                        else{
            //                            self.uploadsArray.append(uploadsObj)
            //                        }
            //
            //
            //
            //
            //
            //                               // saving in user defaults
            //
            //                               let savedPdfFiles = try! JSONEncoder().encode(self.uploadsArray)
            //                               UserDefaults.standard.set(savedPdfFiles, forKey: "files")
            //
        }
        else{
            noFileLabel.alpha=1
        }
        
        
    }
    
    
    
    
    
    
    @IBAction func removeBtn(_ sender: Any) {
        
   
        
        
        let alert = UIAlertController(title: "Remove File", message: "are you sure you want to remove this file", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "yes", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) -> () in
                  self.activityIndecator.alpha=0
                                       self.pdfView.alpha=0
                                       
                                       self.noFileLabel.alpha=1
            self.removeBtn.alpha=0
            self.uploadBtn.alpha=0
                     var defaults = UserDefaults(suiteName: "group.com.yasminmhosen.SharingApp")
                                      defaults?.set(nil, forKey: "pdfData")
                               }))
        
        
               alert.addAction(UIAlertAction(title: "cancel", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) -> () in
                self.dismiss(animated: true, completion: nil)
                                           }))
                    
               
                   self.present(alert, animated: true, completion: nil)
           
        
        
        
        
        
        
    }
    
    
    
    
    
    
    func showToast(message:String){
        
        let alert = UIAlertController(title: "Upload File", message: message, preferredStyle: .alert)
        alert.view.alpha = 0.5
        alert.view.backgroundColor = .black
        alert.view.layer.cornerRadius = 15
        self.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3.0, execute: {
            
            alert.dismiss(animated: true, completion: nil)
        })
        
    }
    
    
}

struct DictionaryEncoder {
    static func encode<T>(_ value: T) throws -> [String: Any] where T: Codable {
        let jsonData = try JSONEncoder().encode(value)
        return try JSONSerialization.jsonObject(with: jsonData) as? [String: Any] ?? [:]
    }
}
