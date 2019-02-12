//
//  QuestionView.swift
//  OpenQuiz
//
//  Created by vrakosky on 16/11/2017.
//  Copyright © 2017 vrakosky. All rights reserved.
//

import UIKit

class QuestionView: UIView {
    
    @IBOutlet private var label: UILabel!
    @IBOutlet private var icon:  UIImageView!
    
    
    enum Style{
        case correct, incorrect, standard
    }
    
    var title = "init" {
        didSet {
            label.text = title
        }
    }
    
    //1 - style with the box
    var style: Style = .standard {
        didSet {
            setStyle(style)
        }
    }
    
    private func setStyle(_ style: Style) {
        switch style {
        case .correct:
            backgroundColor = #colorLiteral(red: 0.7897478938, green: 0.9258520007, blue: 0.6278949976, alpha: 1)
                //UIColor(red: 200/255.0, green: 236/255.0, blue: 160/255.0, alpha: 1)
            icon.image = UIImage(named: "Icon Correct")
            icon.isHidden = false
        case .incorrect:
            backgroundColor = #colorLiteral(red: 0.9567385316, green: 0.5308938622, blue: 0.5824941993, alpha: 1)
            icon.image = #imageLiteral(resourceName: "Icon Error")
            icon.isHidden = false
        case .standard:
            backgroundColor = #colorLiteral(red: 0.7233663201, green: 0.7233663201, blue: 0.7233663201, alpha: 1)
            icon.isHidden = true
            
        }
    }
}
