//
//  ViewController.swift
//  MyApp
//
//  Created by Sameer Narang on 27/03/21.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var StartDate: UILabel!
    
    @IBOutlet weak var EndDate: UILabel!
    
    @IBOutlet weak var Tasks: UITextView!
    
    private var start_date: String!
    private var end_date: String!
    private var tasks: String!
    
    private var currentDataCounter: Int!
    private var prevDataCounter: Int!
    private var nextDataCounter: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        definesPresentationContext = true
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func navigateToAddTask(_ sender: Any) {
        self.performSegue(withIdentifier: "goToAddTask", sender: self)
    }
    
    @IBAction func getCurrentData(_ sender: Any) {
        if let url = URL(string: "https://taskdiaryios-default-rtdb.firebaseio.com/dataCounter.json") {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url, completionHandler: handleCurrentAPIRequest(data:response:error:))
            task.resume()
        }
    }
    
    private func handleCurrentAPIRequest(data: Data?, response: URLResponse?, error: Error?) {
        if error != nil {
            
        }
        else if let safeData = data {
            let dataString = String(data: safeData, encoding: .utf8)
            if let safeDataString = dataString {
                let dataNum = Int(safeDataString)
                if let safeDataNum = dataNum {
                    self.currentDataCounter = safeDataNum
                    self.prevDataCounter = safeDataNum
                    self.nextDataCounter = safeDataNum
                    let dataUrl: String = "https://taskdiaryios-default-rtdb.firebaseio.com/data" + String(safeDataNum) + ".json"
                    if let url = URL(string: dataUrl) {
                        let session = URLSession(configuration: .default)
                        let task = session.dataTask(with: url, completionHandler: parseJSONData(data:response:error:))
                        task.resume()
                    }
                }
            }
        }
    }
    
    func parseJSONData(data: Data?, response: URLResponse?, error: Error?) {
        if let safeData = data {
            do {
                let decodedData = try JSONDecoder().decode(FirebaseData.self, from: safeData)
                if let start_date = decodedData.start_date {
                    self.start_date = start_date
                }
                if let end_date = decodedData.end_date {
                    self.end_date = end_date
                }
                if let tasks = decodedData.tasks {
                    self.tasks = tasks
                }
                DispatchQueue.main.async {
                    self.StartDate.text = self.start_date
                    self.EndDate.text = self.end_date
                    self.Tasks.text = self.tasks
                }
            } catch {
                
            }
        }
    }
    
    @IBAction func getPrevData(_ sender: Any) {
        if self.prevDataCounter <= self.currentDataCounter && self.prevDataCounter > 0 {
            self.prevDataCounter -= 1
            self.nextDataCounter = self.prevDataCounter
            let dataUrl: String = "https://taskdiaryios-default-rtdb.firebaseio.com/data" + String(self.prevDataCounter) + ".json"
            if let url = URL(string: dataUrl) {
                let session = URLSession(configuration: .default)
                let task = session.dataTask(with: url, completionHandler: parseJSONData(data:response:error:))
                task.resume()
            }
        }
    }
    
    @IBAction func getNextData(_ sender: Any) {
        if self.nextDataCounter < self.currentDataCounter {
            self.nextDataCounter += 1
            self.prevDataCounter = self.nextDataCounter
            let dataUrl: String = "https://taskdiaryios-default-rtdb.firebaseio.com/data" + String(self.nextDataCounter) + ".json"
            if let url = URL(string: dataUrl) {
                let session = URLSession(configuration: .default)
                let task = session.dataTask(with: url, completionHandler: parseJSONData(data:response:error:))
                task.resume()
            }
        }
    }
    
}
