//
//  VideoPlayer.swift
//  eZen Dev
//
//  Created by Wykee on 16/01/2023.
//  Copyright © 2023 Music of Wisdom. All rights reserved.
//

import Foundation
import UIKit
import AVKit

class VideoPlayer: UIView {
    
    var vwPlayer: UIView!
    
    var player: AVPlayer?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    fileprivate func commonInit() {
        vwPlayer.frame = self.bounds
        addSubview(vwPlayer)
        addPlayerToView(self.vwPlayer)
    }
    
    fileprivate func addPlayerToView(_ view: UIView) {
        player = AVPlayer()
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.bounds
        playerLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(playerLayer)
        NotificationCenter.default.addObserver(self, selector: #selector(playerEndPlay), name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    func playVideoWithFileName(_ fileName: String, ofType type:String) {
        guard let filePath = Bundle.main.path(forResource: fileName, ofType: type) else { return }
        let videoURL = URL(fileURLWithPath: filePath)
        let playerItem = AVPlayerItem(url: videoURL)
        player?.replaceCurrentItem(with: playerItem)
        player?.play()
    }
    
    @objc func playerEndPlay() {
        print("Player ends playing video")
    }
}
