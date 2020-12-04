//
//  HomeViewController.swift
//  GradientColorPicker
//
//  Created by iDesignA7 on 30/11/20.
//

import UIKit

class HomeViewController: UIViewController {

    var canvasBG: CanvasBackground!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapOnCanvasBGColor(_ sender: UIButton) {
        if let canvasBGColorView = self.storyboard?.instantiateViewController(identifier: "CanvasColorViewController") as? CanvasColorViewController {
            canvasBGColorView.preferredContentSize = CGSize(width: self.view.frame.size.width-10, height: 400)
            canvasBGColorView.modalPresentationStyle = UIModalPresentationStyle.popover
            canvasBGColorView.delegate = self
            if canvasBG != nil {
                canvasBGColorView.canvasBG = canvasBG
            }
            else {          // New canvas
                let newBG = CanvasBackground(cType: BG_TYPE.solid, cBG: UIColor.white as Any)
                canvasBGColorView.canvasBG = newBG
            }
            canvasBGColorView.popoverPresentationController?.dimmingView?.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            canvasBGColorView.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.any
            canvasBGColorView.popoverPresentationController?.delegate = self
            canvasBGColorView.popoverPresentationController?.sourceView = sender
            self.present(canvasBGColorView, animated: true, completion: nil)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension HomeViewController: UIPopoverControllerDelegate, UIPopoverPresentationControllerDelegate {
    // MARK: - popoverPresentationController delegate
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
}


extension HomeViewController: CanvasBGDelegate {
    func didSelectorBG(bg: CanvasBackground) {
        canvasBG = bg
        for item in self.view.layer.sublayers ?? [] where item.name == LAYER_NAME {
            item.removeFromSuperlayer()
        }
        switch canvasBG?.type {
        case .solid:
            if let solid = canvasBG?.selectedBG as? UIColor {
                self.view.backgroundColor = solid
            }
        case .grdient:
            if let gColor = canvasBG?.selectedBG as? GradientBG {
                applyGradient(gradient: gColor)
            }
        case .pattern:
            if let pImg = canvasBG?.selectedBG as? UIImage {
                self.view.backgroundColor = UIColor(patternImage: pImg)
            }
        case .custom:
            if let cImg = canvasBG?.selectedBG as? UIImage {
                self.view.backgroundColor = UIColor(patternImage: cImg)
            }
        default:
            break
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func applyGradient(gradient: GradientBG) {
        let gradientLayer:CAGradientLayer = CAGradientLayer()
        gradientLayer.frame.size = self.view.frame.size
        gradientLayer.colors = [gradient.color1!.cgColor, gradient.color2!.cgColor]
        gradientLayer.name = LAYER_NAME

        self.view.layer.insertSublayer(gradientLayer, at: 0)
        
        switch gradient.type {
        case .top:
            gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        case .left:
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        case .radial:
            gradientLayer.type = .conic
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
            let endY = 0.5 + view.frame.size.width / view.frame.size.height / 2
            gradientLayer.endPoint = CGPoint(x: 1, y: endY)
        case .diagonal:
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        default:
            break
        }
    }
}

extension UIPopoverPresentationController {
    var dimmingView: UIView? {
       return value(forKey: "_dimmingView") as? UIView
    }
}
