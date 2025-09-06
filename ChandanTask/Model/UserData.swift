//
//  UserData.swift
//  ChandanTask
//
//  Created by Chandan Sharda on 03/09/25.
//

// MARK: - UserData
struct UserData: Codable {
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let userHolding: [UserHolding]
}
