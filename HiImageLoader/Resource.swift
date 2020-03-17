//
//  Resource.swift
//  ImageLoader_Samples
//
//  Created by 王海洋 on 2020/3/17.
//  Copyright © 2020 王海洋. All rights reserved.
//

import Foundation

/// 图片资源
protocol Resource {
     
    /// 图片地址
    var downloadUrl: URL { get }
    /// 图片缓存 Key ，这里使用 url 的 绝对地址 absoluteString 
    var cacheKey: String { get }
    
}

extension URL : Resource {
    
    var downloadUrl: URL {
        return self
    }
    
    var cacheKey: String {
        return absoluteString
    }
}

