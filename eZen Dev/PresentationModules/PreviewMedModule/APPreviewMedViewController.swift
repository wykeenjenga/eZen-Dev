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

class APPreviewMedViewController: UIViewController {
    
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
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.invalidateTimer()
        self.playVoice()
    }
    
    @IBAction func closePage(_ sender: Any) {
        
    }
    
    @IBAction func changeOrientation(_ sender: Any) {
        
    }
    
    @IBAction func playMusic(_ sender: Any) {
        
    }
    
    @IBAction func showTranscription(_ sender: Any) {
        
    }
    
    
    @IBAction func showVideo(_ sender: Any) {
        
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
                        let seconds : Float64 = CMTimeGetSeconds(duration)

                        self.start_at.text = self.stringFromTimeInterval(interval: time)
                        
                        self.end_at.text = self.stringFromTimeInterval(interval: seconds)
                        
                        self.playerProgressBar.maximumValue = Float(seconds)
                        self.playerProgressBar.isContinuous = true
                        
                        self.currentDuration = time
                        
                        self.playerProgressBar.setValue(Float(time), animated: true)
                        
                        for word in self.words{
                            let start = word.start
                            let end = word.end
                            let punctuatedWord = word.punctuatedWord

                            let range = start...end

                            if range.contains(time){
                                
                                if let lastString = self.stringArray.last, lastString == punctuatedWord{
                                    print("Word is contained......\(self.stringArray)")
                                    //self.stringArray.remove(at: 0)
                                }else{
                                    
                                    if self.stringArray.count > 3 {
                                        self.stringArray.remove(at: 0)
                                        self.sentence = self.stringArray.joined(separator: " ")
                                        print("Updated sentence: \(self.sentence)")
                                    } else {
                                        print("Number of words is not greater than 4.")
                                    }
                                    
                                    self.stringArray.append(punctuatedWord)
                                    self.sentence = self.stringArray.joined(separator: " ")
                                    
                                    self.transcriptionLbl.text = self.sentence
                                    //self.transcriptionLbl.animate(newText: self.sentence ?? "", characterDelay: 0.1)
                                }

                            }
                        }
                        
                    }
                }
                
                self.isPlaying = true
                
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
    }

    
    func invalidateTimer(){
        self.player?.pause()
        self.playerIcon.image = UIImage(systemName: "play.fill")
        self.isPlaying = false
    }
    
    
}
