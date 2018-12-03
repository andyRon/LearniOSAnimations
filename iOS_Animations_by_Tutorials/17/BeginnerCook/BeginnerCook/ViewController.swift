//
//  ViewController.swift
//  BeginnerCook
//
//  Created by [Andy Ron](https://github.com/andyRon)  on 2018/11/15.
//  Copyright © 2018 [Andy Ron](https://github.com/andyRon) . All rights reserved.
//


import UIKit

let herbs = HerbModel.all()

class ViewController: UIViewController {
  
  @IBOutlet var listView: UIScrollView!
  @IBOutlet var bgImage: UIImageView!
  var selectedImage: UIImageView?
    
  let transition = PopAnimator()
  
  //MARK: UIViewController
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    transition.dismissCompletion = {
        self.selectedImage!.isHidden = false
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    if listView.subviews.count < herbs.count {
      listView.viewWithTag(0)?.tag = 1000 //prevent confusion when looking up images
      setupList()
    }
    
  }

  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }

  //MARK: View setup
  
  //add all images to the list
  func setupList() {
    
    for i in herbs.indices {
      
      //create image view
      let imageView  = UIImageView(image: UIImage(named: herbs[i].image))
      imageView.tag = i
      imageView.contentMode = .scaleAspectFill
      imageView.isUserInteractionEnabled = true
      imageView.layer.cornerRadius = 20.0
      imageView.layer.masksToBounds = true
      listView.addSubview(imageView)
      
      //attach tap detector
      imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapImageView)))
    }
    
    listView.backgroundColor = UIColor.clear
    positionListItems()
  }
  
  //position all images inside the list
  func positionListItems() {
    let listHeight = listView.frame.height
    let itemHeight: CGFloat = listHeight * 1.33
    let aspectRatio = UIScreen.main.bounds.height / UIScreen.main.bounds.width
    let itemWidth: CGFloat = itemHeight / aspectRatio
    
    let horizontalPadding: CGFloat = 10.0
    
    for i in herbs.indices {
      let imageView = listView.viewWithTag(i) as! UIImageView
      imageView.frame = CGRect(
        x: CGFloat(i) * itemWidth + CGFloat(i+1) * horizontalPadding, y: 0.0,
        width: itemWidth, height: itemHeight)
        print(i, imageView.frame)
    }
    
    listView.contentSize = CGSize(
      width: CGFloat(herbs.count) * (itemWidth + horizontalPadding) + horizontalPadding,
      height:  0)
  }
  
  //MARK: Actions
  
  @objc func didTapImageView(_ tap: UITapGestureRecognizer) {
    selectedImage = tap.view as? UIImageView
    
    let index = tap.view!.tag
    let selectedHerb = herbs[index]
    
    //present details view controller
    let herbDetails = storyboard!.instantiateViewController(withIdentifier: "HerbDetailsViewController") as! HerbDetailsViewController
    herbDetails.herb = selectedHerb
    herbDetails.transitioningDelegate = self
    present(herbDetails, animated: true, completion: nil)
  }
  // 设备方向变化
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)

    coordinator.animate(alongsideTransition: { context in
        self.bgImage.alpha = (size.width > size.height) ? 0.25 : 0.55
        // 设备方向变化后的位置调整
        self.positionListItems()
    }, completion: nil)
  }
}

extension ViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.originFrame = selectedImage!.superview!.convert(selectedImage!.frame, to: nil)
        transition.presenting = true
        selectedImage!.isHidden = true
        
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = false
        return transition
    }
}
