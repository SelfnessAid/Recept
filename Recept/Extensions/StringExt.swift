//
//  StringExt.swift
//  Recept
//
//  Created by Daniel Lervik on 2015-06-30.
//  Copyright (c) 2015 Apoteket AB. All rights reserved.
//

extension String {
    var floatValue: Float {
        return (self as NSString).floatValue
    }
}