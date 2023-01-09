//
//  APPreviewMedViewController.swift
//  eZen Dev
//
//  Created by Wykee on 05/01/2023.
//  Copyright © 2023 Music of Wisdom. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AVFoundation
import Speech
import Loaf

class APVisualizeViewController: BaseViewController {
    
    var isMuted = false
    var isTranscription = false
    var isVideo = false
    var isRotation = false
    
    var duration = 0.0
    var currentDuration = 0.0
    
    var timeIntvl: TimeInterval = Double(0.0)
    var cmTime = CMTime()
    
    var url = curr_file_url.address
    var transcription = ""
    var words = [Word]()
    
    
    @IBOutlet weak var transcriptionLbl: UILabel!
    
    var player: AVPlayer?
    var playerItem: AVPlayerItem?
    var sentence = ""
    var stringArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.invalidateTimer()
        self.playVoice()
    }
    
    final class func create() -> APVisualizeViewController {
        let view = APVisualizeViewController(nibName: "APVisualizeViewController", bundle: nil)
        return view
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    public func rotatePotrait(){
        let delegate = UIApplication.shared.delegate as! APAppDelegate
        delegate.orientation = .portrait
        let value = UIInterfaceOrientation.portrait.rawValue
        
        if #available(iOS 16.0, *) {
            DispatchQueue.main.async {
                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                self.setNeedsUpdateOfSupportedInterfaceOrientations()
                self.navigationController?.setNeedsUpdateOfSupportedInterfaceOrientations()
                windowScene?.requestGeometryUpdate(.iOS(interfaceOrientations: .portrait)) { error in
                    print("error",error)
                    print(windowScene?.effectiveGeometry ?? "")
                }
            }
        }else{
            UIDevice.current.setValue(value, forKey: "orientation")
            self.viewWillAppear(true)
        }
    }
    
    public func rotateLandscape(){
        let delegate = UIApplication.shared.delegate as! APAppDelegate
        delegate.orientation = .landscapeRight
        let value = UIInterfaceOrientation.landscapeRight.rawValue
        
        if #available(iOS 16.0, *) {
            DispatchQueue.main.async {
                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                self.setNeedsUpdateOfSupportedInterfaceOrientations()
                self.navigationController?.setNeedsUpdateOfSupportedInterfaceOrientations()
                windowScene?.requestGeometryUpdate(.iOS(interfaceOrientations: .landscapeRight)) { error in
                    print("error",error)
                    print(windowScene?.effectiveGeometry ?? "")
                    
                }
                
            }
        }else{
            UIDevice.current.setValue(value, forKey: "orientation")
            self.viewWillAppear(true)
        }
    }
    
    @IBAction func closePage(_ sender: Any) {
        self.invalidateTimer()
        self.rotatePotrait()
        
        let previewVC = Accessors.AppDelegate.delegate.appDiContainer.makePreviewDIContainer().makePreviewViewController()
        previewVC.isEnhance = true
        previewVC.transcription = self.transcription
        previewVC.words = self.words
        previewVC.sentencesArray = self.sentencesArray
        previewVC.timeStampStart = self.timeStampStart
        previewVC.timeStampEnd = self.timeStampEnd
        previewVC.modalPresentationStyle = .fullScreen
        previewVC.modalTransitionStyle = .coverVertical
        self.customPresent(vc: previewVC, duration: 0.2, type: .fromLeft)
    }
    
    @IBAction func changeOrientation(_ sender: Any) {
        if isRotation{
            isRotation = false
            self.rotatePotrait()

        }else{
            isRotation = true
            self.rotateLandscape()
        }
    }
    
    @IBAction func playMusic(_ sender: Any) {
        //mute and unmute audio
        if isMuted{
            self.player?.isMuted = false
            isMuted = false
//            Loaf("Audio is Unmuted",
//                 state: .success, location: .top, presentingDirection: .vertical, dismissingDirection: .vertical, sender: self).show()
        }else{
            self.player?.isMuted = true
            isMuted = true
//            Loaf("Audio is Muted",
//                 state: .error, location: .top, presentingDirection: .vertical, dismissingDirection: .vertical, sender: self).show()
        }
    }
    
    @IBAction func showTranscription(_ sender: Any) {
        //show or hide transcription
        if isTranscription{
            isTranscription = false
            self.transcriptionLbl.isHidden = false
//            Loaf("Transcription is Live",
//                 state: .success, location: .top, presentingDirection: .vertical, dismissingDirection: .vertical, sender: self).show()
        }else{
            isTranscription = true
            self.transcriptionLbl.isHidden = true
//            Loaf("Transcription is Hidden",
//                 state: .error, location: .top, presentingDirection: .vertical, dismissingDirection: .vertical, sender: self).show()
        }
    }
    
    
    @IBAction func showVideo(_ sender: Any) {
        //show or hide video
    }
    
    var sentencesArray = [String]()
    var timeStampStart = [Double]()
    var timeStampEnd = [Double]()
    
    var counter = 0
    
    func playVoice(){
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            do {
                try AVAudioSession.sharedInstance().setActive(true)
                playerItem = AVPlayerItem(url: self.url!)
                player = AVPlayer(playerItem: playerItem)
                player?.play()

                player!.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(0.0001, preferredTimescale: 60000), queue: DispatchQueue.main) { (CMTime) -> Void in
                    if self.player!.currentItem?.status == .readyToPlay {
                        let time : Float64 = CMTimeGetSeconds(self.player!.currentTime());

                        let duration : CMTime = self.playerItem!.asset.duration
                        let _ : Float64 = CMTimeGetSeconds(duration)
                        
                        self.currentDuration = time
                        
                        for sentence in self.sentencesArray{
                            if sentence != ""{
                                if self.counter <= self.sentencesArray.count - 1{
                                    let start = self.timeStampStart[self.counter]
                                    let end = self.timeStampEnd[self.counter]
                                    
                                    let range = start...end
                                    
                                    if range.contains(time){
                                        print("NNNN.....\(self.sentencesArray[self.counter])......\(self.counter)")
                                        self.transcriptionLbl.text = self.sentencesArray[self.counter]
                                        self.counter += 1
                                    }
                                }
                            }
                        }
                        
//                        for word in self.words{
//                            let start = word.start
//                            let end = word.end
//                            let punctuatedWord = word.punctuatedWord
//
//                            let range = start...end
//
//                            if range.contains(time){
//
//                                if let lastString = self.stringArray.last, lastString == punctuatedWord{
//                                    //print("Word... is contained......\(self.stringArray)")
//                                    //self.stringArray.remove(at: 0)
//                                }else{
//
//                                    if self.stringArray.count > 2 {
//                                        self.stringArray.remove(at: 0)
//                                        self.sentence = self.stringArray.joined(separator: " ")
//                                        //print("Updated.. sentence: \(self.sentence)")
//                                    } else {
//                                        //print("Number.. of words is not greater than 4.")
//                                    }
//
//                                    self.stringArray.append(punctuatedWord)
//                                    self.sentence = self.stringArray.joined(separator: " ")
//
//                                    self.transcriptionLbl.text = self.sentence
//                                    //self.transcriptionLbl.animate(newText: self.sentence ?? "", characterDelay: 0.1)
//                                }
//
//                            }
//                        }
                        
                    }
                }
                
                NotificationCenter.default.addObserver(self,selector: #selector(playerDidFinishPlaying),name: .AVPlayerItemDidPlayToEndTime,object: player?.currentItem)

            } catch _ as NSError {
                print("")
            }
        } catch _ as NSError {
            print("")
        }
     
        
    }

    @objc func playerDidFinishPlaying(note: NSNotification) {
        self.currentDuration = 0.0
        self.invalidateTimer()
        self.transcriptionLbl.text = ""
        self.stringArray.removeAll()
        self.sentence = ""
        //self.dismiss(animated: true, completion: nil)
    }

    
    func invalidateTimer(){
        self.player?.pause()
    }
    
    
}
