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

class LoginViewController: UIViewController, SPTAudioStreamingPlaybackDelegate, SPTAudioStreamingDelegate, WebViewControllerDelegate {

    @IBOutlet weak var loginButton: UIButton!
   
    var auth = SPTAuth.defaultInstance()!
    var session: SPTSession!
    var player: SPTAudioStreamingController?
    var loginUrl: URL?
    
    var authViewController: UIViewController?
    var firstLoad: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageViewThing = UIImageView(image: #imageLiteral(resourceName: "vibetitle"))
        self.navigationItem.titleView = imageViewThing
        // Do any additional setup after loading the view, typically from a nib.
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.sessionUpdatedNotification), name: NSNotification.Name(rawValue: "sessionUpdated"), object: nil)
        self.firstLoad = true
    }
    
    func getAuthViewController(withURL url: URL) -> UIViewController {
        let webView = WebViewController(url: url)
        webView.delegate = self
        
        return UINavigationController(rootViewController: webView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let auth = SPTAuth.defaultInstance()
        // Uncomment to turn off native/SSO/flip-flop login flow
        //auth.allowNativeLogin = NO;
        // Check if we have a token at all
        if auth!.session == nil {
            return
        }
        // Check if it's still valid
        if auth!.session.isValid() && self.firstLoad {
            // It's still valid, show the player.
            session = auth?.session
            self.showPlayer()
            return
        }
        // Oh noes, the token has expired, if we have a token refresh service set up, we'll call tat one.
        if auth!.hasTokenRefreshService {
            self.renewTokenAndShowPlayer()
            return
        }
        // Else, just show login dialog
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func login(_ sender: UIButton) {
        self.openLoginPage()
    }
    
    func sessionUpdatedNotification(_ notification: Notification) {
        let auth = SPTAuth.defaultInstance()
        print(auth?.session)
        session = auth?.session
        self.presentedViewController?.dismiss(animated: true, completion: { _ in })
        if auth!.session != nil && auth!.session.isValid() {
            self.showPlayer()
        }
        else {
            print("*** Failed to log in")
        }
    }
    
    func showPlayer() {
        self.firstLoad = false
        self.performSegue(withIdentifier: "loginToVibe", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loginToVibe" {
            let navVC = segue.destination as! UINavigationController
            let newView = navVC.topViewController as! VibeViewController
            print(session)
            newView.handleNewSession(session)
        }
    }
    
    internal func productViewControllerDidFinish(_ viewController: SPTStoreViewController) {
        viewController.dismiss(animated: true, completion: { _ in })
    }
    
    func openLoginPage() {
        let auth = SPTAuth.defaultInstance()
        if SPTAuth.supportsApplicationAuthentication() {
            UIApplication.shared.open(auth!.spotifyAppAuthenticationURL(), options: [:], completionHandler: nil)
        } else {
            self.authViewController = self.getAuthViewController(withURL: SPTAuth.defaultInstance().spotifyWebAuthenticationURL())
            self.definesPresentationContext = true
            self.present(self.authViewController!, animated: true, completion: { _ in })
        }
        session = auth?.session
    }
    
    func renewTokenAndShowPlayer() {
        SPTAuth.defaultInstance().renewSession(SPTAuth.defaultInstance().session) { error, session in
            SPTAuth.defaultInstance().session = session
            if error != nil {
                print("*** Error renewing session: \(error)")
                return
            }
            self.showPlayer()
        }
    }
    
    func webViewControllerDidFinish(_ controller: WebViewController) {
        // User tapped the close button. Treat as auth error
    }
    
}

