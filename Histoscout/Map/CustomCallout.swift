//
//  CoffeeCalloutView.swift
//  hello-maps
//
//  Created by Mohammad Azam on 8/10/18.
//  Copyright © 2018 Mohammad Azam. All rights reserved.


import Foundation
import UIKit

class CustomCalloutView :UIView {
    
    private var annotation :EditableAnnotation!
    
    init(annotation :EditableAnnotation, frame :CGRect = CGRect.zero) {
        super.init(frame: frame)
        self.annotation = annotation
        self.frame = frame
        configure()
    }
    
    func add(to view :UIView) {
        
        view.addSubview(self)
        
        self.widthAnchor.constraint(equalToConstant: 120).isActive = true
        self.heightAnchor.constraint(equalToConstant: 120).isActive = true
        self.bottomAnchor.constraint(equalTo: view.topAnchor, constant: -5).isActive = true
        self.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    private func configure() {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 60.0
        self.layer.masksToBounds = true
        self.backgroundColor = UIColor(displayP3Red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        
        // text label
        let titleLabel = UILabel(frame: CGRect.zero)
        titleLabel.textColor = UIColor.black
        titleLabel.text = annotation.title
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(titleLabel)
        
        titleLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

