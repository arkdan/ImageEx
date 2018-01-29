//
//  OtherViewController.swift
//  ImageEx
//
//  Created by mac on 1/29/18.
//  Copyright © 2018 obnoxious. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    
    private lazy var scrollView = NYOBetterZoomUIScrollView(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(scrollView)
        view.pin(subview: scrollView)
        
        scrollView.bouncesZoom = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        scrollView.maximumZoomScale = 3
    }
    override func viewDidAppear(_ animated: Bool) {

    super.viewDidAppear(animated)
        let portrait = UIImage(named: "_portrait")!
        let landscape = UIImage(named: "_landscape")!
        update(image: portrait)
    }
    
    private func update(image: UIImage) {
        let imageView = UIImageView(image: image)
        scrollView.childView = imageView
        scrollView.contentSize = imageView.bounds.size
        scrollView.setZoomForContentSize(image.size)
        scrollView.setZoomScale(scrollView.minimumZoomScale, animated: false)
    }
}

extension ViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.scrollView.childView
    }

    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
    }
}
