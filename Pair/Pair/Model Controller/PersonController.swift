//
//  PersonController.swift
//  Pair
//
//  Created by Mitch Merrell on 9/6/19.
//  Copyright © 2019 Mitch Merrell. All rights reserved.
//

import Foundation

class PersonController {
    
    static var shared = PersonController()
    
    var persons: [Person] = []
    var groups: [[Person]] {
        var groupArray: [[Person]] = []
        for person in persons {
            if groupArray.count > 0 {
                if groupArray[groupArray.count - 1].count == 2 {
                    groupArray.append([])
                    groupArray[groupArray.count - 1].append(person)
                } else {
                    groupArray[groupArray.count - 1].append(person)
                }
            } else {
                groupArray.append([])
                groupArray[groupArray.count - 1].append(person)
            }
        }
        return groupArray
    }
    
    // create
    
    func createPerson(name: String) {
        let newPerson = Person(name: name)
        persons.append(newPerson)
        saveToPersistentStore()
    }
    
    // delete
    
    func deleteGroup(group: [Person]) {
        if group.count == 2 {
            let firstPerson = group[0]
            let secondPerson = group[1]
            guard let index1 = persons.firstIndex(of: firstPerson) else { return }
            persons.remove(at: index1)
            guard let index2 = persons.firstIndex(of: secondPerson) else { return }
            persons.remove(at: index2)
        } else {
            let firstPerson = group[0]
            guard let index = persons.firstIndex(of: firstPerson) else { return }
            persons.remove(at: index)
        }
        saveToPersistentStore()
    }
    
    // persistence
    
    private func fileUrl() -> URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectoryURL = urls[0].appendingPathComponent("Pair.json")
        return documentsDirectoryURL
    }
    
    func saveToPersistentStore() {
        let jsonEncoder = JSONEncoder()
        do {
            let jsonPersons = try jsonEncoder.encode(persons)
            try jsonPersons.write(to: fileUrl())
        } catch let encodingError {
            print("There was an error saving!! \(encodingError.localizedDescription)")
        }
    }
    
    func loadFromPersistentStore() {
        let jsonDecoder = JSONDecoder()
        do {
            let jsonData = try Data(contentsOf: fileUrl())
            let decodedPersons = try jsonDecoder.decode([Person].self, from: jsonData)
            persons = decodedPersons
        } catch let decodingError {
            print("There was an error decoding!! \(decodingError.localizedDescription)")
        }
    }
}
