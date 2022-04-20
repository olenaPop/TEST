//
//  Post.swift
//  TEST
//
//  Created by Olena Makhobei on 17.04.2022.
//

import Foundation
import UIKit


//"postId":113,
//"timeshamp":1648987815,
//"title":"Everyone Wants To Be A Billionaire, But Nobody Wants To Admit It",
//"preview_text":"Elon Musk and I went out for dinner to celebrate an increase in Tesla’s stock price. We were both overjoyed because we had an extra million dollars in our bank accounts. Yay.",
//"likes_count":6990


struct Posts : Codable{
    var postId : Int
    var timeshamp : Double
    var title : String
    var preview_text : String
    var likes_count : Int
}


 struct PostResponse : Codable{
    var posts : [Posts]
 }

struct PostDetail : Codable {
            var postId : Int
            var timeshamp : Double
            var title : String
            var text: String
            var postImage: String
            var likes_count : Int
}

struct PostDetailResponse:Codable{
    var post:PostDetail
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
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFill) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
extension Double {
    func getDateStringFromUTC() -> String {
        let date = Date(timeIntervalSince1970: self)

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateStyle = .medium

        return dateFormatter.string(from: date)
    }
}
