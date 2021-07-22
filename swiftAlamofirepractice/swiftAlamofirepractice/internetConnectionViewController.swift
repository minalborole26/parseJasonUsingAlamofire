//
//  internetConnectionViewController.swift
//  swiftAlamofirepractice
//
//  Created by minal borole on 21/07/21.
//

import UIKit
import Alamofire
import Reachability
import Network

class internetConnectionViewController: UIViewController {
   // let reachability = try! Reachability()
    let monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "InternetConnectionMonitor")
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async { [self] in
            monitor.pathUpdateHandler = { pathUpdateHandler in
                        if pathUpdateHandler.status == .satisfied {
                            DispatchQueue.main.async {
                                print("Internet connection is on.")
                                navigationController?.popToRootViewController(animated: true)
                            }
                            
                        } else {
                            
                            DispatchQueue.main.async {
                                print("There's no internet connection.")
                                
                            }
                            
                        }
                    }

            monitor.start(queue: self.queue)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
