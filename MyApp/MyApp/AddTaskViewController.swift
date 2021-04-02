//
//  AddTaskViewController.swift
//  MyApp
//
//  Created by Sameer Narang on 01/04/21.
//

import UIKit

class AddTaskViewController: UIViewController {
    
    
    @IBOutlet weak var StartDate: UITextField!
    
    @IBOutlet weak var EndDate: UITextField!
    
    @IBOutlet weak var Tasks: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func goToMainView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addTaskAndGoToMainView(_ sender: Any) {
        if let url = URL(string: "https://taskdiaryios-default-rtdb.firebaseio.com/dataCounter.json") {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url, completionHandler: handleAPIRequest(data:response:error:))
            task.resume()
            
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    private func handleAPIRequest(data: Data?, response: URLResponse?, error: Error?) {
        if error != nil {
            
        }
        else if let safeData = data {
            let dataString = String(data: safeData, encoding: .utf8)
            if let safeDataString = dataString {
                let dataNum = Int(safeDataString)
                if var safeDataNum = dataNum {
                    safeDataNum += 1
                    
                    if let url = URL(string: "https://taskdiaryios-default-rtdb.firebaseio.com/dataCounter.json") {
                        var request = URLRequest(url: url)
                        request.httpMethod = "PUT"
                        do {
                            let jsonData = try JSONEncoder().encode(safeDataNum)
                            request.httpBody = jsonData
                        } catch {
                            
                        }
                        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                            
                        }
                        task.resume()
                    }
                    
                    let startDate = StartDate.text
                    let endDate = EndDate.text
                    let tasks = Tasks.text
                    
                    let endPoint = "data" + String(safeDataNum)
                    
                    if let dataUrl = URL(string: "https://taskdiaryios-default-rtdb.firebaseio.com/" + endPoint + ".json") {
                        var dataRequest = URLRequest(url: dataUrl)
                        dataRequest.httpMethod = "PUT"
                        let taskData = FirebaseData(start_date: startDate, end_date: endDate, tasks: tasks)
                        do {
                            let jsonTaskData = try JSONEncoder().encode(taskData)
                            dataRequest.httpBody = jsonTaskData
                        } catch {
                            
                        }
                        let dataTask = URLSession.shared.dataTask(with: dataRequest) { (data, response, error) in}
                        dataTask.resume()
                    }
                }
            }
        }
    }
}
