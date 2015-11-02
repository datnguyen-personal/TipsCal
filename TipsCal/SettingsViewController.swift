//
//  SettingsViewController.swift
//  Tips Calculator
//
//  Created by Dat Nguyen on 1/11/15.
//  Copyright © 2015 datnguyen. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var sldDefaultTipRatio: UISlider!
    @IBOutlet weak var lblDefaultTipRatio: UILabel!
    @IBOutlet weak var sgColorPicker: UISegmentedControl!
    
    @IBOutlet weak var vSettingParent: UIView!
    @IBOutlet weak var btnBack: UIButton!
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    let TipRatioKey = "TipRatio"
    let ThemeColorKey = "ThemeColor"
    
    let textColors: [UIColor] =
    [ UIColor(red: 1, green: 88/256, blue: 72/256, alpha: 1), UIColor(red: 1/256, green: 67/256, blue: 128/256, alpha: 1)]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view
        var iTipRatio = getSettings("TipRatio")
        let iThemeColor = getSettings("ThemeColor")
        
        if iTipRatio == 0 {
            iTipRatio = 15
        }
        
        sldDefaultTipRatio.value = Float(iTipRatio)
        lblDefaultTipRatio.text = String(format: "%d%%", iTipRatio)
        sgColorPicker.selectedSegmentIndex = iThemeColor
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        sgColorPicker.subviews[1].tintColor = textColors[0]
        sgColorPicker.subviews[0].tintColor = textColors[1]
        
        changeSettingThemeColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onDefaultTipRatioChanged(sender: AnyObject) {
        saveSettings(Int(sldDefaultTipRatio.value), key: "TipRatio")
        
        let iTipRatio = Int(sldDefaultTipRatio.value)
        
        lblDefaultTipRatio.text = String(format: "%d%%", iTipRatio)
    }
    
    @IBAction func onThemeColorChanged(sender: AnyObject) {
        saveSettings(sgColorPicker.selectedSegmentIndex, key: "ThemeColor")
        
        changeSettingThemeColor()
        
    }
    
    @IBAction func BackButtonClicked(sender: AnyObject) {
        dismissViewControllerAnimated(false, completion: nil)
        //navigationController?.popViewControllerAnimated(true)
    }
    
    func changeSettingThemeColor(){
        for view in self.vSettingParent.subviews as [UIView] {
            if let label = view as? UILabel {
                label.textColor = textColors[sgColorPicker.selectedSegmentIndex]
            }
        }
        
        sldDefaultTipRatio.tintColor = textColors[sgColorPicker.selectedSegmentIndex]
        
        btnBack.setTitleColor(textColors[sgColorPicker.selectedSegmentIndex], forState: UIControlState.Normal)
    }
    
    
    //save settings value to user default
    func saveSettings(value:Int, key:String){
        defaults.setObject(value, forKey: key)
        defaults.synchronize()
    }
    
    //get settings value from key
    func getSettings(key: String) -> Int{
        
        return defaults.integerForKey(key)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
