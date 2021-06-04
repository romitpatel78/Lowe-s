//
//  DetailVC.swift
//  simpsonsviewer
//
//  Created by Romit Patel on 5/26/21.
//

import UIKit

class DetailVC: UIViewController {

    @IBOutlet weak var imgViewProfile: UIImageView!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblreleaseDate: UILabel!
    
    @IBOutlet weak var lbltitle: UILabel!
    var relatedTopics : [String:Any] = [:]
    var strTitle : String = ""
    var releaseDate : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

       let original_title = relatedTopics["original_title"] as? String ?? ""
        //let value = self.splitAtFirst(str: text, delimiter: " -")
        self.lbltitle.text = original_title
        if let overview = relatedTopics["overview"] as? String {
            self.lblDesc.text = overview
        }
        if let release_date = relatedTopics["release_date"] as? String {
            self.lblreleaseDate.text = "Release Date: \(release_date)"
        }
        if let icon = relatedTopics["poster_path"] as? String {
          
            if(icon != ""){
                imgViewProfile.downloaded(from: "https://image.tmdb.org/t/p/w500/\(icon ?? "")")
            }else{
                imgViewProfile.image = #imageLiteral(resourceName: "user.png")
            }
            
        
        }else{
            imgViewProfile.image = #imageLiteral(resourceName: "user.png")
        }
       
        print(relatedTopics)
        
        // Do any additional setup after loading the view.
    }
    
    func splitAtFirst(str: String, delimiter: String) -> (a: String, b: String)? {
       guard let upperIndex = (str.range(of: delimiter)?.upperBound), let lowerIndex = (str.range(of: delimiter)?.lowerBound) else { return nil }
       let firstPart: String = .init(str.prefix(upTo: lowerIndex))
       let lastPart: String = .init(str.suffix(from: upperIndex))
       return (firstPart, lastPart)
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
