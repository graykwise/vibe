//
//  ChooseVibeViewController.swift
//  Vibe
//
//  Created by Grayson Wise on 6/20/17.
//  Copyright © 2017 Vibe. All rights reserved.
//

import UIKit

class ChooseVibeViewController: UIViewController {

    @IBOutlet weak var energizeButton: UIButton!
    @IBOutlet weak var focusButton: UIButton!
    @IBOutlet weak var chillButton: UIButton!
    @IBOutlet weak var timer: UIDatePicker!
    
    @IBAction func chillButton(_ sender: UIButton) {
        showSelectedButton(selected: sender)
        focusButton.layer.opacity = 0.4
        energizeButton.layer.opacity = 0.4
    }
    
    @IBAction func focusButton(_ sender: UIButton) {
        showSelectedButton(selected: sender)
        energizeButton.layer.opacity = 0.4
        chillButton.layer.opacity = 0.4
    }
    
    @IBAction func energizeButton(_ sender: UIButton) {
        showSelectedButton(selected: sender)
        focusButton.layer.opacity = 0.4
        chillButton.layer.opacity = 0.4
    }
    
    func showSelectedButton(selected: UIButton) {
        energizeButton.isSelected = false
        focusButton.isSelected = false
        chillButton.isSelected = false
        selected.isSelected = true
        selected.layer.opacity = 1
    }
    
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func saveButton(_ sender: Any) {
        print(timer.countDownDuration)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timer.countDownDuration = 60.0
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

}
