//
//  AdvancedSearchViewController.h
//  AppDataRoom
//
//  Created by Nathan Walsh on 10/4/18.
//

#import <UIKit/UIKit.h>
#import "mediaTagCell.h"

@interface AdvancedSearchViewController : UIViewController < UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate>
@property(nonatomic, strong) UIView *headerView;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *selectedTagCollection;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;
- (IBAction)doSearch:(id)sender;
- (IBAction)doClearTags:(id)sender;
@property (strong, nonatomic) UICollectionView *resultsCollectionView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) mediaTagCell *parent;
@property (strong, nonatomic) NSMutableArray *listOfSections;
@property (strong, nonatomic) NSMutableArray *selectedTags;
@property (strong, nonatomic) NSMutableArray *foodResultObjects;
@property (strong, nonatomic) NSArray *listOfSearchTags;
@property (strong, nonatomic) NSMutableDictionary *tagTypeDictionary;
@property (strong, nonatomic) NSMutableDictionary *tagNameSizeDictionary;
@property (strong, nonatomic) NSMutableDictionary *tagNameSelectedSizeDictionary;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *selectedFlowLayout;
@property (weak, nonatomic) IBOutlet UIImageView *backButton;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UIView *collectionViewContainer;
@end

