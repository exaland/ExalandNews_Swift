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
class GalleryNewsView: UIViewController {

	@IBOutlet var searchBar: UISearchBar!
	@IBOutlet var collectionViewMenu: UICollectionView!
	@IBOutlet var collectionViewPhotos: UICollectionView!

	private var menus: [String] = []
	private var selectedMenu = 0

    var newsVM = NewsViewModel()
    var newsModel: NewsAPI?
    
	//-------------------------------------------------------------------------------------------------------------------------------------------
	override func viewDidLoad() {

		super.viewDidLoad()
		navigationController?.navigationBar.isHidden = true
		navigationController?.navigationBar.prefersLargeTitles = false
		navigationItem.largeTitleDisplayMode = .never

		searchBar.layer.borderWidth = 1
		searchBar.layer.borderColor = UIColor.systemBackground.cgColor

		collectionViewMenu.register(UINib(nibName: "GalleryNewsCell1", bundle: Bundle.main), forCellWithReuseIdentifier: "GalleryNewsCell1")
		collectionViewPhotos.register(UINib(nibName: "GalleryNewsCell2", bundle: Bundle.main), forCellWithReuseIdentifier: "GalleryNewsCell2")
		collectionViewPhotos.collectionViewLayout = createLayout()

        loadData(category: "")
	}

	//-------------------------------------------------------------------------------------------------------------------------------------------
	override func viewWillDisappear(_ animated: Bool) {

		super.viewWillDisappear(animated)
		navigationController?.navigationBar.isHidden = false
	}

	//-------------------------------------------------------------------------------------------------------------------------------------------
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {

		super.traitCollectionDidChange(previousTraitCollection)
		searchBar.layer.borderColor = UIColor.systemBackground.cgColor
	}

	// MARK: - Data methods
	//-------------------------------------------------------------------------------------------------------------------------------------------
    func loadData(category: String) {
		menus = ["Business", "Entertainment", "General", "Health", "Science", "Sport", "Technology", "Food", "Music"]
        
        newsVM.fetchNewsTopHeadLine(country: "fr", category: category) { data in
            
            self.newsModel = data
           
            DispatchQueue.main.async {
                self.collectionViewPhotos.reloadData()
            }
        } onFailure: { err in
            print(err)
        }

        
	}

	// MARK: - Helper Methods
	//-------------------------------------------------------------------------------------------------------------------------------------------
	func createLayout() -> UICollectionViewLayout {

		let layout = UICollectionViewCompositionalLayout {(sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in

			let leadingItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.665), heightDimension: .fractionalHeight(1.0)))
			leadingItem.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1)

			let trailingItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.3)))
			trailingItem.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1)

			let trailingGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.335), heightDimension: .fractionalHeight(1.0)), subitem: trailingItem, count: 2)

			let topBottomgItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .fractionalHeight(1.0)))
			topBottomgItem.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1)

			let topGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.25)), subitem: topBottomgItem, count: 3)
			let middleGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.5)), subitems: [trailingGroup, leadingItem])

			let mainGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.8)), subitems: [topGroup, middleGroup, topGroup])

			let section = NSCollectionLayoutSection(group: mainGroup)
			return section
		}
		return layout
	}
}

// MARK: - UICollectionViewDataSource
//-----------------------------------------------------------------------------------------------------------------------------------------------
extension GalleryNewsView: UICollectionViewDataSource {

	//-------------------------------------------------------------------------------------------------------------------------------------------
	func numberOfSections(in collectionView: UICollectionView) -> Int {

		return 1
	}

	//-------------------------------------------------------------------------------------------------------------------------------------------
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

		if (collectionView == collectionViewMenu) { return menus.count }
        if (collectionView == collectionViewPhotos) { return newsModel?.articles.count ?? 0 }
		return 0
	}

	//-------------------------------------------------------------------------------------------------------------------------------------------
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

		if (collectionView == collectionViewMenu) {
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryNewsCell1", for: indexPath) as! GalleryNewsCell1
			cell.bindData(title: menus[indexPath.item])
			cell.set(isSelected: (selectedMenu == indexPath.row))
			return cell
		}

		if (collectionView == collectionViewPhotos) {
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryNewsCell2", for: indexPath) as! GalleryNewsCell2
            cell.bindData(index: indexPath, article: (newsModel?.articles[indexPath.row])!)
			return cell
		}
		return UICollectionViewCell()
	}
}

// MARK: - UICollectionViewDelegate
//-----------------------------------------------------------------------------------------------------------------------------------------------
extension GalleryNewsView: UICollectionViewDelegate {

	//-------------------------------------------------------------------------------------------------------------------------------------------
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

		print("didSelectItemAt \(indexPath.row)")
        
		if (collectionView == collectionViewMenu) {
			selectedMenu = indexPath.row
            loadData(category: menus[selectedMenu])
			collectionView.reloadItems(at: collectionView.indexPathsForVisibleItems)
			collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
		}
		if (collectionView == collectionViewPhotos) {
            let detailVC = DetailNewsView()
            detailVC.articleDetail = newsModel?.articles[indexPath.row]
            present(detailVC, animated: true, completion: nil)
		}
	}
}

// MARK: - UICollectionViewDelegateFlowLayout
//-----------------------------------------------------------------------------------------------------------------------------------------------
extension GalleryNewsView: UICollectionViewDelegateFlowLayout {

	//-------------------------------------------------------------------------------------------------------------------------------------------
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

		if (collectionView == collectionViewMenu) {
			let textWidth = menus[indexPath.row].uppercased().width(withConstrainedHeight: 25, font: UIFont.boldSystemFont(ofSize: 24))
			return CGSize(width: textWidth, height: collectionView.frame.size.height-25)
		}

		return CGSize.zero
	}

	//-------------------------------------------------------------------------------------------------------------------------------------------
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {

		if (collectionView == collectionViewMenu) { return 10	}
		if (collectionView == collectionViewPhotos) { return 1	}

		return 0
	}

	//-------------------------------------------------------------------------------------------------------------------------------------------
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {

		if (collectionView == collectionViewMenu) { return 10	}
		if (collectionView == collectionViewPhotos) { return 1	}

		return 0
	}

	//-------------------------------------------------------------------------------------------------------------------------------------------
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

		if (collectionView == collectionViewMenu) { return UIEdgeInsets(top: 10, left: 15, bottom: 15, right: 15) }
		if (collectionView == collectionViewPhotos) { return UIEdgeInsets.zero }

		return UIEdgeInsets.zero
	}
}

// MARK: - String
//-----------------------------------------------------------------------------------------------------------------------------------------------
fileprivate extension String {

	//-------------------------------------------------------------------------------------------------------------------------------------------
	func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {

		let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
		let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
		return ceil(boundingBox.height)
	}

	//-------------------------------------------------------------------------------------------------------------------------------------------
	func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {

		let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
		let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
		return ceil(boundingBox.width)
	}
}
