//
//  UIViewExtension.swift
//  TubbrAssignment
//
//  Created by Gaurav Kabra on 11/07/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

extension UIView
{
    struct Static {
        static var key = "key"
    }
    var assosiatedView: AnyObject? {
        get {
            return objc_getAssociatedObject(self, &Static.key) as AnyObject?
        }
        set {
            objc_setAssociatedObject(self, &Static.key, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    func animateWith(destinationView: UIView, duration: TimeInterval = 0.4, delay: TimeInterval = 0.0,
                     setAssosiate: Bool = false, sourceFrame: CGRect?, completion: (() -> Void)? = nil)
    {
        if let window: UIWindow = UIApplication.shared.windows.first {
            destinationView.layoutIfNeeded()
            isHidden = true
            let sourceSuperView = superview?.superview ?? self
            let sourceOrigin = sourceSuperView.convert(frame.origin, to: nil)
            let destinationSuperView = destinationView.superview ?? destinationView
            let destinationOrigin = destinationSuperView.convert(destinationView.frame.origin, to: nil)
            if let sourceView = self as? UIImageView, let destinationImageView = destinationView as? UIImageView {
                destinationView.isHidden = true
                let itemView = UIImageView(image: destinationImageView.image)
                itemView.contentMode = destinationImageView.contentMode
                itemView.frame.size = frame.size
                itemView.frame.origin = sourceOrigin
                if sourceFrame != nil {
                    itemView.frame.origin = sourceFrame!.origin
                }
                itemView.layer.cornerRadius = sourceView.layer.cornerRadius
                window.addSubview(itemView)
                itemView.clipsToBounds = true
                UIView.animate(withDuration: duration, delay: delay, options: .curveLinear, animations: {
                    itemView.layer.cornerRadius = destinationImageView.layer.cornerRadius
                    itemView.frame.origin = destinationOrigin
                    itemView.frame.size = CGSize.init(width: destinationImageView.frame.size.width, height: destinationImageView.frame.size.height)
                }) { (_) in
                    self.isHidden = false
                    destinationView.isHidden = false
                    itemView.alpha = 0.0
                    itemView.removeFromSuperview()
                    completion?()
                }
            } else if let sourceLabel = self as? UILabel, let destinationLabel = destinationView as? UILabel {
                let itemLabel = UILabel()
                let text = destinationLabel.text
                destinationLabel.text = " "
                itemLabel.text = sourceLabel.text
                itemLabel.font = sourceLabel.font
                itemLabel.frame.size = frame.size
                itemLabel.frame.origin = sourceOrigin
                itemLabel.clipsToBounds = true
                window.addSubview(itemLabel)
                UIView.animate(withDuration: duration, delay: delay, animations: {
                    itemLabel.numberOfLines = destinationLabel.numberOfLines
                    itemLabel.frame.size = destinationLabel.frame.size
                    itemLabel.frame.origin = destinationOrigin
                    itemLabel.font = destinationLabel.font
                    itemLabel.text = text
                    itemLabel.layoutIfNeeded()
                }, completion: {_ in
                    destinationLabel.text = text
                    self.isHidden = false
                    itemLabel.removeFromSuperview()
                    completion?()
                })
            } else {
                destinationView.alpha = 0.0
                let itemView = UIView()
                itemView.frame.size = frame.size
                itemView.backgroundColor = backgroundColor
                itemView.frame.origin = sourceOrigin
                itemView.layer.cornerRadius = layer.cornerRadius
                itemView.layer.shadowColor = layer.shadowColor
                itemView.layer.shadowOffset = layer.shadowOffset
                itemView.layer.shadowOpacity = layer.shadowOpacity
                itemView.layer.masksToBounds = layer.masksToBounds
                itemView.clipsToBounds = clipsToBounds
                window.addSubview(itemView)
                UIView.animate(withDuration: duration, delay: delay, animations: {
                    itemView.frame.size = destinationView.frame.size
                    itemView.frame.origin = destinationOrigin
                    itemView.layer.shadowColor = destinationView.layer.shadowColor
                    itemView.layer.shadowOffset = destinationView.layer.shadowOffset
                    itemView.layer.shadowOpacity = destinationView.layer.shadowOpacity
                    itemView.backgroundColor = destinationView.backgroundColor
                    itemView.layer.cornerRadius = destinationView.layer.cornerRadius
                    itemView.layer.masksToBounds = destinationView.layer.masksToBounds
                    itemView.clipsToBounds = destinationView.clipsToBounds
                    destinationView.alpha = 1
                }, completion: {_ in
                    self.isHidden = false
                    itemView.removeFromSuperview()
                    completion?()
                })
            }
            if setAssosiate {
                destinationView.assosiatedView = self
            }
        }
    }
}
