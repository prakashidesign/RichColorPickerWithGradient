//
//  ViewController.swift
//  GradientColorPicker
//
//  Created by iDesignA7 on 27/11/20.
//

import UIKit
import ColorSlider

import Foundation

public class GradientBG {
    public var type : GRADIENT_TYPE?
    public var color1 : UIColor?
    public var color2 : UIColor?

    required public init?(cType: GRADIENT_TYPE, cColor1: UIColor, cColor2: UIColor) {
        type = cType
        color1 = cColor1
        color2 = cColor2
    }
}

public enum BG_TYPE {
    case solid
    case grdient
    case pattern
    case custom
}

public enum GRADIENT_TYPE {
    case top
    case left
    case radial
    case diagonal
}

public class CanvasBackground {
    public var type : BG_TYPE?
    public var selectedBG : Any?

    required public init?(cType: BG_TYPE, cBG: Any) {
        type = cType
        selectedBG = cBG
    }
}

protocol CanvasBGDelegate {
    func didSelectorBG(bg: CanvasBackground)
}

let LAYER_NAME = "canvasLayer"
let GRADIENT_VIEW_HEIGHT = 171.0
let PATTERN_VIEW_HEIGHT = 161.0
let CUSTOM_IMAGE_VIEW_HEIGHT = 99.0

class CanvasColorViewController: UIViewController {

    @IBOutlet weak var testview: UIView!
    @IBOutlet weak var gradientView: UIView!
    var colorSlider: ColorSlider!
    var colorSlider1: ColorSlider!
    var selectedGradientIndex: GRADIENT_TYPE = .top
    var delegate: CanvasBGDelegate!
    var solidColor: UIColor?
    var gradientColor: GradientBG!
    var patternImage: UIImage?
    var customImage: UIImage?
    var canvasBG: CanvasBackground?
    
    @IBOutlet weak var patternImageView1: UIButton!
    @IBOutlet weak var solidColorBtn: UIButton!
    @IBOutlet weak var gradientView4: UIButton!
    @IBOutlet weak var gradientView3: UIButton!
    @IBOutlet weak var gradientView2: UIButton!
    @IBOutlet weak var gradientView1: UIButton!
    @IBOutlet weak var solidColorRadioBtn: UIButton!
    @IBOutlet weak var gradientColorRadioBtn: UIButton!
    @IBOutlet weak var patternColorRadioBtn: UIButton!
    @IBOutlet weak var customImageRadioBtn: UIButton!
    
    @IBOutlet weak var patternImageButton1: UIButton!
    @IBOutlet weak var patternImageButton2: UIButton!
    @IBOutlet weak var patternImageButton3: UIButton!
    @IBOutlet weak var patternImageButton4: UIButton!
    @IBOutlet weak var patternImageButton5: UIButton!
    @IBOutlet weak var patternImageButton6: UIButton!
    @IBOutlet weak var patternImageButton7: UIButton!
    @IBOutlet weak var patternImageButton8: UIButton!
    
    @IBOutlet weak var patternHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var customImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var gradientHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var customImageBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    private func creatingColorSliders(){
        colorSlider = ColorSlider(orientation: .horizontal, previewSide: .top)
        colorSlider.frame = CGRect(x:100, y: 100, width: 150, height: 15)
        colorSlider.color = .blue
        colorSlider.isSelected = true
        // Add a border
        colorSlider.gradientView.layer.borderWidth = 2.0
        colorSlider.gradientView.layer.borderColor = UIColor.white.cgColor
        colorSlider.addTarget(self, action: #selector(changedColor(_:)), for: .valueChanged)
        colorSlider.tag = 1
        // Disable rounded corners
        colorSlider.gradientView.automaticallyAdjustsCornerRadius = false
        gradientView.addSubview(colorSlider)
        
        colorSlider1 = ColorSlider(orientation: .horizontal, previewSide: .top)
        colorSlider1.frame = CGRect(x: 100, y: 150, width: 150, height: 15)
        colorSlider1.color = .orange
        colorSlider1.addTarget(self, action: #selector(changedColor(_:)), for: .valueChanged)
        colorSlider1.tag = 2
        gradientView.addSubview(colorSlider1)
    }
    
    private func initialSetup(){
        creatingColorSliders()
        
        solidColorRadioBtn.isSelected = false
        gradientColorRadioBtn.isSelected = false
        patternColorRadioBtn.isSelected = false
        solidColor = .white
        
        customImageHeightConstraint.constant = 0
        gradientHeightConstraint.constant = 0
        patternHeightConstraint.constant = 0
        
        switch canvasBG?.type {
        case .solid:
            if let solid = canvasBG?.selectedBG as? UIColor {
                solidColorRadioBtn.isSelected = true
                solidColor = solid
            }
        case .grdient:
            if let gColor = canvasBG?.selectedBG as? GradientBG {
                gradientColorRadioBtn.isSelected = true
                colorSlider.color = gColor.color1!
                colorSlider1.color = gColor.color2!
                selectedGradientIndex = gColor.type!
                removeGradientSelection()
                selectGradient(gColor:gColor)
                gradientHeightConstraint.constant = CGFloat(GRADIENT_VIEW_HEIGHT)
            }
        case .pattern:
            if let pImg = canvasBG?.selectedBG as? UIImage {
                patternColorRadioBtn.isSelected = true
                patternImage = pImg
                selectPatternImage(img: pImg)
                patternHeightConstraint.constant = CGFloat(PATTERN_VIEW_HEIGHT)
            }
        case .custom:
            if let cImg = canvasBG?.selectedBG as? UIImage {
                customImageRadioBtn.isSelected = true
                customImage = cImg
                customImageBtn.setImage(customImage, for: .normal)
                customImageHeightConstraint.constant = CGFloat(CUSTOM_IMAGE_VIEW_HEIGHT)
            }
        case .none:
            break
        }
        
        solidColorBtn.backgroundColor = solidColor
        solidColorBtn.layer.cornerRadius = solidColorBtn.frame.size.height/2
        solidColorBtn.layer.borderWidth = 1.0
        solidColorBtn.layer.borderColor = UIColor.darkGray.cgColor
        solidColorBtn.clipsToBounds = true

        applyGradient(color1: colorSlider.color, color2: colorSlider1.color, selectedView: gradientView1)
        applyGradient(color1: colorSlider.color, color2: colorSlider1.color, selectedView: gradientView2)
        applyGradient(color1: colorSlider.color, color2: colorSlider1.color, selectedView: gradientView3)
        applyGradient(color1: colorSlider.color, color2: colorSlider1.color, selectedView: gradientView4)
 
        gradientView1.layer.borderColor = UIColor.darkGray.cgColor
        gradientView2.layer.borderColor = UIColor.darkGray.cgColor
        gradientView3.layer.borderColor = UIColor.darkGray.cgColor
        gradientView4.layer.borderColor = UIColor.darkGray.cgColor
        
        patternImageButton1.layer.borderColor = UIColor.darkGray.cgColor
        patternImageButton2.layer.borderColor = UIColor.darkGray.cgColor
        patternImageButton3.layer.borderColor = UIColor.darkGray.cgColor
        patternImageButton4.layer.borderColor = UIColor.darkGray.cgColor
        patternImageButton5.layer.borderColor = UIColor.darkGray.cgColor
        patternImageButton6.layer.borderColor = UIColor.darkGray.cgColor
        patternImageButton7.layer.borderColor = UIColor.darkGray.cgColor
        patternImageButton8.layer.borderColor = UIColor.darkGray.cgColor
        
        let radionBtnUnselectedImage = UIImage(named: "baseline_radio_button_unchecked_black_36pt")
        let radionBtnselectedImage = UIImage(named: "baseline_radio_button_checked_black_36pt")
        
        solidColorRadioBtn.setImage(radionBtnUnselectedImage, for: .normal)
        solidColorRadioBtn.setImage(radionBtnselectedImage, for: .selected)
        gradientColorRadioBtn.setImage(radionBtnUnselectedImage, for: .normal)
        gradientColorRadioBtn.setImage(radionBtnselectedImage, for: .selected)
        patternColorRadioBtn.setImage(radionBtnUnselectedImage, for: .normal)
        patternColorRadioBtn.setImage(radionBtnselectedImage, for: .selected)
        customImageRadioBtn.setImage(radionBtnUnselectedImage, for: .normal)
        customImageRadioBtn.setImage(radionBtnselectedImage, for: .selected)

    }
    
    private func selectGradient(gColor: GradientBG) {
        switch gColor.type {
        case .top:
            gradientView1.layer.borderWidth = 5.0
        case .left:
            gradientView2.layer.borderWidth = 5.0
        case .radial:
            gradientView3.layer.borderWidth = 5.0
        case .diagonal:
            gradientView4.layer.borderWidth = 5.0
        default:
            break
        }
    }
    
    private func selectPatternImage(img: UIImage) {
        let btnList: [UIButton] = [patternImageButton1, patternImageButton2, patternImageButton3, patternImageButton4, patternImageButton5, patternImageButton6, patternImageButton7, patternImageButton8]
        for btn in btnList {
            if btn.imageView?.image == img {
                btn.layer.borderWidth = 5.0
                break
            }
        }
    }
    
    @IBAction func didTapOnDone(_ sender: Any) {
        var selBG: Any!
        if solidColorRadioBtn.isSelected {
            selBG = solidColor as Any
         //   self.delegate.didSelectorBG(bg: solidColor as Any)
        }
        else if gradientColorRadioBtn.isSelected {
            selBG = gradientColor as Any
            //self.delegate.didSelectorBG(bg: gradientColor as Any)
        }
        else if patternColorRadioBtn.isSelected {
            selBG = patternImage as Any
        }
        else if customImageRadioBtn.isSelected {
            selBG = customImage as Any
        }
        canvasBG?.selectedBG = selBG
        self.delegate.didSelectorBG(bg: canvasBG!)
    }
    
    @IBAction func didTapOnGallery(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func didTapOnRadioBtn(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            canvasBG?.type = .solid
        case 2:
            canvasBG?.type = .grdient
        case 3:
            canvasBG?.type = .pattern
        case 4:
            canvasBG?.type = .custom
        default:
            break
        }
        solidColorRadioBtn.isSelected = false
        gradientColorRadioBtn.isSelected = false
        patternColorRadioBtn.isSelected = false
        customImageRadioBtn.isSelected = false
        
        sender.isSelected = true
        
        gradientHeightConstraint.constant = 0
        patternHeightConstraint.constant = 0
        customImageHeightConstraint.constant = 0
        
        if sender == gradientColorRadioBtn {
            gradientHeightConstraint.constant = CGFloat(GRADIENT_VIEW_HEIGHT)
            gradientColor = GradientBG(cType: selectedGradientIndex, cColor1: colorSlider.color, cColor2: colorSlider1.color)
            selectGradient(gColor:gradientColor)
        }
        else if sender == patternColorRadioBtn {
            patternHeightConstraint.constant = CGFloat(PATTERN_VIEW_HEIGHT)
            if patternImage == nil {
                patternImageButton1.layer.borderWidth = 5.0
                patternImage = patternImageButton1.imageView?.image
            }
        }
        else if sender == customImageRadioBtn {
            customImageHeightConstraint.constant = CGFloat(CUSTOM_IMAGE_VIEW_HEIGHT)
            if patternImage == nil {
                patternImageButton1.layer.borderWidth = 5.0
                patternImage = patternImageButton1.imageView?.image
            }
        }
    }
    
    @IBAction func didTapOnPattern(_ sender: UIButton) {
        solidColorRadioBtn.isSelected = false
        gradientColorRadioBtn.isSelected = false
        patternColorRadioBtn.isSelected = true
        patternImage = (sender.imageView?.image)!
        removePatternSelection()
        sender.layer.borderWidth = 5.0
       // self.view.backgroundColor = UIColor(patternImage: (sender.imageView?.image)!)
    }
    
    private func removeGradientSelection() {
        gradientView1.layer.borderWidth = 1.0
        gradientView2.layer.borderWidth = 1.0
        gradientView3.layer.borderWidth = 1.0
        gradientView4.layer.borderWidth = 1.0
    }
    
    private func removePatternSelection() {
        patternImageButton1.layer.borderWidth = 0.0
        patternImageButton2.layer.borderWidth = 0.0
        patternImageButton3.layer.borderWidth = 0.0
        patternImageButton4.layer.borderWidth = 0.0
        patternImageButton5.layer.borderWidth = 0.0
        patternImageButton6.layer.borderWidth = 0.0
        patternImageButton7.layer.borderWidth = 0.0
        patternImageButton8.layer.borderWidth = 0.0
    }
    
    @objc func changedColor(_ slider: ColorSlider) {
        removeGradientSelection()
        
        solidColorRadioBtn.isSelected = false
        gradientColorRadioBtn.isSelected = true
        patternColorRadioBtn.isSelected = false
        
        var selectedView = gradientView1
        
        switch selectedGradientIndex {
        case .top:
            selectedView = gradientView1
            gradientView1.layer.borderWidth = 5.0
        case .left:
            selectedView = gradientView2
            gradientView2.layer.borderWidth = 5.0
        case .radial:
            selectedView = gradientView3
            gradientView3.layer.borderWidth = 5.0
        case .diagonal:
            selectedView = gradientView4
            gradientView4.layer.borderWidth = 5.0
        default:
            selectedView = gradientView1
        }
        gradientColor = GradientBG(cType: selectedGradientIndex, cColor1: colorSlider.color, cColor2: colorSlider1.color)
        
        if slider.tag == 1 {
            applyGradient(color1: slider.color, color2: colorSlider1.color, selectedView: selectedView!, isApply: true)
            gradientColor = GradientBG(cType: selectedGradientIndex, cColor1: slider.color, cColor2: colorSlider1.color)
        }
        else{
            applyGradient(color1: colorSlider.color, color2: slider.color, selectedView: selectedView!, isApply: true)
            gradientColor = GradientBG(cType: selectedGradientIndex, cColor1: colorSlider.color, cColor2: slider.color)
        }
    }
    
    func applyGradient(color1: UIColor, color2: UIColor, selectedView: UIView, isApply: Bool = false) {
        let gradientLayer1:CAGradientLayer = CAGradientLayer()
        gradientLayer1.frame.size = selectedView.frame.size
        gradientLayer1.colors = [color1.cgColor, color2.cgColor]
        
        let gradientLayer2:CAGradientLayer = CAGradientLayer()
        gradientLayer2.frame.size = selectedView.frame.size
        gradientLayer2.colors = [color1.cgColor, color2.cgColor]
        
        let gradientLayer3:CAGradientLayer = CAGradientLayer()
        gradientLayer3.frame.size = selectedView.frame.size
        gradientLayer3.colors = [color1.cgColor, color2.cgColor]
        
        let gradientLayer4:CAGradientLayer = CAGradientLayer()
        gradientLayer4.frame.size = selectedView.frame.size
        gradientLayer4.colors = [color1.cgColor, color2.cgColor]
        
        //Top to bottom
        gradientView1.layer.addSublayer(gradientLayer1)
        gradientLayer1.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradientLayer1.endPoint = CGPoint(x: 1.0, y: 1.0)
        //Left to right
        gradientView2.layer.addSublayer(gradientLayer2)
        gradientLayer2.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer2.endPoint = CGPoint(x: 1.0, y: 1.0)
        //Radial
        gradientView3.layer.addSublayer(gradientLayer3)
        gradientLayer3.type = .conic
        gradientLayer3.startPoint = CGPoint(x: 0.5, y: 0.5)
        let endY = 0.5 + view.frame.size.width / view.frame.size.height / 2
        gradientLayer3.endPoint = CGPoint(x: 1, y: endY)
        //Diagonal
        gradientView4.layer.addSublayer(gradientLayer4)
        gradientLayer4.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer4.endPoint = CGPoint(x: 1.0, y: 1.0)
    }
    
    @IBAction func didTapOnSolidColor(_ sender: UIButton) {
        solidColorRadioBtn.isSelected = true
        gradientColorRadioBtn.isSelected = false
        patternColorRadioBtn.isSelected = false
        
        let colorPicker = UIColorPickerViewController()
        colorPicker.delegate = self
        self.present(colorPicker, animated: true, completion: nil)
    }
    
    @IBAction func didTapOnGradientView(_ sender: UIButton) {
        
        solidColorRadioBtn.isSelected = false
        gradientColorRadioBtn.isSelected = true
        patternColorRadioBtn.isSelected = false
        
        gradientView1.layer.borderWidth = 0.5
        gradientView2.layer.borderWidth = 0.5
        gradientView3.layer.borderWidth = 0.5
        gradientView4.layer.borderWidth = 0.5
        
        switch sender.tag {
        case 1:
            selectedGradientIndex = .top
        case 2:
            selectedGradientIndex = .left
        case 3:
            selectedGradientIndex = .radial
        case 4:
            selectedGradientIndex = .diagonal
        default:
            break
        }
        
        switch sender.tag {
        case 1:
            gradientColor = GradientBG(cType: .top, cColor1: colorSlider.color, cColor2: colorSlider1.color)
            gradientView1.layer.borderWidth = 5.0
        case 2:
            gradientColor = GradientBG(cType: .left, cColor1: colorSlider.color, cColor2: colorSlider1.color)
            gradientView2.layer.borderWidth = 5.0
        case 3:
            gradientColor = GradientBG(cType: .radial, cColor1: colorSlider.color, cColor2: colorSlider1.color)
            gradientView3.layer.borderWidth = 5.0
        case 4:
            gradientColor = GradientBG(cType: .diagonal, cColor1: colorSlider.color, cColor2: colorSlider1.color)
            gradientView4.layer.borderWidth = 5.0
        default:
            break
        }
    }
}

extension CanvasColorViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        solidColorBtn.backgroundColor = viewController.selectedColor
        solidColor = viewController.selectedColor
        //self.view.backgroundColor = viewController.selectedColor
    }
}

extension CanvasColorViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            customImage = image
            customImageBtn.setImage(customImage, for: .normal)
            self.dismiss(animated: true, completion: nil)
        }
    }
}
