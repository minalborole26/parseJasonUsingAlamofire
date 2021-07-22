//
//  ViewController.swift
//  swiftAlamofirepractice
//
//  Created by minal borole on 20/07/21.
//

import UIKit
import Alamofire
import Reachability
import Network

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}

struct Album: Decodable {
  let id: Int
  let title: String
  let url: String
  let thumbnailUrl: String
}

class ViewController: UIViewController {
   // let reachability = try! Reachability()
    let monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "InternetConnectionMonitor")
    
    var photosAlbum: [Album] = []

    @IBOutlet weak var photosTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //parseJason()
    }
    
    // ================= jason parsing ===========
    func parseJason(){
        let url = URL(string: "http://jsonplaceholder.typicode.com/photos")
        AF.request(url!).responseJSON { (response) in
            if let result = response.data{
                do{
                 self.photosAlbum = try JSONDecoder().decode([Album].self, from: result)
                    for _ in self.photosAlbum{
                        
                        self.photosTableView.reloadData()
                       // print(Album.title,";",Album.url)
                        
                    }
                    
                }catch{
                    print("something wents wrong")
                }
            }
             //  var myArray  = result[0]
               
        }
    }
    //  ======================  internet connectivity code ================
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        monitor.pathUpdateHandler = { pathUpdateHandler in
            
                    if pathUpdateHandler.status == .satisfied {
                        print("Internet connection is on.")
                    } else {
                        
                        DispatchQueue.main.async {
                            print("There's no internet connection.")
                            let vc2 = self.storyboard?.instantiateViewController(identifier: "internetConnectionViewController") as! internetConnectionViewController
                            self.navigationController?.pushViewController(vc2, animated: true)
                        }
                        
                    }
                }

                monitor.start(queue: queue)
        
       
        parseJason()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let loader1 = self.loader()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [self] in
            stopLoader(loader: loader1)
        }
    }
    
   /* deinit {
        reachability.stopNotifier()
    }*/
}

 // ========================= tableView Methods ======================
extension ViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosAlbum.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! photosTableViewCell
        
        cell.titleLabel.text = photosAlbum[indexPath.row].title
        cell.photoImgView?.contentMode = .scaleAspectFill
        let defaultLink = "https://via.placeholder.com/150/24f355"
        let completeLink = defaultLink + photosAlbum[indexPath.row].thumbnailUrl
        cell.photoImgView?.downloaded(from: completeLink)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 97.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "detailedViewController") as! detailedViewController
        vc.photo = photosAlbum[photosTableView.indexPathForSelectedRow!.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

 // ================= activity indicator ================
extension ViewController{
    func loader() -> UIAlertController{
        let alert = UIAlertController(title: nil, message: "Please Wait", preferredStyle: .alert)
        let indicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
        indicator.style = .large
        
        alert.view.addSubview(indicator)
        present(alert, animated: true, completion: nil)
        return alert
    }
    func stopLoader(loader: UIAlertController) {
        DispatchQueue.main.async {
            loader.dismiss(animated: true, completion: nil)
        }
    }
}
