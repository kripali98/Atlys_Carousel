//
//  ViewController.swift
//  Atlys
//
//  Created by Kripali Agrawal on 22/10/24.
//

import UIKit
class ViewController: UIViewController {

    private let carouselView = ImageCarousel()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(carouselView)
        setupConstraints()
    }

    private func setupConstraints() {
        carouselView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            carouselView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            carouselView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            carouselView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            carouselView.heightAnchor.constraint(equalToConstant: 350)
        ])
    }
}
