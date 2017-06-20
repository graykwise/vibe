//
//  OtherViewController.swift
//  Vibe
//
//  Created by Grayson Wise on 6/20/17.
//  Copyright © 2017 Vibe. All rights reserved.
//

import UIKit
import SafariServices
import AVFoundation

class OtherViewController: UIViewController, SPTAudioStreamingPlaybackDelegate, SPTAudioStreamingDelegate {
    
    var time = 20
    var timer = Timer()
    var auth = SPTAuth.defaultInstance()!
    var session:SPTSession!
    var player: SPTAudioStreamingController?
    var loginUrl: URL?

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        updateAfterFirstLogin()
        // Do any additional setup after loading the view.
    }

    @IBAction func playTimer(_ sender: UIButton) {
        
        self.player?.playSpotifyURI("spotify:user:spotify:playlist:37i9dQZF1DX4WYpdgoIcn6", startingWith: 4, startingWithPosition: 0, callback: { (error) in
            if (error != nil) {
                print("playing!")
            }
        })
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(OtherViewController.countdown), userInfo: nil, repeats: true)
        print("starting timer")
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func countdown() {
        time = time - 1
        print(time)
        if time == 0 {
            print("Reached zero")
            timer.invalidate()
            //stop music
            do {
                try self.player?.stop()
            }
            catch let _ {
                
            }
        }
    }

    func updateAfterFirstLogin () {
        if let sessionObj = UserDefaults.standard.object(forKey: "SpotifySession") {
            let sessionDataObj = sessionObj as! Data
            let firstTimeSession = NSKeyedUnarchiver.unarchiveObject(with: sessionDataObj) as! SPTSession
            self.session = firstTimeSession
            initializePlayer(authSession: session)
        }
    }
    
    func initializePlayer(authSession:SPTSession){
        if self.player == nil {
            self.player = SPTAudioStreamingController.sharedInstance()
            self.player!.playbackDelegate = self
            self.player!.delegate = self
            try! player!.start(withClientId: auth.clientID)
            self.player!.login(withAccessToken: authSession.accessToken)
        }
    }
//    
    func audioStreamingDidLogin(_ audioStreaming: SPTAudioStreamingController!) {
       //This is from the delegate and we need it to possibly play music
    }
    
    func setup () {
        // insert redirect your url and client ID below
        let redirectURL = "vibe-spotify://returnafterlogin" // put your redirect URL here
        let clientID = "c49c6284c544447b8646bbebd99aa15e" // put your client ID here
        
        SPTAuth.defaultInstance().clientID = clientID
        SPTAuth.defaultInstance().redirectURL = URL(string: redirectURL)
        auth.requestedScopes = [SPTAuthStreamingScope]
        loginUrl = auth.spotifyWebAuthenticationURL()
    }

}
