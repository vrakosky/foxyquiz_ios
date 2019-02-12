//
//  FoxView.swift
//  OpenQuiz
//
//  Created by esirem on 18/12/2017.
//  Copyright © 2017 vrakosky. All rights reserved.
//

import UIKit

class FoxView: UIView {
    
    @IBOutlet private var fox: UIImageView!
    
    enum Style{
        case correct, incorrect, standard
    }
    
    //2 - style with the fox
    var style: Style = .standard {
        didSet {
            setStyle(style)
        }
    }
    
    private func setStyle(_ style: Style) {
        switch style {
        case .correct:
            fox.image = #imageLiteral(resourceName: "fox_green")
            fox.isHidden = false
        case .incorrect:
            fox.image = #imageLiteral(resourceName: "fox_red")
            fox.isHidden = false
        case .standard:
            fox.image = #imageLiteral(resourceName: "fox_lightBlue")
            fox.isHidden = false
        }
    }
}
