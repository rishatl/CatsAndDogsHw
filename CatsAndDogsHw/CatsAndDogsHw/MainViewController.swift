//
//  ViewController.swift
//  CatsAndDogsHw
//
//  Created by Rishat on 04.11.2021.
//

import UIKit
import SnapKit
import Kingfisher
import Combine

//MARK: - MainViewController

class MainViewController: UIViewController {

    //MARK: - Private Properties

    private var serviceSubscriber: AnyCancellable?
    private var segmentedControlSubscriber: AnyCancellable?
    private var catSubscriber: AnyCancellable?
    private var dogSubscriber: AnyCancellable?
    private var resetButtonSubscriber: AnyCancellable?

    @Published private var currentSegmentIndex: Int = 0

    @Published private var cat = Cat()
    @Published private var dog = Dog()

    @Published private var catsCount = 0
    @Published private var dogsCount = 0

    //MARK: - UI Properties

    private lazy var segmentedControl: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["Cats", "Dogs"])
        segment.selectedSegmentIndex = 0
        segment.addTarget(self, action: #selector(self.segmentedValueChanged(_:)), for: .valueChanged)
        
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
        label.numberOfLines = 0
        label.textAlignment = .center

        return label
    }()

    //MARK: - Initialization

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()

    }

    //MARK: - Public Methods

    func setupUI() {

        title = "Cats and dogs"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(resetButtonTapped))
        countOfAnimalsLabel.text = "Score: \(catsCount) cats and \(dogsCount) dogs"
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

        configureContentView()
        updateCountOfCats()
        updateCountOfDogs()

    }

    func configureContentView() {

        segmentedControlSubscriber = $currentSegmentIndex
            .receive(on: DispatchQueue.main)
            .sink (receiveCompletion: { _ in }, receiveValue: { index in
                switch index {
                case 0:
                    self.contentTextView.isHidden = false
                    self.contentImageView.isHidden = true
                case 1:
                    self.contentTextView.isHidden = true
                    self.contentImageView.isHidden = false
                default:
                    break
                }
            })
        
    }

    func updateCountOfCats() {

        catSubscriber = $catsCount
            .receive(on: DispatchQueue.main)
            .sink { value in
                self.countOfAnimalsLabel.text = "Score: \(value) cats and \(self.dogsCount) dogs"
            }

    }

    func updateCountOfDogs() {

        dogSubscriber = $dogsCount
            .receive(on: DispatchQueue.main)
            .sink { value in
                self.countOfAnimalsLabel.text = "Score: \(self.catsCount) cats and \(value) dogs"
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

    //MARK: - @objc Methods

    @objc func segmentedValueChanged (_ sender: UISegmentedControl!) {
        currentSegmentIndex = sender.selectedSegmentIndex
    }

    @objc func resetButtonTapped() {

        catsCount = 0
        dogsCount = 0

    }

    @objc func moreButtonTapped(sender: UIButton) {

        animateMoreButton(sender: sender)

        switch segmentedControl.selectedSegmentIndex {
        case 0:
            self.setupCatFact()
            self.catsCount += 1
        case 1:
            self.setupDogMessage()
            self.dogsCount += 1
        default:
            break
        }

    }

    //MARK: - Private

    private func setupCatFact() {

        fetchCatFact()
        contentTextView.text = cat.fact
        contentTextView.centerText()

    }

    private func setupDogMessage() {

        fetchDogMessage()
        guard let imageUrlString = dog.message else { return }
        let imageUrl: URL? = URL(string: imageUrlString)
        contentImageView.kf.setImage(with: imageUrl)
        
    }

    private func fetchCatFact() {

        serviceSubscriber = DataManager().catPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { cat in
                self.cat = cat
            })

    }

    private func fetchDogMessage() {

        serviceSubscriber = DataManager().dogPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { dog in
                self.dog = dog
            })
    }

}
