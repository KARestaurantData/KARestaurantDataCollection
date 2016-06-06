import UIKit

private let PhotoCollectionViewCellIdentifier = "PhotoCell"

class PhotosCollectionViewController: UICollectionViewController {
    
    //MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCollectionViewCells()
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    //MARK: - Collection View Setup
    
    func registerCollectionViewCells() {
        collectionView?.registerNib(UINib(nibName: "PhotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: PhotoCollectionViewCellIdentifier)
    }
    
    // MARK: - UICollectionViewDataSource
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PhotosDataManager.sharedManager.allPhotos().count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PhotoCollectionViewCellIdentifier, forIndexPath: indexPath) as! PhotoCollectionViewCell
        cell.configure(glacierScenicAtIndex(indexPath))
        return cell
    }
    
    func glacierScenicAtIndex(indexPath: NSIndexPath) -> GlacierScenic {
        let photos = PhotosDataManager.sharedManager.allPhotos()
        return photos[indexPath.row]
    }
    
}

extension PhotosCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let spacing: CGFloat = 1
        let itemWidth = (view.bounds.size.width / 2) - (spacing / 2)
        let itemHeight = (view.bounds.size.width / 3) - (spacing / 2)
        return CGSize(width: itemWidth, height: itemHeight)
    }
}