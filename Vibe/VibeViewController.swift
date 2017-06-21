//
//  VibeViewController.swift
//  Vibe
//
//  Created by Grayson Wise on 6/20/17.
//  Copyright © 2017 Vibe. All rights reserved.
//

import UIKit
import AVFoundation
import SafariServices

class VibeViewController: UIViewController, SPTAudioStreamingPlaybackDelegate, SPTAudioStreamingDelegate {

    var clock = Timer()
    var time: Int!
    var player: SPTAudioStreamingController?    
    
    var savedSession: Session!
    
    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func startVibing(_ sender: Any) {
        
        if player?.loggedIn == true {
            print("logged in")
        }
        
        self.player?.setShuffle(true, callback: { (error) in
            if (error != nil) {
                print("not shuffled")
            }
            self.player?.setIsPlaying(true, callback: { (error) in
                if (error != nil) {
                    print("not set to playing, but shuffled")
                }
            })
        })
        
        print(savedSession.playlistURI)
        
        self.player?.playSpotifyURI(savedSession.playlistURI, startingWith: 9, startingWithPosition: 0, callback: { (error) in
            print("in callback")

            if (error == nil) {
                print("playing!")
            }
            else {
                print("Error in playSpotifyURI: \(error)")
            }
        })
        
        print("after callback")
        
        time = savedSession.timeDuration
        
        
        clock = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(OtherViewController.countdown), userInfo: nil, repeats: true)
        print("starting timer")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
  
    
    func audioStreamingDidLogin(_ audioStreaming: SPTAudioStreamingController!) {
        //This is from the delegate and we need it to possibly play music
    }
    
    func countdown() {
        
        time = time - 1
        print(time)
        if time == 0 {
            print("Reached zero")
            clock.invalidate()
            time = 20
            //stop music
            self.player?.setIsPlaying(false, callback: { (error) in
                if (error != nil) {
                    print("not set to stopped")
                }
            })
        }
    }
}
