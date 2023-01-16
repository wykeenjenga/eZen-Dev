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
    var words = [Utterance]()
    
    
    @IBOutlet weak var menuView: CustomView!
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var videoBtn: UIButton!
    @IBOutlet weak var transcriptionBtn: UIButton!
    @IBOutlet weak var musicBtn: UIButton!
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
        print("Sentences count....\(self.self.sentencesArray)")
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
    
    @IBAction func onMenuAction(_ sender: Any) {
        print("MENU is clicked")
    }
    
    @IBAction func closePage(_ sender: Any) {
        self.invalidateTimer()
        self.rotatePotrait()
        
        let previewVC = Accessors.AppDelegate.delegate.appDiContainer.makePreviewDIContainer().makePreviewViewController()
        previewVC.isEnhance = true
        previewVC.words = self.words
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
            self.musicBtn.setBackgroundImage(UIImage(named: "music_on"), for: .normal)
//            Loaf("Audio is Unmuted",
//                 state: .success, location: .top, presentingDirection: .vertical, dismissingDirection: .vertical, sender: self).show()
        }else{
            self.player?.isMuted = true
            isMuted = true
            self.musicBtn.setBackgroundImage(UIImage(named: "music_off"), for: .normal)
//            Loaf("Audio is Muted",
//                 state: .error, location: .top, presentingDirection: .vertical, dismissingDirection: .vertical, sender: self).show()
        }
    }
    
    @IBAction func showTranscription(_ sender: Any) {
        //show or hide transcription
        if isTranscription{
            isTranscription = false
            self.transcriptionLbl.isHidden = false
            self.transcriptionBtn.setBackgroundImage(UIImage(named: "text_off"), for: .normal)
//            Loaf("Transcription is Live",
//                 state: .success, location: .top, presentingDirection: .vertical, dismissingDirection: .vertical, sender: self).show()
        }else{
            isTranscription = true
            self.transcriptionLbl.isHidden = true
            self.transcriptionBtn.setBackgroundImage(UIImage(named: "text_on"), for: .normal)
//            Loaf("Transcription is Hidden",
//                 state: .error, location: .top, presentingDirection: .vertical, dismissingDirection: .vertical, sender: self).show()
        }
    }
    
    var isAnimation = false
    
    @IBAction func showVideo(_ sender: Any) {
        //show or hide video
        if isAnimation{
            isAnimation = false
        }else{
            isAnimation = true
        }
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
                        
                        for sentence in self.words{
                            
                            let start = sentence.start
                            let end = sentence.end
                            let punctuatedWord = sentence.transcript

                            let range = start...end
                            
                            if range.contains(time){
                                self.transcriptionLbl.text = punctuatedWord
//                                print(">>>>>>>>>.\(punctuatedWord)....\(start)......\(end)")
//                                print("")
                            }else{
                                if time > end{
                                    self.transcriptionLbl.text = ""
                                }
                            }
                            
                        }
                        
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


class CustomView: UIView{
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for subview in subviews {
            if subview.frame.contains(point) {
                return true
            }
        }
        return false
    }
}
