//
//  Firebase.swift
//  ProjectSense
//
//  Created by Andriy on 05/12/2016.
//  Copyright © 2016 Andriy. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage


struct Firebase {
	// MARK: - firebase properties
	static var storageRef = FIRStorage.storage().reference(forURL: "gs://projectsense-db599.appspot.com")
	static var myGroup = DispatchGroup()
	
	// MARK: - access to firebase method
	static func login(withEmail email: String, password: String) {
		FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
			if error == nil {
				print("Firebase logged in successfully")
			} else {
				print("Firebase log in failed with \(error)")
			}
		})
	}
	
	static func uploadVideo(withData data: Data, name: String) {
		let videoRef = Firebase.storageRef.child(name)
		
		videoRef.put(data, metadata: nil, completion: { (meta, error) in
			if error != nil {
				print("uploading is failed")
			} else {
				print("uploading finished successfully to \(meta?.downloadURL())")
			}
		})
	}
	
	static func videoURL(withName name: String, complete: @escaping (URL?) -> Swift.Void) {
		let videoRef = Firebase.storageRef.child(name)
		
		videoRef.downloadURL { (url, error) in
			if error != nil {
				print("downloading is failed")
			} else {
				print("firebase video path: \(url)")
				complete(url)
			}
		}
	}
}
