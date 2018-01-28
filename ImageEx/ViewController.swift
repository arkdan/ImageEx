//
//  ViewController.swift
//  ImageEx
//
//  Created by mac on 1/29/18.
//  Copyright © 2018 obnoxious. All rights reserved.
//


import UIKit


class ViewController: UIViewController {

    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var imageView: UIImageView!


    override func viewDidLoad() {
        super.viewDidLoad()

        automaticallyAdjustsScrollViewInsets = false

        scrollView.delegate = self

        let portrait = UIImage(named: "_portrait")!
        let landscape = UIImage(named: "_landscape")!
        update(image: portrait)
    }

    private func update(image: UIImage?) {
        imageView.image = image
        imageView.backgroundColor = .red
        if let image = imageView.image {

        }

        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 6.0
    }
}

extension ViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}



