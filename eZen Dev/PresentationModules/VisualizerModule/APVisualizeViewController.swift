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
import AVKit

class APVisualizeViewController: BaseViewController {
    
    var isMuted = false
    var isTranscription = false
    var isVideo = false
    var isRotation = false
    var isMenu = false
    
    var duration = 0.0
    var currentDuration = 0.0
    
    var timeIntvl: TimeInterval = Double(0.0)
    var cmTime = CMTime()
    
    var url = curr_file_url.address
    var transcription = ""
    var words = [Utterance]()
    
    
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var menuView: CustomView!
    @IBOutlet weak var menuBtn: APBindingButton!
    @IBOutlet weak var videoBtn: APBindingButton!
    @IBOutlet weak var transcriptionBtn: APBindingButton!
    @IBOutlet weak var musicBtn: APBindingButton!
    @IBOutlet weak var transcriptionLbl: UILabel!
    
    var player: AVPlayer?
    var playerItem: AVPlayerItem?
    var player2: AVAudioPlayer?
    var playerItem2: AVPlayerItem?
    
    var videoPlayer: AVPlayer?
    
    var sentence = ""
    var stringArray = [String]()
    
    var sentencesArray = [String]()
    var timeStampStart = [Double]()
    var timeStampEnd = [Double]()
    var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.invalidateTimer()
        
        self.playVoice()
        self.playBackgroundMusic()
        
        self.menuView.isHidden = true
        
        isMuted = false
        isTranscription = false
        isVideo = false
        isRotation = false
        isMenu = false
    }
    
    final class func create() -> APVisualizeViewController {
        let view = APVisualizeViewController(nibName: "APVisualizeViewController", bundle: nil)
        return view
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Sentences count....\(self.self.sentencesArray)")
        self.playVideo()
    }
    
    func playVideo() {
//         get the path string for the video from assets
        let videoString: String? = Bundle.main.path(forResource: "vidaa", ofType: "mp4")
        print("......\(videoString)")
        guard let unwrappedVideoPath = videoString else {
            debugPrint("vidaa.mp4 not found")
            return
        }
        // convert the path string to a url
        let videoUrl = URL(fileURLWithPath: unwrappedVideoPath)
        
        print("Video URl.....\(videoUrl)")

        // initialize the video player with the url
        videoPlayer = AVPlayer(url: videoUrl)

        // create a video layer for the player
        let layer = AVPlayerLayer(player: videoPlayer)

        // make the layer the same size as the container view
        layer.frame = self.videoView.bounds

        // make the video fill the layer as much as possible while keeping its aspect size
        layer.videoGravity = AVLayerVideoGravity.resizeAspectFill

        // add the layer to the container view
        self.videoView.layer.addSublayer(layer)

        videoPlayer?.play()
        
//        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { notification in
//            self.videoPlayer?.seek(to: CMTime.zero)
//            self.videoPlayer?.play()
//        }
    }
    
    func playBackgroundMusic(){
        guard let url = Bundle.main.url(forResource: "Music", withExtension: "mp3") else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            player2 = try? AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            guard let player = player2 else { return }
            player.play()
            player.volume = 0.6
        } catch let error {
            print(error.localizedDescription)
        }
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
        if isMenu{
            isMenu = false
            self.menuView.isHidden = true
            //slide uiview down
            UIView.animate(withDuration: 0.4, animations: {
                self.menuView.frame.origin.y += 10
            }, completion: nil)
            self.menuBtn.setImage(UIImage(named: "menu"), for: .normal)
        }else{
            isMenu = true
            self.menuView.isHidden = false
            //slide uiview up
            UIView.animate(withDuration: 0.4, animations: {
                self.menuView.frame.origin.y = +10
                self.menuView.frame.origin.y -= 10
            }, completion: nil)
            self.menuBtn.setImage(UIImage(named: "cancel"), for: .normal)
        }
    }
    
    @IBAction func closePage(_ sender: Any) {
        self.invalidateTimer()
        self.rotatePotrait()
        
        let previewVC = Accessors.AppDelegate.delegate.appDiContainer.makeTranscriptDIContainer().makeTranscriptViewController()
        //previewVC.isEnhance = true
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
            self.musicBtn.setImage(UIImage(named: "music_on"), for: .normal)
        }else{
            self.player?.isMuted = true
            isMuted = true
            self.musicBtn.setImage(UIImage(named: "music_off"), for: .normal)
        }
    }
    
    @IBAction func showTranscription(_ sender: Any) {
        //show or hide transcription
        if isTranscription{
            isTranscription = false
            self.transcriptionLbl.fadeIn(completion: {_ in
                self.transcriptionLbl.isHidden = false
            })
            self.transcriptionBtn.setImage(UIImage(named: "text_on"), for: .normal)
        }else{
            isTranscription = true
            self.transcriptionLbl.fadeOut(completion: {_ in
                self.transcriptionLbl.isHidden = true
            })
            self.transcriptionBtn.setImage(UIImage(named: "text_off"), for: .normal)
        }
    }
    
    @IBAction func showVideo(_ sender: Any) {
        if isVideo{
            isVideo = false
            self.videoBtn.setImage(UIImage(named: "video_on"), for: .normal)
            self.videoView.fadeIn(completion: {_ in
                self.videoView.isHidden = false
            })
        }else{
            isVideo = true
            self.videoBtn.setImage(UIImage(named: "video_off"), for: .normal)
            self.videoView.fadeOut(completion: {_ in
                self.videoView.isHidden = true
            })
        }
    }
    
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
        self.videoPlayer?.pause()
        self.player2?.pause()
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

extension UIView {
    func fadeIn(_ duration: TimeInterval = 0.3, delay: TimeInterval = 1.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
    }, completion: completion)  }

    func fadeOut(_ duration: TimeInterval = 0.3, delay: TimeInterval = 1.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.0
    }, completion: completion)
   }
    
}
