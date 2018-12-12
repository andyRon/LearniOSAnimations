//
//  ViewController.swift
//  ImageGallery
//
//  Created by [Andy Ron](https://github.com/andyRon)  on 2018/12/4.
//  Copyright © 2018 [Andy Ron](https://github.com/andyRon) . All rights reserved.
//


import UIKit

class ImageViewCard: UIImageView {
  
  var title: String!
  var didSelect: ((ImageViewCard)->())?
  
  convenience init(imageNamed: String, title name: String) {
    self.init()
    
    image = UIImage(named: imageNamed)
    contentMode = .scaleAspectFill
    clipsToBounds = true
    
    title = name
    
    autoresizingMask = [.flexibleHeight, .flexibleWidth]
    
    layer.shouldRasterize = true
    layer.rasterizationScale = UIScreen.main.scale
  }
  
  override func didMoveToSuperview() {
    isUserInteractionEnabled = true
    addGestureRecognizer(UITapGestureRecognizer(target: self,
      action: #selector(ImageViewCard.didTapHandler(_:))))
  }
  
  @objc func didTapHandler(_ tap: UITapGestureRecognizer) {
    didSelect?(self)
  }
}
