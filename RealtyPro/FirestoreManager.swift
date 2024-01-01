//
//  FirestoreManager.swift
//  RealtyPro
//


import Foundation
import FirebaseFirestore
import Firebase
import FirebaseStorage

class FirestoreManager {
    
    static var shared = FirestoreManager()
    
    
    func savePropertyToFirestore(property: Property, images: [UIImage], completion: @escaping (Error?) -> Void) {
        do {
            let db = Firestore.firestore()
            var propertyCopy = property // Create a mutable copy to modify
            
            // Convert UIImage to Data
            propertyCopy.imagePaths = []
            let imageDataArray = images.compactMap { $0.pngData() }
            for (index, imageData) in imageDataArray.enumerated() {
                let imagePath = "\(property.id.uuidString)_\(index).png"
                propertyCopy.imagePaths.append(imagePath)
                
                // Upload image data to Firebase Storage (assuming you have a storage reference named "property_images")
                let storageRef = Storage.storage().reference().child("property_images").child(imagePath)
                storageRef.putData(imageData, metadata: nil) { (_, error) in
                    if let error = error {
                        completion(error)
                    } else {
                        print("Image uploaded successfully")
                    }
                }
            }
            
            // Save the property data to Firestore
            try db.collection("properties").document(property.id.uuidString).setData(from: propertyCopy) { error in
                completion(error)
            }
        } catch {
            completion(error)
        }
    }
}
