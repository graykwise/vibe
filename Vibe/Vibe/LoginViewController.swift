//
//  LoginViewController.swift
//  Vibe
//
//  Created by Grayson Wise on 6/20/17.
//  Copyright © 2017 Vibe. All rights reserved.
//

import UIKit
import SafariServices
import AVFoundation

class LoginViewController: UIViewController, SPTAudioStreamingPlaybackDelegate, SPTAudioStreamingDelegate {

    @IBOutlet weak var loginButton: UIButton!
   
    var auth = SPTAuth.defaultInstance()!
    var session:SPTSession!
    var player: SPTAudioStreamingController?
    var loginUrl: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setup()
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.userLoggedIn), name: NSNotification.Name(rawValue: "loginSuccessful"), object: nil)

    }
    
    func userLoggedIn() {
        updateAfterFirstLogin()
        print("performing segue")

        
        performSegue(withIdentifier: "loginToVibe", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loginToVibe" {
            let navVC = segue.destination as! UINavigationController
            let newView = navVC.topViewController as! VibeViewController
            newView.player = self.player
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
            print("done initializing")
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func login(_ sender: UIButton) {
        
        if UIApplication.shared.canOpenURL(loginUrl!) {
            UIApplication.shared.open(loginUrl!, options: [:], completionHandler: nil)
            
            if auth.canHandle(auth.redirectURL) {
                // To do - build in error handling
            }
        }
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

