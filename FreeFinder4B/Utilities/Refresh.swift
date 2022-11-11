//
//  Refresh.swift
//  FreeFinders3B
//
//  Created by steven arellano on 11/10/22.
//

import Foundation
import UIKit

func refresh() async -> [Item] {
    let user = User(email: "mongodb@gmail.com");
    await user.db_add_user();
    let observer = await AppData(user: user);
    if let mainViewController = await UIApplication.shared.keyWindow?.rootViewController as? HomeViewController {await mainViewController.refresh()}
    return await observer.db_get_all_items()
}


