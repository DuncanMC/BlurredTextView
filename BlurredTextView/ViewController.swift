//
//  ViewController.swift
//  BlurredTextView
//
//  Created by Duncan Champney on 10/11/23.
//

import UIKit

class ViewController: UIViewController {
    
    var blurRadius: Float = 10

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

    @IBOutlet weak var blurSwitch: UISwitch!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var blurView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func handleBlurSwitch(_ sender: UISwitch) {
        print("In \(#function)")
        if !sender.isOn {
            blurView.isHidden = true
        } else {
            
            let renderer = UIGraphicsImageRenderer(size: textView.bounds.size)
            let image = renderer.image { (context) in
                textView.drawHierarchy(in: textView.bounds, afterScreenUpdates: true)
            }
            blurView.image = blur(image: image, withRadius: blurRadius );
            blurView.isHidden = false
        }
        
        
    }
    
}

