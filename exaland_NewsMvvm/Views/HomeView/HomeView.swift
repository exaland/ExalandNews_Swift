//
// Copyright (c) 2022 Exaland Concept - https://exaland.fr
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit

//-----------------------------------------------------------------------------------------------------------------------------------------------
class HomeView: UIViewController {

	@IBOutlet var searchBar: UISearchBar!
	@IBOutlet var tableView: UITableView!

	private var stories: [String] = []
	private var feeds: [[String: Any]] = []
    var newsVM = NewsViewModel()
    var newsModel: NewsAPI?
	//-------------------------------------------------------------------------------------------------------------------------------------------
	override func viewDidLoad() {

		super.viewDidLoad()
		title = "Feed"
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationItem.largeTitleDisplayMode = .always

		tableView.register(UINib(nibName: "HomeViewCell1", bundle: Bundle.main), forCellReuseIdentifier: "HomeViewCell1")
		tableView.register(UINib(nibName: "HomeViewCell4", bundle: Bundle.main), forCellReuseIdentifier: "HomeViewCell4")
		tableView.register(UINib(nibName: "HomeViewCell5", bundle: Bundle.main), forCellReuseIdentifier: "HomeViewCell5")
		tableView.tableFooterView = UIView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 100, height: 100)))
		loadData()
	}
    
    

	// MARK: - Data methods
	//-------------------------------------------------------------------------------------------------------------------------------------------
	func loadData() {

		stories = ["Add Story", "Amy", "Betty", "Chloe", "Doris", "Emma", "Fabia"]

		feeds.removeAll()

		var dict1: [String: Any] = [:]
		dict1["name"] = "Alan Nickerson"
		dict1["time"] = "2 min ago"
		dict1["content"] = "Never put off till tomorrow what may be done day after tomorrow just as well."
		dict1["likes"] = "89.4K likes"
		dict1["comments"] = "93 comments"
		feeds.append(dict1)

		var dict2: [String: Any] = [:]
		dict2["name"] = "Brian Elwood"
		dict2["time"] = "1 hour ago"
		dict2["images"] = 10
		dict2["likes"] = "89.4K likes"
		dict2["comments"] = "93 comments"
		feeds.append(dict2)
        newsVM.fetchNewsTopHeadLine(country: "fr", category: "") { data in
            
            self.newsModel = data
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            print("count is \(self.newsModel?.articles.count)")
        } onFailure: { error in
            print(error)
        }

		refreshTableView()
	}

	// MARK: - User actions
	//-------------------------------------------------------------------------------------------------------------------------------------------
	@IBAction func actionAdd(_ sender: UIButton) {

		print(#function)
		dismiss(animated: true)
	}

	//-------------------------------------------------------------------------------------------------------------------------------------------
	@objc func actionMore(_ sender: UIButton) {

		print(#function)
	}

	//-------------------------------------------------------------------------------------------------------------------------------------------
	@objc func actionLike(_ sender: UIButton) {

		print(#function)
	}

	//-------------------------------------------------------------------------------------------------------------------------------------------
	@objc func actionComment(_ sender: UIButton) {

		print(#function)
	}

	//-------------------------------------------------------------------------------------------------------------------------------------------
	@objc func actionShare(_ sender: UIButton) {

		print(#function)
	}

	// MARK: - Refresh methods
	//-------------------------------------------------------------------------------------------------------------------------------------------
	func refreshTableView() {

		tableView.reloadData()
	}
}

// MARK: - UITableViewDataSource
//-----------------------------------------------------------------------------------------------------------------------------------------------
extension HomeView: UITableViewDataSource {

	//-------------------------------------------------------------------------------------------------------------------------------------------
	func numberOfSections(in tableView: UITableView) -> Int {

		return 2
	}

	//-------------------------------------------------------------------------------------------------------------------------------------------
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return newsModel?.articles.count ?? 0
        
        
    }

	//-------------------------------------------------------------------------------------------------------------------------------------------
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		if (indexPath.row == 0) {
			let cell = tableView.dequeueReusableCell(withIdentifier: "HomeViewCell1", for: indexPath) as! HomeViewCell1
            cell.bindData(data: newsModel!)
			return cell
		}
		if (indexPath.section == 1) {
			let cell = tableView.dequeueReusableCell(withIdentifier: "HomeViewCell4", for: indexPath) as! HomeViewCell4
			cell.buttonMore.addTarget(self, action: #selector(actionMore(_:)), for: .touchUpInside)
			cell.buttonlike.addTarget(self, action: #selector(actionLike(_:)), for: .touchUpInside)
			cell.buttonComment.addTarget(self, action: #selector(actionComment(_:)), for: .touchUpInside)
			cell.buttonShare.addTarget(self, action: #selector(actionShare(_:)), for: .touchUpInside)
            cell.bindData(data: (newsModel?.articles[indexPath.row])!)
			return cell
		}
		if (indexPath.row == 2) {
			let cell = tableView.dequeueReusableCell(withIdentifier: "HomeViewCell5", for: indexPath) as! HomeViewCell5
			cell.buttonMore.addTarget(self, action: #selector(actionMore(_:)), for: .touchUpInside)
			cell.buttonlike.addTarget(self, action: #selector(actionLike(_:)), for: .touchUpInside)
			cell.buttonComment.addTarget(self, action: #selector(actionComment(_:)), for: .touchUpInside)
			cell.buttonShare.addTarget(self, action: #selector(actionShare(_:)), for: .touchUpInside)
            cell.bindData(data: (newsModel?.articles[indexPath.row])!)
			return cell
		}
		return UITableViewCell()
	}
}

// MARK: - UITableViewDelegate
//-----------------------------------------------------------------------------------------------------------------------------------------------
extension HomeView: UITableViewDelegate {

	//-------------------------------------------------------------------------------------------------------------------------------------------
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

		return UITableView.automaticDimension
	}

	//-------------------------------------------------------------------------------------------------------------------------------------------
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

		print("didSelectItemAt \(indexPath.row)")
	}
}
