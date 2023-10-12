//
//  BlurringView.swift
//  BlurredTextView
//
//  Created by Duncan Champney on 10/11/23.
//

import UIKit

class BlurringView: UIView {

    public var blur: Bool = false{
        didSet {
            if !blur {
                blurView.isHidden = true
            } else {
                blurView.isHidden = false
                updateBlurImage()
            }
        }
    }
    
    public var blurRadius: Float = 10 {
        didSet {
            updateBlurImage()
        }
    }
    
    @IBOutlet weak var childView: UIView? {
        didSet {
            guard let childView else {
                blurView.isHidden = true
                return
            }
            let childConstraints = [
                childView.leftAnchor.constraint(equalTo: self.leftAnchor),
                childView.rightAnchor.constraint(equalTo: self.rightAnchor),
                childView.topAnchor.constraint(equalTo: self.topAnchor),
                childView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ]
            childConstraints.forEach{ $0.isActive = true }
            self.addConstraints(childConstraints)
            blurView.removeConstraints(blurView.constraints)
            if blurConstraints == nil {
                blurConstraints = [
                    blurView.leftAnchor.constraint(equalTo: self.leftAnchor),
                    blurView.rightAnchor.constraint(equalTo: self.rightAnchor),
                    blurView.topAnchor.constraint(equalTo: self.topAnchor),
                    blurView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
                ]
                blurConstraints?.forEach{ $0.isActive = true }
                self.addConstraints(blurConstraints!)
            }
            updateBlurImage()
        }
    }
    private var blurView = UIImageView(frame: .zero)
    
    private var blurConstraints: [NSLayoutConstraint]? = nil

    override var bounds: CGRect {
        didSet {
            print("In bounds didSet, new bounds = \(bounds)")
//            updateBlurImage() // This call won't update the blur image correctly unless we delay 0.33 seconds
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        doInitSetup()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        print("In \(#function))")
        
        //The below works to update the blur image after the TextView's frame changes, but only if we add a "magic number" delay of .33 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.33) {
            print("Updating blur image. Bounds = \(self.bounds)")
            self.updateBlurImage()
        }
    }

    func blur(image: UIImage, withRadius radius: Float) -> UIImage {
        let context = CIContext(options: nil)

        guard var ciImage = CIImage(image: image) else {
            fatalError("Can't create CGImage")
        }
        let imageExtent = ciImage.extent
        
        ciImage = ciImage.clampedToExtent()

        guard let filter = CIFilter(name: "CIGaussianBlur") else {
            fatalError("Can't create filter")
        }
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        filter.setValue(radius, forKey: "inputRadius")
        guard let result = filter.outputImage else {
            fatalError("Can't get blurred image from filter")
        }
        guard let outputCG = context.createCGImage(result, from: imageExtent)
               else {
            fatalError("Can't convert CIImage to CGImage")
        }
        let output = UIImage(cgImage: outputCG)
        return output
    }
    
    func doInitSetup() {
        blurView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(blurView)
        blurView.isHidden = true
    }
    
    
    public func updateBlurImage() {
        guard let childView, blur == true else {
            blurView.isHidden = true
            return
        }
        let renderer = UIGraphicsImageRenderer(size: bounds.size)
        let image = renderer.image { (context) in
            let bounds = CGRect(origin: CGPoint.zero, size: childView.bounds.size)
            childView.drawHierarchy(in: bounds, afterScreenUpdates: false)
        }
        blurView.image = blur(image: image, withRadius: blurRadius );
        blurView.isHidden = false
    }
}
