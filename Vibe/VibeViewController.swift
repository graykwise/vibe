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

class VibeViewController: UIViewController, SPTAudioStreamingPlaybackDelegate, SPTAudioStreamingDelegate, SessionDelegate, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var splashScreen: UIImageView!
    
    @IBOutlet weak var sessionTable: UITableView!
    
    var sessionArray = [Session]()
    var clock = Timer()
    var time: Int!
    var player: SPTAudioStreamingController?
    var savedSession: Session!
    var selectedSession: Int!
    var indexOnPlayQueue: Int!
    var session: SPTSession!
    
    var currentTime: Int!
    
    @IBOutlet weak var startButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sessionTable.layer.borderColor = UIColor.gray.cgColor
        sessionTable.layer.borderWidth = 1
        sessionTable.layer.cornerRadius = 10
        sessionTable.backgroundColor = UIColor.init(red: 43, green: 69, blue: 112, alpha: 1)
        sessionTable.isOpaque = false
        sessionTable.layer.backgroundColor = UIColor.init(red: 43, green: 69, blue: 112, alpha: 1).cgColor
        sessionTable.backgroundView = nil
        selectedSession = 0
        indexOnPlayQueue = 0
        sessionTable.dataSource = self
        sessionTable.delegate = self
        sessionTable.allowsSelection = true
        sessionTable.separatorStyle = UITableViewCellSeparatorStyle.none
        initializePlayer(authSession: session)
        // Do any additional setup after loading the view.
        splashScreen.isHidden = false
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "session", for: indexPath) as! SessionTableViewCell
        
        var vibeName = sessionArray[indexPath.item].vibeType
        var vibePhoto = UIImage()
        if vibeName == "Chill"{
            vibePhoto = #imageLiteral(resourceName: "chillButton1")
        }
        if vibeName == "Focus"{
            vibePhoto = #imageLiteral(resourceName: "focusButton1")
        }
        if vibeName == "Energize"{
            vibePhoto = #imageLiteral(resourceName: "energizeButton1")
        }
        
        cell.vibeImage.image = vibePhoto
    
        //sets the label to be in hours/minutes/seconds
        //TODO: fix this it's not the right math
        var length = sessionArray[indexPath.item].timeDuration!
        let hours = length/60/60
        let minutes = length/60 - hours*60
        let seconds = length - hours*60*60 - minutes*60
        cell.time.font = UIFont(name: cell.time.font.fontName, size: 25)
        cell.layer.cornerRadius = 10
        if(hours > 0){
            cell.time.text = "\(hours)hr \(minutes)min"
        }
        else {
            cell.time.text = "\(minutes) min"
    
        }
    
        
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sessionArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedSession = indexPath.item
        startButton.setImage(#imageLiteral(resourceName: "play"), for: UIControlState.normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addSession" {
            let navigationController = segue.destination as! UINavigationController
            let newViewController = navigationController.topViewController as! ChooseVibeViewController
            newViewController.delegate = self
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
    func initializePlayer(authSession: SPTSession){
        if self.player == nil {
            self.player = SPTAudioStreamingController.sharedInstance()
            self.player!.playbackDelegate = self
            self.player!.delegate = self
            try! player!.start(withClientId: SPTAuth.defaultInstance().clientID)
            self.player!.login(withAccessToken: authSession.accessToken)
        }
    }
    
    @IBAction func skipPrev(_ sender: UIButton) {
        player?.skipPrevious({
        error in
        
        })
    }
    
    @IBAction func skipNext(_ sender: UIButton) {
        player?.skipNext({
        error in
            
        })
    }
    
    
    @IBAction func startVibing(_ sender: Any) {
        if(startButton.imageView?.image == #imageLiteral(resourceName: "play"))
        {
        indexOnPlayQueue = selectedSession
        playMusic(playingSession: sessionArray[selectedSession])
        }
    }
    
    func playMusic(playingSession: Session) {
        startButton.setImage(#imageLiteral(resourceName: "pause"), for: UIControlState.normal)
        currentTime = playingSession.timeDuration
        clock = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.countdown), userInfo: nil, repeats: true)
        
        self.player?.setShuffle(true, callback: { (error) in
            if (error != nil) {
                print("not shuffled")
            }
            self.player?.setIsPlaying(true, callback: { (error) in
                if (error != nil) {
                    print("not set to playing, but shuffled")
                }
                print("about to play")
                self.player?.playSpotifyURI(playingSession.playlistURI, startingWith: 9, startingWithPosition: 0, callback: { (error) in
                    print("in callback")
                    
                    if (error == nil) {
                        print("playing!")
                    }
                    else {
                        print("Error in playSpotifyURI: \(error)")
                    }

                })
            })
        })
        
    }
    
    
    func stopMusic(){
        print("Reached zero")
        clock.invalidate()
        //stop music
        self.player?.setIsPlaying(false, callback: { (error) in
            if (error != nil) {
                print("not set to stopped")
            }
        })
        if indexOnPlayQueue + 1 < sessionArray.count {
            indexOnPlayQueue = indexOnPlayQueue + 1
            playMusic(playingSession: sessionArray[indexOnPlayQueue])
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func sessionWasSaved(session: Session) {
        //do stuff here
        savedSession = session
        sessionArray.append(savedSession)
        splashScreen.isHidden = true
        sessionTable.reloadData()
        
    }
    
    func handleNewSession(_ session: SPTSession) {
        self.session = session
    }
    
    func resizeImage(image:UIImage, toTheSize size:CGSize)->UIImage{
        
        
        var scale = CGFloat(max(size.width/image.size.width,
                                size.height/image.size.height))
        
        var width = image.size.width * scale
        var height = image.size.height * scale
        
        var rr = CGRect(x: 0, y: 0, width: width, height: height)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        image.draw(in: rr)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return newImage!
    }
    
    func getCurrentTime() -> Int{
        return currentTime
    }
    
    
    func countdown() {
        print("in countdown")
        self.currentTime = self.currentTime - 1
        print(currentTime)
        if currentTime == 0 {
            startButton.setImage(#imageLiteral(resourceName: "play"), for: UIControlState.normal)
            stopMusic()
        }
    }
}
