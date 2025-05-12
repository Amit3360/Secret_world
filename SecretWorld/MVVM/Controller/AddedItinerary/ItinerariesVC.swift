//
//  ItinerariesVC.swift
//  SecretWorld
//
//  Created by IDEIO SOFT on 30/01/25.
//

import UIKit
import AlignedCollectionViewFlowLayout
class ItinerariesVC: UIViewController {
  //MARK: - IBOutlet
    @IBOutlet weak var btnAddItinerary: UIButton!
    @IBOutlet weak var btmAddBtn: NSLayoutConstraint!
    @IBOutlet weak var topHeaderVw: NSLayoutConstraint!
    @IBOutlet weak var vwDot: UIView!
    @IBOutlet weak var btnNotification: UIButton!
    @IBOutlet weak var btmTblVw: NSLayoutConstraint!
    @IBOutlet var lblNoData: UILabel!
  @IBOutlet var tblVwList: UITableView!
  @IBOutlet var collVwFilter: UICollectionView!
  //MARK: - variables
  var arrFilters = ["All","Personal","Professional"]
  var selectedIndex: IndexPath?
  var viewModel = ItineraryVM()
  var arrItineries = [ItineraryCountsByDate]()
  var type = 0
  let deviceHasNotch = UIApplication.shared.hasNotch
    
  //MARK: - view life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.uiSet()
  }
  private func uiSet(){
      NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotificationMenu(notification:)), name: Notification.Name("CallMenuApi"), object: nil)

    let nibReiew = UINib(nibName: "ItinerariesTVC", bundle: nil)
    tblVwList.register(nibReiew, forCellReuseIdentifier: "ItinerariesTVC")
    let nib = UINib(nibName: "ItinerariesFilterCVC", bundle: nil)
    collVwFilter.register(nib, forCellWithReuseIdentifier: "ItinerariesFilterCVC")
    selectedIndex = IndexPath(row: 0, section: 0)
    // setLayoutFilters()
      tblVwList.showsVerticalScrollIndicator = false
  
    collVwFilter.reloadData()
    
  }
    @objc func methodOfReceivedNotificationMenu(notification: Notification) {
        if Store.userNotificationCount ?? 0 > 0{
            self.vwDot.isHidden = false
        }else{
            self.vwDot.isHidden = true
        }
    }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
      if Store.userNotificationCount ?? 0 > 0{
          vwDot.isHidden = false
      }else{
          vwDot.isHidden = true
      }
      DispatchQueue.main.async {
          self.getItieriesApi(type: self.type)
      
      }
    
  }
 
  
    private func getItieriesApi(type:Int){
        lblNoData.isHidden = true
        arrItineries.removeAll()
        viewModel.GetItineraryApi(type: type,date: "") { data in
        
        self.arrItineries = data?.itineraryCountsByDate ?? []
      if self.arrItineries.count > 0{
        self.lblNoData.isHidden = true
      }else{
        self.lblNoData.isHidden = false
      }
      self.tblVwList.reloadData()
    }
  }
  private func setLayoutFilters(){
    let alignedFlowLayoutCollVw = AlignedCollectionViewFlowLayout(horizontalAlignment: .left, verticalAlignment: .top)
    collVwFilter.collectionViewLayout = alignedFlowLayoutCollVw
    if let flowLayout = collVwFilter.collectionViewLayout as? UICollectionViewFlowLayout {
      flowLayout.estimatedItemSize = CGSize(width: 0, height: 44)
      flowLayout.itemSize = UICollectionViewFlowLayout.automaticSize
    }
  }
  @IBAction func actionAdd(_ sender: UIButton) {
    guard let index = selectedIndex?.row else { return }
    let vc = storyboard?.instantiateViewController(withIdentifier: "AddItineryVC") as! AddItineryVC
    vc.isPersonal = (index == 1)
   
    navigationController?.pushViewController(vc, animated: true)
  }
  @IBAction func actionBack(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
    
    @IBAction func actionNotification(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NotificationsVC") as! NotificationsVC
        vc.callBack = {
            NotificationCenter.default.post(name: Notification.Name("CallMenuApi"), object: nil)
            NotificationCenter.default.post(name: Notification.Name("callHomeSocket"), object: nil)
            DispatchQueue.main.asyncAfter(deadline: .now()+1){
                if Store.userNotificationCount ?? 0 > 0{
                    self.vwDot.isHidden = false
                }else{
                    self.vwDot.isHidden = true
                }
                print("userNotificationCount:-",Store.userNotificationCount)
            }
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
//MARK: - UICollectionViewDelegate
extension ItinerariesVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return arrFilters.count
  }
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItinerariesFilterCVC", for: indexPath) as! ItinerariesFilterCVC
    cell.lblTitle.text = arrFilters[indexPath.row]
    if selectedIndex == indexPath {
      cell.viewBAck.backgroundColor = UIColor(hex: "#E7F3E6")
      cell.lblTitle.textColor = .app
    }else{
      cell.viewBAck.backgroundColor = .white
      cell.lblTitle.textColor = .black
    }
    return cell
  }
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    selectedIndex = indexPath
    if indexPath.row == 0{
      NotificationCenter.default.post(name: Notification.Name("all"), object: nil)
        self.type = 0
        self.btnAddItinerary.isHidden = true
        self.arrItineries.removeAll()
        self.tblVwList.reloadData()
        getItieriesApi(type: 0)
    }else if indexPath.row == 1{
      NotificationCenter.default.post(name: Notification.Name("personal"), object: nil)
        self.type = 2
        self.btnAddItinerary.isHidden = false
        self.arrItineries.removeAll()
        self.tblVwList.reloadData()
        getItieriesApi(type: 2)
    }else{
      NotificationCenter.default.post(name: Notification.Name("professional"), object: nil)
        self.type = 1
        self.arrItineries.removeAll()
        self.tblVwList.reloadData()
        self.btnAddItinerary.isHidden = false
        getItieriesApi(type: 1)
    }
    collVwFilter.reloadData()
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.frame.size.width / 3 - 5, height: 44)
  }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}
//MARK: -UITableViewDelegate
extension ItinerariesVC: UITableViewDelegate,UITableViewDataSource{
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if arrItineries.count > 0{
      return arrItineries.count
    }else{
      return 0
    }
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      guard indexPath.row < arrItineries.count else {
          return UITableViewCell() // Failsafe return
      }

    let cell = tableView.dequeueReusableCell(withIdentifier: "ItinerariesTVC", for: indexPath) as! ItinerariesTVC
   
      let reminderTime = arrItineries[indexPath.row].date ?? ""
      if let formattedDate = convertToDateFormat(reminderTime) {
          cell.lblTimig.text = formattedDate
      } else {
          print("Invalid date format")
      }
      cell.btnDelete.addTarget(self, action: #selector(deleteItinerary), for: .touchUpInside)
      cell.btnDelete.tag = indexPath.row
      cell.lblItemsCount.text = "\(arrItineries[indexPath.row].count ?? 0) item"
      cell.viewDeletBtn.applyShadow()
    return cell
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 70
  }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddedItineraryVC") as! AddedItineraryVC
        vc.date = arrItineries[indexPath.row].date ?? ""
        vc.type = self.type
        vc.callBack = {
            self.getItieriesApi(type: self.type)
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func deleteItinerary(sender:UIButton){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CancelGigVC") as! CancelGigVC
        vc.modalPresentationStyle = .overFullScreen
        vc.isSelect = 5
        vc.callBack = { (message) in
            showSwiftyAlert("", message ?? "", true)
            self.getItieriesApi(type: self.type)
        }
        vc.date = arrItineries[sender.tag].date ?? ""
        self.navigationController?.present(vc, animated: false)
    }
    func convertToDateFormat(_ dateString: String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        inputFormatter.timeZone = TimeZone(abbreviation: "UTC")

        if let date = inputFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "MMM dd, yyyy"
            outputFormatter.timeZone = TimeZone.current // Adjust as needed

            return outputFormatter.string(from: date)
        }
        return nil // Return nil if parsing fails
    }
    
}
