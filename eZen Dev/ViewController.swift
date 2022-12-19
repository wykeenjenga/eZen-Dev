//
//  ViewController.swift
//  eZen Dev
//
//  Created by Wykee on 17/12/2022.
//

import UIKit
import Foundation

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

import Foundation

let headers = [
  "accept": "application/json",
  "content-type": "application/json",
  "authorization": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJpc3MiOiJkb2xieS5pbyIsImlhdCI6MTY3MTE4OTQwNCwic3ViIjoiOXI3amdYaW9GUmYwa1dyZDlFS2FuQT09Iiwic2NvcGUiOiJzZXNzaW9uIiwib2lkIjoiMzc2ODVjZDUtZTc2Yy00NGFiLTg3MjYtZGQ3OTY3ZTJiMGFmIiwiYmlkIjoiOGEzNjgyYTQ4M2FjMjU4ZjAxODNiNjE5NWEzNTYzODAiLCJhaWQiOiJjOGIwNzQwMi04YjhmLTQwZmEtOTlkMi0yZTM1ZGE3NzY1MDciLCJhdXRob3JpdGllcyI6WyJST0xFX0NVU1RPTUVSIl0sImV4cCI6MTY3MTIzMjYwNH0.mW_8f0HIUdolj3_CcuqsiUycQNG2sOG-yg4SB57UuBIKcmJqG8t3tn_pM5lrh5e98kULJI41MTjzg0Yf_8JMyg"
]


func upload (){
    let parameters = [
      "input": "http://45.61.56.80/media/wycliffnjenga19.mp3",
      "output": "http://45.61.56.80/media/wycliffnjenga19dolby.mp3"
    ] as [String : Any]

    let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])

    let request = NSMutableURLRequest(url: NSURL(string: "https://api.dolby.com/media/enhance")! as URL,
                                            cachePolicy: .useProtocolCachePolicy,
                                        timeoutInterval: 10.0)
    request.httpMethod = "POST"
    request.allHTTPHeaderFields = headers
    request.httpBody = postData! as Data

    let session = URLSession.shared
    let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
      if (error != nil) {
        print(error as Any)
      } else {
        let httpResponse = response as? HTTPURLResponse
        print(httpResponse)
      }
    })

    dataTask.resume()
}
