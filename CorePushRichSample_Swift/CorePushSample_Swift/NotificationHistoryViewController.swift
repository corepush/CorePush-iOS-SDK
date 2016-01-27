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
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: NotificationHistoryViewController.CellIdentifier)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let historyManager = CorePushNotificationHistoryManager.shared() as! CorePushNotificationHistoryManager
        historyManager.delegate = self
        
        // 通知履歴一覧を取得する
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        historyManager.requestNotificationHistory()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func setUnreadNumber() {
        let unreadNumber = CorePushNotificationHistoryManager.shared().getUnreadNumber()
        if unreadNumber > 0 {
            self.navigationController?.tabBarItem.badgeValue = "\(unreadNumber)"
        } else {
            self.navigationController?.tabBarItem.badgeValue = nil;
        }
    }
}

extension NotificationHistoryViewController: UITableViewDelegate {
    
}

extension NotificationHistoryViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let historyManager = CorePushNotificationHistoryManager.shared()
        let historyModelArray = historyManager.notificationHistoryModelArray as NSMutableArray
        return historyModelArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier(NotificationHistoryViewController.CellIdentifier, forIndexPath: indexPath)
      
        let historyManager = CorePushNotificationHistoryManager.shared()
        let historyModelArray = historyManager.notificationHistoryModelArray as NSMutableArray
        let historyModel = historyModelArray.objectAtIndex(indexPath.row)
        
        cell.textLabel?.text = historyModel.message
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let historyManager = CorePushNotificationHistoryManager.shared()
        let historyModelArray = historyManager.notificationHistoryModelArray as NSMutableArray
        let historyModel = historyModelArray.objectAtIndex(indexPath.row)
        let historyId = historyModel.historyId
   
        //タップされた場合、該当する通知メッセージを既読に設定する。
        historyManager.setRead(historyId)
        
        //未読数をタブに設定する。
        setUnreadNumber()
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        tableView.reloadData()
    }
}

extension NotificationHistoryViewController: CorePushNotificationHistoryManagerDelegate {
    
    //通知履歴の取得成功
    func notificationHistoryManagerSuccess() {
        setUnreadNumber()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        tableView.reloadData()
    }
    
    //通知履歴の取得失敗
    func notificationHistoryManagerFail() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
}