//
//  PDFViewer.swift
//  SharingApp
//
//  Created by yasmin mohsen on 8/19/20.
//  Copyright © 2020 yasmin mohsen. All rights reserved.
//

import UIKit
import PDFKit

class PDFViewer: UIViewController {
    @IBOutlet weak var pdfView: PDFView!
    var data = Data()
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        pdfView.autoScales = true
        pdfView.displayMode = .singlePageContinuous
        pdfView.displayDirection = .vertical
          pdfView.document = PDFDocument(data: data as! Data)
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
