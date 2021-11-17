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
        // запуск кода в глобальной параллельной очереди 
        DispatchQueue.global(qos: .userInitiated).async {
            self.networkService.getPosts { result in
                print("Get posts closure result", Thread.isMainThread)
                switch result {
                case .success(let posts):
                    self.posts = posts
                    // Желательно обеспечить возврат данны на main очереди
                    // хотя такие библиотеки как Alamofire сами возвращают данные в main очереди уже,
                    // что с одной стороны хорошо, но с другой не дает гибкости в управлении выполнения кода не на main очереди
                    DispatchQueue.main.async {
                        self.tableVIew.reloadData()
                    }
                case .failure(let error):
                    print(error)
                }
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
