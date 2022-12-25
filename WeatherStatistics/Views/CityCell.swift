
import UIKit
import SnapKit

class CityCell: TableViewCell {

    //MARK: - UI Properties
    private lazy var cityImageView = UIImageView()
    private lazy var cityNameLabel = UILabel()

    //MARK: - Lifecycle methods
    override func commonInit() {
        addSubview(cityImageView)
        cityImageView.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview().inset(16)
            $0.height.width.equalTo(100)
        }
        addSubview(cityNameLabel)
        cityNameLabel.snp.makeConstraints {
            $0.leading.equalTo(cityImageView.snp.trailing).offset(32)
            $0.trailing.equalTo(snp.trailing)
            $0.centerY.equalTo(cityImageView.snp.centerY)
        }
    }

    //MARK: - Setup methods
    func setup(name: String, imageStringUrl: String) {
        cityImageView.setImage(from: imageStringUrl)
        cityNameLabel.text = name
        selectionStyle = .none
    }
}
