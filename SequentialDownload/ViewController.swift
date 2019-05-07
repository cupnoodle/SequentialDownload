//
//  ViewController.swift
//  SequentialDownload
//
//  Created by Soulchild on 07/05/2019.
//  Copyright © 2019 fluffy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var downloadButton: UIButton!
    
    @IBOutlet weak var progressLabel: UILabel!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    var session : URLSession!
    var queue : OperationQueue!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
        queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        
        self.cancelButton.isEnabled = false
    }

    @IBAction func downloadTapped(_ sender: UIButton) {
        let completionOperation = BlockOperation {
            print("finished download all")
            DispatchQueue.main.async {
                self.cancelButton.isEnabled = false
            }
        }
        
        let urls = [
            URL(string: "https://github.com/fluffyes/AppStoreCard/archive/master.zip")!,
            URL(string: "https://github.com/fluffyes/currentLocation/archive/master.zip")!,
            URL(string: "https://github.com/fluffyes/DispatchQueue/archive/master.zip")!,
            URL(string: "https://github.com/fluffyes/dynamicFont/archive/master.zip")!,
            URL(string: "https://github.com/fluffyes/telegrammy/archive/master.zip")!
        ]
        
        for (index, url) in urls.enumerated() {
            let operation = DownloadOperation(session: self.session, downloadTaskURL: url, completionHandler: { (localURL, urlResponse, error) in
                
                if error == nil {
                    DispatchQueue.main.async {
                        self.progressLabel.text = "\(index + 1) / \(urls.count) files downloaded"
                    }
                }
            })
            
            completionOperation.addDependency(operation)
            self.queue.addOperation(operation)
        }
        
        self.queue.addOperation(completionOperation)
        self.cancelButton.isEnabled = true
    }
    
    @IBAction func cancelTapped(_ sender: UIButton) {
        queue.cancelAllOperations()
        
        self.progressLabel.text = "Download cancelled"
        
        self.cancelButton.isEnabled = false
    }
    
}

