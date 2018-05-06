//
//  SendMemesTableViewController.swift
//  MemeMe
//
//  Created by Sergio Costa on 01/05/18.
//  Copyright © 2018 Sergio Costa. All rights reserved.
//

import UIKit

class SendMemesTableViewController: UITableViewController {

    var memes = MemeHandler.sharedInstance.memes
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        memes = MemeHandler.sharedInstance.memes
        tableView.reloadData()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }

    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let meme = memes[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "memeCelldentifier", for: indexPath) as! MemeTableViewCell
        
        cell.memeImage.image = meme.memedImage
        cell.topDescription.text = meme.topText
        cell.bottomDescription.text = meme.bottomtext

        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
 
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let meme = memes[indexPath.row]
            MemeHandler.sharedInstance.deleteMeme(meme, indexPath: indexPath.row)
            memes = MemeHandler.sharedInstance.memes
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let meme = memes[indexPath.row]
        performSegue(withIdentifier: "showDetailView", sender: meme)
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailView"{
            let meme = sender as! Meme
            let detailVC = segue.destination as!  MemeDetailViewController
            detailVC.meme = meme
        }
    }
}
