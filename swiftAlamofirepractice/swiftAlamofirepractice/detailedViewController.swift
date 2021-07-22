//
//  detailedViewController.swift
//  swiftAlamofirepractice
//
//  Created by minal borole on 20/07/21.
//

import UIKit
import Alamofire



struct Album2: Decodable {
    var userId: Int?
    var id: Int?
    
    
}

class detailedViewController: UIViewController {
    var photoAlbums2: [Album2] = []
    
    @IBOutlet weak var idTabelView: UITableView!
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var titleLbl2: UILabel!
    
    var strLbl: String!
    var photo: Album?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLbl2.text = photo?.title
        
        let urlString = "https://via.placeholder.com/150/24f355" + (photo?.thumbnailUrl)!
        let url = URL(string: urlString)
        
        imgView.downloaded(from: url!)
        parseJason2()

        // Do any additional setup after loading the view.
    }
    
    func parseJason2(){
        let url = URL(string: "http://jsonplaceholder.typicode.com/albums")
        AF.request(url!).responseJSON { (response) in
            if let result = response.data{
                do{
                 self.photoAlbums2 = try JSONDecoder().decode([Album2].self, from: result)
                    for _ in self.photoAlbums2{
                        
                        self.idTabelView.reloadData()
                       
                        
                    }
                    
                }catch{
                    print("something wents wrong")
                }
            }
             
               
        }
    }
    
    
    

}
extension detailedViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photoAlbums2.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! iDTableViewCell
        
        cell.idLabel.text = "\(photoAlbums2[indexPath.row].id!)"
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72.0
    }
    
}
