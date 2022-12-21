//
//  APHomeViewController.swift
//  eZen Dev
//
//  Created by Wykee on 19/12/2022.
//  Copyright © 2022 Music of Wisdom. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices
import UniformTypeIdentifiers

class APHomeViewController: BaseViewController, UIDocumentPickerDelegate{
    
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
        self.bindViewModel()
    }
    
    func bindViewModel(){
        self.viewModel.route.bind = { [weak self] route in
            DispatchQueue.main.async {
                switch route{
                case .activity(let isLoading):
                    if isLoading{
                        self?.showHUD()
                    }else{
                        self?.hideHUD()
                    }
                case .error:
                    self?.showAlert(title: "Error", message: "We are experiencing technical difficulties. Please try again later")
                    break
                case .isPreview:
                    let homeVC = Accessors.AppDelegate.delegate.appDiContainer.makePreviewDIContainer().makePreviewViewController()
                    homeVC.modalPresentationStyle = .fullScreen
                    homeVC.modalTransitionStyle = .coverVertical
                    self?.present(homeVC, animated: true, completion: nil)
                    break
                default:
                    break
                }
            }
        }
    }
    
    @IBAction func importVoiceOver(_ sender: Any) {
        let documentPicker = UIDocumentPickerViewController(documentTypes: [String(kUTTypeAudio)], in: .import)
        documentPicker.delegate = self
        self.present(documentPicker, animated: true)
    }
    
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        let documentsUrl = urls[0]
        
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
                self.viewModel.route.value = .error
            }
            try fileManager.moveItem(at: originPath, to: destinationPath)
            
            //use destination file path... to upload
            //file_url.address = destinationPath
            self.uploadAudio(filePath: destinationPath)
            //self.viewModel.route.value = .isPreview
            
        } catch {
            self.viewModel.route.value = .error
        }
    }
    
    func uploadAudio(filePath: URL?){
        print("We are uploading")
        self.viewModel.initFile.value = filePath
        self.viewModel.enhanceAudio()
    }
    
}
