//
//  ViewController.swift
//  simpsonsviewer
//
//  Created by Romit Patel on 5/26/21.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate {
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    var arrrelatedTopics : [[String:Any]] = []
    var arrCharName : [String] = []
    
    var currentPage:Int = 1
    var nextpage:Int = 1
    
    
    var searchText : String = "A"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getData(searchName: searchText, page: currentPage)
        self.tblView.estimatedRowHeight = 44.0
        self.tblView.rowHeight = UITableView.automaticDimension
        searchBar.delegate = self
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrrelatedTopics.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! custCell
        let data = arrrelatedTopics[indexPath.row]
        cell.lblText.text = data["original_title"] as? String
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    var request : URLRequest!
    func getData(searchName:String,page:Int){
        
        
        if let url = URL(string: "https://api.themoviedb.org/3/search/movie?api_key=5885c445eab51c7004916b9c0313e2d3&language=en-US&query=\(searchName)&page=\(page)&include_adult=false") {
            request = URLRequest(url: url)
        }
        
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            print(response!)
            do {
                let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                
                if (json["results"] as? [[String:Any]]) != nil{
                   
                    
                    self.nextpage = json["total_pages"] as? Int ?? 0
                    if(self.arrrelatedTopics.count == 0 || self.arrrelatedTopics .isEmpty){
                        self.arrrelatedTopics = (json["results"] as? [[String:Any]])!
                    }else{
                        let array = json["results"] as? [[String:Any]]
                        if(array != nil){
                            for obj in array!{
                                self.arrrelatedTopics.append(obj)
                            }
                        }
                    }
                    print(self.arrCharName)
                    print(self.arrrelatedTopics)
                    DispatchQueue.main.async {
                        self.tblView.dataSource = self
                        self.tblView.delegate = self
                        self.tblView.reloadData()
                    }
                    
                    
                }
                print(json)
            } catch {
                print("error")
            }
        })
        
        task.resume()
        
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if scrollView == self.tblView{
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
            {
                if(currentPage >= nextpage){
                    
                }else{
                    currentPage = currentPage + 1
                    //nextPage = nextPage + 1
                    self.getData(searchName: searchText, page: currentPage)
                }
                
            }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        let data = arrrelatedTopics[indexPath.row]
        
        let vc = self.storyboard?.instantiateViewController(identifier: "DetailVC") as! DetailVC
        vc.relatedTopics = data
        self.navigationController?.pushViewController(vc, animated: true)
        
        
        
        
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.arrCharName.removeAll()
        self.arrrelatedTopics.removeAll()
        
        if(searchText == ""){
            self.searchText = "A"
            self.currentPage = 1
            
            self.getData(searchName: self.searchText, page: currentPage)
            
            tblView.reloadData()
        }else{
            self.searchText = searchText
            self.currentPage = 1
            
            self.getData(searchName: self.searchText, page: currentPage)
            
            tblView.reloadData()
        }
        
    }
    
    func splitAtFirst(str: String, delimiter: String) -> (a: String, b: String)? {
        guard let upperIndex = (str.range(of: delimiter)?.upperBound), let lowerIndex = (str.range(of: delimiter)?.lowerBound) else { return nil }
        let firstPart: String = .init(str.prefix(upTo: lowerIndex))
        let lastPart: String = .init(str.suffix(from: upperIndex))
        return (firstPart, lastPart)
    }
    
}


class custCell:UITableViewCell{
    
    @IBOutlet weak var lblText: UILabel!
    
    
}
