//
//  CoreDataManager.swift
//  MyPhoneBook
//
//  Created by Soo Jang on 7/11/24.
//
import CoreData
import UIKit
import RxSwift

class CoreDataManager {
    var container: NSPersistentContainer!
    
    init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        container = appDelegate.persistentContainer
    }
    
    func createData(name: String, number: String, profileImg: String) {
        guard let entity = NSEntityDescription.entity(forEntityName: CoreDataInfo.entityName, in: self.container.viewContext) else { return }
        let newPhoneBook = NSManagedObject(entity: entity, insertInto: self.container.viewContext)
        newPhoneBook.setValue(name, forKey: CoreDataInfo.name)
        newPhoneBook.setValue(number, forKey: CoreDataInfo.number)
        newPhoneBook.setValue(profileImg, forKey: CoreDataInfo.profileImg)
        do {
            try self.container.viewContext.save()
            print("문맥 저장 성공")
        } catch {
            print("문맥 저장 실패")
        }
    }
    
    func readAllData() -> Observable<[PhoneBook]> {
        return Observable.create() { observable in
            do {
                let request = PhoneBook.fetchRequest()
                request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
                let phoneBooks = try self.container.viewContext.fetch(request)
                observable.onNext(phoneBooks)
            } catch {
                print("데이터 읽기 실패")
            }
            return Disposables.create()
        }
        
    }
    
    func updateData(currentName: String, completionHandler: (([PhoneBook]) -> Void)) {
        let fetchRequest = PhoneBook.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", currentName) // 예시: 이름이 "Adam"인 데이터 수정
        
        do {
            let result = try container.viewContext.fetch(fetchRequest)
            completionHandler(result)
            try container.viewContext.save()
        } catch {
            print("데이터 수정 실패")
        }
    }
    
}
