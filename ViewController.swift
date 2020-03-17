//
//  ViewController.swift
//  ImageLoader_Samples
//
//  Created by 王海洋 on 2020/3/13.
//  Copyright © 2020 王海洋. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var number: Int = 0
    var number2: Int = 0
    var number3: Int = 0
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: view.bounds)
        imageView.backgroundColor = .white
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    
 

}


extension ViewController {
    
    ///UIGraphicsImageRenderer 52.6
    func qresizeImagae(at path: URL, size: CGSize) -> UIImage? {

        guard let image = UIImage(contentsOfFile: path.path) else { return nil }

        let render = UIGraphicsImageRenderer(size: size)

        return render.image { (context) in
            image.draw(in: CGRect(origin: .zero, size: size))
        }

    }
    
    /// Core Graphics 54.6
    func aresizeImagae(at path: URL, size: CGSize) -> UIImage? {
    
        guard let imageSource = CGImageSourceCreateWithURL(path as CFURL, nil) else { return nil }
        
        guard let image = CGImageSourceCreateImageAtIndex(imageSource, 0, nil) else { return nil }

        let context = CGContext(data: nil,
                                width: Int(size.width),
                                height: Int(size.height),
                                bitsPerComponent: image.bitsPerComponent,
                                bytesPerRow: image.bytesPerRow,
                                space: image.colorSpace ?? CGColorSpace(name: CGColorSpace.sRGB)!,
                                bitmapInfo: image.bitmapInfo.rawValue)
        context?.interpolationQuality = .high
        
        context?.draw(image, in: CGRect(origin: .zero, size: size))
        
        guard let scaleImage = context?.makeImage() else { return nil }
        
        
        return UIImage(cgImage: scaleImage)
    }
    
    ///  Image io 52.8
    func resizeImagae(at path: URL, size: CGSize) -> UIImage? {
        let scale = UIScreen.main.scale
        
        let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        guard let imageSource = CGImageSourceCreateWithURL(path as CFURL, imageSourceOptions) else { return nil }

        
        let options: [CFString : Any] = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceThumbnailMaxPixelSize: max(size.width, size.height) * scale
        ]
        
        
        guard let image = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options as CFDictionary) else { return nil }
    
        return UIImage(cgImage: image)
        
    }
    
}


extension Dictionary: Identifiable {
   
    
    public var id: ObjectIdentifier {
    
        return ObjectIdentifier(Dictionary.self)
    }
    
}

protocol MyIdentifiable {
    
    func identifier(_ identifier: String) -> IdentifierImp
}

class IdentifierImp {
       let value: String

       init(_ value: String) {
           self.value = value
       }
       
   }

class Person: Identifiable {
    
    var name:   String?
    var age:    Int?
    var school: String?
    
    func changeName(name: String) {
        self.name = name
    }
}



typealias DoneClosure = () -> Void
typealias WorkerClosure = (_ done: @escaping DoneClosure) -> Void
/// 顺序执行异步任务
class AsyncSerialQueue {
    
    
    private let serialQueue = DispatchQueue(label: "com.serialQueue.async")
    
    func enqueue(work: @escaping WorkerClosure) {
        
        serialQueue.async {
            
            let semaphore = DispatchSemaphore(value: 1)
                        
            if semaphore.wait(timeout: .distantFuture) == .success {
                work({
                    semaphore.signal()
                })
            }
        }
    }
}


/// 控制队列的最大并发数
class LimitedWorkQueue {
    
    private let concurrentQueue = DispatchQueue(label: "com.concurrentQueue.limited", attributes: .concurrent)
    
    private let semaphore: DispatchSemaphore!
    
    init(limit: Int) {
        semaphore = DispatchSemaphore(value: limit)
    }
    
    func enqueue(work: @escaping () -> Void) {
        
        concurrentQueue.async {
            if self.semaphore.wait(timeout: .distantFuture) == .success{
                work()
                self.semaphore.signal()
            }
        }
    }
}


class IdentityMap<T: Identifiable> {
    var dictionary = Dictionary<String,T>()
    
    let accessQueue = DispatchQueue(label: "com.accessQueue.rw", attributes: .concurrent)
    
    func object(with id: String) -> T? {
        var result: T? = nil
        accessQueue.sync {
            result = dictionary[id]
        }
        return result
    }
    
    func add(object: T) {
        accessQueue.async(flags: .barrier) {
            self.dictionary["\(object.id)"] = object
        }
    }
}


