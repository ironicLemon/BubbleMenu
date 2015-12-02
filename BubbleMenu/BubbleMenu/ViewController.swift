//
//  ViewController.swift
//  BubbleMenu
//
//  Created by zeus on 11/11/2015.
//  Copyright © 2015 Si. All rights reserved.
//

import UIKit

final class ViewController: UIViewController, UICollisionBehaviorDelegate, UIGestureRecognizerDelegate, UIDynamicAnimatorDelegate {
    
    private var greenCircle: UIView?
    
    private var animator: UIDynamicAnimator?
    private var gravity: UIGravityBehavior?
    private var collision: UICollisionBehavior?
    
    private var panGesture: UIPanGestureRecognizer?
    
    private var attach: UIAttachmentBehavior?
    
    private var labelConstraint : NSLayoutConstraint?
    
    private var widthConstraint : NSLayoutConstraint?
    private var heightConstraint : NSLayoutConstraint?
    
    private var xBubbleCentre : NSLayoutConstraint?
    private var yBubbleCentre : NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Instantiate the box View
        self.greenCircle = UIView()
        
        // Make it green
        self.greenCircle?.backgroundColor = UIColor.greenColor();
        self.greenCircle?.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.greenCircle!)
        
        self.widthConstraint = NSLayoutConstraint (
            item: self.greenCircle!,
            attribute: .Width,
            relatedBy: .Equal,
            toItem: nil,
            attribute: .NotAnAttribute,
            multiplier: 1,
            constant: 100)
        
        self.greenCircle?.addConstraint(self.widthConstraint!)
        
        self.heightConstraint = NSLayoutConstraint (
            item: self.greenCircle!,
            attribute: .Height,
            relatedBy: .Equal,
            toItem: nil,
            attribute: .NotAnAttribute,
            multiplier: 1,
            constant: 100)
        
        self.greenCircle?.addConstraint(self.heightConstraint!)
        
        // set x and y position
        xBubbleCentre = NSLayoutConstraint(item: self.greenCircle!, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .Left, multiplier: 1, constant: 250)
        yBubbleCentre = NSLayoutConstraint(item: self.greenCircle!, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1, constant: 250)
        
        self.view.addConstraint(xBubbleCentre!)
        self.view.addConstraint(yBubbleCentre!)
        
        self.greenCircle?.layer.cornerRadius = 50;
        self.greenCircle?.clipsToBounds = true
        
        let label = UILabel()
        label.text = "item"
        label.intrinsicContentSize()
        label.translatesAutoresizingMaskIntoConstraints = false
        self.greenCircle!.addSubview(label)
        
        let xConstraint = NSLayoutConstraint(item: label, attribute: .CenterX, relatedBy: .Equal, toItem: self.greenCircle, attribute: .CenterX, multiplier: 1, constant: 0)
        self.labelConstraint = NSLayoutConstraint(item: label, attribute: .CenterY, relatedBy: .Equal, toItem: self.greenCircle, attribute: .CenterY, multiplier: 1, constant: 0)
        
        self.greenCircle?.addConstraint(self.labelConstraint!)
        self.greenCircle?.addConstraint(xConstraint)
        
        self.panGesture = UIPanGestureRecognizer(target: self, action: "panning:")
        self.panGesture?.delegate = self
        self.greenCircle?.addGestureRecognizer(self.panGesture!)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "tap:")
        tapGesture.delegate = self
        self.greenCircle?.addGestureRecognizer(tapGesture)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard(self.animator == nil) else {
            return;
        }

        // Instantiates the animator
        self.animator = UIDynamicAnimator(referenceView: self.view);
        
        self.animator!.delegate = self
        
        // Instantiates the Gravity Behavior and assigns
        self.gravity = UIGravityBehavior(items: [self.greenCircle!]);
        
        self.animator!.addBehavior(self.gravity!)
        
        self.collision = UICollisionBehavior(items: [self.greenCircle!]);
        self.collision?.collisionDelegate = self
        
        // set a collision boundary according to the bounds of the dynamic animator's coordinate system (in our case the boundaries of self.view,
        self.collision!.translatesReferenceBoundsIntoBoundary = true
        
        self.animator!.addBehavior(self.collision!)
        
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        print("update view constriants")

        // if the frame has already been realised then adjust the constraints
        if (self.greenCircle?.frame.width > 0)
        {
            self.xBubbleCentre!.constant = self.greenCircle!.center.x
            self.yBubbleCentre!.constant = self.greenCircle!.center.y
            
//            print("width \(self.greenCircle!.frame.size.width)")
//            print("height \(self.greenCircle!.frame.size.height)")
//            
//            self.widthConstraint!.constant = self.greenCircle!.frame.size.width
//            self.heightConstraint!.constant = self.greenCircle!.frame.size.height
        }
    }
    
    func tap(tapGesture: UITapGestureRecognizer) {
        
        print("item tapped")
        
        let item = tapGesture.view
        //item?.removeGestureRecognizer(tapGesture)
  
        weak var weakSelf = self
        
        self.animator!.removeAllBehaviors()
        
        let image = UIImage(named: "0007")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.alpha = 0
        
        item?.addSubview(imageView)
        
        let xConstraint = NSLayoutConstraint(item: imageView, attribute: .CenterX, relatedBy: .Equal, toItem: item, attribute: .CenterX, multiplier: 1, constant: 0)
        let yConstraint = NSLayoutConstraint(item: imageView, attribute: .CenterY, relatedBy: .Equal, toItem: item, attribute: .CenterY, multiplier: 1, constant: 0)
        
        item?.addConstraint(xConstraint)
        item?.addConstraint(yConstraint)
        
        
        let animation = CABasicAnimation(keyPath: "cornerRadius")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.fromValue = self.greenCircle!.layer.cornerRadius
        animation.toValue = 75
        animation.duration = 1.4
        self.greenCircle!.layer.addAnimation(animation, forKey: "cornerRadius")
        
        item?.layoutIfNeeded()

        UIView.animateWithDuration(1.4, animations: { () -> Void in
            
            weakSelf?.heightConstraint?.constant = 150
            weakSelf?.widthConstraint?.constant = 150
            
            weakSelf?.labelConstraint?.constant = 22

            imageView.alpha = 1.0
            
            self.view.layoutIfNeeded()
            

            }) { (result) -> Void in

                item?.layer.cornerRadius = 75;
                
                //weakSelf?.animator!.addBehavior(self.gravity!)
                //weakSelf?.animator!.addBehavior(self.collision!)
                
                //self.animator?.updateItemUsingCurrentState(item!)
                
                //item?.setNeedsUpdateConstraints()
                
                print("animation complete")
        }
        
        
    }
    
    func panning(pan: UIPanGestureRecognizer) {
        print("Our box is panning...");
        let location = pan.locationInView(self.view);
        let touchLocation = pan.locationInView(self.greenCircle);
        
        if pan.state == .Began {
            //Removes all the behaviors attached to the animators for now
            self.animator!.removeAllBehaviors()
            
            let offset = UIOffsetMake(touchLocation.x - CGRectGetMidX(self.greenCircle!.bounds), touchLocation.y - CGRectGetMidY(self.greenCircle!.bounds))
            self.attach = UIAttachmentBehavior(item: self.greenCircle!, offsetFromCenter: offset, attachedToAnchor: location)
            self.animator!.addBehavior(self.attach!);
        }
        else if pan.state == .Changed {
            //self.greenCircle!.center = location;
            self.attach!.anchorPoint = location;
        }
        else if pan.state == .Ended {
            self.animator!.removeBehavior(self.attach!)
            
            let itemBehavior = UIDynamicItemBehavior(items: [self.greenCircle!]);
            itemBehavior.addLinearVelocity(pan.velocityInView(self.view), forItem: self.greenCircle!);
            itemBehavior.angularResistance = 0;
            itemBehavior.elasticity = 0.3;
            self.animator!.addBehavior(itemBehavior);
            
            // Handles what should happen when the box is released...
            self.animator!.addBehavior(self.gravity!)
            self.animator!.addBehavior(self.collision!)
        }
    }
    
    func dynamicAnimatorDidPause(animator: UIDynamicAnimator) {
        print("animator paused")
        
        // TODO add gesture recogisnes here otherwise can interact before the gravity has finished affecting the position

        self.view.setNeedsUpdateConstraints()
    }
    
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, atPoint p: CGPoint) {
        print("Boundary contact occurred - \(identifier)")
 
    }
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        print("gesture recognizer begin \(gestureRecognizer)")

        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

