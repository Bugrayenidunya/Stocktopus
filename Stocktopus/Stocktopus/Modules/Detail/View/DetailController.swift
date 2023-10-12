//
//  DetailController.swift
//  Stocktopus
//
//  Created by Enes Buğra Yenidünya on 7.10.2023.
//

import API
import Combine
import DGCharts
import Kingfisher
import UIKit

final class DetailController: UIViewController {
    
    // MARK: Properties
    private let viewModel: DetailViewModelInput
    private var cancallables: [AnyCancellable] = []
    
    // MARK: Views
    private let scrollView: UIScrollView = {
       let scrollView = UIScrollView()
        return scrollView
    }()
    
    private let containerView: UIView = {
       let view = UIView()
        return view
    }()
    
    private let logoImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .center
        imageView.image = UIImage(systemName: "photo")
        imageView.tintColor = .primaryFont
        imageView.layer.cornerRadius = 28
        imageView.layer.borderColor = UIColor.primaryFont.cgColor
        imageView.layer.borderWidth = 2
        return imageView
    }()
    
    private let tickerLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 32, weight: .semibold)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = .primaryFont
        return label
    }()
    
    private let priceLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = .primaryFont
        return label
    }()
    
    private let changeRateLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = .primaryFont
        return label
    }()
    
    private let candlestickChartView: CandleStickChartView = {
        let chartView = CandleStickChartView(frame: CGRect(x: 0, y: 0, width: 300, height: 234))
        return chartView
    }()
    
    private let descriptionTitleLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = .primaryFont
        label.text = "Info"
        return label
    }()
    
    private let descriptionLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = .secondaryFont
        return label
    }()
    
    private let addressTitleLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = .primaryFont
        label.text = "Address"
        return label
    }()
    
    private let addressLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = .secondaryFont
        return label
    }()

    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commonInit()
        viewModel.viewDidLoad()
    }
    
    // MARK: Init
    init(viewModel: DetailViewModelInput) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Helpers
private extension DetailController {
    func setupSubscriptions() {
        viewModel.stockDetailPublisher.sink { [weak self] stockDetail in
            guard let self else { return }
            
            self.navigationItem.title = stockDetail.name
            self.tickerLabel.text = stockDetail.ticker
            self.priceLabel.text = "\(stockDetail.price) \(stockDetail.currencyName)"
            self.changeRateLabel.text = stockDetail.changeRate
            self.descriptionLabel.text = stockDetail.description
            self.addressLabel.text = stockDetail.address
            self.changeRateLabel.textColor = stockDetail.changeRateTextColor
            
            if let imageURL = stockDetail.imageURL {
                let processor = DownsamplingImageProcessor(size: self.logoImageView.bounds.size)
                             |> RoundCornerImageProcessor(cornerRadius: 20)
                
                self.logoImageView.kf.setImage(with: imageURL, options: [
                    .processor(processor),
                    .loadDiskFileSynchronously,
                    .transition(.fade(0.25))
                ])
            }
        }
        .store(in: &cancallables)
        
        viewModel.chartDataPublisher.sink { [weak self] chartData in
            guard let self else { return }
            
            self.candlestickChartView.data = chartData
            self.candlestickChartView.notifyDataSetChanged()
        }
        .store(in: &cancallables)
    }
    
    func commonInit() {
        setupViews()
        setupSubscriptions()
        setupChartView()
    }
    
    func setupChartView() {
        candlestickChartView.chartDescription.enabled = true
        candlestickChartView.dragEnabled = true
        candlestickChartView.setScaleEnabled(true)
        candlestickChartView.maxVisibleCount = 20
        candlestickChartView.pinchZoomEnabled = true
        candlestickChartView.legend.horizontalAlignment = .right
        candlestickChartView.legend.verticalAlignment = .top
        candlestickChartView.legend.orientation = .vertical
        candlestickChartView.legend.drawInside = false
        candlestickChartView.legend.font = .systemFont(ofSize: 12, weight: .medium)
        candlestickChartView.leftAxis.labelFont = .systemFont(ofSize: 12, weight: .medium)
        candlestickChartView.rightAxis.enabled = false
        candlestickChartView.xAxis.labelPosition = .bottom
        candlestickChartView.xAxis.labelFont = .systemFont(ofSize: 12, weight: .medium)
    }
    
    func setupViews() {
        view.backgroundColor = .controllerBackground
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubViews([logoImageView, tickerLabel, priceLabel, changeRateLabel, candlestickChartView, descriptionTitleLabel, descriptionLabel, addressTitleLabel, addressLabel])
        
        scrollView.setConstraint(
            top: view.safeAreaLayoutGuide.topAnchor,
            leading: view.leadingAnchor,
            bottom: view.bottomAnchor,
            trailing: view.trailingAnchor,
            leadingConstraint: .zero,
            bottomConstraint: .zero,
            trailingConstraint: .zero,
            width: UIScreen.main.bounds.width,
            height: UIScreen.main.bounds.height
        )
        
        containerView.setConstraint(
            top: scrollView.topAnchor,
            leading: scrollView.leadingAnchor,
            bottom: scrollView.bottomAnchor,
            trailing: scrollView.trailingAnchor,
            topConstraint: .zero,
            leadingConstraint: .zero,
            bottomConstraint: .zero,
            trailingConstraint: .zero,
            centerX: scrollView.centerXAnchor,
            width: UIScreen.main.bounds.width
        )
        
        logoImageView.setConstraint(
            top: containerView.topAnchor,
            leading: containerView.leadingAnchor,
            topConstraint: 24,
            leadingConstraint: 16,
            width: 56,
            height: 56
        )
        
        tickerLabel.setConstraint(
            top: logoImageView.topAnchor,
            leading: logoImageView.trailingAnchor,
            trailing: containerView.trailingAnchor,
            topConstraint: .zero,
            leadingConstraint: 8,
            trailingConstraint: 16
        )
        
        priceLabel.setConstraint(
            top: tickerLabel.bottomAnchor,
            leading: logoImageView.trailingAnchor,
            topConstraint: 4,
            leadingConstraint: 8
        )
        
        changeRateLabel.setConstraint(
            leading: priceLabel.trailingAnchor,
            leadingConstraint: 4,
            centerY: priceLabel.centerYAnchor
        )
        
        candlestickChartView.setConstraint(
            top: logoImageView.bottomAnchor,
            leading: containerView.leadingAnchor,
            trailing: containerView.trailingAnchor,
            topConstraint: 24,
            leadingConstraint: 16,
            trailingConstraint: 16,
            height: 234
        )
        
        descriptionTitleLabel.setConstraint(
            top: candlestickChartView.bottomAnchor,
            leading: containerView.leadingAnchor,
            trailing: containerView.trailingAnchor,
            topConstraint: 16,
            leadingConstraint: 16,
            trailingConstraint: 16
        )
        
        descriptionLabel.setConstraint(
            top: descriptionTitleLabel.bottomAnchor,
            leading: containerView.leadingAnchor,
            trailing: containerView.trailingAnchor,
            topConstraint: 8,
            leadingConstraint: 16,
            trailingConstraint: 16
        )
        
        addressTitleLabel.setConstraint(
            top: descriptionLabel.bottomAnchor,
            leading: containerView.leadingAnchor,
            trailing: containerView.trailingAnchor,
            topConstraint: 16,
            leadingConstraint: 16,
            trailingConstraint: 16
        )
        
        addressLabel.setConstraint(
            top: addressTitleLabel.bottomAnchor,
            leading: containerView.leadingAnchor,
            bottom: containerView.bottomAnchor,
            trailing: containerView.trailingAnchor,
            topConstraint: 8,
            leadingConstraint: 16,
            bottomConstraint: .zero,
            trailingConstraint: 16
        )
    }
}
