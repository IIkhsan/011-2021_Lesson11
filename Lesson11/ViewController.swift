//
//  ViewController.swift
//  Lesson11
//
//  Created by ilyas.ikhsanov on 16.11.2021.
//

import UIKit

final class ViewController: UIViewController {
    
    @IBOutlet weak var tableVIew: UITableView!
    
    let networkService: PostNetworkService = PostNetworkService()
    
    var posts: [Post] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableVIew.dataSource = self
        
        getPosts()
        
    }
    
    private func getPosts() {
        networkService.getPosts { result in
            switch result {
            case .success(let posts):
                self.posts = posts
                DispatchQueue.main.async {
                    self.tableVIew.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else { return UITableViewCell() }
        cell.textLabel?.text = posts[indexPath.row].title
        cell.detailTextLabel?.text = posts[indexPath.row].body
        return cell
    }
}
