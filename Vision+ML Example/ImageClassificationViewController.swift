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
    
    @IBOutlet weak var imageView: UIImageView!
    var image : UIImage!
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var classificationLabel: UILabel!
    
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
    }

    @IBAction func callHelp(_ sender: Any) {
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
                let descriptions = topClassification.map { classification in
                    // Formats the classification for display; e.g. "(0.37) cliff, drop, drop-off".
                     return String(classification.identifier)
                }
                self.alertLabel.text = "Your plant is infected with"
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
                
            }
        } catch {
            // handle error
            }
        }
    }
}
