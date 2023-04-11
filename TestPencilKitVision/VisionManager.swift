//
//  VisionManager.swift
//  TestPencilKitVision
//
//  Created by Brayton Lordianto on 4/10/23.
//

import Foundation
import UIKit
import Vision

class VisionManager {
    private var image: UIImage
    init(image: UIImage) {
        self.image = image
    }
    
    func setImage(_ image: UIImage) {
        self.image = image
    }
    
    func analyzeText() -> String {
        let errorMessage = "ERROR: NO TEXT FOUND"
        guard let ciImage = CIImage(image: image) else { print("DEBUG: no ciimage"); return errorMessage }
        var text = ""
        
        let request = VNRecognizeTextRequest { (request, error) in
            guard let observations = request.results as? [VNRecognizedTextObservation] else { print("DEBUG: no text"); text = errorMessage; return }
            
            for currentObservation in observations {
                let topCandidate = currentObservation.topCandidates(1)
                print("DEBUG: Text found is  " + (topCandidate.first?.string ?? "na"))
                if let recognizedText = topCandidate.first {
                    text += " " + recognizedText.string
                } else {
                    text = errorMessage
                }
            }
        }
        request.recognitionLevel = .accurate
        
        let requestHandler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        do {
            try requestHandler.perform([request])
        } catch {
            text = errorMessage
        }
        
        return text
    }
}
