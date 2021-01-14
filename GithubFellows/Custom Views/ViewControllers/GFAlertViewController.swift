//
//  GFAlertViewController.swift
//  GithubFellows
//
//  Created by diayan siat on 10/11/2020.
//  Copyright © 2020 Diayan Siat. All rights reserved.

import UIKit

class GFAlertViewController: UIViewController {
    
    let containerView = GFAlertContainerView()
    let titleLabel    = GFTitleLabel(textAlignment: .center, fontSize: 20)
    let messageLabel  = GFBodyLabel(textAlignment: .center)
    let actionButton  = GFButton(backgroundColor: .systemPink, title: "Ok")
    
    var alertTitle: String?
    var message: String?
    var buttonTitle: String?
    
    let padding: CGFloat = 20
    
    init(title: String, message: String, buttonTitle: String) {
        super.init(nibName: nil, bundle: nil)
        
        self.alertTitle  = title
        self.message     = message
        self.buttonTitle = buttonTitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75) //set the background color to black with an opacity of 0.75
        
        configureContainerView()
        configureTitleLabel()
        configureActionButton()
        configureMessageLabel()
    }
    
    func configureContainerView() {
        view.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor), //center vertically
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor), //center horizontally
            containerView.widthAnchor.constraint(equalToConstant: 280), //set width alert
            containerView.heightAnchor.constraint(equalToConstant: 220) //set height of alert
        ])
    }
    
    func configureTitleLabel() {
        containerView.addSubview(titleLabel)
        titleLabel.text = alertTitle ?? "Something went wrong"
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 28)
        ])
    }
    
    func configureActionButton() {
        containerView.addSubview(actionButton)
        actionButton.setTitle(buttonTitle ?? "Ok", for: .normal)
        
        actionButton.addTarget(self, action: #selector(dismisVC), for: .touchUpInside)
        NSLayoutConstraint.activate([
            actionButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -padding),
            actionButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            actionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            actionButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    func configureMessageLabel() {
        containerView.addSubview(messageLabel)
        messageLabel.text          = message ?? "Unable to complete request"
        messageLabel.numberOfLines = 4
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            messageLabel.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -12),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding)
        ])
    }
    @objc func dismisVC(){
        dismiss(animated: true)
    }
}
