//
//  DetailViewController.swift
//  TEST
//
//  Created by Olena Makhobei on 17.04.2022.
//

import Foundation
import UIKit

class DetailViewController: UIViewController{
    var postId : Int?
    var dataForDetailView: PostDetail?
    
    @IBOutlet var imagePost: UIImageView!
    @IBOutlet var tittlePost: UILabel!
    @IBOutlet var descriptionPost: UITextView!
    @IBOutlet var time_counterPost: UILabel!
    @IBOutlet var like_counterPost: UILabel!
    
    
    override func viewDidLoad() {
        let url = "https://raw.githubusercontent.com/anton-natife/jsons/master/api/posts/\(postId!).json"
        getData(from: url)
    }
    
    private func getData(from url: String){
        let task = URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: {data, response, error in
            guard let data = data, error == nil else{
                print("Something go wrong")
                return
            }
                                                
            // HAVE a data
            var result : PostDetailResponse?
            do{
                result = try JSONDecoder().decode(PostDetailResponse.self, from: data)
                
                DispatchQueue.main.async {
                    self.dataForDetailView = result?.post
                    self.imagePost.downloaded(from: (result?.post.postImage)!)
                    self.tittlePost.text = result?.post.title
                    self.tittlePost.numberOfLines = 0
                    self.descriptionPost.text = result?.post.text
                    self.descriptionPost.isEditable = false
                    
                    self.like_counterPost.text = String(result?.post.likes_count ?? 00)
                    self.time_counterPost.text = String(result?.post.timeshamp ?? 00)
                    
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
            print(json)
         })
        task.resume()
        }

}

