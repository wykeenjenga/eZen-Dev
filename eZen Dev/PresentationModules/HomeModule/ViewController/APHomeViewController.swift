//
//  APHomeViewController.swift
//  eZen Dev
//
//  Created by Wykee on 19/12/2022.
//  Copyright © 2022 Music of Wisdom. All rights reserved.
//

import UIKit

class APHomeViewController: UIViewController {
    
    var viewModel: APHomeViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    final class func create(with viewModel: APHomeViewModel) -> APHomeViewController {
        let view = APHomeViewController(nibName: "APHomeViewController", bundle: nil)
        view.viewModel = viewModel
        return view
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        var documentsUrl = urls[0]
        
        let ext = documentsUrl.pathExtension
        
        let path = documentsUrl.deletingLastPathComponent()

        let fileNameBefore = documentsUrl.lastPathComponent
        let fileNameAfter = "adminSample.\(ext)"
        
        do {
            let documentDirectory = URL(fileURLWithPath: "\(path)")
            let originPath = documentDirectory.appendingPathComponent("\(fileNameBefore)")
            let destinationPath = documentDirectory.appendingPathComponent("\(fileNameAfter)")
            
            let fileManager = FileManager.default
            
            if fileManager.fileExists(atPath: "\(destinationPath.path)") {
                try fileManager.removeItem(atPath: destinationPath.path)
            }else{
                //self.viewModel.route.value = .error
            }
            try fileManager.moveItem(at: originPath, to: destinationPath)
            
            //use destination file path... to upload
            
        } catch {
            //self.viewModel.route.value = .error
        }
    }
    
}
