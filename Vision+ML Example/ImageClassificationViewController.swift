/*
See LICENSE folder for this sample’s licensing information.

Abstract:
View controller for selecting images and applying Vision + Core ML processing.
*/

import UIKit
import CoreML
import Vision
import ImageIO

class ImageClassificationViewController: UIViewController {
    // MARK: - IBOutlets
    
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    var image : UIImage!
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var classificationLabel: UILabel!
    @IBOutlet weak var remedyB: UIButton!
    var remedies: [String]!
    var remedyUrl: String!
    // MARK: - Image Classification
    override func viewDidLoad() {
        
        imageView.image = image
        updateClassifications(for: image)
    }
    /// - Tag: MLModelSetup
    lazy var classificationRequest: VNCoreMLRequest = {
        do {
            /*
             Use the Swift class `MobileNet` Core ML generates from the model.
             To use a different Core ML classifier model, add it to the project
             and replace `MobileNet` with that model's generated Swift class.
             */
            let model = try VNCoreMLModel(for: cropDisease().model)
            
            let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
                self?.processClassifications(for: request, error: error)
            })
            request.imageCropAndScaleOption = .centerCrop
            return request
        } catch {
            fatalError("Failed to load Vision ML model: \(error)")
        }
    }()
    
    @IBAction func showRemedies(_ sender: Any) {
              performSegue(withIdentifier: "showRemedies", sender: self)
    }

    @IBAction func callHelp(_ sender: Any) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRemedies" {
            let controller = segue.destination as! RemedyTableViewController
            controller.remedies = remedies
            controller.imageUrl = remedyUrl
        }
    }
}

    /// - Tag: PerformRequests
extension ImageClassificationViewController{
    
    func updateClassifications(for image: UIImage) {
        alertLabel.text = "Classifying..."
        
        let orientation = CGImagePropertyOrientation(image.imageOrientation)
        guard let ciImage = CIImage(image: image) else { fatalError("Unable to create \(CIImage.self) from \(image).") }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation)
            do {
                try handler.perform([self.classificationRequest])
            } catch {
                /*
                 This handler catches general image processing errors. The `classificationRequest`'s
                 completion handler `processClassifications(_:error:)` catches errors specific
                 to processing that request.
                 */
                print("Failed to perform classification.\n\(error.localizedDescription)")
            }
        }
    }
    
    /// Updates the UI with the results of the classification.
    /// - Tag: ProcessClassifications
    func processClassifications(for request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            guard let results = request.results else {
                self.alertLabel.text = "Unable to classify image.\n\(error!.localizedDescription)"
                return
            }
            // The `results` will always be `VNClassificationObservation`s, as specified by the Core ML model in this project.
            let classifications = results as! [VNClassificationObservation]
        
            if classifications.isEmpty {
                self.alertLabel.text = "Nothing recognized."
            } else {
                // Display top classifications ranked by confidence in the UI.
                let topClassification = classifications.prefix(1)
                let descriptions = topClassification.map { classification -> String in
                    // Formats the classification for display; e.g. "(0.37) cliff, drop, drop-off".
                    if(classification.confidence < 0.3){
                        self.remedyB.isEnabled = false
                         self.alertLabel.text = "Not infected!"
                        return ""
                    }
                    else{
                         self.alertLabel.text = "Your plant is infected with"
                     self.remedyB.isEnabled = true
                     return String(classification.identifier)
                    }
                }
               
                self.parseJson(descriptions[0])
               
            }
        }
    }
}

extension ImageClassificationViewController{
    
    func parseJson(_ identifier: String){
    if let path = Bundle.main.path(forResource: "remedies", ofType: "json") {
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            if let jsonResult = jsonResult as? Dictionary<String, Dictionary<String, AnyObject>>, let disease = jsonResult["\(identifier)"]{
                // do stuff
                self.classificationLabel.text = disease["name"] as? String
                self.remedies = disease["remedies"] as? [String]
                self.remedyUrl = disease["url"] as? String
            }
        } catch {
            // handle error
            print("Json parse error")
            }
        }
    }
    
    func setupView(){
        self.infoView.layer.shadowColor = UIColor.black.cgColor
        self.infoView.layer.shadowRadius = 5
        self.infoView.layer.shadowOpacity = 0.5
        self.infoView.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.infoView.layer.masksToBounds = false
        //self.infoView.layer.cornerRadius = 10
    }
}
