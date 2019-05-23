//
//  LoginViewController.swift
//  Bement
//
//  Created by Runkai Zhang on 8/7/18.
//  Copyright © 2018 Numeric Design. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ATCWalkthroughViewControllerDelegate {
    
    @IBOutlet var lunchButton: UIButton!
    @IBOutlet var reportsButton: UIButton!
    @IBOutlet var SupportButton: UIButton!
    
    let walkthroughs = [
        ATCWalkthroughModel(title: "Efficienct Login System", subtitle: "This login system is very user-friendly and 100% secure when handling your data.", icon: "Real"),
        ATCWalkthroughModel(title: "Quick Responses", subtitle: "This system have lightning respond time and can provide you first hand data withour delay.", icon: "lighting"),
        ATCWalkthroughModel(title: "Calender Feeds", subtitle: "Extremely convenient calender system by using Apple's native calender app, keeping you up to date.", icon: "Straight"),
        ATCWalkthroughModel(title: "Get Notified", subtitle: "Receive notifications when a term report is released to stay on top of everything.", icon: "bell"),
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isAppAlreadyLaunchedOnce() == false {
            let walkthroughVC = self.walkthroughVC()
            walkthroughVC.delegate = self
            self.addChildViewControllerWithView(walkthroughVC)
        }
        
        tools.beautifulButton(SupportButton)
        tools.beautifulButton(reportsButton)
        tools.beautifulButton(lunchButton)
    }
    
    @IBAction func done(_ segue: UIStoryboardSegue) {
        //print("Popping back to this view controller!")
        // reset UI elements etc here
    }
    
    @IBAction func support(_ sender: Any) {
        globalVariable.firstTimeIndicator = true
    }
    
    func isAppAlreadyLaunchedOnce()-> Bool {
        let defaults = UserDefaults.standard
        if let _ = defaults.string(forKey: "isAppAlreadyLaunchedOnce"){
            //print("App already launched")
            return true
        }else{
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            //print("App launched first time")
            return false
        }
    }
    
    func walkthroughViewControllerDidFinishFlow(_ vc: ATCWalkthroughViewController) {
        UIView.transition(with: self.view, duration: 1, options: .transitionFlipFromLeft, animations: {
            vc.view.removeFromSuperview()
            let viewControllerToBePresented = UIViewController()
            self.view.addSubview(viewControllerToBePresented.view)
        }, completion: nil)
    }
    
    fileprivate func walkthroughVC() -> ATCWalkthroughViewController {
        let viewControllers = walkthroughs.map { ATCClassicWalkthroughViewController(model: $0, nibName: "ATCClassicWalkthroughViewController", bundle: nil) }
        return ATCWalkthroughViewController(nibName: "ATCWalkthroughViewController",
                                            bundle: nil,
                                            viewControllers: viewControllers)
    }
}
