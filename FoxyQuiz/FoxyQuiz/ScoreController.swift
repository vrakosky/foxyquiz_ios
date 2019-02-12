//
//  ScoreController.swift
//  OpenQuiz
//
//  Created by esirem on 24/11/2017.
//  Copyright © 2017 vrakosky. All rights reserved.
//

import UIKit
import AVFoundation

class ScoreController: UIViewController {

    @IBOutlet weak var cloudHolder: UIView!
    @IBOutlet weak var rocket: UIImageView!
    @IBOutlet weak var hustleLbl: UILabel!
    @IBOutlet weak var onLbl: UILabel!
        
    @IBOutlet weak var blurEffect: UIVisualEffectView!
    
    var myScore = String()
    var player: AVAudioPlayer!
    var effect: UIVisualEffect!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = Bundle.main.path(forResource: "hustle-on", ofType: "wav")!
        let url = URL(fileURLWithPath: path)
        do{
            player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
        }catch let error as NSError{
            print(error.description)
        }
        //Blur effect
        effect = blurEffect.effect
        blurEffect.effect = nil
        
        startAnimation((Any).self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func startAnimation(_ sender: Any) {
        cloudHolder.isHidden = false
        
        player.play()
        
        UIView.animate(withDuration: 2.3, animations:  {
            self.rocket.frame = CGRect(x: 0, y: 140, width: 375, height: 402)
            

        }) { (finished) in
            self.hustleLbl.isHidden = false
            self.onLbl.isHidden = false
            self.onLbl.text = self.myScore
            //self.blurEffect.isHidden = false
            UIView.animate(withDuration: 1.6, animations:  { self.blurEffect.effect = self.effect })
        }
    }
    
    func applyMotionEffect(toView view:UIView, magnitude:Float) {
        let xMotion = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        xMotion.minimumRelativeValue = -magnitude
        xMotion.maximumRelativeValue = magnitude
        
        let yMotion = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongVerticalAxis)
        yMotion.minimumRelativeValue = -magnitude
        yMotion.maximumRelativeValue = magnitude
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [xMotion, yMotion]
        
        view.addMotionEffect(group)
        
    }
}
