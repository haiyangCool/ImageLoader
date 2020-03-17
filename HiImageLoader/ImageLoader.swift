//
//  ImageLoader.swift
//  ImageLoader_Samples
//
//  Created by 王海洋 on 2020/3/13.
//  Copyright © 2020 王海洋. All rights reserved.
//

import Foundation

#if os(iOS)
    import UIKit
    public typealias Image     = UIImage
    public typealias ImageView = UIImageView
    public typealias Button    = UIButton
    
#endif

public final class ImageLoader<Base> {
    
    private let base: Base
    
    public init (_ base: Base) {
        self.base = base
    }
}
