//
//  NewsTableViewController.swift
//  ios-whatnews-demo
//
//  Created by lorilalonde on 2017-11-16.
//  Copyright © 2017 Lori Lalonde. All rights reserved.
//


import UIKit
import Foundation
import SwiftyJSON
import Alamofire

class NewsTableViewController: UITableViewController {

    // MARK: Variables and Constant declarations
    let BING_NEWS_SEARCH_URL = "https://api.cognitive.microsoft.com/bing/v7.0/news?category="
    let BING_SEARCH_KEY = "YOUR BING SEARCH API KEY HERE"
    
    let TEXT_ANALYTICS_URL = "https://eastus.api.cognitive.microsoft.com/text/analytics/v2.0/sentiment"
    let TEXT_ANALYTICS_KEY = "YOUR TEXT ANALYTICS KEY HERE"
    
    var allNewsItems = [NewsItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        let fullUrl = BING_NEWS_SEARCH_URL + "entertainment"
        getCurrentNews(url: fullUrl, key: BING_SEARCH_KEY)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Bing Search Load methods
    
    func getCurrentNews(url : String, key : String) {
        let headers: HTTPHeaders = ["Ocp-Apim-Subscription-Key" : key]
        
        Alamofire.request(url, method: .get, headers: headers).responseJSON {
            response in
            
            print(response.result.value)
            if (response.result.isSuccess) {
                print("Success! Got the news results")
                
                let newsJSON = JSON(response.result.value!)
                print(newsJSON)
                
                self.updateNewsItemsArray(json: newsJSON)
            }
            else {
                print("Error \(response.result.error)")
            }
        }
    }
    
    func updateNewsItemsArray(json : JSON){
        
        if let resultItems = json["value"].array
        {
            print(resultItems)
            for item in resultItems
            {
                print(item)
                let newsItem: NewsItem = NewsItem()
                newsItem.headline = item["name"].stringValue
                newsItem.description = item["description"].stringValue
                newsItem.imageURL = item["image"]["thumbnail"]["contentUrl"].stringValue
                
                allNewsItems.append(newsItem)
            }
            self.tableView.reloadData()
        }
    }
    
    // MARK: Text analytics methods
    
    func getNewsItemSentiment(itemIndex : Int, headline : String, url : String, key : String) {
        let headers: HTTPHeaders = ["Ocp-Apim-Subscription-Key" : key]
        
        let params = [
            "documents": [["language":"en-US","id":"1","text":headline]]
        ]
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            print(response.request)
            print(response.result.value)
            
            if (response.result.isSuccess) {
                let sentimentJSON = JSON(response.result.value!)
                let sentimentValue = sentimentJSON["documents"][0]["score"].double!
                self.allNewsItems[itemIndex].updateNewsItemImage(sentimentValue: sentimentValue)
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return allNewsItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "NewsItemTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? NewsItemTableViewCell else
        {
            fatalError("The dequeued cell is not an instance of NewsItemTableViewCell")
        }

        // Configure the cell...
        let newsItem = allNewsItems[indexPath.row]
        cell.headlineLabel.text = newsItem.headline
        
        if newsItem.sentimentImage != "" {
            cell.imageView?.image = UIImage(named: newsItem.sentimentImage)
            cell.descriptionLabel.text = String(newsItem.textAnalytics)
            
        }
        else {
            let url = URL(string: newsItem.imageURL)
            let data = try? Data(contentsOf: url!)
            cell.imageView?.image = UIImage(data: data!)
            cell.descriptionLabel.text = ""
            
        }
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        getNewsItemSentiment(itemIndex: indexPath.row, headline: allNewsItems[indexPath.row].headline, url: TEXT_ANALYTICS_URL, key: TEXT_ANALYTICS_KEY)
    }

    

}
