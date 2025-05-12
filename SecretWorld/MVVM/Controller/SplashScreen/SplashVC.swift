//
//  SplashVC.swift
//  SecretWorld
//
//  Created by Ideio Soft on 17/03/25.
//

import UIKit
import Lottie

class SplashVC: UIViewController {

    @IBOutlet weak var imgVwSplash: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgVwSplash.loadGif(name: "splash (9)")
        view.addSubview(imgVwSplash)
        
    }
   

}

extension UIImageView {
    func loadGif(name: String) {
        guard let path = Bundle.main.path(forResource: name, ofType: "gif"),
              let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            return
        }
        let source = CGImageSourceCreateWithData(data as CFData, nil)
        let count = CGImageSourceGetCount(source!)

        var images: [UIImage] = []
        var duration: TimeInterval = 0

        for i in 0..<count {
            if let cgImage = CGImageSourceCreateImageAtIndex(source!, i, nil) {
                let frameDuration = 0.1
                duration += frameDuration
                images.append(UIImage(cgImage: cgImage))
            }
        }
       
        self.animationImages = images
        self.animationDuration = duration
        self.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now()+5.0){
                    if Store.autoLogin == 1{
                        SceneDelegate().accountTypeVCRoot()
                    }else if Store.autoLogin == 2{
            
                        if Store.role == "b_user"{
                            SceneDelegate().completeSignupBusinessUserVCRoot()
                        }else{
                            SceneDelegate().completeSignupUserVCRoot()
                        }
                    }else if Store.autoLogin == 3{
            
                        Store.SubCategoriesId = nil
                        SceneDelegate().userRoot()
                    }else if Store.autoLogin == 0{
            
                        SceneDelegate().OnboardingThirdVCRoot()
                    }else{
            
                        SceneDelegate().OnboardingFirstVCRoot()
                    }
        }
    }
}
