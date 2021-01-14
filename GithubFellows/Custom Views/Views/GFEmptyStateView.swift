//
//  GFEmptyStateView.swift
//  GithubFellows
//
//  Created by diayan siat on 19/12/2020.
//  Copyright © 2020 Diayan Siat. All rights reserved.
//

import UIKit

class GFEmptyStateView: UIView {
    
    let messageLabel = GFTitleLabel(textAlignment: .center, fontSize: 28)
    let logoImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //convinience initializer
    convenience init(message: String) {
        self.init(frame: .zero)
        messageLabel.text = message
    }
    
    private func configure() {
        configureMessageLabel()
        configureImageLogo()
    }
    
    private func configureMessageLabel() {
        addSubview(messageLabel)
        messageLabel.numberOfLines = 3
        messageLabel.textColor     = .secondaryLabel
        
        //custom constraints for iPhoneSE and iPhone8Zoomed
        let labelCenterYConstant: CGFloat      = DeviceType.isiPhoneSE || DeviceType.isiPhone8Zoomed  ? -80 : -150
        
        NSLayoutConstraint.activate([
            messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
            messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
            messageLabel.heightAnchor.constraint(equalToConstant: 200),
            messageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: labelCenterYConstant),//this puts it up 150 points above the middle
        ])
    }
    
    private func configureImageLogo() {
        addSubview(logoImageView)
        logoImageView.image    = Images.emptyStateLogo
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let logoBottomViewConstant: CGFloat    = DeviceType.isiPhoneSE || DeviceType.isiPhone8Zoomed  ? 80 : 40
        let logoImageViewBottomConstraint = logoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: logoBottomViewConstant)
        logoImageViewBottomConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            logoImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.3), //take image width and multiply it by 3
            logoImageView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.3), //the height and width will be the same
            logoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 170)
        ])
    }
}
