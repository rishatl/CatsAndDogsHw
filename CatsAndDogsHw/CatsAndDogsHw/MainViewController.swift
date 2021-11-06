//
//  ViewController.swift
//  CatsAndDogsHw
//
//  Created by Rishat on 04.11.2021.
//

import UIKit
import SnapKit
import Combine

//MARK: - MainViewController

class MainViewController: UIViewController {

    //MARK: - Private Properties

    private var subscriber: AnyCancellable?

    private var cat = Cat()

    //MARK: - UI Properties

    private var segmentedControl: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["Cats", "Dogs"])

        return segment
    }()

    private var contentImageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.contentMode = .scaleToFill
        view.layer.masksToBounds = false
        view.clipsToBounds = true

        return view
    }()

    private var contentTextView: UITextView = {
        let view = UITextView()
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1

        return view
    }()

    private let moreButton: UIButton = {
        let button = UIButton()
        button.setTitle("more", for: [])
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.backgroundColor = UIColor(red: 255 / 255, green: 155 / 255, blue: 138 / 255, alpha: 1)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)

        return button
    }()

    private var countOfAnimalsLabel: UILabel = {
        let label = UILabel()
        label.text = "nothing so far..."
        label.numberOfLines = 0
        label.textAlignment = .center

        return label
    }()

    //MARK: - Initialization

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Cats and dogs"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(resetButtonTapped))

        setupUI()

    }

    //MARK: - Public Methods

    func setupUI() {

        contentImageView.isHidden = true

        view.addSubview(segmentedControl)
        view.addSubview(contentImageView)
        view.addSubview(contentTextView)
        view.addSubview(moreButton)
        view.addSubview(countOfAnimalsLabel)

        segmentedControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(196)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(27)
        }

        contentImageView.snp.makeConstraints { make in
            make.height.equalTo(205)
            make.top.equalTo(segmentedControl.snp.bottom).offset(41)
            make.leading.equalToSuperview().offset(19)
            make.trailing.equalToSuperview().inset(18)
        }

        contentTextView.snp.makeConstraints { make in
            make.height.equalTo(205)
            make.top.equalTo(segmentedControl.snp.bottom).offset(41)
            make.leading.equalToSuperview().offset(19)
            make.trailing.equalToSuperview().inset(18)
        }

        moreButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(144)
            make.height.equalTo(40)
            make.top.equalTo(contentImageView.safeAreaLayoutGuide.snp.bottom).offset(13)
        }

        countOfAnimalsLabel.snp.makeConstraints { make in
            make.top.equalTo(moreButton.snp.bottom).offset(19)
            make.leading.equalToSuperview().offset(22)
            make.bottom.greaterThanOrEqualTo(view.safeAreaLayoutGuide.snp.bottom).inset(327)
            make.trailing.equalToSuperview().inset(22)
        }

        setupSegmentedControl()

    }

    func setupSegmentedControl() {

        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(self.segmentedValueChanged(_:)), for: .valueChanged)

    }

    //MARK: - @objc Methods

    @objc func segmentedValueChanged (_ sender: UISegmentedControl!) {

        switch sender.selectedSegmentIndex {
        case 0:
            contentTextView.isHidden = false
            contentImageView.isHidden = true
        case 1:
            contentTextView.isHidden = true
            contentImageView.isHidden = false
        default:
            break
        }

    }

    @objc func resetButtonTapped() {

    }

    @objc func moreButtonTapped(sender: UIButton) {

        animateMoreButton(sender: sender)

        switch segmentedControl.selectedSegmentIndex {
        case 0:
            setupCatFact()
        case 1:
            break
        default:
            break
        }

    }

    func animateMoreButton(sender: UIButton) {

        sender.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)

        UIView.animate(withDuration: 2.0,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.20),
                       initialSpringVelocity: CGFloat(6.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        sender.transform = CGAffineTransform.identity
                       },
                       completion: { _ in()  }
        )

    }

    //MARK: - Private

    private func setupCatFact() {

        contentTextView.text = fetchCatFact()
        contentTextView.centerText()

    }

    private func fetchCatFact() -> String {

        subscriber = DataManager().catPublisher
            .sink(receiveCompletion: { _ in }, receiveValue: { cat in
                DispatchQueue.main.async {
                    self.cat = cat
                }
            })

        guard let catFact = cat.fact else { return "" }

        return catFact

    }

}
