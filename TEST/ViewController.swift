//
//  ViewController.swift
//  TEST
//
//  Created by Oleh Makhobei on 17.04.2022.
//

import UIKit
import Foundation

class CustomCell : UITableViewCell{
    
    
    @IBOutlet var postTitle: UILabel!
    @IBOutlet var likesCounter: UILabel!
    @IBOutlet var prewiewText: UILabel!
    @IBOutlet var timeCounter: UILabel!
}


class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    var postIdForDetailView : Int?
    
    var dataForTableView : PostResponse?
    
    @IBOutlet var postsTableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let dataForTableView = dataForTableView {
            return dataForTableView.posts.count
           }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = postsTableView.dequeueReusableCell(withIdentifier: "postsTableView", for: indexPath) as! CustomCell
    
        if let dataForTableView = dataForTableView{
            cell.postTitle.text = dataForTableView.posts[indexPath.row].title
            cell.likesCounter.text = String(dataForTableView.posts[indexPath.row].likes_count)
            cell.prewiewText.text = dataForTableView.posts[indexPath.row].preview_text
            cell.timeCounter.text = String(dataForTableView.posts[indexPath.row].timeshamp)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let dataForTableView = dataForTableView
        {
            let postId = dataForTableView.posts[indexPath.row].postId
            self.postIdForDetailView = postId
        }
        performSegue(withIdentifier: "DetailViewController" , sender: postIdForDetailView)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Preparing+ \(segue.destination)")
        guard let detailVC = segue.destination as? DetailViewController else { return }
       
        detailVC.postId = postIdForDetailView
        //print(detailVC.postId)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        postsTableView.delegate = self
        postsTableView.dataSource = self
        
        let url = "https://raw.githubusercontent.com/anton-natife/jsons/master/api/main.json"
        getData(from: url)
    }
    
    private func getData(from url: String){
        let task = URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: {data, response, error in
            guard let data = data, error == nil else{
                print("Something go wrong")
                return
            }
                                                
            // HAVE a data
            var result : PostResponse?
            do{
                result = try JSONDecoder().decode(PostResponse.self, from: data)
                
                DispatchQueue.main.async {
                                 self.dataForTableView = result
                                 self.postsTableView.reloadData()
                       }
              }
            catch
            {
                print("failed to conver \(error.localizedDescription)")
            }
            guard let json = result else
            {
                return
            }
                                                    
            print(json.posts)
            
         })
        task.resume()
        }

}

