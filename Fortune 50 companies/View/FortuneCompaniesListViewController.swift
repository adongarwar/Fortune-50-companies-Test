//
//  ViewController.swift
//  Fortune 50 companies
//
//  Created by Avinash Dongarwar on 4/10/22.
//
import UIKit

class FortuneCompaniesListViewController: UITableViewController, UISearchResultsUpdating {
	
	// TODO: This URL contains street sweeping data for SF
	// Fetch the data from this endpoint and
	// show the block being swept, the day of the week, and time window
	private var companies: [Company] = []
	fileprivate var viewModel = ViewModel()
	
	var filteredData = [Company]()
	var resultSearchController = UISearchController()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		viewModel.delegate = self
		configureSearchController()
		// Do any additional setup after loading the view.
		viewModel.fetchCompanies()
	}
	
	private func configureSearchController() {
		resultSearchController = ({
			let controller = UISearchController(searchResultsController: nil)
			controller.searchResultsUpdater = self
			controller.obscuresBackgroundDuringPresentation = false
			controller.searchBar.sizeToFit()
			
			tableView.tableHeaderView = controller.searchBar
			
			return controller
		})()
	}
	
	func updateSearchResults(for searchController: UISearchController) {
		filteredData.removeAll(keepingCapacity: false)
		
		let searchText = searchController.searchBar.text!
		filteredData = companies.filter { $0.name.range(of: searchText, options: [.caseInsensitive]) != nil }
		self.tableView.reloadData()
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if (resultSearchController.isActive) {
			return filteredData.count
		}
		return companies.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CompanyTableViewCell
		cell.delegate = self

		let company = resultSearchController.isActive ? filteredData[indexPath.row] : companies[indexPath.row]
		cell.configure(company: company,
					   isFavorite: viewModel.isFavorite(symbol: company.symbol))
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let controller = storyboard.instantiateViewController(withIdentifier: "CompanyDetailViewController") as! CompanyDetailViewController
		let company = resultSearchController.isActive ? filteredData[indexPath.row] : companies[indexPath.row]
		controller.company = company
		navigationController?.pushViewController(controller, animated: true)
	}
	
	@IBAction func refresh(sender: UIButton) {
		viewModel.fetchCompanies()
	}
	
	@IBAction func refreshAction(sender: UIBarButtonItem) {
		viewModel.fetchCompanies()
	}
	
	@IBAction func settingsAction(sender: UIBarButtonItem) {
		
	}
	
	enum Strings {
		static let settingsTitle = "Settings".localized()
	}
}

extension FortuneCompaniesListViewController: ViewActionDelegate {
	var errorHandler: ((Error) -> Void)? {
		get {
			return nil
		}
		set {
			
		}
	}
	
	func dataRefreshed(companies: [Company]) {
		self.companies = companies
		self.tableView.reloadData()
	}
}

extension FortuneCompaniesListViewController: CompanyTableViewCellDelegate {

	func favoriteButtonTapped(symbol: String) {
		viewModel.markFavorite(symbol: symbol)
		if let index = companies.firstIndex(where: {$0.symbol ==  symbol}) {
			tableView.reloadRows(at: [IndexPath(row: index, section: 0)],
								 with: .automatic)
		}
	}
}
