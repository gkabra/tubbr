//
//  SearchTrackViewModel.swift
//  TubbrAssignment
//
//  Created by Gaurav Kabra on 12/07/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import UIKit

protocol SearchTrackViewModelDelegate: class {
    func reloadTableWithSearchRecords(records: [SearchTracksResponseModel])
    func showError(message: String)
}


class SearchTrackViewModel {

    weak var delegate: SearchTrackViewModelDelegate?

    public func getSearchableTracksFromSpotifyApi(completion: @escaping (_ result: Bool, _ error: String, _ data: SearchTracksResponseModel?) -> Void) {
        var requestParameters = [String: Any]()
        //Tracks record
        requestParameters = ["ids": "5M7LdQfurIG70nbvlSAO07,3NeiYiBn3rQBgurfVk92Zm,6toZIttVTq28b6YprzBeYA,1KyNvNEJ1vsVG87gWSwk1z,5FIH0jTiNPN6N2JvfGvo07,3hlw3DbacwGe7lYA64K7LM,5n8BCU2JmPORrFboGeDlXV,6VoXc7GRlsVaIkamDLPfTu,3NjTGTng8AFkYIk4fxiUWZ,1BwlamEsFRvFgnXAZNJFQA"]

        ServiceManager.getSearchRecords(request: requestParameters) { (result) in
            switch result {
            case .success(let response):
                if let records = response{
                    self.delegate?.reloadTableWithSearchRecords(records: [records])
                }

            case .failure(let error):
                print(error.localizedDescription)
                self.delegate?.showError(message: error.localizedDescription)
            }
        }
    }
}
