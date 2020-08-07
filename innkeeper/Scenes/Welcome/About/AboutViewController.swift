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
        UIView.setResolution(targetView: ytHSView)
    }
    
    func setBackButtonPosition() {
        if UIDevice.current.hasNotch {
            print("notch")
            if UIDevice.current.userInterfaceIdiom == .phone {
                btnBack.frame = CGRect(x: 15, y: 50, width: 38, height: 38)
            } else {
                btnBack.frame = CGRect(x: 15, y: 40, width: 50, height: 50)
            }
        } else {
            print("not notch")
    
            if UIDevice.current.userInterfaceIdiom == .phone {
                btnBack.frame = CGRect(x: 15, y: 15, width: 38, height: 38)
            } else {
                btnBack.frame = CGRect(x: 15, y: 35, width: 50, height: 50)
            }
        }
    }

    @IBAction func back(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
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

