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
                
                // Upload image data to Firebase Storage
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
    
    func getAllProperties(completion: @escaping (Result<[Property], Error>) -> Void) {
        let db = Firestore.firestore()
        
        db.collection("properties").getDocuments { querySnapshot, error in
            if let error = error {
                completion(.failure(error))
            } else {
                do {
                    let properties = try querySnapshot?.documents.compactMap { document -> Property? in
                        let property = try document.data(as: Property.self)
                        return property
                    } ?? []
                    completion(.success(properties))
                } catch {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func getImageURL(for url: String, completion: @escaping (URL?) -> Void) {
        let storageReference = Storage.storage().reference(withPath: "property_images").child(url)
        storageReference.downloadURL { url, error in
            if let _url = url {
                print("Image URL: \(_url)")
                completion(_url)
            } else {
                print("Error fetching image URL: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
            }
        }
    }
    
    func getCategoryNames(completion: @escaping ([String]?, Error?) -> Void) {
        let db = Firestore.firestore()
        
        db.collection("categories").document("mYLVddzw3E9pDWgK3XDD").getDocument { document, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            if let document = document, document.exists {
                if let names = document.data()?["name"] as? [String] {
                    completion(names, nil)
                } else {
                    completion(nil, nil)
                }
            } else {
                completion(nil, nil)
            }
        }
    }
    
    func getProperties(forOwner ownerID: String, completion: @escaping ([Property]?, Error?) -> Void) {
        let db = Firestore.firestore()
        let collectionName = "properties" // Replace with your actual collection name
            
        db.collection(collectionName)
            .whereField("owner", isEqualTo: ownerID)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    completion(nil, error)
                } else {
                    let properties = querySnapshot?.documents.compactMap { document -> Property? in
                        do {
                            let property = try document.data(as: Property.self)
                            return property
                        } catch {
                            print(error.localizedDescription)
                            return nil
                        }
                    }
                    completion(properties, nil)
                }
            }
    }
}
