//
//  APPreviewAudioViewController.swift
//  eZen Dev
//
//  Created by Wykee on 20/12/2022.
//  Copyright © 2022 Music of Wisdom. All rights reserved.
//

struct file_url {
    static var address : URL?
}

import UIKit
import Alamofire
import SwiftyJSON
import AVFoundation
import Speech

class APPreviewAudioViewController: BaseViewController {
    
    var asset: AVURLAsset!
    let outputFileName = "output"
    var isPlaying: Bool = false
    var isSegments: Bool = false
    var isSaved: Bool = false
    
    var duration = 0.0
    var currentDuration = 0.0
    
    var timeIntvl: TimeInterval = Double(0.0)
    var cmTime = CMTime()
    
    var url = file_url.address
    
    
    @IBOutlet weak var start_at: UILabel!
    @IBOutlet weak var end_at: UILabel!
    @IBOutlet var playerIcon: UIImageView!

    @IBOutlet var playerProgressBar: UISlider!
    
    var start1 : Double = 0
    var end1 : Double = 10
    
    var isEnhance = true
    var viewModel: APHomeViewModel!
 
    @IBAction func playVoiceOver(_ sender: Any) {
        if isPlaying{
            self.pausePlayer()
        }else{
            self.playPlayer()
        }
    }
    
    @IBAction func exit(_ sender: Any) {
        self.invalidateTimer()
        let homeVC = Accessors.AppDelegate.delegate.appDiContainer.makeHomeDIContainer().makeHomeViewController()
        homeVC.modalPresentationStyle = .fullScreen
        homeVC.modalTransitionStyle = .coverVertical
        self.present(homeVC, animated: true, completion: nil)
    }
    
    @IBAction func saveAndContinue(_ sender: Any) {
        self.invalidateTimer()
        self.saveRecordedFile(url: url!)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        asset = AVURLAsset(url: url!, options: [AVURLAssetPreferPreciseDurationAndTimingKey : true])
        
        let length = Float(asset.duration.value) / Float(asset.duration.timescale)
        end1 = Double(length)
        
        end_at.text = stringFromTimeInterval(interval: TimeInterval(Int(end1)))

    }
    
    
    final class func create(with viewModel: APHomeViewModel) -> APPreviewAudioViewController {
        let view = APPreviewAudioViewController(nibName: "APPreviewAudioViewController", bundle: nil)
        view.viewModel = viewModel
        return view
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        playerProgressBar.minimumValue = 0
        playerProgressBar.addTarget(self, action: #selector(playbackSliderValueChanged(_:)), for: .valueChanged)

        playerProgressBar.isContinuous = true
        
        if !isEnhance{
            applyBellBtn.isHidden = true
        }
        
//        if !AppSettings.isBellCurveEQAtcive{
//            self.applyBellBtn.setTitle("Apply Gate", for: .normal)
//        }
        
        self.applyBellBtn.setTitle("Apply Gate", for: .normal)
        self.bindViewModel()
    }
    
    @IBOutlet weak var applyBellBtn: UIButton!
    @IBAction func applyBellEQ(_ sender: Any) {
        self.viewModel.equalizeAudio()
        self.invalidateTimer()
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
                    homeVC.isEnhance = false
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
    
    func pausePlayer(){
        playerIcon.image = UIImage(systemName: "play.fill")
        isPlaying = false
        self.invalidateTimer()
    }
    
    func playPlayer(){
        self.invalidateTimer()
        self.playVoice()
        if self.currentDuration > 1 {
            let toTime = CMTime(seconds: self.currentDuration, preferredTimescale: 60000)
            player?.seek(to: toTime, toleranceBefore: .zero, toleranceAfter: .zero)
        }
        playerIcon.image = UIImage(systemName: "pause.fill")
        
        self.showTC()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func showTC(){
        let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
        let request = SFSpeechURLRecognitionRequest(url: file_url.address!)

        request.shouldReportPartialResults = true
        request.taskHint = .dictation
        

        if (recognizer?.isAvailable)! {

            recognizer?.recognitionTask(with: request) { result, error in
                guard error == nil else { print("Error: \(error!)"); return }
                guard let result = result else { print("No result!"); return }
                
                print(result.bestTranscription.formattedString)
                
            }
        } else {
            print("Device doesn't support speech recognition")
        }
    }
    
    var player: AVPlayer?
    var playerItem: AVPlayerItem?
    
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
    }

    
    func invalidateTimer(){
        self.player?.pause()
        self.playerIcon.image = UIImage(systemName: "play.fill")
        self.isPlaying = false
    }
    
    func saveRecordedFile(url: URL){
        let audioURL = url
        let fileURL = audioURL
        var filesToShare = [Any]()
        filesToShare.append(fileURL)
        let activityViewController = UIActivityViewController(activityItems: filesToShare, applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: {
            self.isSaved = true
        })
    }
    
    
    @objc func playbackSliderValueChanged(_ playbackSlider: UISlider) {
        let pos = floor(playerProgressBar.value)
        if isPlaying{
            self.invalidateTimer()
            if pos == 0{
                self.invalidateTimer()
                self.start_at.text = self.stringFromTimeInterval(interval: TimeInterval(pos))
            }else{
                self.playPlayer()
            }
            currentDuration = Double(pos)
        }else{
            currentDuration = Double(pos)
        }
        
    }
    
    func stringFromTimeInterval(interval: TimeInterval) -> String {
        let time = NSInteger(interval)
        let ms = Int(interval.truncatingRemainder(dividingBy: 1) * 10)
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3600)
        return String(format: "%0.2d:%0.2d:%0.2d", hours,minutes,seconds)
    }
    
}

