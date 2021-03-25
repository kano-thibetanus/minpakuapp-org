//
//  SearchViewModel.swift
//  MinpakuMock
//
//  Created by hiratti on 2019/03/26.
//  Copyright © 2019 hiratti. All rights reserved.
//

import UIKit

class SearchViewModel: NSObject {
    func searchQuerys(viewController: SearchViewController) -> [NSPredicate] {
        // ・同一フィールド内でのスペース区切りは、OR
        // ・複数フィールド間は、AND
        
        var predicates: [NSPredicate] = []
        print(predicates.count)
        if let predicate = self.freeWordPredicates(text: viewController.freeWordTextField.text) {
            predicates.append(predicate)
        }
        
        if let predicate = self.titlePredicates(text: viewController.titleTextField.text) {
            predicates.append(predicate)
        }
        
        if let predicate = self.placePredicates(text: viewController.placeTextField.text) {
            predicates.append(predicate)
        }
        
        if let predicate = self.peoplePredicates(text: viewController.peapleTextField.text) {
            predicates.append(predicate)
        }
        
        if let predicate = self.owcPredicates(text: viewController.owcTextField.text) {
            predicates.append(predicate)
        }
        
        if let predicate = self.ocmPredicates(text: viewController.ocmTextField.text) {
            predicates.append(predicate)
        }
        
        print(predicates.count)
        return predicates
    }
    
    func searchKeys(viewController: SearchViewController) -> [String] {
        var searchKeys: [String] = []
        if let text = viewController.freeWordTextField.text, !text.isEmpty {
            searchKeys.append(Mokuroku.SearchKey.keyWord.rawValue)
        }
        
        if let text = viewController.titleTextField.text, !text.isEmpty {
            searchKeys.append(Mokuroku.SearchKey.title.rawValue)
        }
        
        if let text = viewController.placeTextField.text, !text.isEmpty {
            searchKeys.append(Mokuroku.SearchKey.place.rawValue)
        }
        
        if let text = viewController.peapleTextField.text, !text.isEmpty {
            searchKeys.append(Mokuroku.SearchKey.people.rawValue)
        }
        
        if let text = viewController.owcTextField.text, !text.isEmpty {
            searchKeys.append(Mokuroku.SearchKey.owc.rawValue)
        }
        
        if let text = viewController.ocmTextField.text, !text.isEmpty {
            searchKeys.append(Mokuroku.SearchKey.ocm.rawValue)
        }
        
        return searchKeys
    }
    
    func searchWords(viewController: SearchViewController) -> [String] {
        var searchWords: [String] = []
        if let text = viewController.freeWordTextField.text, !text.isEmpty {
            searchWords.append(text)
        }
        
        if let text = viewController.titleTextField.text, !text.isEmpty {
            searchWords.append(text)
        }
        
        if let text = viewController.placeTextField.text, !text.isEmpty {
            searchWords.append(text)
        }
        
        if let text = viewController.peapleTextField.text, !text.isEmpty {
            searchWords.append(text)
        }
        
        if let text = viewController.owcTextField.text, !text.isEmpty {
            searchWords.append(text)
        }
        
        if let text = viewController.ocmTextField.text, !text.isEmpty {
            searchWords.append(text)
        }
        
        return searchWords
    }
    
    func freeWordPredicates(text: String?) -> NSPredicate? {
        var query = ""
        if let safeText = text {
            if !safeText.isEmpty {
                for word in splitSearchWord(str: safeText) {
                    // キーワード：
                    // cat_title, place, nation, social_group, owcの日本語訳、ocmの日本語訳、
                    // imf_description, ful_product_description, ful_use_description, ful_miscel_description,
                    // imf_title, hash_tags, 大カテゴリの日本語名, section
                    query.append(String(format: "catTitle CONTAINS \"%@\" OR ", word))
                    query.append(String(format: "place CONTAINS \"%@\" OR ", word))
                    query.append(String(format: "nation CONTAINS \"%@\" OR ", word))
                    query.append(String(format: "socialGroup CONTAINS \"%@\" OR ", word))
                    if let safeWord = OWC.owcCode(owcString: word) {
                        query.append(String(format: "SUBQUERY(owc, $s, $s.str BEGINSWITH \"%@\").@count > 0 OR ", safeWord))
                    }
                    if let safeWord = OCM.ocmCode(ocmString: word) {
                        query.append(String(format: "SUBQUERY(ocm, $s, $s.str BEGINSWITH \"%@\").@count > 0 OR ", safeWord))
                    }
                    query.append(String(format: "imfDescription CONTAINS \"%@\" OR ", word))
                    query.append(String(format: "fulProductDescription CONTAINS \"%@\" OR ", word))
                    query.append(String(format: "fulUseDescription CONTAINS \"%@\" OR ", word))
                    query.append(String(format: "fulMiscelDescription CONTAINS \"%@\" OR ", word))
                    query.append(String(format: "imfTitle CONTAINS \"%@\" OR ", word))
                    query.append(String(format: "hashTagString CONTAINS \"%@\" OR ", word))
                    query.append(String(format: "categoryBigName CONTAINS \"%@\" OR ", word))
                    query.append(String(format: "section CONTAINS \"%@\" OR ", word))
                    
                    // 4/24追加 objectID
                    query.append(String(format: "objectID == \"%@\" OR ", word))
                }
                // 末尾を削除
                query = String(query.prefix(query.count - 4))
            }
        }
        
        if query.isEmpty {
            return nil
        }
        print(query)
        return NSPredicate(format: query)
    }
    
    func titlePredicates(text: String?) -> NSPredicate? {
        var query = ""
        if let safeText = text {
            if !safeText.isEmpty {
                for word in splitSearchWord(str: safeText) {
                    // タイトル：cat_title
                    query.append(String(format: "catTitle CONTAINS \"%@\" OR ", word))
                }
                // 末尾を削除
                query = String(query.prefix(query.count - 4))
            }
        }
        
        if query.isEmpty {
            return nil
        }
        print(query)
        return NSPredicate(format: query)
    }
    
    func placePredicates(text: String?) -> NSPredicate? {
        var query = ""
        if let safeText = text {
            if !safeText.isEmpty {
                for word in splitSearchWord(str: safeText) {
                    // 地域：place, nation, owcの日本語訳
                    query.append(String(format: "place CONTAINS \"%@\" OR ", word))
                    query.append(String(format: "nation CONTAINS \"%@\" OR ", word))
                    if let safeWord = OWC.owcCode(owcString: word) {
                        query.append(String(format: "owcString CONTAINS \"%@\" OR ", safeWord))
                    }
                }
                // 末尾を削除
                query = String(query.prefix(query.count - 4))
            }
        }
        
        if query.isEmpty {
            return nil
        }
        print(query)
        return NSPredicate(format: query)
    }
    
    func peoplePredicates(text: String?) -> NSPredicate? {
        var query = ""
        if let safeText = text {
            if !safeText.isEmpty {
                for word in splitSearchWord(str: safeText) {
                    // 民族：social_group, owcの日本語訳
                    query.append(String(format: "socialGroup CONTAINS \"%@\" OR ", word))
                    if let safeWord = OWC.owcCode(owcString: word) {
                        query.append(String(format: "SUBQUERY(owc, $s, $s.str BEGINSWITH %@).@count > 0 OR ", safeWord))
                    }
                }
                // 末尾を削除
                query = String(query.prefix(query.count - 4))
            }
        }
        
        if query.isEmpty {
            return nil
        }
        print(query)
        return NSPredicate(format: query)
    }
    
    func owcPredicates(text: String?) -> NSPredicate? {
        var query = ""
        if let safeText = text {
            if !safeText.isEmpty {
                for word in splitSearchWord(str: safeText) {
                    // owcコード
                    query.append(String(format: "SUBQUERY(owc, $s, $s.str BEGINSWITH \"%@\").@count > 0 OR ", word))
                    // owc日本語
                    if let safeWord = OWC.owcCode(owcString: word) {
                        query.append(String(format: "SUBQUERY(owc, $s, $s.str BEGINSWITH \"%@\").@count > 0 OR ", safeWord))
                    }
                }
                // 末尾を削除
                query = String(query.prefix(query.count - 4))
            }
        }
        
        if query.isEmpty {
            return nil
        }
        print(query)
        return NSPredicate(format: query)
    }
    
    func ocmPredicates(text: String?) -> NSPredicate? {
        var query = ""
        if let safeText = text {
            if !safeText.isEmpty {
                for word in splitSearchWord(str: safeText) {
                    // ocmコード
                    query.append(String(format: "SUBQUERY(ocm, $s, $s.str BEGINSWITH \"%@\").@count > 0 OR ", word))
                    // ocm日本語
                    if let safeWord = OCM.ocmCode(ocmString: word) {
                        query.append(String(format: "SUBQUERY(ocm, $s, $s.str BEGINSWITH \"%@\").@count > 0 OR ", safeWord))
                    }
                }
                // 末尾を削除
                query = String(query.prefix(query.count - 4))
            }
        }
        
        if query.isEmpty {
            return nil
        }
        print(query)
        return NSPredicate(format: query)
    }
    
    func splitSearchWord(str: String) -> [String] {
        var words: [String] = []
        // realmEscapedで全角を半角に直したりとかしている
        for splitWord in str.realmEscaped.split(separator: " ") {
            words.append(String(splitWord))
        }
        return words
    }
}
