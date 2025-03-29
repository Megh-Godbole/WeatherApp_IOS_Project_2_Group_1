//
//  ViewController.swift
//  Weather Application (Project 2)
//
//  Created by Megh Godbole on 2025-03-29.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func locationPressed(_ sender: UIButton) {
    }
    @IBAction func searchPressed(_ sender: UIButton) {
    }
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBAction func searchTextField(_ sender: UITextField) {
    }
    @IBAction func toggleSwitch(_ sender: Any) {
    }
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
}

