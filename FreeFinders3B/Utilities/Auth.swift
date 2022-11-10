//
//  Auth.swift
//  FreeFinders3B
//
//  Created by steven arellano on 11/10/22.
//

import Foundation

func sign_in(email: String) async -> User?{
    if email.hasSuffix("@uchicago.edu"){
        return await User(email: email)
    }
    return nil;
}
