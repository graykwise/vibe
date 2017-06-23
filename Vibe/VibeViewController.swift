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
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var bigTimer: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var currentSong: UILabel!
    
    @IBOutlet weak var currentArtist: UILabel!
    
    var sessionArray = [Session]()
    var clock = Timer()
    var time: Int!
    var player: SPTAudioStreamingController?
    var savedSession: Session!
    var selectedSession: Int!
    var indexOnPlayQueue: Int!
    var session: SPTSession!
    var currentTime: Int!
    var currentPlaylistLength: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentPlaylistLength = 0
        sessionTable.layer.borderColor = UIColor.gray.cgColor
        sessionTable.layer.borderWidth = 0
        sessionTable.layer.cornerRadius = 0
        sessionTable.isHidden = true
        selectedSession = 0
        bigTimer.isHidden = true
        indexOnPlayQueue = 0
        sessionTable.dataSource = self
        sessionTable.delegate = self
        sessionTable.allowsSelection = true
        sessionTable.separatorStyle = UITableViewCellSeparatorStyle.none
        initializePlayer(authSession: session)
        startButton.isHidden = true
        prevButton.isHidden = true
        nextButton.isHidden = true
        currentSong.isHidden = true
        currentArtist.isHidden = true
        splashScreen.isHidden = false
        let imageViewThing = UIImageView(image: #imageLiteral(resourceName: "vibetitle"))
        self.navigationItem.titleView = imageViewThing
        
    }
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didChange metadata: SPTPlaybackMetadata!) {
        print("Spotify Meta Data Changed")
        currentSong.text = metadata.currentTrack?.name
        currentArtist.text = metadata.currentTrack?.artistName
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "session", for: indexPath) as! SessionTableViewCell
        cell.layer.backgroundColor = UIColor.clear.cgColor

        var vibeName = sessionArray[indexPath.item].vibeType
        var vibePhoto = UIImage()
        if vibeName == "Chill"{
            vibePhoto = #imageLiteral(resourceName: "chillB")
        }
        if vibeName == "Focus"{
            vibePhoto = #imageLiteral(resourceName: "focusB")
        }
        if vibeName == "Sweat"{
            vibePhoto = #imageLiteral(resourceName: "energizeB")
        }
        
        cell.vibeImage.image = vibePhoto
    
        //sets the label to be in hours/minutes/seconds
        //TODO: fix this it's not the right math
        var length = sessionArray[indexPath.item].timeDuration!
        let hours = length/60/60
        let minutes = length/60 - hours*60
        let seconds = length - hours*60*60 - minutes*60
        //cell.time.font = UIFont(name: cell.time.font.fontName, size: 25)
        cell.layer.cornerRadius = 0
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
        if sessionArray.count == 0 {
            startButton.isEnabled = false
            nextButton.isEnabled = false
            prevButton.isEnabled = false
        }
        else {
            startButton.isEnabled = true
            nextButton.isEnabled = true
            prevButton.isEnabled = true
        }
        
        return sessionArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedSession = indexPath.item
        startButton.setImage(#imageLiteral(resourceName: "playButton"), for: UIControlState.normal)
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            sessionArray.remove(at: indexPath.item)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            stopMusic()
            bigTimer.isHidden = true
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Kill Vibe"
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
        tableView.backgroundView?.backgroundColor = UIColor.clear
        tableView.backgroundColor = UIColor.clear

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
        bigTimer.isHidden = false

        if(startButton.imageView?.image == #imageLiteral(resourceName: "playButton"))
        {
            startButton.setImage(#imageLiteral(resourceName: "stopButton"), for: UIControlState.normal)
            currentSong.isHidden = false
            currentArtist.isHidden = false
            indexOnPlayQueue = selectedSession
            playMusic(playingSession: sessionArray[selectedSession])
        }
        else {
            startButton.setImage(#imageLiteral(resourceName: "playButton"), for: UIControlState.normal)
            currentSong.text = "Start a new vibe!"
            currentArtist.text = "You know you want to..."
            killVibe()
        }
    }
    
    func playMusic(playingSession: Session) {
        currentTime = playingSession.timeDuration
        var random = arc4random_uniform(26)
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
                self.player?.playSpotifyURI(playingSession.playlistURI, startingWith: UInt(random), startingWithPosition: 0, callback: { (error) in
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
        startButton.isHidden = false
        prevButton.isHidden = false
        nextButton.isHidden = false
                //do stuff here
        splashScreen.isHidden = true
        sessionTable.isHidden = false
        savedSession = session
        sessionArray.append(savedSession)
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
    
    func killVibe() {
        clock.invalidate()
        //stop music
        self.player?.setIsPlaying(false, callback: { (error) in
            if (error != nil) {
                print("not set to stopped")
            }
        })
        currentTime = sessionArray[indexOnPlayQueue].timeDuration
        updateTimeLabel()
    }
    
    
    func countdown() {

        print("in countdown")
        self.currentTime = self.currentTime - 1
        updateTimeLabel()

        print(currentTime)
        if currentTime == 0 {
            startButton.setImage(#imageLiteral(resourceName: "playButton"), for: UIControlState.normal)
            stopMusic()
        }
    }
    
    func updateTimeLabel() {
        let thehours = currentTime/60/60
        let theminutes = currentTime/60 - thehours*60
        let theseconds = currentTime - thehours*60*60 - theminutes*60
        
        if(thehours > 0){
            if (theminutes < 10) {
                if theseconds < 10 {
                    bigTimer.text = "\(thehours):0\(theminutes):0\(theseconds)"
                    
                }
                else {
                    bigTimer.text = "\(thehours):0\(theminutes):\(theseconds)"
                }
            }
            else
            {
                if theseconds < 10 {
                    bigTimer.text = "\(thehours):\(theminutes):0\(theseconds)"
                    
                }
                else {
                    bigTimer.text = "\(thehours):\(theminutes):\(theseconds)"
                }
                
            }
        }
        else {
            if (theminutes > 0) {
                if theseconds < 10 {
                    bigTimer.text = "\(theminutes):0\(theseconds)"
                    
                }
                else {
                    bigTimer.text = "\(theminutes):\(theseconds)"
                }
            }
            else
            {
                bigTimer.text = "\(theseconds)"
            }
            
        }
    }
}
