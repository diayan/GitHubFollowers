//
//  GFAvatarImageView.swift
//  GithubFellows
//
//  Created by diayan siat on 16/12/2020.
//  Copyright © 2020 Diayan Siat. All rights reserved.
//

import UIKit

class GFAvatarImageView: UIImageView {
    let cache = NetworkManager.shared.cache
    let placeholderImage   = UIImage(named: "avatar-placeholder")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    private func configure(){
        layer.cornerRadius = 10
        clipsToBounds      = true //this ensures that the image itself takes the coner radius
        image              = placeholderImage!
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func downloadImage(from urlString: String) {
        let cacheKey = NSString(string: urlString)
        //check if image exists, if it does, don't do a network call to download
        if let image = cache.object(forKey: cacheKey) {
            self.image = image
            return
        }
        
        guard let url       = URL(string: urlString) else {return}
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self  = self else {return}
            
            if error != nil {return}
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {return}
            guard let data  = data else {return}
            
            guard let image = UIImage(data: data) else {return}
            self.cache.setObject(image, forKey: cacheKey) //put image in cache so that the next time it is not downloaded
            
            DispatchQueue.main.async {self.image  = image}
        }
        task.resume()
    }
}
