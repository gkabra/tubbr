//
//  SpotifyViewController.swift
//  TubbrAssignment
//
//  Created by Gaurav Kabra on 10/07/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import NVActivityIndicatorViewExtended

class SpotifyViewController: UIViewController,UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, NVActivityIndicatorViewable
{
    @IBOutlet weak var navigationBarView: NavigationBarView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lblNoRecordsFound: UILabel!

    var searchViewModel = SearchTrackViewModel()
    var tracksData : [SearchTracksResponseModel]?

    var offsetCount = 0
    var page : Int = 1

    //Used to change the loading animation 32 types available
    private let presentingIndicatorTypes = {
        return NVActivityIndicatorType.allCases.filter { $0 != .blank }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()


       


        // Do any additional setup after loading the view.
        self.collectionView.register(UINib(nibName:
            NIBNames.SpotifyTrackCollectionViewCellNib, bundle: nil),
                                     forCellWithReuseIdentifier: NIBIdentifier.SpotifyCellIdentifier)

        self.setUpView()
    }

    private func setUpView()
    {
        
        self.lblNoRecordsFound.isHidden = true

        let size = CGSize(width: 30, height: 30)
        let selectedIndicatorIndex = 19
        let indicatorType = presentingIndicatorTypes[selectedIndicatorIndex]
        startAnimating(size, message: "Fetching music...", type: indicatorType, fadeInAnimation: nil)

        //API Calling
        searchViewModel.delegate = self
        searchViewModel.getSearchableTracksFromSpotifyApi { (success, message, result) in
            if success {
                if result != nil {
                }
            } else
            {
            }
        }

        //Setting properties of navigation bar
        self.navigationBarView.delegate = self
        //self.navigationBarView.view.backgroundColor = .orange
        self.navigationBarView.headerTitleLabel.text = "Spotify Music"


        //Setting properties of collection view cell
        let screenWidth = UIScreen.main.bounds.width
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: screenWidth - 32, height: 280)
        layout.minimumLineSpacing = 16
        layout.scrollDirection = .vertical
        self.collectionView.collectionViewLayout = layout
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tracksData?[0].tracks.count ?? 0
        //return 5

    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell: SpotifyTrackCollectionViewCell =
            collectionView.dequeueReusableCell(withReuseIdentifier:
                NIBIdentifier.SpotifyCellIdentifier, for: indexPath) as? SpotifyTrackCollectionViewCell {
            cell.trackTitle.text = self.tracksData?[0].tracks[indexPath.row].name ?? "Spotify Track"
            cell.trackSubTitle.text = self.tracksData?[0].tracks[indexPath.row].artists[0].name ?? "Artist"
            let imageUrl = self.tracksData?[0].tracks[indexPath.row].album.images[0].url
            if let iconUrl = URL.init(string: imageUrl!) {
                ImageDownloadManager.downloadImage(url: iconUrl) { (image, error) in
                    if error != nil {
                        cell.trackImageView.image = UIImage.init(named: "tubbr")
                    } else {
                        cell.trackImageView.image = image
                    }
                }
            }
            return cell
        }
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let musicUrl = self.tracksData?[0].tracks[indexPath.row].previewURL ?? ""
        if musicUrl != "" {
            self.downloadMusic(musicUrl: musicUrl)
        }
        if let cell = collectionView.cellForItem(at: indexPath) as? SpotifyTrackCollectionViewCell{
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            if let spotifyDetailVC = storyboard.instantiateViewController(withIdentifier: "SpotifyDetailViewController") as? SpotifyDetailViewController{

                let imageUrl = self.tracksData?[0].tracks[indexPath.row].album.images[0].url
                if let iconUrl = URL.init(string: imageUrl!) {
                    if let data = try? Data(contentsOf: iconUrl) {
                        // Create Image and Update Image View
                         let image = UIImage(data: data)
                        let imageDefaults = UserDefaults.standard
                        imageDefaults.setImage(image: image, forKey: "selectedImage")

                    }
                }
                spotifyDetailVC.modalPresentationStyle = .overCurrentContext
                //spotifyDetailVC.selectedImage = cell.trackImageView.image
                self.present(spotifyDetailVC, animated: false) {
                    cell.trackImageView.animateWith(destinationView: spotifyDetailVC.imageView, sourceFrame: nil)
                }
            }
        }

    }

    //This method is reposible for downloading the selected track from spotify library
    func downloadMusic(musicUrl: String)
    {
            if let audioUrl = URL(string: musicUrl) {

                // then lets create your document folder url
                let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

                // lets create your destination file url
                let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent + ".mp3")
                print(destinationUrl)
                UserDefaults.standard.set(destinationUrl.path, forKey: "DownloadedTrackFile")
                // to check if it exists before downloading it
                if FileManager.default.fileExists(atPath: destinationUrl.path) {
                    print("The file already exists at path")

                    // if the file doesn't exist
                } else {

                    // you can use NSURLSession.sharedSession to download the data asynchronously
                    URLSession.shared.downloadTask(with: audioUrl) { location, response, error in
                        guard let location = location, error == nil else { return }
                        do {
                            // after downloading your file you need to move it to your destination url
                            try FileManager.default.moveItem(at: location, to: destinationUrl)
                            print("File moved to documents folder")
                        } catch {
                            print(error)
                        }
                    }.resume()
                }
            }
    }
}

extension SpotifyViewController : NavigationBarDelegate
{
    func backButtonPressed(_ button: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension SpotifyViewController: SearchTrackViewModelDelegate{
    func reloadTableWithSearchRecords(records: [SearchTracksResponseModel]) {
        if self.tracksData == nil{
            self.tracksData = records
        }
        if tracksData?[0].tracks.count ?? 0 > 0{
            self.lblNoRecordsFound.isHidden = true
            self.collectionView.reloadData()
        }else{
            self.lblNoRecordsFound.isHidden = false
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
            self.stopAnimating(nil)
        }
    }

    func showError(message: String) {
        self.lblNoRecordsFound.isHidden = false
        self.lblNoRecordsFound.text = message
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
            self.stopAnimating(nil)
        }

    }


}
