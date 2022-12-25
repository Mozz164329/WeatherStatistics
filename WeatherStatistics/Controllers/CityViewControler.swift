
import UIKit
import MapKit
import SnapKit

class CityDetailViewController: UIViewController {

    //MARK: - UI Properties
    private lazy var minTempLabel = UILabel()
    private lazy var maxTempLabel = UILabel()
    private lazy var pressureLabel = UILabel()
    private lazy var statisticsLabel = UILabel() => {
        $0.text = "Statistics"
        $0.textAlignment = .center
        $0.font = .preferredFont(forTextStyle: .title2)
    }
    private lazy var infoStackView = UIStackView() => {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.spacing = 4
        $0.addArrangedSubview(minTempLabel)
        $0.addArrangedSubview(maxTempLabel)
        $0.addArrangedSubview(pressureLabel)
    }
    private lazy var mapView = MKMapView() => {
        $0.overrideUserInterfaceStyle = .dark
    }

    //MARK: - Properties
    let city: City

    //MARK: - Lifecycle methods
    init(model: City) {
        self.city = model
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        setupStatisticsLabel()
        setInfoStackView()
        loadStatistics()
        title = city.name
    }
    
    //MARK: - Setup methods
    private func setupMapView() {
        view.addSubview(mapView)
        mapView.snp.makeConstraints {
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.height.equalTo((view.frame.height/3) * 2)
        }

        let pinCoordinate = CLLocationCoordinate2D(latitude: city.lat, longitude: city.lon)
        let region = MKCoordinateRegion(center: pinCoordinate, latitudinalMeters: 1000000, longitudinalMeters: 1000000)
        let pin = MKPointAnnotation()
        pin.title = "Selected region"
        pin.coordinate = pinCoordinate
        mapView.addAnnotation(pin)
        mapView.setRegion(region, animated: false)
    }

    private func setupStatisticsLabel() {
        view.addSubview(statisticsLabel)
        statisticsLabel.snp.makeConstraints {
            $0.top.equalTo(mapView.snp.bottom).offset(16)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(16)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-16)
        }
    }

    private func setInfoStackView() {
        view.addSubview(infoStackView)
        infoStackView.snp.makeConstraints {
            $0.top.equalTo(statisticsLabel.snp.bottom).offset(16)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(16)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-16)
        }
    }

    private func setStatistics(statistics: Statistics) {
        minTempLabel.text = "Minimum temperature: \(statistics.tempMin)"
        maxTempLabel.text = "Maximum temperature: \(statistics.tempMax)"
        pressureLabel.text = "Pressure: \(statistics.pressure)"
    }

    private func loadStatistics() {
        let stringUrl = "https://api.openweathermap.org/data/2.5/weather?lat="+"\(city.lat)"+"&lon="+"\(city.lon)"+"&appid=8d28e8b7563eef2a50be305a2f0fa122"
        guard let url = URL(string: stringUrl) else {
            return
        }
        NetworkService.request(fromURL: url) { (result: Result<Statistics, Error>) in
            switch result {
            case .success(let Cities):
                self.setStatistics(statistics: Cities)
            case .failure(let error):
                print("\(error.localizedDescription)")
            }
        }
    }
}
