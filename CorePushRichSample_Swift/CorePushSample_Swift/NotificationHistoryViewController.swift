//
//  NotificationHistoryViewController.swift
//  CorePushSample_Swift
//
//  Copyright (c) 2016 株式会社ブレスサービス. All rights reserved.
//

import UIKit

class NotificationHistoryViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    static let CellIdentifier = "Cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "通知履歴";
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: NotificationHistoryViewController.CellIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let historyManager = CorePushNotificationHistoryManager.shared() as! CorePushNotificationHistoryManager
        historyManager.delegate = self
        
        // 通知履歴一覧を取得する
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        historyManager.requestNotificationHistory()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func setUnreadNumber() {
        let historyManager = CorePushNotificationHistoryManager.shared() as! CorePushNotificationHistoryManager
        let unreadNumber = historyManager.getUnreadNumber()
        if unreadNumber > 0 {
            self.navigationController?.tabBarItem.badgeValue = "\(unreadNumber)"
        } else {
            self.navigationController?.tabBarItem.badgeValue = nil;
        }
    }
}

extension NotificationHistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let historyManager = CorePushNotificationHistoryManager.shared() as! CorePushNotificationHistoryManager
        let historyModelArray = historyManager.notificationHistoryModelArray as NSMutableArray
        let historyModel = historyModelArray.object(at: indexPath.row) as! CorePushNotificationHistoryModel
        let historyId = historyModel.historyId
        
        //タップされた場合、該当する通知メッセージを既読に設定する。
        historyManager.setRead(historyId)
        
        //未読数をタブに設定する。
        setUnreadNumber()
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        tableView.reloadData()
    }
}

extension NotificationHistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let historyManager = CorePushNotificationHistoryManager.shared() as! CorePushNotificationHistoryManager
        let historyModelArray = historyManager.notificationHistoryModelArray as NSMutableArray
        return historyModelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: NotificationHistoryViewController.CellIdentifier, for: indexPath)
      
        let historyManager = CorePushNotificationHistoryManager.shared() as! CorePushNotificationHistoryManager
        let historyModelArray = historyManager.notificationHistoryModelArray as NSMutableArray
        let historyModel = historyModelArray.object(at: indexPath.row) as! CorePushNotificationHistoryModel
        
        cell.textLabel?.text = historyModel.message
        
        return cell
    }
}

extension NotificationHistoryViewController: CorePushNotificationHistoryManagerDelegate {
    
    //通知履歴の取得成功
    func notificationHistoryManagerSuccess() {
        setUnreadNumber()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        tableView.reloadData()
    }
    
    //通知履歴の取得失敗
    func notificationHistoryManagerFail() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
