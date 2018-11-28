//
//  ViewController.swift
//  PullToRefresh
//
//  Created by [Andy Ron](https://github.com/andyRon)  on 2018/11/14.
//  Copyright © 2018 [Andy Ron](https://github.com/andyRon) . All rights reserved.
//

import UIKit

func delay(seconds: Double, completion: @escaping ()-> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: completion)
}

let kRefreshViewHeight: CGFloat = 110.0
let packItems = ["Ice cream money", "Great weather", "Beach ball", "Swimsuit for him", "Swimsuit for her", "Beach games", "Ironing board", "Cocktail mood", "Sunglasses", "Flip flops", "Spare flip flops"]

class ViewController: UITableViewController {

    var refreshView: RefreshView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Vacation pack list"
        self.view.backgroundColor = UIColor(red: 0.0, green: 154.0/255.0, blue: 222.0/255.0, alpha: 1.0)
        self.tableView.rowHeight = 64.0
        
        let refreshRect = CGRect(x: 0.0, y: -kRefreshViewHeight, width: view.frame.size.width, height: kRefreshViewHeight)
        refreshView = RefreshView(frame: refreshRect, scrollView: self.tableView)
        refreshView.delegate = self
        view.addSubview(refreshView)
    }
    
    // MARK: Scroll View
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        refreshView.scrollViewDidScroll(scrollView)
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        refreshView.scrollViewWillEndDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
    
    // MARK: Table View
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 11
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        cell.accessoryType = .none
        cell.textLabel!.text = packItems[indexPath.row]
        cell.imageView!.image = UIImage(named: "summericons_100px_\(indexPath.row).png")
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

extension ViewController: RefreshViewDelegate {
    
    func refreshViewDidRefresh(_ refreshView: RefreshView) {
        delay(seconds: 4) {
            refreshView.endRefreshing()
        }
    }
}

