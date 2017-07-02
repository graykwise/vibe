//
//  ChooseVibeViewController.swift
//  Vibe
//
//  Created by Grayson Wise on 6/20/17.
//  Copyright © 2017 Vibe. All rights reserved.
//

import UIKit

class ChooseVibeViewController: UIViewController {
    var selectedVibe: String!
    var delegate: SessionDelegate?
    var selectedSession: Session!
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var sweatButton: UIButton!
    @IBOutlet weak var focusButton: UIButton!
    @IBOutlet weak var chillButton: UIButton!
    @IBOutlet weak var timer: UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let imageViewThing = UIImageView(image: #imageLiteral(resourceName: "vibetitle"))
//        self.navigationItem.titleView = imageViewThing
        timer.countDownDuration = 60.0
        saveButton.isEnabled = false
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func chillButton(_ sender: UIButton) {
        showSelectedButton(selected: sender)
        focusButton.layer.opacity = 0.4
        sweatButton.layer.opacity = 0.4
        
        selectedVibe = "Chill"
        saveButton.isEnabled = true
        
    }
    
    @IBAction func focusButton(_ sender: UIButton) {
        showSelectedButton(selected: sender)
        sweatButton.layer.opacity = 0.4
        chillButton.layer.opacity = 0.4
        
        selectedVibe = "Focus"
        saveButton.isEnabled = true
        
    }
    
    @IBAction func sweatButton(_ sender: UIButton) {
        showSelectedButton(selected: sender)
        focusButton.layer.opacity = 0.4
        chillButton.layer.opacity = 0.4
        
        selectedVibe = "Sweat"
        saveButton.isEnabled = true
    }
    
    func showSelectedButton(selected: UIButton) {
        sweatButton.isSelected = false
        focusButton.isSelected = false
        chillButton.isSelected = false
        selected.isSelected = true
        selected.layer.opacity = 1
    }
    
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func saveButton(_ sender: Any) {
        selectedSession = Session(length: Int(timer.countDownDuration), vibe: selectedVibe)
        delegate?.sessionWasSaved(session: selectedSession)
        dismiss(animated: true, completion: nil)
    }
    
   
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "saveSegue" {
            //
            print(selectedSession.vibeType)

            let nextView = segue.destination as? VibeViewController
            nextView?.savedSession = selectedSession
            }
    }

}
