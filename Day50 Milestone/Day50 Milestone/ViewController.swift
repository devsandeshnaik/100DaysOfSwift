//
//  ViewController.swift
//  Day50 Milestone
//
//  Created by Sandesh on 01/01/20.
//  Copyright © 2020 Sandesh. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    private var images: [Image] = [] {
        didSet {
            let encoder = JSONEncoder()
            if let data = try? encoder.encode(images) {
                UserDefaults.standard.set(data, forKey: "images")
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(selectImage))
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if let data = UserDefaults.standard.data(forKey: "images") {
             let decoder = JSONDecoder()
            if let images = try? decoder.decode([Image].self, from: data) {
                self.images = images
                tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CaptionCell") {
            cell.textLabel?.text = images[indexPath.row].caption
            return cell
        }
        
        return UITableViewCell()
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedImage = images[indexPath.row]
        
        if let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailVC")  as? DetailVC {
            detailVC.path = getDocumentsDirectory().appendingPathComponent(selectedImage.name).path
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    @objc private func selectImage() {
        let imagePicker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
        }
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker,animated: true)
    }
    
    private func saveImage(image: UIImage) {
        let imagename = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imagename)
        if let _ = try? image.jpegData(compressionQuality: 0.8)?.write(to: imagePath) {
            //image is stored successfully
            let alert = UIAlertController(title: "Enter Image Caption", message: nil, preferredStyle: .alert)
            alert.addTextField()
            let action = UIAlertAction(title: "OK", style: .default) {[weak self, weak alert] _ in
                
                if let caption = alert?.textFields?[0].text {
                    let image = Image(name: imagename, caption: caption)
                    self?.images.append(image)
                    self?.tableView.reloadData()
                }
            }
            
            
            alert.addAction(action)
            present(alert, animated:  true)
        } else {
            let failureAlert = UIAlertController(title: "Error!!", message: "Selected image could not be stored to disk!", preferredStyle: .alert)
            failureAlert.addAction(UIAlertAction(title: "OK", style: .default){ _ in})
            present(failureAlert, animated: true)
        }
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        if let image =  info[.editedImage] as? UIImage {
            dismiss(animated: true)
            saveImage(image: image)
             
        }
        
    }
}

