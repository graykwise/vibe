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
    
    @IBAction func chillButton(_ sender: UIButton) {
        showSelectedButton(selected: sender)
    }
    
    @IBAction func focusButton(_ sender: UIButton) {
        showSelectedButton(selected: sender)
    }
    
    @IBAction func energizeButton(_ sender: UIButton) {
        showSelectedButton(selected: sender)
    }
    
    func showSelectedButton(selected: UIButton) {
        selected.isSelected = true
        //set the other 2 buttons to not selected
        //still need to implement
        energizeButton.isSelected = false
        focusButton.isSelected = false
    }
    
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func saveButton(_ sender: Any) {
    }
    
    @IBOutlet weak var timer: UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
