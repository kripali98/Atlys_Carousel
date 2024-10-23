//
//  ImageCarousel.swift
//  Atlys
//
//  Created by Kripali Agrawal on 23/10/24.
//

import Foundation
import UIKit

class ImageCarousel: UIView {

    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private let pageControl = UIPageControl()
    
    private let images: [UIImage] = [
        UIImage(named: "image1")!,
        UIImage(named: "image2")!,
        UIImage(named: "image3")!
    ]

    private let itemSize: CGFloat = 200
    private let scaleFactor: CGFloat = 1.5
    private let imageSpacing: CGFloat = 0
    private var closestIndex: Int = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        scrollView.isPagingEnabled = false
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.decelerationRate = .fast
        scrollView.clipsToBounds = false
        scrollView.bounces = false
        addSubview(scrollView)

        stackView.axis = .horizontal
        stackView.spacing = imageSpacing
        stackView.alignment = .center
        scrollView.addSubview(stackView)

        for image in images {
            let containerView = UIView()
            containerView.translatesAutoresizingMaskIntoConstraints = false
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 15
            imageView.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(imageView)
            stackView.addArrangedSubview(containerView)

            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalToConstant: itemSize),
                imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor), // 1:1 aspect ratio
                imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                imageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
            ])

            NSLayoutConstraint.activate([
                containerView.widthAnchor.constraint(equalToConstant: itemSize),
                containerView.heightAnchor.constraint(equalToConstant: itemSize)
            ])
        }

        pageControl.numberOfPages = images.count
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .black
        addSubview(pageControl)
        
        setupConstraints()

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.scrollToImage(index: 1, animated: false)
            self.pageControl.currentPage = 1
        }
    }

    private func setupConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        pageControl.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor)
        ])

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            pageControl.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 10),
            pageControl.centerXAnchor.constraint(equalTo: centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: bottomAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    func updatePageIndex() {
        pageControl.currentPage = closestIndex
    }

    private func scrollToImage(index: Int, animated: Bool = true) {
        let initialOffsetX = (itemSize + imageSpacing) * CGFloat(index) - scrollView.frame.width / 2 + itemSize / 2
        scrollView.setContentOffset(CGPoint(x: initialOffsetX, y: 0), animated: animated)
    }
}


extension ImageCarousel: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollToImage(index: closestIndex)
        updatePageIndex()
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            scrollToImage(index: closestIndex)
            updatePageIndex()
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let centerX = scrollView.contentOffset.x + (scrollView.frame.size.width / 2)
        let maxDistance = scrollView.frame.width / 2
        for (index, view) in stackView.arrangedSubviews.enumerated() {
            let containerCenterX = view.frame.origin.x + view.frame.size.width / 2
            let distanceFromCenter = abs(centerX - containerCenterX)
            let scale = max(1.0, scaleFactor - (distanceFromCenter / maxDistance))
            if scale > 1.0 && closestIndex != index {
                closestIndex = index
                stackView.bringSubviewToFront(view)
            }
            view.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }
}
