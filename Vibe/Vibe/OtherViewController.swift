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
    var auth = SPTAuth.defaultInstance()!
    var session:SPTSession!
    var player: SPTAudioStreamingController?
    var loginUrl: URL?

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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
    
    func audioStreamingDidLogin(_ audioStreaming: SPTAudioStreamingController!) {
        // after a user authenticates a session, the SPTAudioStreamingController is then initialized and this method called
        print("logged in")
        self.player?.setShuffle(true, callback: { (error) in
            if (error != nil) {
                print("didnt shuffle")
            }
            
            self.player?.playSpotifyURI("spotify:user:spotify:playlist:37i9dQZF1DX4WYpdgoIcn6", startingWith: 4, startingWithPosition: 0, callback: { (error) in
                if (error != nil) {
                    print("playing!")
                }
            })
        })
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
