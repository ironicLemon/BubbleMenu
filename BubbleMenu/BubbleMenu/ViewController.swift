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
        let xCentre = NSLayoutConstraint(item: self.greenCircle!, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .Left, multiplier: 1, constant: 250)
        let yCentre = NSLayoutConstraint(item: self.greenCircle!, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1, constant: 250)
        
        self.view.addConstraint(xCentre)
        self.view.addConstraint(yCentre)
        
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
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard(self.animator == nil) else {
            return;
        }
        
//        print("layout subviews")
//        print("frame height \(self.greenCircle!.frame.size.height)")
//        print("frame width \(self.greenCircle!.frame.size.width)")
//        print("frame x \(self.greenCircle!.frame.origin.x)")
//        print("frame y \(self.greenCircle!.frame.origin.y)")

        
        // Instantiates the animator
        self.animator = UIDynamicAnimator(referenceView: self.view);
        
        self.animator!.delegate = self
        
        // Instantiates the Gravity Behavior and assigns
        self.gravity = UIGravityBehavior(items: [self.greenCircle!]);
        self.gravity?.action = { () in
            //self.view.updateConstraintsIfNeeded()
        }
        
        self.animator!.addBehavior(self.gravity!)
        
        self.collision = UICollisionBehavior(items: [self.greenCircle!]);
        self.collision?.collisionDelegate = self
        
        self.collision?.action = { () in
            //self.view.updateConstraintsIfNeeded()
        }
        
        // et a collision boundary according to the bounds of the dynamic animator's coordinate system (in our case the boundaries of self.view,
        self.collision!.translatesReferenceBoundsIntoBoundary = true
        
        self.animator!.addBehavior(self.collision!)
        
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        print("update constrinats")
        print("frame height \(self.greenCircle!.frame.size.height)")
        print("frame width \(self.greenCircle!.frame.size.width)")
        print("frame x \(self.greenCircle!.frame.origin.x)")
        print("frame y \(self.greenCircle!.frame.origin.y)")
        
        // TODO reset constraints to reflect the frame
        
    }
    
    func tap(tapGesture: UITapGestureRecognizer) {
        
        print("item tapped")
        
        let item = tapGesture.view
        //item?.removeGestureRecognizer(tapGesture)
        
        //item?.updateConstraintsIfNeeded()
  
        weak var weakSelf = self
        
        self.animator!.removeAllBehaviors()
        
        //self.view.updateConstraintsIfNeeded()
        
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            
            //weakSelf?.view.layoutIfNeeded()
            //weakSelf?.view.updateConstraints()
            
            //item?.removeConstraints(item!.constraints)
            
            weakSelf?.heightConstraint?.constant = 150
            weakSelf?.widthConstraint?.constant = 150
            
            //item?.addConstraint(weakSelf!.heightConstraint!)
            //item?.addConstraint(weakSelf!.widthConstraint!)
            
            let touchLocation = tapGesture.locationInView(self.view);
            
            print("touch x \(touchLocation.x)")
            print("touch y \(touchLocation.y)")
            
            print("frame height \(item?.frame.size.height)")
            print("frame width \(item?.frame.size.width)")
            
            // TODO translate into view click position
            print("frame x \(item?.frame.origin.x)")
            print("frame y \(item?.frame.origin.y)")
            
            item?.layer.cornerRadius = 75;
            item?.layer.borderWidth = 2.0
            item?.layer.borderColor = UIColor.brownColor().CGColor
            
            // TODO are those constraints dodgy so knocking out of whack....
            
//            let image = UIImage(named: "0007")
//            let imageView = UIImageView(image: image)
//            imageView.translatesAutoresizingMaskIntoConstraints = false
//            
//            item?.addSubview(imageView)
//            
//            let xConstraint = NSLayoutConstraint(item: imageView, attribute: .CenterX, relatedBy: .Equal, toItem: item, attribute: .CenterX, multiplier: 1, constant: 0)
//            let yConstraint = NSLayoutConstraint(item: imageView, attribute: .CenterY, relatedBy: .Equal, toItem: item, attribute: .CenterY, multiplier: 1, constant: 0)
//            
//            item?.addConstraint(xConstraint)
//            item?.addConstraint(yConstraint)
//            
//            weakSelf?.labelConstraint?.constant = 22
            
            //weakSelf?.view.updateConstraintsIfNeeded()
            //weakSelf?.view.layoutIfNeeded()
            
            
            //self.animator!.updateItemUsingCurrentState(item!)
            //self.view.updateConstraintsIfNeeded()
            
            //weakSelf?.view.layoutIfNeeded()

            }) { (result) -> Void in
                
                //self.view.updateConstraints()
                
                //self.view.layoutIfNeeded()
                
                //self.view.updateConstraintsIfNeeded()
                //item?.layoutIfNeeded()
                //self.animator!.updateItemUsingCurrentState(item!)
                //item?.updateConstraintsIfNeeded()
                weakSelf?.animator!.addBehavior(self.gravity!)
                weakSelf?.animator!.addBehavior(self.collision!)
                //self.animator!.updateItemUsingCurrentState(item!)
                //self.animator!.updateItemUsingCurrentState(self.view)
                //item?.updateConstraintsIfNeeded()
                //self.view.updateConstraintsIfNeeded()
                
//                print("animation completion block")
//                print("frame height \(item?.frame.size.height)")
//                print("frame width \(item?.frame.size.width)")
//                
//                // TODO translate into view click position
//                print("frame x \(item?.frame.origin.x)")
//                print("frame y \(item?.frame.origin.y)")
                
                //weakSelf?.view.updateConstraintsIfNeeded()
                //weakSelf?.view.layoutIfNeeded()
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
        //self.view.updateConstraints()
        //self.animator!.updateItemUsingCurrentState(self.view)
        
        self.view.setNeedsUpdateConstraints()
        self.view.layoutIfNeeded()
        
//        print("ldynamic animator paused")
//        print("frame height \(self.greenCircle!.frame.size.height)")
//        print("frame width \(self.greenCircle!.frame.size.width)")
//        print("frame x \(self.greenCircle!.frame.origin.x)")
//        print("frame y \(self.greenCircle!.frame.origin.y)")
    }
    
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, atPoint p: CGPoint) {
        print("Boundary contact occurred - \(identifier)")
        
        //self.animator!.updateItemUsingCurrentState(self.greenCircle!)
        //self.animator!.updateItemUsingCurrentState(self.view)
    }
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        print("gesture recognizer begin \(gestureRecognizer)")
        
        //self.view.updateConstraints()
        
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

