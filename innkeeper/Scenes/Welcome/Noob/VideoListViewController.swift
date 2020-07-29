//
//  VideoListViewController.swift
//  innkeeper
//
//  Created by orca on 2020/07/14.
//  Copyright © 2020 example. All rights reserved.
//

import UIKit

class VideoListViewController: UIViewController {
    
    @IBOutlet var videoCollection: UICollectionView!
    
    var nvTitle: String = ""
    var videoIDs: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.videoCollection.delegate = self
        self.videoCollection.dataSource = self
        self.navigationItem.title = self.nvTitle
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.topItem?.title = ""
    }
    
    func setDatas(title: String, videoIDs: [String]) {
        self.nvTitle = title
        self.videoIDs = videoIDs
    }
    
    func getVideoHeight(targetView: UIView) -> CGFloat{
        
        let newViewWidth = UIScreen.main.bounds.width       // 현재 스크린의 width
        let originViewWidth = targetView.frame.width        // 원래 뷰의 width
        let originViewHeight = targetView.frame.height      // 원래 뷰의 height
        
        
        /* 비율 공식으로 height를 계산한다
         
              414       :        234       =     1000     :   ?
        originViewWidth : originViewHeight = newViewWidth :   ?
        
        ? = originViewHeight * newViewWidth / originViewWidth
        
        */
        let newViewHeight = originViewHeight * newViewWidth / originViewWidth
        return newViewHeight
    }
}


//MARK:- UICollectionViewDelegate, UICollectionViewDataSource
extension VideoListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videoIDs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoCollectionViewCell.identifier, for: indexPath) as! VideoCollectionViewCell
        cell.configure(videoID: videoIDs[indexPath.row])
        
        return cell
    }
}

extension VideoListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoCollectionViewCell.identifier, for: indexPath) as! VideoCollectionViewCell
        
        let height = self.getVideoHeight(targetView: cell.player)
        return CGSize(width: UIScreen.main.bounds.width - 20, height: height - 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 40.0
    }
}
