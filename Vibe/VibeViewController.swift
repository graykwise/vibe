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

    @IBOutlet weak var sessionTable: UITableView!
    
    var sessionArray = [Session]()
    var clock = Timer()
    var time: Int!
    var player: SPTAudioStreamingController?
    var savedSession: Session!
    
    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sessionTable.dataSource = self
        sessionTable.delegate = self
        sessionTable.allowsSelection = true
        sessionTable.separatorStyle = UITableViewCellSeparatorStyle.none
        // Do any additional setup after loading the view.
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
    

    @IBAction func startVibing(_ sender: Any) {
        
        if player?.loggedIn == true {
            print("logged in")
        }
        if player?.loggedIn == false {
            print("not logged in")
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
        
        self.player?.playSpotifyURI(sessionArray[0].playlistURI, startingWith: 9, startingWithPosition: 0, callback: { (error) in
            print("in callback")

            if (error == nil) {
                print("playing!")
            }
            else {
                print("Error in playSpotifyURI: \(error)")
            }
        })
        
        time = sessionArray[0].timeDuration
        
        
        clock = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(OtherViewController.countdown), userInfo: nil, repeats: true)
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
        
        sessionTable.reloadData()
        
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
