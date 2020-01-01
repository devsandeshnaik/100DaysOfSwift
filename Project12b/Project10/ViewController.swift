//
//  ViewController.swift
//  Project10
//
//  Created by Sandesh on 24/12/19.
//  Copyright © 2019 Sandesh. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    var people = [Person]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
        
        let defaults = UserDefaults.standard
        if let savedPeople = defaults.object(forKey: "people") as? Data {
            let decoder = JSONDecoder()
            do {
                people = try decoder.decode([Person].self, from: savedPeople)
            } catch {
                print("Failed to load user ")
            }
        }
    }
    
    @objc func addNewPerson() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        }
        present(picker, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath ) as? PersonCell else {
            fatalError("Unable to deque PersonCell")
        }
        
        let person = people[indexPath.item]
        cell.name.text = person.name
        let path = getDocumentDiretory().appendingPathComponent(person.image)
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        
        return cell
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentDiretory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath )
        }
        
        let person = Person(name: "Unknown", image: imageName)
        people.append(person)
        save()
        collectionView.reloadData()
        dismiss(animated: true)
    }
    
    func getDocumentDiretory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = people[indexPath.item]
        
        let actionOptionAlert = UIAlertController(title: "What you wanna do?", message: nil, preferredStyle: .alert)
        
        actionOptionAlert.addAction(UIAlertAction(title: "Delete", style: .destructive) {
            [weak self] _ in
            self?.people.remove(at: indexPath.item)
            self?.save()
            self?.collectionView.reloadData()
        })
        
        actionOptionAlert.addAction(UIAlertAction(title: "Rename", style: .default) {
            [weak self] _ in
            
            let ac = UIAlertController(title: "Rename Persom", message: nil, preferredStyle: .alert)
            ac.addTextField()
            ac.addAction(UIAlertAction(title: "OK", style: .default) {[weak self, weak ac] _ in
                guard let newName = ac?.textFields?[0].text else { return }
                person.name = newName
                self?.collectionView.reloadData()
            })
            
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
            self?.present(ac, animated: true)
            
        } )
        
        present(actionOptionAlert, animated: true)
    }
    
    
    
    func save() {
        let jsonEncode = JSONEncoder()
        
        if let savedData = try? jsonEncode.encode(people) {
            let defaults = UserDefaults.standard
            defaults.setValue(savedData, forKey: "people")
        } else {
            print("Failed to save people ")
        }
    }
}

