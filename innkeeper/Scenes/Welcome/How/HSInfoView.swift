//
//  InfoView.swift
//  innkeeper
//
//  Created by orca on 2020/07/07.
//  Copyright © 2020 example. All rights reserved.
//

import UIKit

class HSInfoView: UIView {

    struct HSInfo {
        var title: String
        var desc: String
        var mask: CGRect
    }
    
    @IBOutlet weak var hsImgView: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var desc: UILabel!
    
    var infos: [HSInfo] = []
    var grayView: UIView!
    var initialized: Bool = false
    var current: Int = 0
    var verticalRate: CGFloat = 0
    var horizontalRate: CGFloat = 0
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func didMoveToWindow() {
        if initialized { return }
        UIView.setResolution(targetView: hsImgView)
        self.initInfos()
        self.setInfos()
        self.setScreenRate()
        self.setMaskViews()
        self.makeMask(invert: true)
        initialized = true
    }
    
    func initInfos() {
        
        var info = HSInfo(title: "즐길 준비 됐나요?", desc: "놀랄 만큼 쉽고 믿기 힘들 만큼 재미있습니다. 한 번 시작하면 멈출 수 없는 전략 카드 게임 하스스톤에 오신 것을 환영합니다!", mask: CGRect(x: 0, y: 0, width: hsImgView.bounds.width, height: hsImgView.bounds.height))
        
        self.infos.append(info)
        
        info = HSInfo(title: "당신의 손", desc: "당신은 매 턴마다 덱에서 카드를 한 장씩 뽑아 손에 추가합니다. 테두리가 초록색으로 반짝이는 카드가 낼 수 있는 카드입니다. 테두리가 반짝이지 않는 카드는 마나가 더 필요하거나 다른 요구 조건이 충족되지 않은 상태입니다.", mask: CGRect(x: 135, y: 246, width: 114, height: 43))
        
        self.infos.append(info)
        
        info = HSInfo(title: "영웅", desc: "이야, 어엿한 영웅이 다 되셨군요! 초상화의 우측 하단에는 당신의 생명력이 표시됩니다. 하수인이나 주문으로 피해를 받으면 생명력이 점점 감소하죠. 생명력이 0 이하로 떨어지면 패배합니다.", mask: CGRect(x: 175, y: 191, width: 52, height: 55))
        
        self.infos.append(info)
        
        info = HSInfo(title: "영웅 능력", desc: "모든 영웅들은 고유한 영웅 능력을 매 턴마다 사용할 수 있습니다. 전사는 방어도를 올릴 수 있고, 주술사는 토템을 소환할 수 있죠. 그리고 도적들은 눈깜짝할 새에 단검을 뽑아 들더군요. 도대체 몇 자루나 들고 다니는 걸까요?", mask: CGRect(x: 227, y: 197, width: 46, height: 46))
        
        self.infos.append(info)
        
        info = HSInfo(title: "마나", desc: "모든 카드는 낼 때 일정량의 마나를 사용합니다(네, 물론 몇몇 카드들은 마나 소비량이 0이기도 하죠. 그것도 결국은 일정량이니까요). 당신의 턴이 시작되면 사용했던 마나를 모두 회복하고, 추가로 새로운 마나 수정을 1개 얻습니다. 마나 수정은 최대 10개까지 보유할 수 있습니다.", mask: CGRect(x: 266, y: 256, width: 124, height: 23))
        
        self.infos.append(info)
        
        info = HSInfo(title: "당신의 무기", desc: "영웅이 쓸 무기를 장비하면, 이곳에 나타납니다. 무기는 사용할 때마다 내구도가 1씩 감소합니다. 즉, 사용 제한이 있으니 현명하게 사용하세요!", mask: CGRect(x: 128, y: 201, width: 45, height: 42))
        
        self.infos.append(info)
        
        info = HSInfo(title: "하수인", desc: "이것은 당신의 하수인입니다. 하수인을 사용하여 상대의 영웅이나 하수인을 공격하세요. 많은 하수인들이 전략적으로 활용할 수 있는 특별한 능력을 갖고 있습니다.", mask: CGRect(x: 143, y: 132, width: 119, height: 50))
        
        self.infos.append(info)
        
        info = HSInfo(title: "상대", desc: "상대방을 쓰러뜨리면 게임에서 이깁니다. 하수인과 주문으로 상대 영웅의 생명력을 0으로 만드세요!", mask: CGRect(x: 173, y: 22, width: 56, height: 62))
        
        self.infos.append(info)
        
        info = HSInfo(title: "덱", desc: "당신은 매 턴마다 덱에서 카드를 한 장씩 뽑아 손에 추가합니다. 모든 덱은 정확히 30장으로 이루어져 있습니다.", mask: CGRect(x: 365, y: 145, width: 33, height: 53))
        
        self.infos.append(info)
        
        info = HSInfo(title: "게임 기록", desc: "이곳에서는 최근에 게임에서 일어난 모든 경과를 알려줍니다. ‘왜 갑자기 내 생명력이 이렇게 낮아졌지?’나 ‘왜 내 하수인들이 모두 닭이 되어 있는 거야?’와 같은 상황에 유용하죠.", mask: CGRect(x: 15, y: 75, width: 31, height: 124))
        
        self.infos.append(info)
        
        desc.sizeToFit()
    }
    
    func setInfos() {
        
        guard 0..<self.infos.count ~= self.current else { return }
        
        title.text = self.infos[self.current].title
        desc.text = self.infos[self.current].desc
    }
    
    func setScreenRate() {
        let originImgBounds = hsImgView.bounds
        
        hsImgView.setNeedsLayout()
        hsImgView.layoutIfNeeded()
        let newImgBounds = hsImgView.bounds
        
        self.verticalRate = newImgBounds.width / originImgBounds.width
        self.horizontalRate = newImgBounds.height / originImgBounds.height
    }
     
    func setMaskViews() {
        let imgBounds = hsImgView.bounds
        grayView = UIView(frame: CGRect(x: 0, y: 0, width: imgBounds.width, height: imgBounds.height))
        grayView.backgroundColor = .black
        grayView.alpha = 0.5
        self.hsImgView.addSubview(grayView)
    }
    
    func getMaskRect() -> CGRect {
        let mask = self.infos[self.current].mask
        let posX: CGFloat = mask.origin.x * self.horizontalRate
        let posY: CGFloat = mask.origin.y * self.verticalRate
        let width: CGFloat = mask.size.width * self.horizontalRate
        let height: CGFloat = mask.size.height * self.verticalRate
        
        let rect = CGRect(x: posX, y: posY, width: width, height: height)
        
        return rect
    }
        
    func makeMask(invert: Bool = true) {
        let maskLayer = CAShapeLayer()
        let path = CGMutablePath()
        
        if invert {
            path.addRect(self.grayView.bounds)
        }
        path.addRoundedRect(in: self.getMaskRect(), cornerWidth: 5, cornerHeight: 5)
 
        maskLayer.path = path
        if (invert) {
            maskLayer.fillRule = .evenOdd
        }
        
        self.grayView.layer.mask = maskLayer
    }
    
    @IBAction func onPrev(_ sender: Any) {
        self.current -= 1
        if (self.current < 0) { self.current = self.infos.count - 1 }
//        print("current : \(self.current)")
        
        self.setInfos()
        self.makeMask(invert: true)
    }
    
    @IBAction func onNext(_ sender: Any) {
        self.current += 1
        
        if (self.current >= self.infos.count) { self.current = 0 }
//        print("current : \(self.current)")
        
        self.setInfos()
        self.makeMask()
    }

}
