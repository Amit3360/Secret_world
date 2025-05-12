//
//  WalletWebViewVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 03/09/24.
//

import UIKit
import WebKit

class WalletWebViewVC: UIViewController,WKNavigationDelegate {
    //MARK: - IBOutlet
    @IBOutlet weak var webVw: WKWebView!
    //MARK: - VARIBALES
    var paymentLink: String = ""
    var callback:((_ payment:Bool)->())?
    override func viewDidLoad() {
        super.viewDidLoad()
        uiSet()
    }
    //MARK: - METHODS
    func uiSet() {
        guard let url = URL(string: paymentLink) else {
            print("Invalid URL: \(paymentLink)")
            return
        }
        let request = URLRequest(url: url)
        webVw.navigationDelegate = self
        webVw.load(request)
//        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
//                   swipeRight.direction = .right
//                   view.addGestureRecognizer(swipeRight)
    }
//    @objc func handleSwipe() {
//        UIView.animate(withDuration: 0.3, animations: {
//            self.view.transform = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
//            self.view.alpha = 0
//        }, completion: { _ in
//            self.dismiss(animated: false, completion: nil)
//        })
//    }

    //MARK: - IBAction
//    @IBAction func actionBack(_ sender: UIButton) {
//        self.dismiss(animated: true)
//        callback?(false)
//    }
    // MARK: - WKNavigationDelegate Methods
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
           guard let url = navigationAction.request.url else {
               decisionHandler(.allow)
               return
           }
           print("decidePolicyFor - url: \(url)")
           if let successURL = URL(string:  "http://18.191.108.162/secretWorld/success"),
              let cancelURL = URL(string: "http://18.191.108.162/secretWorld/cancel") { 
               if url == successURL {
                   self.dismiss(animated: true)
                   self.callback?(true)
                   decisionHandler(.cancel)
                   return
               } else if url == cancelURL {
                   self.dismiss(animated: true)
                   self.callback?(false)
                   decisionHandler(.cancel)
                   return
               }
           }
           
           decisionHandler(.allow)
       }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("didStartProvisionalNavigation - webView.url: \(String(describing: webView.url?.description))")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        let nserror = error as NSError
        if nserror.code != NSURLErrorCancelled {
            // Handle the error appropriately
            print("Navigation failed with error: \(error.localizedDescription)")
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("didFinish - webView.url: \(String(describing: webView.url?.description))")
    }
}
