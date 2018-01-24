//
//  ViewController.swift
//  ExpandingCollasingViews
//
//  Created by John DeLong on 10/11/17.
//  Copyright © 2017 MichiganLabs. All rights reserved.
//

//PresentSectionViewController

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    fileprivate var selectedCell: UICollectionViewCell?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.dataSource = self
        self.collectionView.delegate = self

        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 300, height: 300)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16
        self.collectionView.collectionViewLayout = layout

        self.collectionView.register(cellType: Cell.self)
    }
}

extension ViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: Cell.self)

        return cell
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedCell = self.collectionView.cellForItem(at: indexPath)
        let vc = ExpandedViewController.instantiate()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ViewController: Animatable {
    var containerView: UIView? {
        return self.collectionView
    }
    
    var childView: UIView? {
        return self.selectedCell
    }
}
