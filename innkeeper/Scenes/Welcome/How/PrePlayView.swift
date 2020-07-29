//
//  PrePlayView.swift
//  innkeeper
//
//  Created by orca on 2020/07/08.
//  Copyright © 2020 example. All rights reserved.
//

import UIKit

class PrePlayView: UIView {
    
    struct PlayInfo {
        var imgName: String
        var title: String
        var desc: String
    }
    
    @IBOutlet var playImgView: UIImageView!
    @IBOutlet var title: UILabel!
    @IBOutlet var desc: UILabel!
    
    var current: Int = 0
    var infos: [PlayInfo] = []
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func didMoveToWindow() {
        self.initInfos()
        self.setInfos()
    }
    
    func initInfos() {
        
        var info: PlayInfo = PlayInfo(imgName: "img_preplay_0", title: "시작 카드 선택", desc: "게임이 시작되면 우선 누가 선공을 가지는 지를 결정하는 동전 던지기를 합니다. 그리고 양쪽 플레이어들은 시작하는 카드를 결정하죠. 선공은 세 장을, 후공은 네 장의 카드를 가지고 시작합니다. 선공이 미세하게 전략적 우위를 점하기 때문에, 후공인 플레이어는 ‘동전 한 닢’이라는 카드를 추가로 가집니다. 이 카드는 일시적으로 마나를 1만큼 생성합니다! 한 번에 한해 시작하는 카드에서 원하는 만큼의 카드를 다시 뽑을 수 있습니다. 양쪽 플레이어의 시작하는 카드가 확정되면 진짜 대결이 시작됩니다.")
        
        infos.append(info)
        
        info = PlayInfo(imgName: "img_preplay_1", title: "카드뽑기", desc: "턴이 시작되면 덱에서 카드를 한 장 뽑습니다. 하지만 특정 카드들은 카드를 더 뽑을 수 있게 해줍니다. 이교도 지도자는 아군 하수인이 죽을 때마다 카드 한 장을 뽑게 해줍니다. 하지만 주의하세요. 카드가 다 떨어졌는데도 이렇게 카드를 추가적으로 뽑으려 하면 탈진으로 피해를 입습니다.")
        
        infos.append(info)
        
        info = PlayInfo(imgName: "img_preplay_2", title: "카드 내기", desc: "1 마나는 낮은 수치지만, 첫 턴에 낼 수 있는 낮은 비용의 카드는 얼마든지 있습니다. 예를 들어 이 은빛십자군 종자 카드를 보세요. 대부분의 하수인은 낸 순간에 공격할 수 없습니다. 그래서 이 하수인은 공격을 준비하기 위해 한 턴 동안 잠을 잡니다. 주문 카드는 내는 즉시 효과가 나타나고, 비밀 카드는 특정 조건을 만족하면 효과가 발동합니다.")
        
        infos.append(info)
        
        info = PlayInfo(imgName: "img_preplay_3", title: "공격", desc: "상대방이 하수인을 냈군요. 다시 우리 차례입니다. 마나 수정이 두 개 있으니 하수인을 또 내거나 주문을 사용할 수 있고, 영웅 능력을 사용해도 됩니다. 선택의 연속이죠… 우리의 은빛십자군 종자는 이제 공격할 준비를 마쳤습니다. 상대 영웅을 공격하거나 하수인을 공격할 수 있죠. 은빛십자군 종자가 천상의 보호막 능력을 가지고 있으니, 우리는 아무런 피해 없이 상대의 하수인을 처리할 수 있습니다.")
        
        infos.append(info)
        
        info = PlayInfo(imgName: "img_preplay_4", title: "영웅 능력 사용", desc: "도적은 영웅 능력으로 단검을 장착할 수 있습니다. 그러니 무기를 생성해 상대방의 하수인을 공격하고, 은빛십자군 종자의 천상의 보호막을 계속 유지시킵시다. 무기를 휘두르는 영웅들은 적 영웅이나 하수인을 공격할 수 있습니다. 하지만 주의하세요. 공격할 때마다 무기의 내구도가 1씩 감소하고, 내구도가 0이 된 무기는 사라집니다.")
        
        infos.append(info)
        
        info = PlayInfo(imgName: "img_preplay_5", title: "턴 종료하기", desc: "이제 더는 할 수 있는 행동이 없으니 턴을 종료합니다. 상대방이 어떻게 나올지 한 번 보죠!")
        
        infos.append(info)
        
        desc.sizeToFit()
    }

    func setInfos() {
        let info: PlayInfo = self.infos[self.current]
        playImgView.image = UIImage(named: info.imgName)
        
        title.text = info.title
        desc.text = info.desc
    }
    
    @IBAction func onPrev(_ sender: Any) {
        self.current -= 1
        if (self.current < 0) { self.current = self.infos.count - 1 }
        //        print("current : \(self.current)")
        
        self.setInfos()
        
    }
    
    @IBAction func onNext(_ sender: Any) {
        self.current += 1
        
        if (self.current >= self.infos.count) { self.current = 0 }
        //        print("current : \(self.current)")
        
        self.setInfos()
    }
}
