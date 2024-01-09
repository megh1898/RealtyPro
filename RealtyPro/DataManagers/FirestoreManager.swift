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
    
    func getProperties(completion: @escaping ([Property]?, Error?) -> Void) {
        guard let ownerID = AppUtility.shared.userId else {return}
        
        let db = Firestore.firestore()
        let collectionName = "properties"
            
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
    
    func deleteProperty(propertyID: String, completion: @escaping (Error?) -> Void) {
        let db = Firestore.firestore()
        let collectionName = "properties"

        db.collection(collectionName).document(propertyID).delete { error in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    func getLoggedInUserByUID(uid: String) {
        let db = Firestore.firestore()
        let usersCollection = db.collection("users")

        usersCollection.document(uid).getDocument { (document, error) in
            if let error = error {
                print("Error getting user document: \(error)")
                return
            }

            if let userData = document?.data() {
                AppUtility.shared.email = userData["email"] as? String ?? ""
                AppUtility.shared.name = userData["name"] as? String ?? ""
                AppUtility.shared.phone = userData["phone"] as? String ?? ""
            } else {
                print("User document not found")
            }
        }
    }
    
    func addFavorite(propertyId: String, completion: @escaping (Error?) -> Void) {
        guard let userId = AppUtility.shared.userId else {return}
        
        let db = Firestore.firestore()
        let favoritesCollection = db.collection("users").document(userId).collection("favoriteProperties")
        
        let data: [String: Any] = [
            "propertyId": propertyId,
        ]
        
        favoritesCollection.addDocument(data: data) { error in
            if let error = error {
                print("Error adding favorite: \(error.localizedDescription)")
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    func deleteFavoriteProperty(favoritePropertyId: String, completion: @escaping (Error?) -> Void) {
        guard let userId = AppUtility.shared.userId else {return}
        
        let db = Firestore.firestore()
        let properties = db.collection("users").document(userId).collection("favoriteProperties")
        
        let query = properties.whereField("propertyId", isEqualTo: favoritePropertyId)
        
        query.getDocuments { (snapshot, error) in
            if let error = error {
                print("Error querying favorites: \(error.localizedDescription)")
                completion(error)
                return
            }
            
            // Delete each document that matches the query
            let batch = db.batch()
            snapshot?.documents.forEach { document in
                batch.deleteDocument(properties.document(document.documentID))
            }
            
            // Commit the batch delete
            batch.commit { error in
                if let error = error {
                    print("Error deleting favorites: \(error.localizedDescription)")
                    completion(error)
                } else {
                    print("Favorites deleted successfully.")
                    completion(nil)
                }
            }
        }
    }

    func isPropertyFavorite(propertyId: String, completion: @escaping (Bool, Error?) -> Void) {
        guard let userId = AppUtility.shared.userId else {return}
        
        let db = Firestore.firestore()
        let properties = db.collection("users").document(userId).collection("favoriteProperties")
        properties.whereField("propertyId", isEqualTo: propertyId).getDocuments { (snapshot, error) in
            if let error = error {
                print("Error getting favorites: \(error.localizedDescription)")
                completion(false, error)
            } else {
                if let snapshot = snapshot {
                    let isFavorite = !snapshot.documents.isEmpty
                    completion(isFavorite, nil)
                } else {
                    completion(false, nil)
                }
            }
        }
    }
    
//    func fetchFavouriteList(completion: @escaping ([Property]?,Error?) -> Void) {
//        let db = Firestore.firestore()
//        let imagesCollection = db.collection("users").document(AppUtility.shared.userId!).collection("favorites")
//        
//        imagesCollection.getDocuments { snapshot, error in
//            
//            
//            if let error = error {
//                completion([], error)
//                return
//            }
//            var ids = [String]()
//            if let snapshot = snapshot {
//                for document in snapshot.documents {
//                    let data = document.data()
//                    guard let id = data["favoriteImageID"] as? String else { continue }
//                    ids.append(id)
//                    
//                }
//            }
//            if ids.count > 0 {
//                self.getDataForSelectedIDs(selectedIDs: ids) { images in
//                    completion(images, nil)
//                }
//            }
//            else {
//                completion([], nil)
//            }
//        }
//    }
    
}
