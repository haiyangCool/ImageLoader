//
//  Indicator.swift
//  ImageLoader_Samples
//
//  Created by 王海洋 on 2020/3/17.
//  Copyright © 2020 王海洋. All rights reserved.
//

import Foundation
#if os(iOS)
import UIKit
public typealias IndicatorView = UIView

#endif

/// 加载图片的指示器协议
public protocol Indicator {
    
    /// indicatorView 的中心
    var indicatorViewCenter: CGPoint { get }
    /// indicatorView
    var indicatorView: IndicatorView { get }
    /// 是否正在执行动画
    var isAnimating: Bool { get }
    
    
    func startAnimating()
    func stopAnimating()
}

extension Indicator {
    
    public var indicatorViewCenter: CGPoint {
        
        get {
            return indicatorView.center
        }
        
        set {
            indicatorView.center = newValue
        }
    }
    
}

/// 指示器类型
public enum IndicatorType {
    
    /// 不添加指示器
    case none
    /// 使用系统的指示器： 在iOS上为 动态菊花(UIActivityIndicatorView)
    case systemActivityIndicator
    /// 图片
    case image(data: Data)
    /// 自定义指示器(实现Indicator协议)
    case custom(indicator: Indicator)
    
}

/// 系统加载指示器
class SystemActivityIndicator: Indicator {
    
    private let activityIndicatorView: UIActivityIndicatorView
    
    var indicatorView: IndicatorView {
        return activityIndicatorView
    }
    
    var isAnimating: Bool {
        return activityIndicatorView.isAnimating
    }
    
    func startAnimating() {
        activityIndicatorView.startAnimating()
    }
    
    func stopAnimating() {
        activityIndicatorView.stopAnimating()
    }
    
    init() {
        
        var indicatorType: UIActivityIndicatorView.Style
        if #available(iOS 13, *) {
            indicatorType = .medium
        }else {
            indicatorType = .gray
        }
        activityIndicatorView = UIActivityIndicatorView(style: indicatorType)
        activityIndicatorView.autoresizingMask = [.flexibleLeftMargin,
                                                  .flexibleRightMargin,
                                                  .flexibleTopMargin,
                                                  .flexibleBottomMargin]
        activityIndicatorView.hidesWhenStopped = true
    
    }
    
}

class ImageIndicator: Indicator {
    
    private let imageIndicatorView: ImageView
    
    var indicatorView: IndicatorView {
        return imageIndicatorView
    }
    
    var isAnimating: Bool {
        return imageIndicatorView.isAnimating
    }
    
    func startAnimating() {
        imageIndicatorView.startAnimating()
    }
    
    func stopAnimating() {
        imageIndicatorView.stopAnimating()
    }
    
    init?(imageData: Data) {


        guard let image = UIImage(data: imageData) else {
            /// Only a failable initializer can return 'nil'
            return nil
        }


        imageIndicatorView = ImageView()
        imageIndicatorView.frame = CGRect(origin: .zero, size: image.size)

        imageIndicatorView.contentMode = .center
        imageIndicatorView.autoresizingMask = [.flexibleLeftMargin,
                                               .flexibleRightMargin,
                                               .flexibleTopMargin,
                                               .flexibleBottomMargin]
    }
}
