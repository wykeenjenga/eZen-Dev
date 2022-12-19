//
//  APHardWallViewController.swift
//  eZen Dev
//
//  Created by Wykee on 19/12/2022.
//  Copyright © 2022 Music of Wisdom. All rights reserved.
//

import UIKit

class APHardWallViewController: UIViewController {
    
    @IBOutlet var image: UIImageView!
    @IBOutlet var footTitle: UILabel!
    @IBOutlet var footNote: UILabel!
    
    @IBOutlet weak var getStartedBtn: UIButton!
    
    @IBOutlet var vONE: UIView!
    @IBOutlet var vTWO: UIView!
    @IBOutlet var vTHREE: UIView!
    
    var pos = 0
    
    let titles: [String] = [OnboardingTitles.mic, OnboardingTitles.headphones, OnboardingTitles.meditate]
    
    let footNotes: [String] = [OnboardingSubTitles.mic, OnboardingSubTitles.headphones, OnboardingSubTitles.meditate]
    
    let images = [OnboardingImages.mic, OnboardingImages.headphones, OnboardingImages.meditate]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.image.image = images[0]
        self.footTitle.text = titles[0]
        self.footNote.text = footNotes[0]
        
        let isOnboardingShown = UserDefaults.standard.bool(forKey: "isOnboarding")
        print(".......\(isOnboardingShown)")
        if isOnboardingShown{
            navigateHome()
        }
    }
    
    @IBAction func getStarted(_ sender: Any) {
        navigateHome()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.animateViews()
        self.initSwipe()
        self.getStartedBtn.isEnabled = false
    }
    
    func navigateHome(){
        UserDefaults.standard.set(true, forKey: "isOnboarding")
        let homeVC = Accessors.AppDelegate.delegate.appDiContainer.makeHomeDIContainer().makeHomeViewController()
//        homeVC.modalPresentationStyle = .fullScreen
//        homeVC.modalTransitionStyle = .coverVertical
        self.present(homeVC, animated: true)
    }
    
    func initSwipe(){
        let leftRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(onBoardingSwipeMade(_:)))
        leftRecognizer.direction = .left
        
        let rightRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(onBoardingSwipeMade(_:)))
        rightRecognizer.direction = .right
        self.view.addGestureRecognizer(leftRecognizer)
        self.view.addGestureRecognizer(rightRecognizer)
    }
    
    @IBAction func onBoardingSwipeMade(_ sender: UISwipeGestureRecognizer) {
       if sender.direction == .left {
           self.pos = self.pos + 1
           if pos > 2 {
               pos = 2
           }else{
               self.setOnBoardingValues(pos: pos)
           }
           
           if pos == 2{
               self.getStartedBtn.isEnabled = true
           }
       }
        
       if sender.direction == .right {
           self.pos = self.pos - 1
           if pos < 0 {
               pos = 0
           }else{
               self.setOnBoardingValues(pos: pos)
           }
       }
    }
    
    func setOnBoardingValues(pos: Int){
        self.image.image = images[pos]
        self.footTitle.text = titles[pos]
        self.footNote.text = footNotes[pos]
        self.observerIndicator()
        self.animateViews()
    }
    
    func observerIndicator(){
        switch self.pos{
        case 0:
            self.vTWO.backgroundColor = UIColor(named: "grayB")
            self.vTHREE.backgroundColor = UIColor(named: "grayB")
            self.vONE.backgroundColor = UIColor(named: "blue")
            
        case 1:
            self.vONE.backgroundColor = UIColor(named: "grayB")
            self.vTHREE.backgroundColor = UIColor(named: "grayB")
            self.vTWO.backgroundColor = UIColor(named: "blue")
        case 2:
            self.vONE.backgroundColor = UIColor(named: "grayB")
            self.vTWO.backgroundColor = UIColor(named: "grayB")
            self.vTHREE.backgroundColor = UIColor(named: "blue")
        default:
            break
        }
    }
    
    
    func animateViews(){
        UIView.animate(withDuration: 0.0) {
            self.image.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
         }
        UIView.animate(withDuration: 2.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.4, options: [], animations: {
            self.footTitle.center.y += 30.0
            self.footTitle.alpha = 1.0
        }, completion: nil)
        
        UIView.animate(withDuration: 2.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.4, options: [], animations: {
            self.image.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.image.alpha = 1.0
        }, completion: nil)
    }

}
