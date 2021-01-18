//
//  CachedRemoteImage.swift
//  PokeBowl
//
//  Created by Bart Kneepkens on 16/01/2021.
//

import SwiftUI

struct CachedRemoteImage: View {
    private enum LoadState {
        case initial, loading, success, failure
    }
    
    private class Loader: ObservableObject {
        var image: UIImage?
        var state = LoadState.initial
        
        private let cache = SessionImageCache.shared
        
        init(url: URL?) {
            guard state == .initial else { return }
            
            guard let parsedURL = url else {
                print("Invalid URL: \(url?.absoluteString ?? "")")
                return
            }
            
            self.state = .loading
            
            if let cachedImage = self.cache.get(for: parsedURL.absoluteString) {
                self.image = cachedImage
                self.state = .success
                return
            }
            
            URLSession.shared.dataTask(with: parsedURL) { data, response, error in
                print("Fetched Image from \(parsedURL)")
                
                if let data = data, !data.isEmpty {
                    self.image = UIImage(data: data)
                    self.state = .success
                    
                    if let image = UIImage(data: data) {
                        self.cache.set(image: image, for: parsedURL.absoluteString)
                    }
                } else {
                    self.state = .failure
                }
                
                DispatchQueue.main.async {
                    self.objectWillChange.send()
                }
            }.resume()
        }
    }
    
    @ObservedObject private var loader: Loader
    @Binding var showsOriginal: Bool
    
    var body: some View {
        if loader.state == .loading {
            ProgressView()
        } else if loader.state == .success, let image = loader.image {
            Image(uiImage: image)
                .renderingMode(self.showsOriginal ? .original : .template)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.black)
        }
    }
    
    init(url: URL?, showsOriginal: Binding<Bool>) {
        self.loader = Loader(url: url)
        _showsOriginal = showsOriginal
    }
}

