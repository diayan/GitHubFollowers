//
//  GFButton.swift
//  GithubFellows
//
//  Created by diayan siat on 10/11/2020.
//  Copyright © 2020 Diayan Siat. All rights reserved.
//

import UIKit

class GFButton: UIButton {
    
    //override since we're going to customize
    override init(frame: CGRect) {
        super.init(frame: frame) //calls the super UIButton method
        configure()
    }
    
    //this is what handles initialization via storyboard. So it should be used to handle storyboard cases 
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //custom initializer to set background color and title
    convenience init(backgroundColor: UIColor, title: String){
        self.init(frame: .zero) //set the frame to zero cause we will be setting the height and width in autolayout
        self.backgroundColor  = backgroundColor
        self.setTitle(title, for: .normal)
    }
    
    private func configure() {
        layer.cornerRadius    = 10
        titleLabel?.font      = UIFont.preferredFont(forTextStyle: .headline)
        setTitleColor(.white, for: .normal)
        translatesAutoresizingMaskIntoConstraints = false //add view to a view hierachy that uses autolayout
    }
    
    func set(backgroundColor: UIColor, title: String) {
        self.backgroundColor  = backgroundColor
        setTitle(title, for: .normal)
    }
}
