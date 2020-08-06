import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var appliedFilter: UILabel!

    let context = CIContext()
    var original: UIImage!
    
    override func viewDidLoad() {
        self.appliedFilter.text = ""
    }
    
    @IBAction func saveToLib()
    {
        if original == nil {
            return
        }
        UIImageWriteToSavedPhotosAlbum(imageView.image!, self, nil, nil)
    }


    @IBAction func applySepia() {
        if original == nil {
            return
        }

        let filter = CIFilter(name: "CISepiaTone")
        filter?.setValue(CIImage(image: original), forKey: kCIInputImageKey)
        filter?.setValue(1.0, forKey: kCIInputIntensityKey)
        appliedFilter.text = "Sepia"
        display(filter: filter!)
    }

    @IBAction func applyNoir() {
        if original == nil {
            return
        }

        let filter = CIFilter(name: "CIPhotoEffectNoir")
        filter?.setValue(CIImage(image: original), forKey: kCIInputImageKey)
        appliedFilter.text = "Noir"
        display(filter: filter!)
    }

    @IBAction func applyVintage() {
        if original == nil {
            return
        }

        let filter =  CIFilter(name: "CIPhotoEffectProcess")
        filter?.setValue(CIImage(image: original), forKey: kCIInputImageKey)
        appliedFilter.text = "Vintage"
        display(filter: filter!)
    }
    
    @IBAction func applyRandom()
    {
        if original == nil {
            return
        }
        let random = Int.random(in: 0 ..< 4)
        var filter: CIFilter
        switch random
        {
        case 0:
            appliedFilter.text = "Invert"
            filter = CIFilter(name: "CIColorInvert")!
            filter.setValue(CIImage(image: original), forKey: kCIInputImageKey)
        case 1:
            appliedFilter.text = "Glass Lozenge"
            filter = CIFilter(name: "CIGlassLozenge")!
            let point0 = CIVector(x: original.size.width/4, y: original.size.height/4)
            let point1 = CIVector(x: original.size.width - original.size.width/4, y: original.size.height - original.size.height/4)
            let radius: NSNumber = 200
            filter.setValue(CIImage(image: original), forKey: kCIInputImageKey)
            filter.setValue(point0, forKey: "inputPoint0")
            filter.setValue(point1, forKey: "inputPoint1")
            filter.setValue(radius, forKey: kCIInputRadiusKey)
        case 2:
            appliedFilter.text = "Pixellate"
            filter = CIFilter(name: "CIPixellate")!
            let scale: NSNumber = 50
            let center = CIVector(x: original.size.width, y: original.size.height)
            filter.setValue(CIImage(image: original), forKey: kCIInputImageKey)
            filter.setValue(center, forKey: kCIInputCenterKey)
            filter.setValue(scale, forKey: kCIInputScaleKey)
        default:
            appliedFilter.text = "Line Overlay"
            filter = CIFilter(name: "CILineOverlay")!
            filter.setValue(CIImage(image: original), forKey: kCIInputImageKey)
        }
         display(filter: filter)
    }

    @IBAction func choosePhoto(_ sender: UIBarButtonItem) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .photoLibrary
            self.navigationController?.present(picker, animated: true, completion: nil)
        }
    }

    func display(filter: CIFilter) {
        let output = filter.outputImage!
        imageView.image = UIImage(cgImage: self.context.createCGImage(output, from: output.extent)!)
    }

    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        self.navigationController?.dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
            original = image
        }
    }
}
