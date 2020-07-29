//
//  NoobViewController.swift
//  innkeeper
//
//  Created by orca on 2020/07/10.
//  Copyright © 2020 example. All rights reserved.
//

import UIKit
import SafariServices

class NoobViewController: UIViewController {

    @IBOutlet var commuCollectionView: UICollectionView!
    @IBOutlet var lectureTableView: UITableView!
    
    var commuCellDatas: [CommuCellData] = []
    var currentPage: Int = 0
    var currentCell: Int = 0
    var commuColumnCount : Int = 0
    
    var lectureCellDatas: [LectureCellData] = []
    
    override func viewDidAppear(_ animated: Bool) {
        
        guard 0 == commuColumnCount else { return }
        self.commuColumnCount = Int(self.commuCollectionView.bounds.size.height / self.commuCollectionView.cellForItem(at: IndexPath(row: 0, section: 0))!.bounds.size.height)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commuCollectionView.delegate = self
        commuCollectionView.dataSource = self
       
        var data = CommuCellData(imgName: "img_commu_icon_0", title: "하스스터디", url: "https://www.hearthstudy.com/", hidden: false)
        commuCellDatas.append(data)
        
        data = CommuCellData(imgName: "img_commu_icon_1", title: "하스스톤 인벤", url: "http://hs.inven.co.kr/", hidden: false)
        commuCellDatas.append(data)
        
        data = CommuCellData(imgName: "img_commu_icon_2", title: "따악", url: "http://dda.ac/deck", hidden: false)
        commuCellDatas.append(data)
        
        data = CommuCellData(imgName: "img_commu_icon_3", title: "HSReplay.net", url: "https://hsreplay.net/", hidden: false)
        commuCellDatas.append(data)
        
        data = CommuCellData(imgName: "img_commu_icon_4", title: "HearthPwn", url: "https://www.hearthpwn.com/", hidden: false)
        commuCellDatas.append(data)
        
        data = CommuCellData(imgName: "img_commu_icon_5", title: "Hearthstone Top Decks", url: "https://www.hearthstonetopdecks.com/", hidden: false)
        commuCellDatas.append(data)
        
        data = CommuCellData(imgName: "img_commu_icon_6", title: "Icy Veins", url: "https://www.icy-veins.com/", hidden: false)
        commuCellDatas.append(data)
        
        data = CommuCellData(imgName: "img_commu_icon_7", title: "TEMPO/STORM", url: "https://tempostorm.com/", hidden: false)
        commuCellDatas.append(data)
        
        data = CommuCellData(imgName: "img_commu_icon_0", title: "", url: "", hidden: true)
        commuCellDatas.append(data)

        data = CommuCellData(imgName: "img_commu_icon_0", title: "", url: "", hidden: true)
        commuCellDatas.append(data)
        
        lectureTableView.delegate = self
        lectureTableView.dataSource = self
        
        var data2 = LectureCellData(imgName: "icon-streamer-4", title: "에디하 (Eddie Ha)",
                                    videos: [InnIdentifiers.YOUTUBE_HS_EDDIE_0.rawValue,
                                             InnIdentifiers.YOUTUBE_HS_EDDIE_1.rawValue,
                                             InnIdentifiers.YOUTUBE_HS_EDDIE_2.rawValue])
        lectureCellDatas.append(data2)
        
        data2 = LectureCellData(imgName: "icon-streamer-0", title: "룩삼 (Looksam)",
                                    videos: [InnIdentifiers.YOUTUBE_HS_LOOKSAM_0.rawValue,
                                             InnIdentifiers.YOUTUBE_HS_LOOKSAM_1.rawValue,
                                             InnIdentifiers.YOUTUBE_HS_LOOKSAM_2.rawValue])
        lectureCellDatas.append(data2)
        
        data2 = LectureCellData(imgName: "icon-streamer-1", title: "침착맨",
                                videos: [InnIdentifiers.YOUTUBE_HS_CHIM_0.rawValue,
                                         InnIdentifiers.YOUTUBE_HS_CHIM_1.rawValue,
                                         InnIdentifiers.YOUTUBE_HS_CHIM_2.rawValue,
                                         InnIdentifiers.YOUTUBE_HS_CHIM_3.rawValue])
        lectureCellDatas.append(data2)
        
        data2 = LectureCellData(imgName: "icon-streamer-2", title: "따효니 (DDahyoni)",
                                videos: [InnIdentifiers.YOUTUBE_HS_DDA_0.rawValue,
                                         InnIdentifiers.YOUTUBE_HS_DDA_1.rawValue,
                                         InnIdentifiers.YOUTUBE_HS_DDA_2.rawValue,
                                         InnIdentifiers.YOUTUBE_HS_DDA_3.rawValue,
                                         InnIdentifiers.YOUTUBE_HS_DDA_4.rawValue])
        lectureCellDatas.append(data2)
        
        data2 = LectureCellData(imgName: "icon-streamer-3", title: "옥냥이 (RooftopCat)",
                                videos: [InnIdentifiers.YOUTUBE_HS_CAT_0.rawValue,
                                         InnIdentifiers.YOUTUBE_HS_CAT_1.rawValue,
                                         InnIdentifiers.YOUTUBE_HS_CAT_2.rawValue])
        lectureCellDatas.append(data2)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.backItem?.title = InnIdentifiers.SCENE_FOR_NOOB.rawValue
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == InnIdentifiers.SEGUE_LECTURE_VIDEO.rawValue {
            let destination = segue.destination
            guard let videoListVC = destination as? VideoListViewController else { return }
            
            let cell = sender as! LectureTableViewCell
            guard let indexPath = self.lectureTableView.indexPath(for: cell) else { return }
            
            let lecture = lectureCellDatas[indexPath.row]
            videoListVC.setDatas(title: lecture.title,videoIDs: lecture.videos)
        }
    }
}

//MARK:- UIcollectionViewDelegate
extension NoobViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let url: URL = URL(string: commuCellDatas[indexPath.row].url)!
        let sfVC: SFSafariViewController = SFSafariViewController(url: url)
        self.present(sfVC, animated: true, completion: nil)
    }
}

// MARK:- UICollectionViewDataSource
extension NoobViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return commuCellDatas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommuCollectionViewCell.identifier, for: indexPath) as! CommuCollectionViewCell
        
        //let index = indexPath.row * 2
        //cell.configure(datas: [commuCellDatas[index], commuCellDatas[index + 1]])
        cell.configure(data: commuCellDatas[indexPath.row])
        return cell
    }
    
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        targetContentOffset.pointee = scrollView.contentOffset
        var indexes = self.commuCollectionView.indexPathsForVisibleItems
        indexes.sort()
        var index = indexes.first!
        
        if velocity.x > 0 {
            index.row += self.commuColumnCount
        } else if velocity.x == 0 {
            let cell = self.commuCollectionView.cellForItem(at: index)!
            let position = self.commuCollectionView.contentOffset.x - cell.frame.origin.x
            let cellHalfWidth = cell.frame.size.width / 2
            if position > cellHalfWidth {
                index.row += self.commuColumnCount
            }
        }
        
        if commuCellDatas[index.row].hidden {
            index.row -= 2
        }
        
        // 마지막 페이지(비어있음)에 스크롤되지 않도록 함
//        if index.row > commuCellDatas.count - 3 {
//            index.row = commuCellDatas.count - 3
//        }
         
        self.commuCollectionView.reorderingCadence = .fast
        self.commuCollectionView.scrollToItem(at: index, at: .left, animated: true )
    }
 
}

// MARK:- UICollectionViewDelegateFlowLayout
extension NoobViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //        return CGSize(width: collectionView.bounds.width / 2, height: 250)      // ipad에서의 cell size
        
        let collectionViewWidth = collectionView.bounds.size.width
        return CGSize(width: collectionViewWidth - 30, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
}


// MARK:- UITableViewDelegate
extension NoobViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension NoobViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lectureCellDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LectureTableViewCell.identifier) as! LectureTableViewCell
        
        cell.configure(imgName: lectureCellDatas[indexPath.row].imgName, title: lectureCellDatas[indexPath.row].title)
        
        return cell
    }
}



//MARK:- CommuCellData
struct CommuCellData {
    var imgName: String
    var title: String
    var url: String
    var hidden: Bool
}

//MARK:- LectureCellData
struct LectureCellData {
    var imgName: String
    var title: String
    var videos: [String]
}
