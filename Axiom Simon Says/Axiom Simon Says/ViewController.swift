//
//  ViewController.swift
//  Axiom Simon Says
//
//  Created by Julien Saad on 2018-07-10.
//  Copyright © 2018 Axiom. All rights reserved.
//
import AVFoundation
import UIKit

class ViewController: UIViewController {

    var pattern : [Int] = []

    @IBOutlet weak var currentScoreLabel: UILabel!
    @IBOutlet weak var payAttentionLabel: UILabel!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var orangeButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var highs: UILabel!
    
    var buttons: [UIButton] = []
    var userSequence: [Int] = []
    var numberOfTaps = 0
    var highestscore = 0
    var player: AVAudioPlayer = AVAudioPlayer()

    func playSound(named soundName: String){
        let soundURL = Bundle.main.path(forResource: soundName, ofType: "mp3")
        player = try! AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: soundURL!) as URL, fileTypeHint: AVFileType.mp3.rawValue)
        player.play()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        buttons = [greenButton, redButton, orangeButton, blueButton]

        for button in buttons {
            button.layer.cornerRadius = 50
            button.layer.shadowRadius = 5
            button.layer.shadowOffset = CGSize(width: 0, height: 1)
            button.layer.shadowColor = UIColor.black.cgColor
            button.layer.shadowOpacity = 0.1
        }

        presentNextSequence()
    }

    func presentNextSequence() {
        
        let newRandomnumber = Int(arc4random()) % buttons.count
        
        
        pattern.append(newRandomnumber)
        
        
        numberOfTaps = numberOfTaps + 1

        payAttentionLabel.text = "Pay Attention!"

        if numberOfTaps > pattern.count {
            showVictoryScreen()
            return
        }

        for button in buttons {
            button.isUserInteractionEnabled = false
        }

        let baseDelay = 2
        for i in 0..<numberOfTaps {
            let buttonIndexToTap = pattern[i]
            let button = buttons[buttonIndexToTap]

            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i + baseDelay)) {
                button.isHighlighted = true
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) + Double(baseDelay) + 0.5) {
                button.isHighlighted = false
            }
        }


        DispatchQueue.main.asyncAfter(deadline: .now() + Double(numberOfTaps) + Double(baseDelay)) {
            self.payAttentionLabel.text = "Your turn!"
            for button in self.buttons {
                button.isUserInteractionEnabled = true
            }
        }

    }



    @IBAction func tapButton(_ sender: UIButton) {
        
         self.playSound(named: "correct")

        if sender == greenButton {
            userSequence.append(0)
        }
        else if sender == redButton {
            userSequence.append(1)
        }
        else if sender == orangeButton {
            userSequence.append(2)
        }
        else {
            userSequence.append(3)
        }

        if userSequence.count == numberOfTaps {
            validateSequence()
            userSequence = []
            currentScoreLabel.text = "Current Score: " + String(numberOfTaps - 1)
        }
    }

    func validateSequence() {
        for index in 0..<numberOfTaps {
            if userSequence[index] != pattern[index] {
                // Show failure!
                // You lose!
                showDefeatScreen()
                return
            }
        }
        presentNextSequence()
    }

    func showVictoryScreen() {
        let alert = UIAlertController(title: "You won! 👑", message: "Wow, you have the memory of an elephant 🐘", preferredStyle: .alert)

        let okAction = UIAlertAction(title: "Yay!", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }

    func showDefeatScreen() {
        let alert = UIAlertController(title: "You have a score of .", message: "Sorry, try again!", preferredStyle: .alert)

        let okaction = UIAlertAction(title: "restart", style: .default) { _ in
            
            if self.numberOfTaps > self.highestscore {
                
                self.highestscore = self.numberOfTaps
            
            }
            
                UserDefaults.standard.set(self.highestscore, forKey: "highscore")
            
            self.highs.text = "HighScore: " + String(self.highestscore - 1)
            self.userSequence = []
            self.pattern = []
            self.numberOfTaps = 0
            self.presentNextSequence()
            self.currentScoreLabel.text = "Current Score: 0"
            
        }
        alert.addAction(okaction)
        present(alert, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

