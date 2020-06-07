//
//  MediaService.swift
//  SoundWavePlayer
//
//  Created by Максим Спиридонов on 06.06.2020.
//  Copyright © 2020 Максим Спиридонов. All rights reserved.
//

import Foundation
import AVFoundation



protocol MediaServiceDelegate: class {
    func play()
    func pause()
    func goforward()
    func gobackward()
    func progress(_ currentProgress: TimeInterval, currentTime: TimeInterval)
    func audioMeteringLevelUpdate(_ meteringLevels: [Float])
    func getFilePath(_ url: URL)
}

protocol MediaServiceType {
    var delegate: MediaServiceDelegate? { get set }
    
    func openAudioTrack(_ data: Data, completion: @escaping (Bool) -> Void)
    func openAudioTrack(_ filePath: URL, completion: @escaping (Bool) -> Void)
    var isPlaying: Bool { get }
    func play()
    func pause()
    func setNewTimeValue(_ senderValue: Float)
    func gobackward()
    func goforward()
    
    var statusValue: (TimeInterval, TimeInterval) { get }
}




final class MediaService: NSObject, MediaServiceType, AVAudioPlayerDelegate {
    
    weak var delegate: MediaServiceDelegate?
    
    fileprivate var player: AVAudioPlayer = AVAudioPlayer()
    fileprivate var updater: CADisplayLink! = nil
    fileprivate let fileWorker = LocalFileFetcher()
    
    var statusValue: (TimeInterval, TimeInterval) {
        get {
            return (player.duration, player.currentTime)
        }
    }
    
    override init() {
        super.init()
        
    }
    
    
    
    
    
    var isPlaying: Bool {
        return self.player.isPlaying
    }
    
    
    func openAudioTrack(_ filePath: URL, completion: @escaping (Bool) -> Void) {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            self.updater = CADisplayLink(target: self, selector: #selector(self.trackAudio))
            self.updater.preferredFramesPerSecond = 1
            self.updater.add(to: RunLoop.current, forMode: RunLoop.Mode.common)

            self.player = try AVAudioPlayer(contentsOf: filePath)

            self.player.play()
            self.delegate?.play()

        } catch let error {
            print("Error \(error.localizedDescription)")
            completion(false)
        }

    }
    
    
    
    func openAudioTrack(_ data: Data, completion: @escaping (Bool) -> Void) {
        print(#function)
        fileWorker.createFile(data) {[weak self] (filePath) in
            if let filePath = filePath {
                do {
                    try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                    try AVAudioSession.sharedInstance().setActive(true)
                    
                    self?.updater = CADisplayLink(target: self!, selector: #selector(self?.trackAudio))
                    self?.updater.preferredFramesPerSecond = 1
                    self?.updater.add(to: RunLoop.current, forMode: RunLoop.Mode.common)
                    
                    //            player = try AVAudioPlayer(data: data, fileTypeHint: AVFileType.aiff.rawValue)
                    self?.player = try AVAudioPlayer(contentsOf: filePath, fileTypeHint: AVFileType.aiff.rawValue)
                    
                    self?.player.isMeteringEnabled = false
                    self?.player.play()
                    self?.delegate?.play()
                    
                    
                } catch let error {
                    print(error.localizedDescription)
                }
                
                self?.delegate?.getFilePath(filePath)
                completion(true)
            } else {
                completion(false)
            }
            
        }
        
        
        
        
    }
    
    
    @objc fileprivate func trackAudio() {
        delegate?.progress(player.duration, currentTime: player.currentTime)
    }
    
    
    
    func play() {
        player.play()
        updater = CADisplayLink(target: self, selector: #selector(trackAudio))
        updater.preferredFramesPerSecond = 1
        updater.add(to: RunLoop.current, forMode: RunLoop.Mode.common)
        player.numberOfLoops = -1
        player.delegate = self
        self.delegate?.play()
    }
    
    func pause() {
        self.delegate?.pause()
        player.pause()
        updater.invalidate()
    }
    
    func gobackward() {
        self.player.currentTime -= 15.0
        delegate?.progress(player.duration, currentTime: player.currentTime)
    }
    
    func goforward() {
        self.player.currentTime += 15.0
        delegate?.progress(player.duration, currentTime: player.currentTime)
    }
    
    
    func setNewTimeValue(_ senderValue: Float) {
        guard let value = TimeInterval(exactly: Float(senderValue * Float(player.duration) / 100)) else { return }
        
        DispatchQueue.main.async {
            self.player.currentTime = value
        }
        
    }
}

