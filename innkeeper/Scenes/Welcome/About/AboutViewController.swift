//
//  AboutViewController.swift
//  innkeeper
//
//  Created by orca on 2020/07/02.
//  Copyright © 2020 example. All rights reserved.
//

import UIKit
import youtube_ios_player_helper
import SafariServices

class AboutViewController: UIViewController {
    
    @IBOutlet var btnBack: UIButton!
    @IBOutlet weak var ytHSView: YTPlayerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setBackButtonPosition()
        self.setCinematicVideo()
        self.setResolution(targetView: ytHSView)
    }
    
    func setBackButtonPosition() {
        
//        let systemVersion = getDeviceIdentifier()
        
        if UIDevice.current.hasNotch {
            btnBack.frame.origin.x = 20
            btnBack.frame.origin.y = 50
        } else {
            btnBack.frame.origin.x = 20
            btnBack.frame.origin.y = 10
        }
    }

    
    @IBAction func back(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func getDeviceIdentifier() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        return identifier
    }
    
    @IBAction func moveToHearthStonePage(_ sender: UIButton) {
        
        let url: URL = URL(string: "https://playhearthstone.com/ko-kr/")!
        let sfVC: SFSafariViewController = SFSafariViewController(url: url)
        self.present(sfVC, animated: true, completion: nil)
    }
    
    @IBAction func moveToHearthStoneAppStore(_ sender: UIButton) {
        if let url = URL(string: "itms-apps://itunes.apple.com/app/id625257520"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) { UIApplication.shared.open(url) }
            else                       { UIApplication.shared.openURL(url) }
        }
    }
}


// MARK:- Set specified view's height (based on screen width)
extension UIViewController {
    
    // 늘어난 스크린 넓이 만큼의 비율로 targetView의 높이를 변경한다
    func setResolution(targetView: UIView) {
        
        guard let targetHeight = targetView.constraints.filter({ $0.identifier == "targetHeight" }).first
        else { return }
        
        let newViewWidth = UIScreen.main.bounds.width       // 현재 스크린의 width
        let originViewWidth = targetView.frame.width        // 원래 뷰의 width
        let originViewHeight = targetView.frame.height      // 원래 뷰의 height
        
        
        /* 비율 공식으로 height를 계산한다
         
              414       :        234       =     1000     :   ?
        originViewWidth : originViewHeight = newViewWidth :   ?
        
        ? = originViewHeight * newViewWidth / originViewWidth
        
        */
        let newViewHeight = originViewHeight * newViewWidth / originViewWidth
        targetHeight.constant = newViewHeight
    }
}


//MARK:- Youtube Player
extension AboutViewController: YTPlayerViewDelegate {
    
    func setCinematicVideo()
    {
        ytHSView.delegate = self
        ytHSView.load(withVideoId: InnIdentifiers.YOUTUBE_HS_CINEMATIC.rawValue, playerVars: ["playsinline": 1])
    }
}


//MARK:- UIDevice Notch
extension UIDevice {
    var hasNotch: Bool {

//        let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        let bottom = keyWindow?.safeAreaInsets.bottom ?? 0

        return bottom > 0
    }
    
    func getNotchHeight() -> CGFloat {
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        let bottom = keyWindow?.safeAreaInsets.bottom ?? 0
        
        return bottom
    }
}

