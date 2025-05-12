//
//  AIImageCreateVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 23/12/24.
//

import UIKit
import IQKeyboardManagerSwift



class AIImageCreateVC: UIViewController {
  @IBOutlet weak var txtVwDescription: IQTextView!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var btnCross: UIButton!
  @IBOutlet weak var btnAddImage: UIButton!
  @IBOutlet weak var btnImageGenerate: UIButton!
  @IBOutlet weak var imgVwGenerate: UIImageView!
    var callBack:((_ image:UIImage)->())?
    override func viewDidLoad() {
      super.viewDidLoad()
        uiSet()
    }
    func uiSet(){
        self.activityIndicator.isHidden = true
     
    }
    @IBAction func actionBack(_ sender: UIButton) {
      self.navigationController?.popViewController(animated: true)
    }
    @IBAction func actionCross(_ sender: UIButton) {
      self.imgVwGenerate.image = nil
      self.btnCross.isHidden = true
    }
    @IBAction func actionAddImage(_ sender: UIButton) {
      self.navigationController?.popViewController(animated: true)
      callBack?(self.imgVwGenerate.image ?? UIImage())
    }
    @IBAction func actionImageGenerate(_ sender: UIButton) {
        self.activityIndicator.isHidden = false
        guard let prompt = txtVwDescription.text, !prompt.isEmpty else {
             // Show alert if the description is empty
             let alert = UIAlertController(title: "Error", message: "Please enter a description to generate an image.", preferredStyle: .alert)
             alert.addAction(UIAlertAction(title: "OK", style: .default))
             self.present(alert, animated: true)
             return
         }

         self.activityIndicator.hidesWhenStopped = true
         self.activityIndicator.startAnimating()
         btnImageGenerate.isEnabled = false

         let apiKey = "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"
         let url = URL(string: "https://api.openai.com/v1/images/generations")!
         var request = URLRequest(url: url)
         request.httpMethod = "POST"
         request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
         request.addValue("application/json", forHTTPHeaderField: "Content-Type")

         let parameters: [String: Any] = [
             "model": "dall-e-3",
             "prompt": prompt,
             "n": 1,
             "size": "1024x1024"
         ]

         request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)

         URLSession.shared.dataTask(with: request) { data, response, error in
             DispatchQueue.main.async {
                 self.activityIndicator.stopAnimating()
                 self.btnImageGenerate.isEnabled = true
             }

             if let error = error {
                 DispatchQueue.main.async {
                     self.showAlert(title: "Error", message: error.localizedDescription)
                 }
                 return
             }

             guard let data = data,
                   let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let dataArray = json["data"] as? [[String: Any]],
                   let imageUrlString = dataArray.first?["url"] as? String,
                   let imageUrl = URL(string: imageUrlString) else {
                 DispatchQueue.main.async {
                     self.showAlert(title: "Error", message: "Failed to generate image. Please try again.")
                 }
                 return
             }

             // Load the image
             DispatchQueue.main.async {
                 self.imgVwGenerate.sd_setImage(with: imageUrl, completed: { _, _, _, _ in
                     self.btnCross.isHidden = false
                     self.btnAddImage.isHidden = false
                     self.btnImageGenerate.setTitle("Re-generate", for: .normal)
                 })
             }
         }.resume()
     }

     private func showAlert(title: String, message: String) {
         let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
         alert.addAction(UIAlertAction(title: "OK", style: .default))
         self.present(alert, animated: true)
     }
   
  }
