
import UIKit
import Foundation

//class CustomCell : UITableViewCell{
//    
//    @IBOutlet var expand_collapseBttn: UIButton!
//    @IBOutlet var postTitle: UILabel!
//    @IBOutlet var likesCounter: UILabel!
//    @IBOutlet var prewiewText: UILabel!
//    @IBOutlet var timeCounter: UILabel!
//}

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
  
    var postIdForDetailView : Int?
    var dataForTableView : PostResponse?

    var filterParam : String?
    var filterCategory = ["date","rate"]
    var toolBar = UIToolbar()
    var picker  = UIPickerView()
    var flag : Bool = true
 
    @IBOutlet var postsTableView: UITableView!
    @IBOutlet var filterBttn: UIBarButtonItem!
    @IBAction func filterButton(_ sender: UIButton) {
         picker = UIPickerView.init()
         picker.delegate = self
         picker.dataSource = self
         picker.backgroundColor = UIColor.white
         picker.setValue(UIColor.black, forKey: "textColor")
         picker.autoresizingMask = .flexibleWidth
         picker.contentMode = .center
         picker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
         self.view.addSubview(picker)
                 
         toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
         toolBar.barStyle = .black
         toolBar.items = [UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(onDoneButtonTapped))]
         self.view.addSubview(toolBar)
         
    }
    @objc func onDoneButtonTapped() {
        toolBar.removeFromSuperview()
       // print(filterParam)
        let sortedDataByRate  =  dataForTableView?.posts.sorted(by: {$0.likes_count > $1.likes_count})
        let sortedDataByDate = dataForTableView?.posts.sorted(by: {$0.timeshamp > $1.timeshamp})
                   if filterParam == "date"{
                       self.dataForTableView = PostResponse(posts: sortedDataByDate!)
                   }
                   else if filterParam == "rate"{
                       self.dataForTableView = PostResponse(posts: sortedDataByRate!)
                   }
        picker.removeFromSuperview()
        postsTableView.reloadData()
       
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let dataForTableView = dataForTableView {
            return dataForTableView.posts.count
           }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCustomTableViewCell", for: indexPath) as! MyCustomTableViewCell
        cell.expandBttn.isHidden = true
        if let dataForTableView = dataForTableView{
              cell.titleLbl.text = dataForTableView.posts[indexPath.row].title
              cell.likesLbl.text = String(dataForTableView.posts[indexPath.row].likes_count)
              cell.textViewLbl.text = dataForTableView.posts[indexPath.row].preview_text
              cell.timesLbl.text = String(dataForTableView.posts[indexPath.row].timeshamp)
        }
        cell.expandBttn.layer.cornerRadius = 10
        cell.controller = self
        print(cell.textViewLbl.maxNumberOfLines)
        let countOfLineInTxt = cell.textViewLbl.maxNumberOfLines
        if countOfLineInTxt > 2 {
            cell.expandBttn.isHidden = false
            print("Succes")
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
        guard let detailVC = segue.destination as? DetailViewController else { return }
        detailVC.postId = postIdForDetailView
    }

    override func viewDidLoad() {
       
        super.viewDidLoad()
        postsTableView.register(UINib(nibName: "MyCustomTableViewCell", bundle: nil), forCellReuseIdentifier: "MyCustomTableViewCell")
        postsTableView.rowHeight = UITableView.automaticDimension
        postsTableView.estimatedRowHeight = 580
        postsTableView.delegate = self
        postsTableView.dataSource = self
        
        let url = "https://raw.githubusercontent.com/anton-natife/jsons/master/api/main.json"
        getData(from: url)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
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
extension ViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        filterCategory.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return filterCategory[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        filterParam = filterCategory[row]
        
    }
    
}

extension UILabel {

    var maxNumberOfLines: Int {
           let maxSize = CGSize(width: frame.size.width, height: CGFloat(MAXFLOAT))
           let text = (self.text ?? "") as NSString
        let textHeight = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [.font: font!], context: nil).height
           let lineHeight = font.lineHeight
           return Int(ceil(textHeight / lineHeight))
       }
}

