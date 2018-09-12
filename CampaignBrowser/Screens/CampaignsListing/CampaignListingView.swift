import UIKit


/**
 The view which displays the list of campaigns. It is configured in the storyboard (Main.storyboard). The corresponding
 view controller is the `CampaignsListingViewController`.
 */
class CampaignListingView: UICollectionView {

    /**
     A strong reference to the view's data source. Needed because the view's dataSource property from UIKit is weak.
     */
    @IBOutlet var strongDataSource: UICollectionViewDataSource!

    /**
     All the possible cell types that are used in this collection view.
     */
    enum Cells: String {

        /** The cell which is used to display the loading indicator. */
        case loadingIndicatorCell

        /** The cell which is used to display a campaign. */
        case campaignCell
        
        /** The cell which is used to display an info about connection problem */
        case errorCell
    }

    /**
     Displays the given campaign list.
     */
    func display(campaigns: CampaignList) {
        let campaignDataSource = ListingDataSource(campaigns: campaigns)
        display(from: campaignDataSource)
    }
    
    /**
     Display loading screen.
    */
    func displayLoading() {
        display(from: LoadingDataSource())
    }
    
    /**
    Display error info
    */
    func displayError() {
        display(from: ErrorDataSource())
    }
    
    /**
     Generic display function.
     
     - Parameter source: The data source that need to be displayed.
     */
    func display<T>(from source: T) where T: UICollectionViewDataSource & UICollectionViewDelegate {
        dataSource = source
        delegate = source
        strongDataSource = source
        reloadData()
    }
    
}


/**
 The data source for the `CampaignsListingView` which is used to display the list of campaigns.
 */
class ListingDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    /** The campaigns that need to be displayed. */
    let campaigns: [Campaign]

    /**
     Designated initializer.

     - Parameter campaign: The campaigns that need to be displayed.
     */
    init(campaigns: [Campaign]) {
        self.campaigns = campaigns
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return campaigns.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let campaign = campaigns[indexPath.item]
        let reuseIdentifier =  CampaignListingView.Cells.campaignCell.rawValue
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        if let campaignCell = cell as? CampaignCell {
            campaignCell.moodImage = campaign.moodImage
            campaignCell.name = campaign.name
            campaignCell.descriptionText = campaign.description
        } else {
            assertionFailure("The cell should a CampaignCell")
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 450)
    }

}

final class LoadingDataSource: SingleCellDataSource {
    convenience init() {
        self.init(cell: .loadingIndicatorCell)
    }
}

final class ErrorDataSource: SingleCellDataSource {
    convenience init() { self.init(cell: .errorCell) }
}

/**
 The single cell data source for the `CampaignsListingView` which is used while the actual contents are still loaded or to display the info about connection problem
 */
class SingleCellDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    typealias Cell = CampaignListingView.Cells
    
    /** The cell that need to be displayed. */
    let cell: Cell
    
    /**
     Designated initializer.
     
     - Parameter cell: The cell that need to be displayed.
     */
    init(cell: Cell) {
        self.cell = cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reuseIdentifier = cell.rawValue
        return collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                  for: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
}
