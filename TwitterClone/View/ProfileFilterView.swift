//
//  ProfileFilterView.swift
//  TwitterClone
//
//  Created by Fenominall on 12/25/21.
//

import UIKit

private let reuseIdentifier = "ProfileFilterCell"

class ProfileFilterView: UIView {
    
    
    // MARK: - Properties
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // registering CollectionView
        collectionView.register(ProfileFilterCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        // adding a collectionView as a layer to the UIView
        addSubview(collectionView)
        // filling the entire UIView with the collectionView
        collectionView.addConstraintsToFillView(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    // MARK: - Helpers
}

// MARK: - UICollectionViewDelegate
extension ProfileFilterView: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDataSource
extension ProfileFilterView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ProfileFilterCell
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
// adjust the size of ProfileFilterCell and amount of sections
extension ProfileFilterView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / 3, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
