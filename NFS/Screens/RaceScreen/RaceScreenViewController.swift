//
//  RaceScreenViewController.swift
//  NFS
//
//  Created by Вячеслав on 13/2/24.
//

import UIKit
private enum Constants {
    //КНОПКИ
    static let xLeftButton: CGFloat = 20
    static let trailingOffsetRightButton: CGFloat = 20
    static let xRightButton: CGFloat = UIScreen.main.bounds.width - leftRightButtonWidth - trailingOffsetRightButton
    static let yButton = UIScreen.main.bounds.height - bottomOffsetButton
    static let bottomOffsetButton: CGFloat = 90
    static let leftRightButtonWidth: CGFloat = UIScreen.main.bounds.width / 6
    static let leftRightButtonHeight: CGFloat = 60
    static let buttonStep: CGFloat = 30
    // MARK: - СARS
    //коэфициент ширины машины относительно ширины экрана(мб изменить на 0.15)
    static let coefficientOfMachineWidthInRelationToScreenWidth: Double = 0.16
    static let widthOfCar: CGFloat = UIScreen.main.bounds.width * coefficientOfMachineWidthInRelationToScreenWidth
    //отношение ширины машины к ее длинне
    static let machineWidthToMachineLengthRatio: Double = 0.53
    static let heightOfCar: CGFloat = widthOfCar / machineWidthToMachineLengthRatio
    static let originXForCar: CGFloat = UIScreen.main.bounds.width/2 - (widthOfCar/2)
    static let originYForCar: CGFloat = UIScreen.main.bounds.height - Constants.heightOfCar - 10
    //коэфициент ширины бордюра относительно ширины дороги
    static let kerbWidthCoefficientRelativeToRoadWidth: Double = 0.13
    static let leftMostPointX: CGFloat = UIScreen.main.bounds.width * kerbWidthCoefficientRelativeToRoadWidth
    static let rightMostPointX: CGFloat = UIScreen.main.bounds.width - leftMostPointX - widthOfCar
    static let arrayOfOpponentCarsNames:[String] = ["68' Krome Trajam", "95' Mercedes C-Class", "99' Lamborghini Diablo"]
}


protocol IRaceScreenViewController: AnyObject {
    var userSettings: UserSettings! { get set }
}

final class RaceScreenViewController: UIViewController {
    var userSettings: UserSettings!
    private var presenter: IRaceScreenPresenter!
    private var timeRoad: Timer?
    var playerCar = UIImageView()
    private var userScore = 0 {
        willSet {
            scoreLabel.text = "Очки: \(newValue)"
        }
    }
    private var scoreLabel = UILabel()
    private lazy var rightButton = UIButton()
    private lazy var leftButton = UIButton()
    private var opponentCarTimer: Timer?
    private var opponentCarTimerTimeInterval = Double()
    private var opponentCarAnimateDuration = Double()
    private var opponentCars = [UIImageView]()
    private var displayLink: CADisplayLink?
        
    init() {
        super.init(nibName: nil, bundle: nil)
        presenter = RaceScreenPresenter(viewController: self)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserSettingsFromMemory()
        createsRoad()
        setupLable()
        addPlayerCar()
        choiceOfManagement()
        setupopponentCarTimerTimeInterval()
        setupOpponentCarAnimateDuration()
        addOpponentCarTimer()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timeRoad?.invalidate()
        opponentCarTimer?.invalidate()
    }
    private func createsRoad() {
        timeRoad = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: true, block: {  _ in
            let imageRoad = UIImageView()
            imageRoad.image = UIImage(named: "дорога")
            imageRoad.frame = CGRect(x: 0,
                                     y: -100,
                                     width: self.view.bounds.width,
                                     height: self.view.bounds.height + 100 )
            self.view.insertSubview(imageRoad, at: 0)
            //GameConstants.roadDuration
            self.animationBackground(imageRoad, 3.0)
        })
    }
    private func animationBackground(_ imageView: UIImageView, _ duration: TimeInterval) {
        UIView.animate(withDuration: duration, delay: 0.3, options: .curveLinear) {
            imageView.center.y += self.view.frame.height + 150
        } completion: {  _ in
            imageView.removeFromSuperview()
        }
    }
    private func loadUserSettingsFromMemory() {
        presenter.loadUserSettingsFromMemory()
    }
    private func addPlayerCar() {
        let nameOfUserCar = userSettings.car.CarString
        playerCar = UIImageView(frame: CGRect(x: Constants.originXForCar,
                                              y: Constants.originYForCar,
                                              width: Constants.widthOfCar,
                                              height: Constants.heightOfCar)
            )
        playerCar.image = UIImage(named: nameOfUserCar)
       // playerCar.contentMode = .scaleAspectFill
        view.addSubview(playerCar)
    }
    private func setupLable() {
        scoreLabel.text = "Очки: 0"
        scoreLabel.frame = CGRect(x: (view.frame.width / 2) - 50, y: 30, width: 130, height: 50)
        view.addSubview(scoreLabel)
    }
    private func choiceOfManagement() {
        let choice = userSettings.type
        switch choice {
        case .tap: setupTapNavigation()
        case .swipe: setupTapNavigation()
        case .accelerometer: setupTapNavigation()
        }
    }
    private func setupTapNavigation() {
        leftButton.frame = CGRect(x: Constants.xLeftButton,
                                  y: Constants.yButton,
                                  width: Constants.leftRightButtonWidth,
                                  height: Constants.leftRightButtonHeight)
        leftButton.setTitle("Left", for: .normal)
        leftButton.contentHorizontalAlignment = .center
        leftButton.backgroundColor = .blue
        leftButton.addTarget(self, action: #selector(movePlayerCarLeft), for: .touchUpInside)
        view.addSubview(leftButton)
        
        rightButton.frame = CGRect(x: Constants.xRightButton,
                                   y: Constants.yButton,
                                   width: Constants.leftRightButtonWidth,
                                   height: Constants.leftRightButtonHeight)
        rightButton.setTitle("Right", for: .normal)
        rightButton.contentHorizontalAlignment = .center
        rightButton.backgroundColor = .blue
        rightButton.addTarget(self, action: #selector(movePlayerCarRight), for: .touchUpInside)
        view.addSubview(rightButton)
    }
    private func setupopponentCarTimerTimeInterval() {
        opponentCarTimerTimeInterval = 2.0
    }
    private func setupOpponentCarAnimateDuration() {
        opponentCarAnimateDuration = 1.0
    }
    private func addOpponentCarTimer() {
        opponentCarTimer = Timer.scheduledTimer(timeInterval: opponentCarTimerTimeInterval,
                                                target: self,
                                                selector: #selector(addOpponentCar),
                                                userInfo: nil,
                                                repeats: true)
    }
    private func createDisplayLink() {
        displayLink = CADisplayLink(target: self, selector: #selector(checkCollision))
        displayLink?.add(to: .current, forMode: .default)
    }
    private func endGame() {
        let alertController = UIAlertController(title: "Ты проиграл", message: "Твой результа \(userScore)", preferredStyle: .alert)
        presenter.saveResult(score: userScore)
        present(alertController, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.navigationController?.popViewController(animated: true)
            alertController.dismiss(animated: false)
        }
    }
    @objc private func movePlayerCarLeft() {
        UIView.animate(withDuration: 0.2,
                       delay: 0.0,
                       options: .curveLinear,
                       animations: { [self] in
            playerCar.frame.origin.x -= Constants.buttonStep
                        }, completion: nil)
        if playerCar.frame.origin.x <= Constants.leftMostPointX {
            endGame()
        }
    }
    @objc private func movePlayerCarRight() {
        UIView.animate(withDuration: 0.2,
                       delay: 0.0,
                       options: .curveLinear,
                       animations: { [self] in
            playerCar.frame.origin.x += Constants.buttonStep
                        }, completion: nil)
        if playerCar.frame.origin.x >= Constants.rightMostPointX {
            endGame()
        }
    }
    @objc private func addOpponentCar() {
        let opponentCarXPosition: CGFloat = Double.random(in: Constants.leftMostPointX...Constants.rightMostPointX)
        let opponentCar = UIImageView(frame: CGRect(x: opponentCarXPosition,
                                                    y: 0 - Constants.heightOfCar,
                                                    width: Constants.widthOfCar,
                                                    height: Constants.heightOfCar)
        )
        opponentCar.image = UIImage(named: Constants.arrayOfOpponentCarsNames.randomElement()!)
        view.addSubview(opponentCar)
        opponentCars.append(opponentCar)
        
        UIView.animate(withDuration: opponentCarAnimateDuration,
                       delay: 0.0,
                       options: .curveLinear,
                       animations: { [self] in
            opponentCar.frame.origin.y = self.view.frame.height
            createDisplayLink()
            
        }, completion: { _ in
            self.userScore += 1
            opponentCar.removeFromSuperview()
            self.opponentCars.remove(at: self.opponentCars.firstIndex(of: opponentCar)!)
            })
    }
    @objc func checkCollision() {
        for car in opponentCars {
            if playerCar.layer.presentation()!.frame.intersects(car.layer.presentation()!.frame) {
                endGame()
            }
        }
    }
}

extension RaceScreenViewController: IRaceScreenViewController {
    
}
