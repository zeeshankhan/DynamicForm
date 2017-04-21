//
//  CountryListVC.swift
//  ZKSignup
//
//  Created by Zeeshan Khan on 2/19/17.
//  Copyright © 2017 Zeeshan Khan. All rights reserved.
//

import UIKit

class CountryListVC: UIViewController {

    var countryList: [[String: String]] = []
    var filteredList: [[String: String]] = []

    var sectionsTitles: [String] = []
    var sections: [String: [[String: String]]] = [:]

    var didSelectCountry: ((_ code: Dictionary<String, String>) -> Void)?

    @IBOutlet weak var countryListTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Select a Country"
        countryListTableView.sectionIndexBackgroundColor = UIColor.clear

        if let fileUrl = Bundle.main.url(forResource: "CountryList", withExtension: "plist"),
            let data = try? Data(contentsOf: fileUrl) {
            if let result = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [[String : String]] {

                let sorted = (result?.sorted { item1, item2 in
                    let name1 = item1["name"]
                    let name2 = item2["name"]
                    return name1! < name2!
                    })!

                countryList = sorted

                var dict: [String : [[String : String]]] = [:]
                for country in sorted {
                    let key = String(describing: country["name"]!.characters.first!)
                    var arrKV = dict[key]
                    if arrKV == nil {
                        arrKV = []
                    }
                    arrKV?.append(country)
                    dict[key] = arrKV
                }

                sections = dict
                sectionsTitles = dict.keys.sorted().flatMap { $0 }
            }
        }
    }
}

extension CountryListVC : UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return filteredList.count > 0 ? 1 : sectionsTitles.count
    }

    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return filteredList.count > 0 ? nil : sectionsTitles as [String]
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return filteredList.count > 0 ? "Countries" : sectionsTitles[section]
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredList.count > 0 {
            return filteredList.count
        }
        let rows = sections[sectionsTitles[section]]
        return (rows?.count)!
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryListCell", for: indexPath) as! CountryListCell
        var country: [String: String] = [:]

        if filteredList.count > 0 {
            country = filteredList[indexPath.row]
        } else {
            let rows = sections[sectionsTitles[indexPath.section]]
            country = (rows?[indexPath.row])!
        }

        cell.icon.image = UIImage(named: (country[kCountryFlag]!))
        cell.icon.layer.cornerRadius = 1.5
        cell.icon.layer.masksToBounds = true
        cell.name.text = (country[kCountryFlag]!) + "-" + (country["name"]!)
        cell.code.text = "+" + (country[kPhoneCode]!)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if didSelectCountry != nil {

            var country: [String: String] = [:]
            if filteredList.count > 0 {
                country = filteredList[indexPath.row]
            } else {
                let rows = sections[sectionsTitles[indexPath.section]]
                country = (rows?[indexPath.row])!
            }
            didSelectCountry!(country)
            _ = navigationController?.popViewController(animated: true)
        }
    }
}

extension CountryListVC : UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        let text = searchText.trimmingCharacters(in: CharacterSet.whitespaces)
        if text.characters.count == 0 {
            filteredList = []
        } else {
            filteredList = countryList.filter { ($0["name"]?.contains(text))! }
        }
        countryListTableView.reloadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

}

class CountryListCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var code: UILabel!
}
