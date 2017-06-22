//
//  AppDelegate.swift
//  Vibe
//
//  Created by Grayson Wise on 6/20/17.
//  Copyright © 2017 Vibe. All rights reserved.
//

import UIKit

let appDelegate = UIApplication.shared.delegate as! AppDelegate

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var session: SPTSession?
    var player: SPTAudioStreamingController?
    let clientID = "c49c6284c544447b8646bbebd99aa15e"
    let callbackURL = "vibe-spotify://returnafterlogin"
    let tokenSwapURL = "http://localhost:1234/swap"
    let tokenRefreshServiceURL = "http://localhost:1234/refresh"
    let sessionUserDefaultsKey = "SpotifySession"
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        SPTAuth.defaultInstance().clientID = clientID
        SPTAuth.defaultInstance().redirectURL = URL(string:callbackURL)
        //SPTAuth.defaultInstance().tokenSwapURL = URL(string:kTokenSwapURL)
        SPTAuth.defaultInstance().requestedScopes = [SPTAuthStreamingScope]
        //SPTAuth.defaultInstance().tokenRefreshURL = URL(string: kTokenRefreshServiceURL)!
        SPTAuth.defaultInstance().sessionUserDefaultsKey = sessionUserDefaultsKey
        
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        // Ask SPTAuth if the URL given is a Spotify authentication callback
        
        print("The URL: \(url)")
        if SPTAuth.defaultInstance().canHandle(url) {
            SPTAuth.defaultInstance().handleAuthCallback(withTriggeredAuthURL: url) { error, session in
                // This is the callback that'll be triggered when auth is completed (or fails).
                if error != nil {
                    print("*** Auth error: \(error)")
                    return
                }
                else {
                    SPTAuth.defaultInstance().session = session
                }
                NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "sessionUpdated"), object: self)
            }
        }
        return false
    }
}


