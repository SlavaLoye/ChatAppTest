//
//  Extentions.swift
//  ChatApp
//
//  Created by Вячеслав Лойе on 29.06.2018.
//  Copyright © 2018 Вячеслав Лойе. All rights reserved.
//
import Foundation
import UIKit

// Обязательно подгружать в кэшь - фото и видео

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    func loadImageUsingCacheWithUrlString(urlString: String) {
        self.image = nil
        // то есть если у нас есть такая картинка то му ее загрузим
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cachedImage
            return
        }
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                return
            }
            DispatchQueue.main.async {
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                    self.image = UIImage(data: data!)
                }
            }
        }.resume()
    }
}






















