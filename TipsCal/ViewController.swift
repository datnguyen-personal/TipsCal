//
//  ViewController.swift
//  TipsCal
//
//  Created by Dat Nguyen on 30/10/15.
//  Copyright © 2015 datnguyen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //UI
    @IBOutlet weak var btnSetting: UIButton!
    @IBOutlet weak var txtBillAmount: UITextField!
    @IBOutlet weak var sldTipRatio: UISlider!
    @IBOutlet weak var lblTipRatio: UILabel!
    @IBOutlet weak var vTipRatioWrapper: UIView!
    @IBOutlet weak var lblTipAmount: UILabel!
    @IBOutlet weak var lblTotalAmount: UILabel!
    @IBOutlet weak var sldFriends: UISlider!
    @IBOutlet weak var lblFriends: UILabel!
    @IBOutlet weak var lblFriendAmount: UILabel!
    @IBOutlet weak var vTipWrapper: UIView!
    @IBOutlet weak var vParent: UIView!
    @IBOutlet weak var imgPersonIcon: UIImageView!
    
    //variables
    var rBillTextFieldRec: CGRect!
    var rTipWrapperRec: CGRect!
    var rParentRec: CGRect!
    var rTipRatioRec: CGRect!
    
    var rKeyboardFrame: CGRect! = nil
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    
    let darkColors: [UIColor] =
    [ UIColor(red: 1, green: 88/255, blue: 72/255, alpha: 1), UIColor(red: 1/255, green: 67/255, blue: 128/255, alpha: 1)]
    
    let lightColors: [UIColor] =
    [ UIColor(red: 1, green: 177/255, blue: 64/255, alpha: 1), UIColor(red: 87/255, green: 205/255, blue: 255/255, alpha: 1)]
    
    let personIcons: [UIImage] = [ UIImage(named: "person")!, UIImage(named: "bluePerson")!]
    
    let TipRatioKey = "TipRatio"
    let ThemeColorKey = "ThemeColor"
    let StandByTimeKey = "StandByTime"
    let LastBillAmountKey = "LastBillAmount"
    
    let numberFormatter = NSNumberFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onBackgroundState", name: UIApplicationDidEnterBackgroundNotification, object: nil)
        
        let StandByTime = defaults.objectForKey(StandByTimeKey)
        let LastBillAmount = defaults.stringForKey(LastBillAmountKey)
        
        if StandByTime != nil {
            let time = NSDate().timeIntervalSinceDate(StandByTime as! NSDate)
            print(time)
            if time < 300 { //5 minutes
                txtBillAmount.text = LastBillAmount
                updateAllAmount()
            }
        }
        
    }
    
    func onBackgroundState() {
        
        defaults.setObject(txtBillAmount.text, forKey:LastBillAmountKey)
        defaults.setObject(NSDate(), forKey:StandByTimeKey)
        defaults.synchronize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        txtBillAmount.becomeFirstResponder()
        
        rBillTextFieldRec = txtBillAmount.frame
        
        rTipWrapperRec = vTipWrapper.frame
        
        rParentRec = vParent.frame
        
        rTipRatioRec = vTipRatioWrapper.frame
        
        if txtBillAmount.text!.isEmpty {
            toggleTip(true)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if txtBillAmount.text!.isEmpty {
            vTipWrapper.hidden = true
            vTipRatioWrapper.hidden = true
        }
        
        var iTipRatio = getSettings(TipRatioKey)
        
        if iTipRatio == 0 {
            iTipRatio = 15
        }
        
        changeThemeColor(getSettings(ThemeColorKey))
        
        changeDefaultTipRatio(iTipRatio)
        
        numberFormatter.numberStyle = .DecimalStyle
        numberFormatter.locale = NSLocale.currentLocale()
        numberFormatter.maximumFractionDigits = 2
        
        txtBillAmount.placeholder = numberFormatter.currencySymbol
        
        updateAllAmount()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    //when user start editting bill amount
    @IBAction func onBillEidittingChanged(sender: AnyObject) {
        //recalculate tip amount and total amount
        updateAllAmount()
        toggleTip(txtBillAmount.text!.isEmpty)
        
    }
    
    //when user change tip ratio
    @IBAction func onTipRatioChanged(sender: AnyObject) {
        updateAllAmount()
        
    }
    
    //when user change number of friends
    @IBAction func onFriendValueChanged(sender: AnyObject) {
        updateAllAmount()
        
    }
    
    @IBAction func onTapOutside(sender: AnyObject) {
        if (txtBillAmount.text!.isEmpty==false){
            txtBillAmount.endEditing(true)
        }
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            rKeyboardFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue()
        } else {
            rKeyboardFrame = nil
        }
    }
    
    //function to show/hide tips
    func toggleTip(emptyBill: Bool){
        if emptyBill == false {
            
            vTipRatioWrapper.hidden = false
            vTipWrapper.hidden = false
            
            UIView.animateWithDuration(0.25, animations: {
                self.txtBillAmount.frame = self.rBillTextFieldRec
                self.vTipRatioWrapper.frame = self.rTipRatioRec
                self.vTipWrapper.frame = self.rTipWrapperRec
            })
            
        } else {
            var fBillY: CGFloat! = 0
            //get keyboard frame
            if self.rKeyboardFrame != nil {
                fBillY = ((self.rParentRec.height - self.rKeyboardFrame.height)/2) - (self.rBillTextFieldRec.height/2)
            }
            
            UIView.animateWithDuration(0.25, animations: {
                
                //hide tip ratio
                self.vTipRatioWrapper.frame = CGRectMake(self.rTipRatioRec.origin.x, self.rParentRec.maxY, self.rTipRatioRec.width, self.rTipRatioRec.height)
                
                //hide Tip bottom
                self.vTipWrapper.frame = CGRectMake(self.rTipWrapperRec.origin.x, self.rParentRec.maxY, self.rTipWrapperRec.width, self.rTipWrapperRec.height)
                
                //move bill text field to middle
                self.txtBillAmount.frame = CGRectMake(self.rBillTextFieldRec.origin.x, fBillY, self.rBillTextFieldRec.width, self.rBillTextFieldRec.height)
                
                }, completion: {
                    (value: Bool) in
                    //self.vTipWrapper.hidden = true
                    //self.vTipRatioWrapper.hidden = true
            } )
            
            
        }
    }
    
    func initTip(){
        vTipWrapper.hidden = true
        vTipRatioWrapper.hidden = true
        var fBillY: CGFloat! = 0
        //get keyboard frame
        if rKeyboardFrame != nil {
            fBillY = ((rParentRec.height - rKeyboardFrame.height)/2) - (rBillTextFieldRec.height/2)
        }
        
        //move bill text field to middle
        txtBillAmount.frame = CGRectMake(rBillTextFieldRec.origin.x, fBillY, rBillTextFieldRec.width, rBillTextFieldRec.height)
    }

    func updateAllAmount(){
        //recalculate tip amount and total amount
        let strBillAmount = txtBillAmount.text! as NSString
        
        var fBillAmount: Double!=0
        
        if strBillAmount != "" {
            fBillAmount = (txtBillAmount.text! as NSString).doubleValue
        } else {
            fBillAmount = 0
        }
        
        let iTipRatio = Int(sldTipRatio.value)
        let iNumOfFriends = Int(sldFriends.value)
        let fTipAmount  = fBillAmount! * Double(iTipRatio)/100
        let fTotalAmount = fBillAmount! + fTipAmount
        let fFriendAmount = fTotalAmount / Double(iNumOfFriends)
        
        lblTipRatio.text = String(format: "%d%%", iTipRatio)
        lblFriends.text = String(format: "%d", iNumOfFriends)
        lblTipAmount.text = numberFormatter.currencySymbol + " " + numberFormatter.stringFromNumber(fTipAmount)!
        lblTotalAmount.text = numberFormatter.currencySymbol + " " + numberFormatter.stringFromNumber(fTotalAmount)!
        lblFriendAmount.text = numberFormatter.currencySymbol + " " + numberFormatter.stringFromNumber(fFriendAmount)!

    }
    
    func changeThemeColor(colorIndex: Int){
        for view in self.vTipWrapper.subviews as [UIView] {
            if let label = view as? UILabel {
                label.textColor = lightColors[colorIndex]
            }
        }
        
        sldFriends.tintColor = lightColors[colorIndex]
        
        imgPersonIcon.image = personIcons[colorIndex]
        
        sldTipRatio.tintColor = darkColors[colorIndex]
        
        txtBillAmount.textColor = darkColors[colorIndex]
        
        btnSetting.setTitleColor(darkColors[colorIndex], forState: UIControlState.Normal)
        
        lblTipRatio.textColor = darkColors[colorIndex]
        
        vParent.backgroundColor = lightColors[colorIndex]
        
        vTipWrapper.backgroundColor = darkColors[colorIndex]
    }
    
    func changeDefaultTipRatio(ratio: Int){
        lblTipRatio.text = String(format: "%d%%", ratio)
        sldTipRatio.value = Float(ratio)
    }
    
    func getSettings(key: String) -> Int{
        
        return defaults.integerForKey(key)
    }

}

