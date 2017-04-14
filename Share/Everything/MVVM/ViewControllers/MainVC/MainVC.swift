//
//  MainVC.swift
//  Share
//
//  Created by Aseem 7 on 17/10/16.
//  Copyright © 2016 CodeBrew. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import PieCharts
import SVProgressHUD


class MainVC: UIViewController {
    
//MARK: - Local Variables
    let disposeBag = DisposeBag()
    var viewModel:MainVM?
    var selectedBtn:UIButton?
    var selectedIndex:Int = 0
    var statusTimer:Timer?
    var imageObservavle = Variable<[UIImage]>([])
    var selectedImage : [UIImage] = []
    var selectedName : [String] = []
    var selectedTag : [Int] = []
    // editing
    var socialSelected = ["facebook", "instagram", "twitter", "tumblr", "vine", "pinterest",  "linkedin", "youtube"]
    var indexSelected = Int()
    //outlet for pieChart from the Charts ------------------
    var sliceSelected: PieSlice?
    let popupView = VKPopupView(backgroundStyle: .dark, contentViewStyle: .extraLight) // view popup effect
    
    fileprivate static let alpha: Float = 1.0
    let colors = [
        UIColor(colorLiteralRed: 45/255, green: 92/255, blue: 149/255, alpha: alpha),
        UIColor(colorLiteralRed: 236/255, green: 25/255, blue: 105/255, alpha: alpha),
        UIColor(colorLiteralRed: 0/255, green: 165/255, blue: 238/255, alpha: alpha),
        UIColor(colorLiteralRed: 50/255, green: 71/255, blue: 92/255, alpha: alpha),
        UIColor(colorLiteralRed: 0/255, green: 191/255, blue: 146/255, alpha: alpha),
        UIColor(colorLiteralRed: 0/255, green: 0/255, blue: 0/255, alpha: alpha),
        UIColor(colorLiteralRed: 0/255, green: 136/255, blue: 189/255, alpha: alpha),
        UIColor(colorLiteralRed: 239/255, green: 19/255, blue: 32/255, alpha: alpha),
        UIColor.orange.withAlphaComponent(CGFloat(alpha)),
        UIColor.brown.withAlphaComponent(CGFloat(alpha)),
        UIColor.lightGray.withAlphaComponent(CGFloat(alpha)),
        UIColor.gray.withAlphaComponent(CGFloat(alpha))
    ]
    fileprivate var currentColorIndex = 0
    var flagSelected = false
    var time = 10
    // ends

    
//MARK: - Outlets
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var graphImage: UIImageView!
    
    ///*editing
    //magnification of pie chart
    
    @IBOutlet weak var scrollViewMain: UIScrollView!
    @IBOutlet weak var viewMagnifyPieChart: UIView!
    @IBOutlet weak var lblSoicalNameMagnified: UILabel!
    @IBOutlet weak var lblSocialValueMagnified: UILabel!
    
    @IBOutlet var lblSocialNameCollection: [UILabel]!
    @IBOutlet var lblSocialValueCollection: [UILabel]!
    @IBOutlet weak var lbltotalTimeSpentName: UILabel!
    @IBOutlet weak var lblTotalTimeSpentValue: UILabel!
    @IBOutlet weak var lblValuePercentageCenterPieChart: UILabel!
    
    //ends
    @IBOutlet weak var collViewSocialScreen: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
   
    
    @IBOutlet weak var chartView: PieChart!
    @IBOutlet weak var collView: UICollectionView!
    
    @IBOutlet weak var btnHome: UIButton!
    @IBOutlet weak var btnTop: UIButton!
    @IBOutlet weak var graphCenterView: UIView!
    
    
//MARK: - didLoad Function
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = MainVM(mainVCObj:self)
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(updateIndex), name: Notification.Name("IndexChanged"), object: nil)
        chartView.delegate = self // chart view delegate
        // refreshing the piechart data
        let pc = NotificationCenter.default
        pc.addObserver(self, selector: #selector(refreshPieChart), name: Notification.Name("DataPieChanged"), object: nil)
        //pc.addObserver(self, selector: #selector(startPieChart), name: Notification.Name("DataPieChanged"), object: nil)
        // magnified pie chart
        viewMagnifyPieChart.isHidden = true
        bindingUI()
    }
//    func startPieChart(_ not: Notification) {
//        if let userInfo = not.userInfo {
//            // Safely unwrap the name sent out by the notification sender
//            if let _ = userInfo["userModel"] as? UserData {
//                chartView.models = createModels()
//                //chartView.layers = [createPlainTextLayer()/*, createTextWithLinesLayer()*/]
//            }
//        }
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        //------pieChart Code--------------
        //chartView.layers = [createPlainTextLayer()/*, createTextWithLinesLayer()*/]
        
        //observer to update the pie chart
//        let pc = NotificationCenter.default
//        pc.addObserver(self, selector: #selector(startPieChart), name: Notification.Name("DataPieChanged"), object: nil)
        chartView.models = createModels() // order is important - models have to be set at the end
        statusTimer = Timer.scheduledTimer(timeInterval: TimeInterval(time), target: self, selector: #selector(updateStatus), userInfo: nil, repeats: true)
        SVProgressHUD.show()
        //blurView(super.view)
        super.view.isUserInteractionEnabled = false
        let gameTimer: Timer!
        statusTimer = Timer.scheduledTimer(timeInterval: TimeInterval(time), target: self, selector: #selector(removeProgressHUD), userInfo: nil, repeats: false)
        //---------------------------------
        
        self.userName.text=(UserDefaults.standard.value(forKey: userDefaultsKey.userName.rawValue) as! String)
        if(UserDefaults.standard.value(forKey: userDefaultsKey.bgColor.rawValue) != nil ){
            
            let bgColor:Data = UserDefaults.standard.value(forKey: userDefaultsKey.bgColor.rawValue) as! Data
            let color:UIColor = NSKeyedUnarchiver.unarchiveObject(with: bgColor) as! UIColor
            self.view.backgroundColor=color
            self.btnTop.backgroundColor=color
            self.btnHome.backgroundColor=color
            self.graphCenterView.backgroundColor=color
        }
        statusTimer = Timer.scheduledTimer(timeInterval: TimeInterval(time), target: self, selector: #selector(updateStatus), userInfo: nil, repeats: true)
        
        imageObservavle.value.removeAll()
        selectedImage.removeAll()
        selectedTag .removeAll()
        selectedName.removeAll()
        
        var socialName:String
        var imageData:UIImage
        var selectedImageData:UIImage
        var socialStr:String
        
        for index in 0..<8
        {
            
            switch (index) {
            case 0:
                socialName = "facebookShare"
                socialStr = "Facebook"
                imageData = UIImage.init(named:"ic_facebook-2")!
                selectedImageData =  UIImage.init(named:"ic_fb_circle")!
            case 1:
                socialName = "instagramShare"
                socialStr = "Instagram"
                imageData = UIImage.init(named:"ic_insta-1")!
                selectedImageData =  UIImage.init(named:"ic_insta_circle")!
            case 2:
                socialName = "twitterShare"
                socialStr = "Twitter"
                imageData = UIImage.init(named:"ic_Twitter-2")!
                selectedImageData =  UIImage.init(named:"ic_twitter_clirce")!
            case 3:
                socialName = "tumblrShare"
                socialStr = "Tumblr"
                imageData = UIImage.init(named:"ic_tumbler")!
                selectedImageData =  UIImage.init(named:"ic_tumbler_circle")!
            case 4:
                socialName = "vineShare"
                socialStr = "Vine"
                imageData = UIImage.init(named:"ic_vine-3")!
                selectedImageData =  UIImage.init(named:"ic_vine_circle")!
            case 5:
                socialName = "pinterestShare"
                socialStr = "Pinterest"
                imageData = UIImage.init(named:"ic_pintrest-1")!
                selectedImageData = UIImage.init(named:"ic_pintrest_circle")!
            case 6:
                socialName = "linkedinShare"
                socialStr = "LinkedIn"
                imageData = UIImage.init(named:"ic_linkedin-1")!
                selectedImageData =  UIImage.init(named:"ic_linkedin_circle")!
            case 7:
                socialName = "youtubeShare"
                socialStr = "Youtube"
                imageData = UIImage.init(named:"ic_youtube-1")!
                selectedImageData =  UIImage.init(named:"ic_youtube_circle")!
            default:
                socialName = "Share"
                socialStr = ""
                imageData = UIImage.init(named:"ic_facebook-2")!
                selectedImageData =  UIImage.init(named:"ic_fb_circle")!
            }
            if(UserDefaults.standard.value(forKey: socialName) != nil)
            {
                let value:String = UserDefaults.standard.value(forKey: socialName) as! String
                if(value != "0")
                {
                    imageObservavle.value.append(imageData)
                    selectedImage.append(selectedImageData)
                    selectedName.append(socialStr)
                    selectedTag.append(index)
                }
            }
            else
            {
                imageObservavle.value.append(imageData)
                selectedImage.append(selectedImageData)
                selectedName.append(socialStr)
                selectedTag.append(index)
            }
        }
    }
    func blurView(_ view: UIView) {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
    }
    func removeProgressHUD() {
        SVProgressHUD.dismiss()
        super.view.isUserInteractionEnabled = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        statusTimer?.invalidate()
    }
    func reloadUpperCollView(_ indexSelected: Int) {
        if selectedIndex != indexSelected {
            selectedIndex = indexSelected
            let selectedVal:Int = self.selectedTag[selectedIndex]
            self.viewModel?.socialBtnClicked(selectedVal)
            //SVProgressHUD.dismiss()
            removePreviousPieChart(chartView)
            chartView.models = createModels()
            
            collView.reloadData()
            if viewMagnifyPieChart.isHidden == true {
                
            }
            else {
                print("Showing you the view man!")
            }
//            self.viewModel?.socialBtnClicked(selectedVal)
//            removePreviousPieChart(chartView)
//            chartView.models = createModels()
//            collView.reloadData()
        }
    }
    func updateIndex(not: Notification) {
        // userInfo is the payload send by sender of notification
        if let userInfo = not.userInfo {
            // Safely unwrap the name sent out by the notification sender
            if let index = userInfo["index"] as? Int {
                print(index)
                reloadUpperCollView(index)
            }
        }
    }
//MARK: - UI Binding
    func bindingUI(){
        
        
        imageObservavle.asObservable()
            .bindTo(collView.rx.items(cellIdentifier: "socialCell", cellType: SocialCell.self)) { (row, element, cell) in
                if(row == self.selectedIndex) {
                    cell.socialImage.image = self.selectedImage[row]
                }
                else {
                    cell.socialImage.image = element
                }
            }
            .addDisposableTo(disposeBag)
        
        //MARK: reload collView
        collView.rx
            .modelSelected(UIImage.self)
            .subscribe(onNext:  { value in
                if let rowIndex :Int = self.collView.indexPathsForSelectedItems?[0].row {
                    if(self.selectedIndex==rowIndex){ return }
                    self.selectedIndex=rowIndex
                    
                    self.collView.reloadData()
                    
                }
            })
            .addDisposableTo(disposeBag)
        
        if self.selectedIndex == currentIndex{
            print("The selected index is :(inside if) \(selectedIndex)")
            print("The selected index is : (inside if)\(currentIndex)")
            return }
        else {
            print("The selected index is : (inside else)\(selectedIndex)")
            print("The selected index is : (inside else)\(currentIndex)")
            self.selectedIndex = currentIndex
            self.collView.reloadData()
        }

        DispatchQueue.global().async {
            
        }
        
        //Binding buttons
        self.userName.text=(UserDefaults.standard.value(forKey: userDefaultsKey.userName.rawValue) as! String)
        
        
        btnHome.rx.tap.subscribe(onNext: { _ in
            self.viewModel?.homeClicked()
        }).addDisposableTo(disposeBag)
        
        btnTop.rx.tap.subscribe(onNext: { _ in
            self.viewModel?.topClicked()
        }).addDisposableTo(disposeBag)
        
    }
   
    //Update status method
    func updateStatus() {
        viewModel?.updateStatus()
        viewModel?.sendStatus()
    }
    
    func removePreviousPieChart(_ chartView: PieChart) {
        for view in chartView.subviews {
            view.removeFromSuperview()
        }
        chartView.removeSlices()
        chartView.models.removeAll()
        chartView.layers.removeAll()
    }
    
    func refreshPieChart(_ not: Notification) {
        removePreviousPieChart(chartView)
        if let userInfo = not.userInfo {
            // Safely unwrap the name sent out by the notification sender
            if let data = userInfo["userModel"] as? UserData {
                chartView.models = updateModels(data)
                setValuesAfterUpdation(data)
                
                //chartView.layers = [createPlainTextLayer()/*, createTextWithLinesLayer()*/]
            }
        }
    }
    
    func setValuesAfterUpdation(_ data: UserData) {
        var arrayTime = [Int]()
        arrayTime.append(data.fbTime)
        arrayTime.append(data.instaTIme)
        arrayTime.append(data.twitTime)
        arrayTime.append(data.tumbTime)
        arrayTime.append(data.vinTime)
        arrayTime.append(data.pinTime)
        arrayTime.append(data.linktime)
        arrayTime.append(data.ytubeTime)
        setValuesInViewPopUp(arrayTime, data.totalTime)
    }
    
    func setValuesInViewPopUp(_ dataArrayToSet: [Int], _ totalTime: Int) {
        print("The data array fetched from the data of api is \n\(dataArrayToSet)")
        for index in 0..<lblSocialNameCollection.count {
            lblSocialNameCollection[index].text = selectedName[index]
            lblSocialValueCollection[index].text = "\(dataArrayToSet[index] / 60) mins \(dataArrayToSet[index] % 60) sec"
        }
        lblTotalTimeSpentValue.text = "\(Int(totalTime / 3600)) hrs \(totalTime / 60) mins \(totalTime % 60) sec"
    }
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        chartView.isUserInteractionEnabled = false
//    }
}

extension MainVC : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        
        let cellCount = CGFloat(imageObservavle.value.count)
        
        if cellCount > 0 {
            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
            let cellWidth = flowLayout.itemSize.width + flowLayout.minimumInteritemSpacing
            let totalCellWidth = cellWidth*cellCount + 5*(cellCount-1)
            let contentWidth = collectionView.frame.size.width - collectionView.contentInset.left - collectionView.contentInset.right
            
            if (totalCellWidth < contentWidth) {
                let padding = (contentWidth - totalCellWidth) / 2.0
                return UIEdgeInsetsMake(0, padding, 0, padding)
            }
        }
        return UIEdgeInsets.zero
    }
    
}

//MARK: PieChart Delegate
extension MainVC: PieChartDelegate {
    func onSelected(slice: PieSlice, selected: Bool) {
        print("Selected: \(selected), slice: \(slice)")
        
        if selected == true {
            self.viewMagnifyPieChart.isHidden = false
            lblValuePercentageCenterPieChart.text = "\(Int(slice.data.percentage * 100))%"
            flagSelected = true
            scrollViewMain.isScrollEnabled = false
            self.lblSoicalNameMagnified.text = self.socialSelected[slice.hashValue].capitalized
            self.lblSocialValueMagnified.text = "\(Int(slice.data.model.value / 60)) mins \(Int(slice.data.model.value.truncatingRemainder(dividingBy: 60)))seconds"
            self.viewMagnifyPieChart.superview?.bringSubview(toFront: self.viewMagnifyPieChart)
            self.viewMagnifyPieChart.backgroundColor = self.colors[slice.hashValue]
        }
        else if selected == false {
            scrollViewMain.isScrollEnabled = true
            viewMagnifyPieChart.isHidden = true
            flagSelected = false
            lblValuePercentageCenterPieChart.text = ""
        }
        
    }
    // MARK: - Models
    
    fileprivate func createModels() -> [PieSliceModel] {
        print("fb toggle value is : ")
        print(userDefaultsKey.facebookTogle.rawValue)
        let models = [
            PieSliceModel(value: 1, color: colors[0]),
            PieSliceModel(value: 0, color: colors[1]),
            PieSliceModel(value: 0, color: colors[2]),
            PieSliceModel(value: 0, color: colors[3]),
            PieSliceModel(value: 0, color: colors[4]),
            PieSliceModel(value: 0, color: colors[5]),
            PieSliceModel(value: 0, color: colors[6]),
            PieSliceModel(value: 0, color: colors[7])
        ]
        
        currentColorIndex = models.count
        return models
    }
    fileprivate func updateModels(_ data: UserData) -> [PieSliceModel] {
        
        let updateModels = [
            PieSliceModel(value: Double(data.fbTime), color: colors[0]),
            PieSliceModel(value: Double(data.instaTIme), color: colors[1]),
            PieSliceModel(value: Double(data.twitTime), color: colors[2]),
            PieSliceModel(value: Double(data.tumbTime), color: colors[3]),
            PieSliceModel(value: Double(data.vinTime), color: colors[4]),
            PieSliceModel(value: Double(data.pinTime), color: colors[5]),
            PieSliceModel(value: Double(data.linktime), color: colors[6]),
            PieSliceModel(value: Double(data.ytubeTime), color: colors[7])
            //fbTime instaTIme twitTime tumbTime vinTime pinTime linktime ytubeTime
        ]
        
        currentColorIndex = updateModels.count
        return updateModels
    }

    
    // MARK: - Layers
    
    fileprivate func createPlainTextLayer() -> PiePlainTextLayer {
        
        let textLayerSettings = PiePlainTextLayerSettings()
        textLayerSettings.viewRadius = 45
        textLayerSettings.hideOnOverflow = true
        textLayerSettings.label.font = UIFont.systemFont(ofSize: 10)
        textLayerSettings.label.textColor = UIColor.white
        
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        textLayerSettings.label.textGenerator = {slice in
            return formatter.string(from: slice.data.percentage * 100 as NSNumber).map{"\($0)%"} ?? ""
        }
        
        let textLayer = PiePlainTextLayer()
        textLayer.settings = textLayerSettings
        return textLayer
    }
    
    fileprivate func createTextWithLinesLayer() -> PieLineTextLayer {
        let lineTextLayer = PieLineTextLayer()
        var lineTextLayerSettings = PieLineTextLayerSettings()
        lineTextLayerSettings.lineColor = UIColor.lightGray
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        lineTextLayerSettings.label.font = UIFont.systemFont(ofSize: 14)
        lineTextLayerSettings.label.textGenerator = {slice in
            return formatter.string(from: slice.data.model.value as NSNumber).map{"\($0)"} ?? ""
        }
        
        lineTextLayer.settings = lineTextLayerSettings
        return lineTextLayer
    }
}
extension CGFloat {
    // used for color generation
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func randomColor() -> UIColor {
        return UIColor(red: .random(), green: .random(), blue: .random(), alpha: 1.0)
    }
}
















