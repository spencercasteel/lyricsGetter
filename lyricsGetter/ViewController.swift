//
//  ViewController.swift
//  lyricsGetter
//
//  Created by Spencer Casteel on 10/23/18.
//  Copyright © 2018 Spencer Casteel. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UITextFieldDelegate{
    @IBOutlet weak var artistTextFeild: UITextField!
    @IBOutlet weak var songTextFeild: UITextField!
    @IBOutlet weak var lyricsTextView: UITextView!
    
    //the base URL for the lyrics API, aka the point where we connect to it
    let lyricsAPIBaseURL = "https://api.lyrics.ovh/v1"
    
    override func viewDidLoad() {
        super.viewDidLoad()
       artistTextFeild.delegate = self
        songTextFeild.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    @IBAction func submitButttonTapped(_ sender: Any) {
        guard let artistName = artistTextFeild.text, let songTitle = songTextFeild.text else {
            return
        }
        
        //since we cant use spaces in our URL, we need to replace them with a +
        let artistNameURLComponent = artistName.replacingOccurrences(of: " ", with: "+")
        
        let songTitleURLComponent = songTitle.replacingOccurrences(of: " ", with: "+")
        
        //Full URL for the request we will make to the API
        let requestURL = "\(lyricsAPIBaseURL)/\(artistNameURLComponent)/\(songTitleURLComponent)"
        print(requestURL)
        
        //we are going to use alamoFire to create an
        let request = Alamofire.request(requestURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
        
        //now we need to actully make our request
        request.responseJSON { response in
            //we switch based on response result, which can be either success or failure
            switch response.result {
            case .success(let Value):
               //in the case of success, the request has succeeded, and we've gotten some data back
                print("Success!")
                
                let json = JSON(Value)
                
                self.lyricsTextView.text = json["lyrics"].stringValue
            case .failure(let Error):
                //in the case of failure, the request has failed and we've gotten an error back
                print("Error. :(")
                print(Error.localizedDescription)
                
            }
        }
        artistTextFeild.text = ""
        songTextFeild.text = ""
    }
}

