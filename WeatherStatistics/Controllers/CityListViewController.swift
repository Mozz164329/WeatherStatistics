
import UIKit
import SnapKit

class CityListViewController: UIViewController {
    
    //MARK: - UI Properties
    private lazy var tableView = UITableView()
    private lazy var searchBar = UISearchBar()
    
    //MARK: - Properties
    var cities: [City] = []
    var filteredCities: [City] = []
    let pairImageURLString = "https://infotech.gov.ua/storage/img/Temp3.png"
    let nonPairImageUrlString = "https://infotech.gov.ua/storage/img/Temp1.png"

    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupSearchBar()
        loadCityList()
    }
    
    //MARK: - Setup methods
    private func setupSearchBar() {
        searchBar.showsCancelButton = true
        searchBar.searchBarStyle = .default
        searchBar.delegate = self
        navigationItem.titleView = searchBar
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CityCell.self, forCellReuseIdentifier: CityCell.identifier)
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func loadCityList() {
        JSONService.request(fileName: .cityList, fileType: .json) { (result: Result<[City], Error>) in
            switch result {
            case .success(let model):
                self.cities = model
                self.filteredCities = model
            case .failure(let error):
                print("\(error.localizedDescription)")
            }
        }
    }
}

//MARK: - UISearchBarDelegate
extension CityListViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredCities = cities.filter { $0.name.lowercased().prefix(searchText.count) == searchText.lowercased() }
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        filteredCities = cities
        tableView.reloadData()
    }
}

//MARK: - UITableViewDataSource
extension CityListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CityCell.identifier) as? CityCell
        else {
            return UITableViewCell()
        }
        let name = filteredCities[indexPath.row].name
        let imageStringUrl = (indexPath.row % 2 == 0) ? pairImageURLString : nonPairImageUrlString
        cell.setup(name: name, imageStringUrl: imageStringUrl)
        return cell
    }
}

//MARK: - UITableViewDelegate
extension CityListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCity = filteredCities[indexPath.row]
        let vc = CityDetailViewController(model: selectedCity)
        navigationController?.pushViewController(vc, animated: true)
    }
}
