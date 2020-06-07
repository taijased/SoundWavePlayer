//
//  ViewController.swift
//  SoundWavePlayer
//
//  Created by Максим Спиридонов on 06.06.2020.
//  Copyright © 2020 Максим Спиридонов. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    
    let playerView = SoundPlayerView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    
    fileprivate func setupUI() {
        
        let thisBundle = Bundle(for: type(of: self))
        guard
            let filePath = thisBundle.url(forResource: "witcher", withExtension: "mp3"),
            filePath.checkFileExist()
            else { return }
        
        view.addSubview(playerView)
        playerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        playerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        playerView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        playerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        playerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        playerView.openAudioTrack(filePath)
        
    }

}

