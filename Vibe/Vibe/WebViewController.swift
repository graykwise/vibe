//
//  WebViewController.swift
//  Vibe
//
//  Created by Grayson Wise on 6/22/17.
//  Copyright © 2017 Vibe. All rights reserved.
//

import UIKit
import WebKit

@objc protocol WebViewControllerDelegate {
    func webViewControllerDidFinish(_ controller: WebViewController)
    /*! @abstract Invoked when the initial URL load is complete.
     @param success YES if loading completed successfully, NO if loading failed.
     @discussion This method is invoked when SFSafariViewController completes the loading of the URL that you pass
     to its initializer. It is not invoked for any subsequent page loads in the same SFSafariViewController instance.
     */
    @objc optional func webViewController(_ controller: WebViewController, didCompleteInitialLoad didLoadSuccessfully: Bool)
}
class WebViewController: UIViewController, UIWebViewDelegate {
    
    
    var loadComplete: Bool = false
    var initialURL: URL!
    var webView: UIWebView!
    var delegate: WebViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let imageViewThing = UIImageView(image: #imageLiteral(resourceName: "vibetitle"))
//        self.navigationItem.titleView = imageViewThing
        print(initialURL)
        let initialRequest = URLRequest(url: self.initialURL)
        self.webView = UIWebView(frame: self.view.bounds)
        self.webView.delegate = self
        self.webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(self.webView)
        self.navigationController?.navigationBar.backgroundColor = UIColor(red: 107, green: 105, blue: 206, alpha: 0.75)
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 107, green: 105, blue: 206, alpha: 0.75)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.done))
        self.webView.loadRequest(initialRequest)
    }
    
    func done() {
        
        self.delegate?.webViewControllerDidFinish(self)
        self.presentingViewController?.dismiss(animated: true, completion: { _ in })
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        if !self.loadComplete {
            delegate?.webViewController?(self, didCompleteInitialLoad: true)
            self.loadComplete = true
        }
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        if !self.loadComplete {
            
            delegate?.webViewController?(self, didCompleteInitialLoad: true)
            self.loadComplete = true
        }
    }
    
    init(url URL: URL) {
        super.init(nibName: nil, bundle: nil)
        self.initialURL = URL as URL!
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
