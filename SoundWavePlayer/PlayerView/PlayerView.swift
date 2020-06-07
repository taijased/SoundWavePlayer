//
//  PlayerView.swift
//  SoundWavePlayer
//
//  Created by Максим Спиридонов on 06.06.2020.
//  Copyright © 2020 Максим Спиридонов. All rights reserved.
//


import UIKit
import AVFoundation



final class SoundPlayerView: UIView {
    
    fileprivate var mediaService: MediaServiceType = MediaService()
    
    
    
    fileprivate let emptyLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray3
        return view
    }()
    
    
    fileprivate let slider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.isContinuous = true
        slider.tintColor = .clear
        slider.setMinimumTrackImage(UIImage(), for: .normal)
        slider.setMaximumTrackImage(UIImage(), for: .normal)
        
        slider.addTarget(self, action: #selector(sliderValueDidChange), for: .valueChanged)
        let config: UIImage.SymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 1, weight: UIImage.SymbolWeight.bold, scale: UIImage.SymbolScale.large)
        slider.setThumbImage(UIImage(systemName: "circle.fill", withConfiguration: config), for: .normal)
        slider.minimumValue = 0
        slider.maximumValue = 100
        
        return slider
    }()
    
    
    @objc func sliderValueDidChange(_ sender: UISlider) {
        
        self.mediaService.setNewTimeValue(sender.value)
    }
       
       
    
    fileprivate let playButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 7
        button.layer.masksToBounds = false
        let config: UIImage.SymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 24, weight: UIImage.SymbolWeight.bold, scale: UIImage.SymbolScale.large)
        button.setImage(UIImage(systemName: "play.fill", withConfiguration: config), for: .normal)
        button.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        button.tintColor = .systemGray
        return button
    }()
    
    fileprivate let backwardButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 7
        button.layer.masksToBounds = false
        let config: UIImage.SymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 20, weight: UIImage.SymbolWeight.bold, scale: UIImage.SymbolScale.large)
        button.setImage(UIImage(systemName: "arrow.uturn.left", withConfiguration: config), for: .normal)
        button.addTarget(self, action: #selector(backwardButtonTapped), for: .touchUpInside)
        button.tintColor = .systemGray
        return button
    }()
    

    fileprivate let forwardButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 7
        button.layer.masksToBounds = false
        let config: UIImage.SymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 20, weight: UIImage.SymbolWeight.bold, scale: UIImage.SymbolScale.large)
        button.setImage(UIImage(systemName: "arrow.uturn.right", withConfiguration: config), for: .normal)
        button.addTarget(self, action: #selector(forwardButtonTapped), for: .touchUpInside)
        button.tintColor = .systemGray
        return button
    }()
    
    @objc fileprivate func backwardButtonTapped(_ sender: UIButton) {
        mediaService.gobackward()
    }
    
    @objc fileprivate func forwardButtonTapped(_ sender: UIButton) {
        mediaService.goforward()
    }
    
    
    
    fileprivate let mainAreaView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 45
        view.layer.shadowRadius = 7
        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        return view
    }()
    
   
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    
    
    fileprivate func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(mainAreaView)
        
        mainAreaView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        mainAreaView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        mainAreaView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        mainAreaView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        
        
        mainAreaView.addSubview(backwardButton)
        backwardButton.leadingAnchor.constraint(equalTo: mainAreaView.leadingAnchor, constant: 20).isActive = true
        backwardButton.centerYAnchor.constraint(equalTo: mainAreaView.centerYAnchor).isActive = true
        backwardButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        backwardButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        mainAreaView.addSubview(playButton)
        playButton.leadingAnchor.constraint(equalTo: backwardButton.trailingAnchor, constant: 15).isActive = true
        playButton.centerYAnchor.constraint(equalTo: mainAreaView.centerYAnchor).isActive = true
        playButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        playButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        mainAreaView.addSubview(forwardButton)
        forwardButton.leadingAnchor.constraint(equalTo: playButton.trailingAnchor, constant: 15).isActive = true
        forwardButton.centerYAnchor.constraint(equalTo: mainAreaView.centerYAnchor).isActive = true
        forwardButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        forwardButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        
        
        addSubview(slider)
        slider.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -0.5).isActive = true
        slider.leadingAnchor.constraint(equalTo: forwardButton.trailingAnchor, constant: 12).isActive = true
        slider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
        
        
        self.mediaService.delegate = self
        
    }
    
    
    @objc func playButtonTapped() {
       
        var playBtnImage: String
        
        
        if mediaService.isPlaying {
            playBtnImage = "play.fill"
            mediaService.pause()
        } else {
            
            
            playBtnImage = "stop.fill"
            mediaService.play()
        }
        
        let config: UIImage.SymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 24, weight: UIImage.SymbolWeight.bold, scale: UIImage.SymbolScale.large)
        
        UIView.animate(withDuration: 0.25) {
            self.playButton.setImage(UIImage(systemName: playBtnImage, withConfiguration: config), for: .normal)
        }
        
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var soundId: String = ""
    
    
    
    
    
    func openAudioTrack(_ data: Data, id: String) {
        self.soundId = id
        self.mediaService.openAudioTrack(data) { [weak self] status in
            if status {
                let config: UIImage.SymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 24, weight: UIImage.SymbolWeight.bold, scale: UIImage.SymbolScale.large)
                UIView.animate(withDuration: 0.0) {
                    self?.isHidden = false
                    self?.playButton.setImage(UIImage(systemName: "stop.fill", withConfiguration: config), for: .normal)
                }
            }
        }
        
    }
    
}




//MARK: - AVAudioPlayerDelegate

extension PlayerPanelView: MediaServiceDelegate {
    func getFilePath(_ url: URL) {
        print(#function)
    }
    
    
    // its trash
    func audioMeteringLevelUpdate(_ meteringLevels: [Float]) {
        

        
    }
    
    func play() {
        print(#function)
       
    }
    
    func pause() {
        print(#function)
    }
    
    func goforward() {
        print(#function)
    }
    
    func gobackward() {
        print(#function)
    }
    
    func progress(_ currentProgress: TimeInterval, currentTime: TimeInterval) {
        
        let current = Float(currentTime * 100 / currentProgress)
        
        UIView.animate(withDuration: 0.1) {
            self.slider.value = current
        }
    }
}

