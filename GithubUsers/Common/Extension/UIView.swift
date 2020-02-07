//
//  UIView.swift
//  GithubUsers
//
//  Created by Ngo Lien on 2/7/20.
//  Copyright © 2020 Alex Ngo. All rights reserved.
//

import UIKit

typealias GradientPoints = (startPoint: CGPoint, endPoint: CGPoint)
enum GradientOrientation {
    case topRightBottomLeft
    case topLeftBottomRight
    case horizontal
    case vertical
    
    var startPoint : CGPoint {
        return points.startPoint
    }
    
    var endPoint : CGPoint {
        return points.endPoint
    }
    
    var points : GradientPoints {
        get {
            switch(self) {
            case .topRightBottomLeft:
                return (CGPoint(x: 0.0,y: 1.0), CGPoint(x: 1.0,y: 0.0))
            case .topLeftBottomRight:
                return (CGPoint(x: 0.0,y: 0.0), CGPoint(x: 1,y: 1))
            case .horizontal:
                return (CGPoint(x: 0.0,y: 0.5), CGPoint(x: 1.0,y: 0.5))
            case .vertical:
                return (CGPoint(x: 0.0,y: 0.0), CGPoint(x: 0.0,y: 1.0))
            }
        }
    }
}

extension UIView {
    
    /// Set corner radius
    @IBInspectable var cornerRadiusUI: CGFloat {
        get { return layer.cornerRadius }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    /// Set border width of layer
    @IBInspectable var borderWidthUI: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    
    /// Set border color of layer
    @IBInspectable var borderColorUI: UIColor? {
        get { return UIColor(cgColor: layer.borderColor!) }
        set { layer.borderColor = newValue?.cgColor }
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func dropShadows(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.darkGray.alpha(0.9).cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 2
        var rect = bounds
        rect.origin.x = 0
        rect.size.width += 30
        layer.shadowPath = UIBezierPath(rect: rect).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func dropShadows2(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.darkGray.alpha(0.9).cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 2
        var rect = bounds
//        rect.origin.x = 0
//        rect.size.width += 30
        layer.shadowPath = UIBezierPath(rect: rect).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    // Note: the method needs the view from which the context is taken as an argument.
    func dropShadow(superview: UIView) {
        // Get context from superview
        UIGraphicsBeginImageContext(self.bounds.size)
        superview.drawHierarchy(in: CGRect(x: -self.frame.minX, y: -self.frame.minY, width: superview.bounds.width, height: superview.bounds.height), afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Add a UIImageView with the image from the context as a subview
        let imageView = UIImageView(frame: self.bounds)
        imageView.image = image
        imageView.layer.cornerRadius = self.layer.cornerRadius
        imageView.clipsToBounds = true
        self.addSubview(imageView)
        
        // Bring the background color to the front, alternatively set it as UIColor(white: 1, alpha: 0.2)
        let brighter = UIView(frame: self.bounds)
        brighter.backgroundColor = self.backgroundColor ?? UIColor(white: 1, alpha: 0.2)
        brighter.layer.cornerRadius = self.layer.cornerRadius
        brighter.clipsToBounds = true
        self.addSubview(brighter)
        
        // Set the shadow
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor("#c9c9c9").cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 3)//5
        self.layer.shadowOpacity = 1//0.35
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
    }
    
    func rotateLoading() {
        let rotation  = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = 4*CGFloat.pi
        rotation.duration = 1
        rotation.repeatCount = Float(Int.max)
        layer.add(rotation, forKey: "rotationAnimation")
    }
    
    func gradient(colors: [UIColor], orientation: GradientOrientation) {
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = colors.map { $0.cgColor }
        gradient.startPoint = orientation.startPoint
        gradient.endPoint = orientation.endPoint
        layer.insertSublayer(gradient, at: 0)
    }
    
    
    func gradient(_ topColor: UIColor, bottomColor: UIColor) {
        DispatchQueue.main.async {
            self.layer.sublayers?.filter({$0.name == "gradient_bottom"}).first?.removeFromSuperlayer()
            let gLayer = CAGradientLayer()
            gLayer.colors = [bottomColor.cgColor, topColor, UIColor.clear, UIColor.clear]
            gLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
            gLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
            gLayer.locations = [0, 0.3, 0.4, 1]
            gLayer.frame = self.bounds
            gLayer.name = "gradient_bottom"
            self.layer.insertSublayer(gLayer, at: 0)
        }
    }
}
