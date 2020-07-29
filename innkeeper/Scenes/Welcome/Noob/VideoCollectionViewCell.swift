//
//  VideoCollectionViewCell.swift
//  innkeeper
//
//  Created by orca on 2020/07/14.
//  Copyright © 2020 example. All rights reserved.
//

import UIKit
import youtube_ios_player_helper

class VideoCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "VideoCollectionViewCell"
    
    @IBOutlet var player: YTPlayerView!
    
    func configure(videoID: String) {
        self.setVideo(videoID: videoID)
    }
}


//MARK:- Youtube Player
extension VideoCollectionViewCell: YTPlayerViewDelegate {
    
    func setVideo(videoID: String)
    {
        player.delegate = self
        player.load(withVideoId: videoID, playerVars: ["playsinline": 1])
    }
}
