//
//  ViewController.swift
//  Demo
//
//  Created by wkcloveYang on 2020/8/6.
//  Copyright © 2020 wkcloveYang. All rights reserved.
//

import UIKit
import WKCFansyPhotoLiveView

class ViewController: UIViewController, WKCFansyPhotoLiveViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fansyPhotoView = WKCFansyPhotoLiveView(filePlaceholdImageName: "launch_guide_2.jpg", fileMovURL: URL(fileURLWithPath: Bundle.main.path(forResource: "launch_guide_2", ofType: "mov")!))
        fansyPhotoView?.frame = view.bounds
        fansyPhotoView?.delegate = self
        view.addSubview(fansyPhotoView!)
    }

    func fansyPhotoLiveViewWillBeginPlay(_ liveView: WKCFansyPhotoLiveView!) {
        debugPrint("开始播放")
    }
    
    func fansyPhotoLiveViewDidEndPlay(_ liveView: WKCFansyPhotoLiveView!) {
        debugPrint("结束播放")
    }

}

