//
//  WebViewVC.swift
//  SecretWorld
//
//  Created by meet sharma on 21/05/24.
//

import UIKit
import WebKit

class WebViewVC: UIViewController,WKNavigationDelegate {
    
    @IBOutlet weak var webVw: WKWebView!
    
    var paymentLink: String = ""
    var callback:((_ payment:Bool)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiSet()
    }
    
    func uiSet() {
        guard let url = URL(string: paymentLink) else {
            print("Invalid URL: \(paymentLink)")
            return
        }
        
        let request = URLRequest(url: url)
        webVw.navigationDelegate = self
        webVw.load(request)
    }
    
    // MARK: - WKNavigationDelegate Methods
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url?.absoluteString else {
            decisionHandler(.allow)
            return
        }

        print("decidePolicyFor - url: \(url)")

        if url.contains("/success") {
            print("PAYMENT STATUS: true")
            self.dismiss(animated: false) {
                self.callback?(true)
            }
            decisionHandler(.cancel)
            return
        }else if url.contains("/cancel") {
            print("PAYMENT STATUS: false")
            self.dismiss(animated: false) {
                self.callback?(false)
            }
            decisionHandler(.cancel)
            return
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
