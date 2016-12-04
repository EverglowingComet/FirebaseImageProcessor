//
//  VideoRecordController.swift
//  ProjectSense
//
//  Created by Andriy on 11/25/16.
//  Copyright © 2016 Kevin Jiang. All rights reserved.
//

import UIKit
import SCRecorder
import AVFoundation
import Photos

class VideoRecordController: UIViewController {
    static let VideoMaxDuration: Double = 6.0
    
    @IBOutlet weak var cameraPreview: TouchView!
    @IBOutlet weak var recordedTimeProgressView: UIProgressView!
    
    var recorder: SCRecorder = SCRecorder()
    var updateTimer: Timer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.cameraPreview.delegate = self
        
        self.setupRecorder()
        self.startRecord()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        self.stopRecord()
    }
    
    // MARK: - Manage Recording
    func setupRecorder() {
        self.recorder.previewView = self.cameraPreview
        
        self.recorder.captureSessionPreset = AVCaptureSessionPresetHigh
        self.recorder.device = AVCaptureDevicePosition.front
        self.recorder.maxRecordDuration = CMTimeMake(6000, 1000)
        
        let videoConfiguration = self.recorder.videoConfiguration
        videoConfiguration.enabled = true
        videoConfiguration.size = CGSize(width: 640, height: 640)
        videoConfiguration.scalingMode = AVVideoScalingModeResizeAspectFill
        videoConfiguration.timeScale = 1
        videoConfiguration.sizeAsSquare = true

        let audioConfiguration = self.recorder.audioConfiguration
        audioConfiguration.enabled = true
        audioConfiguration.channelsCount = 1
        audioConfiguration.sampleRate = 0
        audioConfiguration.format = Int32(kAudioFormatMPEG4AAC)
        
        let photoConfiguration = self.recorder.photoConfiguration
        photoConfiguration.enabled = false
        
        self.recorder.session = SCRecordSession()
        self.recorder.session?.fileType = AVFileTypeQuickTimeMovie
    }
    
    func startRecord() {
        self.recorder.startRunning()
    }
    
    func stopRecord() {
        self.recorder.stopRunning()
    }
    
    func resumeRecord() {
        self.updateTimer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true, block: { (timer) in
            let recordedTime = CMTimeGetSeconds(self.recorder.session!.duration)
            let progress = Double(recordedTime) / VideoRecordController.VideoMaxDuration
            self.recordedTimeProgressView.progress = Float(progress)
            
        })
        self.updateTimer?.fire()
        
        self.recorder.record()
    }
    
    func pauseRecord() {
        self.recorder.pause()
        
        self.updateTimer?.invalidate()
        self.updateTimer = nil
    }
    
    @IBAction func onSwitchCamera(_ sender: Any) {
        self.recorder.switchCaptureDevices()
    }
    
    @IBAction func onDiscardRecordedVideo(_ sender: Any) {
        self.recorder.session!.removeAllSegments()
        self.recordedTimeProgressView.progress = 0
    }
	
	@IBAction func onNext(_ sender: Any) {
		var exportSession: SCAssetExportSession
		let asset = self.recorder.session?.assetRepresentingSegments()
		
		exportSession = SCAssetExportSession(asset: asset!)
		exportSession.videoConfiguration.enabled = true
		exportSession.videoConfiguration.size = CGSize(width: 640, height: 640) // 1080x1920
		exportSession.videoConfiguration.scalingMode = AVVideoScalingModeResizeAspectFill
		exportSession.videoConfiguration.timeScale = 1
		exportSession.videoConfiguration.sizeAsSquare = false
		exportSession.videoConfiguration.bitrate = 600000 //24000000
		
		exportSession.audioConfiguration.preset = SCPresetHighestQuality
		exportSession.outputUrl = self.recorder.session?.outputUrl
		exportSession.outputFileType = AVFileTypeMPEG4
		exportSession.delegate = self
		exportSession.contextType = .auto
		
		exportSession.exportAsynchronously { [weak self] in
			self?.recorder.session!.removeAllSegments()
			self?.recordedTimeProgressView.progress = 0
			
			if let error = exportSession.error {
				print("FAILED: \(error.localizedDescription)")
				return;
			}
			
			if false { // testing code: save video to camera roll
				PHPhotoLibrary.shared().performChanges({
					PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: exportSession.outputUrl!)
				}) { saved, error in
					if saved {
						print("video saved sucessfully!")
					}
				}
				
			} else {
				// upload file to firebase
				let videoData = try? Data(contentsOf: exportSession.outputUrl!)
				Firebase.uploadVideo(withData: videoData!, name: "video.mp4")
			}
		}
	}
}

extension VideoRecordController: TouchViewDelegte {
    func touchViewDidBeginTouch(_ touchView: TouchView) {
        self.resumeRecord()
    }
    
    func touchViewDidEndTouch(_ touchView: TouchView) {
        self.pauseRecord()
    }
}

extension VideoRecordController: SCAssetExportSessionDelegate {
	func assetExportSessionDidProgress(_ assetExportSession: SCAssetExportSession) {
		
	}
}
