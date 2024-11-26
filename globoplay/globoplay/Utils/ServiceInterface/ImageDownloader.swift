//
//  ImageDownloader.swift
//  globoplay
//
//  Created by JOÃO GUILHERME BONILHA VIANA on 24/11/24.
//

import Foundation
import UIKit

class ImageDownloader {
    
    static let shared = ImageDownloader()
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    func downloadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        
        if let cachedImage = cache.object(forKey: urlString as NSString) {
            completion(cachedImage)
            return
        }
        
        guard let url = URL(string: urlString) else {
            print("URL inválida: \(urlString)")
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                print("Erro ao baixar imagem: \(error.localizedDescription)")
                completion(nil)
                return
            }
            guard let data = data, let image = UIImage(data: data) else {
                print("Não foi possível criar a imagem com os dados recebidos.")
                completion(nil)
                return
            }
    
            self?.cache.setObject(image, forKey: urlString as NSString)
            
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
}

