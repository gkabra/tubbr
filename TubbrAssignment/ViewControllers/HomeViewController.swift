//
//  ViewController.swift
//  TubbrAssignment
//
//  Created by Gaurav Kabra on 10/07/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import AVKit
import NVActivityIndicatorView
import NVActivityIndicatorViewExtended

class HomeViewController: UIViewController, NVActivityIndicatorViewable {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var storeVideoButton: UIButton!
    @IBOutlet var musicImageView: UIImageView!

    var imagePicker: ImagePicker!
    var selectedImage: UIImage!
    var imageFileName: String!
    var isImageSelected = false
    var imageDefaults = UserDefaults.standard

    private let MultipleSingleMovieFileName = "newVideo"

    //Used to change the loading animation 32 types available
    private let presentingIndicatorTypes = {
        return NVActivityIndicatorType.allCases.filter { $0 != .blank }
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.musicImageView.image = nil
        imageDefaults.setImage(image: nil, forKey: "selectedImage")
        // Do any additional setup after loading the view.
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)

        //Take permission to access library initially
        let photos = PHPhotoLibrary.authorizationStatus()
        if photos == .notDetermined {
            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized{
                    print("OKAY")
                } else {
                    print("NOTOKAY")
                }
            })
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        self.storeVideoButton.isEnabled = true
        if imageDefaults != nil{
            let bgImage = imageDefaults.imageForKey(key: "selectedImage")
            if bgImage != nil {
                self.musicImageView.image = bgImage
            }
        }

        //As of now calling when coming on Home, we can add a time of 50 sec to get the token refreshed.
        let parameters = "grant_type=client_credentials"
               let postData =  parameters.data(using: .utf8)

               var request = URLRequest(url: URL(string: "https://accounts.spotify.com/api/token")!,timeoutInterval: Double.infinity)
               request.addValue("Basic NjQzYzJhNTBjOWIxNGVmMTllOTI2ZTEyNjAzYmEwMDc6YzEyM2Q0YTFiNmU1NGY2Y2FiZjExOTMwYzZhMDY0OTc=", forHTTPHeaderField: "Authorization")
               request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
               //request.addValue("__Host-device_id=AQDIDqoWZ5P-n_W30sjg3AKwiuPJpErtR0rBqFTSYLFlVnJ3HOLs28LQIhFEG_XS8dWZ991Oc4h1m3Mz04U0cnX0oX-qqUcmHoU", forHTTPHeaderField: "Cookie")

               request.httpMethod = "POST"
               request.httpBody = postData
               let session = URLSession.shared

                let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in

                      guard error == nil else {
                          return
                      }

                      guard let data = data else {
                          return
                      }

                      do {
                          //create json object from data
                          if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                              print(json)
                           let token = json["access_token"]!
                           print(token)
                           bearerToken = token as! String
                              // handle json...
                          }
                      } catch let error {
                          print(error.localizedDescription)
                      }
                  })
                  task.resume()

    }

   @IBAction func showImagePicker(_ sender: UIButton) {
       self.imagePicker.present(from: sender)
   }

    @IBAction func openSpotify(_ sender: UIButton) {
        //Resetting values
        self.musicImageView.image = nil
        UserDefaults.standard.set(nil, forKey: "DownloadedTrackFile")
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        if let spotifyListVC = storyboard.instantiateViewController(withIdentifier: "SpotifyViewController") as? SpotifyViewController{
            spotifyListVC.modalPresentationStyle = .currentContext
            self.present(spotifyListVC, animated: true, completion: nil)
        }
    }
    

    @IBAction func generateMultipleImageSingleAudioVideo(_ sender: UIButton)
    {
        if let audioURL = UserDefaults.standard.value(forKey: "DownloadedTrackFile"){
            if isImageSelected
            {
                let size = CGSize(width: 30, height: 30)
                let selectedIndicatorIndex = 1
                let indicatorType = presentingIndicatorTypes[selectedIndicatorIndex]

                startAnimating(size, message: "Preparing Video...", type: indicatorType, fadeInAnimation: nil)

                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
                    NVActivityIndicatorPresenter.sharedInstance.setMessage("Few seconds left...")
                }

                //Music file selected from spotify list
                let fileUrl = URL(fileURLWithPath: audioURL as! String)

                //Music file picked from bundle
                /*if let audioURL1 = Bundle.main.url(forResource: "samlemp3", withExtension: "mp3") {
                 self.inputUrl = audioURL1*/

                let asset = AVAsset(url: fileUrl)
                if let image = self.imageFileName{
                    self.trimTrack(asset, fileName: image + ".m4a")
                }else{
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
                        self.stopAnimating(nil)
                    }
                    let alertController = UIAlertController(title: "Please select some image from gallery.", message: nil, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
            else
            {
                DispatchQueue.main.async {
                   let alertController = UIAlertController(title: "Please ensure you have selected image before preparing video.", message: nil, preferredStyle: .alert)
                   let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                   alertController.addAction(defaultAction)
                   self.present(alertController, animated: true, completion: nil)
                }
            }
        }
        else
        {
            DispatchQueue.main.async {
               let alertController = UIAlertController(title: "Please ensure you have selected image & music both before preparing video.", message: nil, preferredStyle: .alert)
               let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
               alertController.addAction(defaultAction)
               self.present(alertController, animated: true, completion: nil)
            }
        }


    }

    //This functions is used for trimming the track
    func trimTrack(_ asset: AVAsset, fileName: String) {
           print("\(#function)")

           let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
           let trimmedSoundFileURL = documentsDirectory.appendingPathComponent(fileName)
           print("saving to \(trimmedSoundFileURL.absoluteString)")

           if FileManager.default.fileExists(atPath: trimmedSoundFileURL.absoluteString) {
               print("sound exists, removing \(trimmedSoundFileURL.absoluteString)")
               do {
                   if try trimmedSoundFileURL.checkResourceIsReachable() {
                       print("is reachable")
                   }

                   try FileManager.default.removeItem(atPath: trimmedSoundFileURL.absoluteString)
               } catch {
                   print("could not remove \(trimmedSoundFileURL)")
                   print(error.localizedDescription)
               }

           }

           print("creating export session for \(asset)")

           if let exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A) {
               exporter.outputFileType = AVFileType.m4a
               exporter.outputURL = trimmedSoundFileURL

               let duration = CMTimeGetSeconds(asset.duration)
               if duration < 5.0 {
                   print("sound is not long enough")
                   return
               }
               // e.g. the first 20 seconds
               let startTime = CMTimeMake(value: 0, timescale: 1)
               let stopTime = CMTimeMake(value: 20, timescale: 1)
               exporter.timeRange = CMTimeRangeFromTimeToTime(start: startTime, end: stopTime)

               // do it
               exporter.exportAsynchronously(completionHandler: {
                   print("export complete \(exporter.status)")

                   switch exporter.status {
                   case  AVAssetExportSessionStatus.failed:

                       if let e = exporter.error {
                           print("export failed \(e)")
                       }

                   case AVAssetExportSessionStatus.cancelled:
                       print("export cancelled \(String(describing: exporter.error))")
                   default:
                       print("export complete")

                       self.prepareVideo(audioURL: trimmedSoundFileURL)
                   }
               })
           } else {
               print("cannot create AVAssetExportSession for asset \(asset)")
           }

       }

       func prepareVideo(audioURL : URL){
            let audioURL1 = audioURL

               VideoGenerator.fileName = MultipleSingleMovieFileName
               VideoGenerator.shouldOptimiseImageForVideo = true

        VideoGenerator.current.generate(withImages: [self.selectedImage!], andAudios: [audioURL1], andType: .singleAudioMultipleImage, { (progress) in
                   print(progress)
               }) { (result) in
                   switch result {
                   case .success(let url):
                       print(url)
                       //Storing video in gallery
                       PHPhotoLibrary.shared().performChanges({
                       PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
                       }) { saved, error in
                           if saved {
                            DispatchQueue.main.async {
                                self.storeVideoButton.isEnabled = true
                               let alertController = UIAlertController(title: "Your video saved successfully in Gallery.", message: nil, preferredStyle: .alert)
                               let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                               alertController.addAction(defaultAction)
                               self.present(alertController, animated: true, completion: nil)
                                self.imageView.image = nil
                                self.musicImageView.image = nil
                                self.isImageSelected = false
                                UserDefaults.standard.set(nil, forKey: "DownloadedTrackFile")

                            }

                           }
                       }
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
                        self.stopAnimating(nil)
                    }
                   case .failure(let error):
                       print(error)
                       let alertController = UIAlertController(title: "Alert", message: "\(error.localizedDescription)", preferredStyle: .alert)
                       let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                       alertController.addAction(defaultAction)
                       self.present(alertController, animated: true, completion: nil)
                       DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
                           self.stopAnimating(nil)
                       }
                       self.musicImageView.image = nil
                       self.isImageSelected = false
                       UserDefaults.standard.set(nil, forKey: "DownloadedTrackFile")
                }
               }
       }
    }


extension HomeViewController: ImagePickerDelegate {

    func didSelect(image: UIImage?, fileName: String?) {
        self.selectedImage = image
        self.imageFileName = fileName

        // Add watermark on image
        let backgroundImage = image!
        let watermarkImage = #imageLiteral(resourceName: "tubbr")

        let size = backgroundImage.size
        let scale = backgroundImage.scale

        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        backgroundImage.draw(in: CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height))
        watermarkImage.draw(in: CGRect(x: size.width - 140, y: size.height - 140, width: 120, height: 120))

        self.selectedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        self.imageView.image = self.selectedImage
        isImageSelected = true

    }
}
