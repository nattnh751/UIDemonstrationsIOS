
//  AdvancedSearchViewController.m
//  AppDataRoom
//
//  Created by Nathan Walsh on 10/4/18.
//

#import "AdvancedSearchViewController.h"
#import "mediaTagCell.h"
#import "UIColor+hex.h"
#import "Ios_Demonstrations-Swift.h"
//#import "UIImage+tint.h"

//#import "CMPopTipView.h"

@interface AdvancedSearchViewController ()

@end

@implementation AdvancedSearchViewController {
  UIFont *clientFont, *boldClientFont, *italicClientFont;
  UITextView *noResultsFound;
  
}
@synthesize searchButton,backButton,foodResultObjects,resultsCollectionView,collectionView,searchBar,listOfSections,listOfSearchTags,flowLayout,selectedTags,selectedTagCollection,selectedFlowLayout,clearButton,tagTypeDictionary,tagNameSelectedSizeDictionary,tagNameSizeDictionary,collectionViewContainer;

- (void)viewDidLoad {
  [super viewDidLoad];
  tagNameSizeDictionary = [NSMutableDictionary new];
  tagNameSelectedSizeDictionary = [NSMutableDictionary new];
  tagTypeDictionary = [NSMutableDictionary new];
  listOfSections = [NSMutableArray new];
  selectedTags = [NSMutableArray new];
  foodResultObjects = [NSMutableArray new];

  [clearButton setTitle:@"Clear Search" forState:UIControlStateNormal];
  [searchButton setTitle:@"Search" forState:UIControlStateNormal];
  [searchButton setTitle:@"Close Search" forState:UIControlStateSelected];
  
}

- (void)viewWillAppear:(BOOL)animated {
  UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:searchBar action:@selector(resignFirstResponder)];
  UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
  toolbar.items = [NSArray arrayWithObject:barButton];
  searchBar.inputAccessoryView = toolbar;
  searchBar.delegate = self;
  
}
-(void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  NSArray *sortby = @[[NSSortDescriptor sortDescriptorWithKey:@"type"
                                                    ascending:YES]];
  listOfSearchTags = [[SearchTag new] getAllSearchTags];
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                 ^{
                   for(SearchTag *tag in listOfSearchTags) {
                     if(tag.type) {
                       if(![listOfSections containsObject:tag.type]) {
                           [listOfSections addObject:tag.type];
                           NSArray *sortby = @[[NSSortDescriptor sortDescriptorWithKey:@"name"
                                                                             ascending:YES]];
                         [tagTypeDictionary setObject:[[SearchTag new] getAllSearchTagsForType:tag.type] forKey:tag.type];
                       }
                     }
                   }
                   dispatch_async(dispatch_get_main_queue(), ^{
                     UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goBack:)];
                     tapGestureRecognizer.numberOfTapsRequired = 1;
                     [backButton addGestureRecognizer:tapGestureRecognizer];
                     backButton.userInteractionEnabled = YES;
                     [self initializeSelectedTagCollectionView];
                     [self initializeResultsCollectionView];
                     [self initializeTagCollectionView];
                   });
                 });
}
- (void)initializeResultsCollectionView {
  UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
  CGRect frame = self.collectionView.frame;
  resultsCollectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
  [resultsCollectionView setHidden:NO];
  [resultsCollectionView setAlpha:0];
  [resultsCollectionView setBackgroundColor:[UIColor whiteColor]];
//  [resultsCollectionView registerClass:[MediaItemCell class] forCellWithReuseIdentifier:@"*"];
  [resultsCollectionView setDelegate:self];
  [resultsCollectionView setFrame:frame];
  [resultsCollectionView setDataSource:self];
  noResultsFound = [UITextView new];
  noResultsFound.text = @"Search results empty";
  noResultsFound.userInteractionEnabled = NO;
  noResultsFound.textColor = [UIColor blackColor];
  [noResultsFound setEditable:NO];
  noResultsFound.backgroundColor = [UIColor clearColor];
  [noResultsFound sizeToFit];
  [noResultsFound setHidden:YES];
  [resultsCollectionView addSubview:noResultsFound];
  [collectionViewContainer addSubview:resultsCollectionView];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
  if(resultsCollectionView) {
    CGRect frame = self.collectionView.frame;
    [resultsCollectionView setFrame:frame];
  }
}

- (void)initializeSelectedTagCollectionView {
  selectedFlowLayout.estimatedItemSize = CGSizeMake(1.f, 1.f);
  [selectedTagCollection setDelegate:self];
  [selectedTagCollection setDataSource:self];
  [selectedTagCollection setCollectionViewLayout:selectedFlowLayout];
  UINib *mediaCellNib = [UINib nibWithNibName:@"mediaTagCell" bundle: nil];
  [selectedTagCollection registerNib:mediaCellNib forCellWithReuseIdentifier:@"mediaTagCell"];
}

- (void)initializeTagCollectionView {
  flowLayout.estimatedItemSize = CGSizeMake(1.f, 1.f);
  flowLayout.headerReferenceSize = CGSizeMake(50.f, 50.f);
  //  flowLayout.sectionInset = UIEdgeInsetsMake(40, 0, 0, 0);
  [collectionView setDelegate:self];
  [collectionView setDataSource:self];
  [collectionView setCollectionViewLayout:flowLayout];
  UINib *mediaCellNib = [UINib nibWithNibName:@"mediaTagCell" bundle: nil];
  UINib *sectionHeader = [UINib nibWithNibName:@"AdvancedSearchSectionTitle" bundle: nil];
  [collectionView registerNib:mediaCellNib forCellWithReuseIdentifier:@"mediaTagCell"];
  [collectionView registerNib:sectionHeader forSupplementaryViewOfKind:UICollectionElementKindSectionHeader  withReuseIdentifier:@"AdvancedSearchSectionTitle"];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
  [self refreshSearchResults];
  if(resultsCollectionView.alpha == 0) {
    resultsCollectionView.alpha = 0;
    typeof(self) __weak weakSelf = self;
    [UIView animateWithDuration:0.15f animations:^{
      weakSelf.resultsCollectionView.alpha = 1;
      [clearButton setHidden:YES];
    }];
    [searchButton setSelected:YES];
  }
}

- (void)refreshSearchResults {
  foodResultObjects = nil;
  if(foodResultObjects.count<=0) {
    [noResultsFound setHidden:NO];
  } else {
    [noResultsFound setHidden:YES];
  }
  [resultsCollectionView reloadData];
}

-(void)presentOfflinePopup {
  UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Results unavailable offline" preferredStyle:UIAlertControllerStyleAlert];
  UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
  [alert addAction:cancel];
  [self presentViewController:alert animated:YES completion:nil];
}

- (NSInteger)collectionView:(UICollectionView *)theCollectionView numberOfItemsInSection:(NSInteger)section {
  //return listOfSearchTags.count;
  if(theCollectionView==collectionView) {
    NSArray *tesr = [tagTypeDictionary objectForKey:[listOfSections objectAtIndex:section]];
    return  tesr.count;
  } else {
    if(theCollectionView==selectedTagCollection) {
      return selectedTags.count;
    }
    return foodResultObjects.count;
  }
}
// flow layout tweaking

- (CGSize)collectionView:(UICollectionView *)cv
                  layout:(UICollectionViewLayout *)layout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
  if(cv == resultsCollectionView) {
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout*) layout;
    BOOL horizontal = (resultsCollectionView.bounds.size.width > resultsCollectionView.bounds.size.height + 100);
//    CGSize cellSize  = [MediaItemCell getSizeForCell:flowLayout isHorizontal:horizontal gridObjects:self.foodResultObjects collectionView:resultsCollectionView index:indexPath splitMode:NO];
    return CGSizeMake(10.0f, 100.0f);
  }
  return CGSizeMake(10.0f, 10.0f);

}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)theCollectionView {
  if(theCollectionView==collectionView) {
    return listOfSections.count;
  } else {
    return 1;
  }
}

- (void)collectionView:(UICollectionView *)theCollectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
  if(theCollectionView==collectionView) {
    NSMutableArray *testArray;
    testArray = [[tagTypeDictionary objectForKey:[listOfSections objectAtIndex:indexPath.section]]  mutableCopy];
    SearchTag *tag = [testArray objectAtIndex:indexPath.item];
    if(![selectedTags containsObject:tag]) {
      [selectedTags insertObject:tag atIndex:0];
      [selectedTagCollection reloadData];
      mediaTagCell *cell = (mediaTagCell *) [collectionView cellForItemAtIndexPath:indexPath];
      typeof(mediaTagCell *) __weak weakSelf = cell;
      [UIView animateWithDuration:0.38f animations:^{
        weakSelf.backgroundColor = UIColor.grayColor;
        weakSelf.label.textColor = UIColor.darkGrayColor;
        weakSelf.alpha = 0.4f;
        [cell layoutSubviews];
      }];
    }
    [self refreshSearchResults];
  } else {
    if(theCollectionView==selectedTagCollection) {
      SearchTag *tag = [selectedTags objectAtIndex:indexPath.item];
      [selectedTags removeObject:tag];
      [selectedTagCollection reloadData];
      for(mediaTagCell * cell in collectionView.visibleCells) {
        if(cell.tagID == tag.searchTagId) {
          typeof(mediaTagCell *) __weak weakSelf = cell;
          [UIView animateWithDuration:0.38f animations:^{
            weakSelf.backgroundColor = tag.color;
            weakSelf.label.textColor = UIColor.whiteColor;
            weakSelf.alpha = 1.f;
            [cell layoutSubviews];
          }];
        }
      }
      [self refreshSearchResults];
    } else {
//      Media *m = (Media *)self.foodResultObjects[indexPath.item];
//      [m setSeenValue:YES];
//      Session *session = [AppDataRoomService sharedInstance].session;
//      [session.managedObjectContext save:nil];
//      if (networkStatus == AFNetworkReachabilityStatusNotReachable && !m.availableOfflineValue) {
//        [self presentOfflinePopup];
//        [theCollectionView deselectItemAtIndexPath:indexPath animated:YES];
//        return;
//      }
      [theCollectionView deselectItemAtIndexPath:indexPath animated:YES];
    }
  }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)theCollectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//  if(theCollectionView==resultsCollectionView) {
////    Media *m = [self.foodResultObjects objectAtIndex:indexPath.item];
////    UIColor *color = [UIColor colorWithHexString:@"222222"];
////    Session *session = [AppDataRoomService sharedInstance].session;
////    clientFont = session.selectedAccount.clientFont;
////    boldClientFont = session.selectedAccount.boldClientFont;
////    italicClientFont = session.selectedAccount.italicClientFont;
////    MediaItemCell *cell = (id)[theCollectionView dequeueReusableCellWithReuseIdentifier:@"*" forIndexPath:indexPath];
////    [cell setMedia:m];
////    [cell textLabel]; //force lazycreate
////    [[cell textLabel] setText:m.title];
////    [cell recursiveReplaceSystemFontWith:clientFont
////                                    bold:boldClientFont
////                                  italic:italicClientFont];
////    UIButton *butt = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
////    UIImage *plus = [[UIImage imageNamed:@"button-plus.png"] imageWithTintBackgroundOnly:color];
////    [butt setImage:plus forState:UIControlStateNormal];
////    [butt addTarget:self action:@selector(doActionPopup:) forControlEvents:UIControlEventTouchUpInside];
////    [cell setAccessoryView:butt];
////    [self addWifiIconIfNeededToCell:cell forMedia:m];
////    return cell;
//  } else {
    NSArray *testArray;
    BOOL isSelectedView = theCollectionView==selectedTagCollection;
    if(isSelectedView) {
      testArray = [selectedTags copy];
    } else {
      testArray = [[tagTypeDictionary objectForKey:[listOfSections objectAtIndex:indexPath.section]] copy];
    }
    mediaTagCell *cell = [theCollectionView dequeueReusableCellWithReuseIdentifier:@"mediaTagCell" forIndexPath:indexPath];
    SearchTag *tag = [testArray objectAtIndex:indexPath.item];
    [cell setTagID:tag.searchTagId];
    if(isSelectedView) {
      [cell.label setText:[NSString stringWithFormat:@"%@    x", tag.name]];
      cell.backgroundColor = tag.color;
      cell.layer.cornerRadius = (CGFloat) (14);
    } else {
      [cell.label setText:tag.name];
      if([selectedTags containsObject:tag]) {
        cell.backgroundColor = UIColor.grayColor;
        cell.label.textColor = UIColor.darkGrayColor;
        cell.alpha = 0.4f;
      } else {
        cell.backgroundColor = tag.color;
        cell.label.textColor = UIColor.whiteColor;
        cell.alpha = 1.f;
      }
      cell.layer.cornerRadius = (CGFloat) (14);
    }
    return cell;
//  }
}
- (UITextView *)getLabelView:(SearchTag *)tag showDelete:(BOOL)showDelete {
  UITextView *textLabel = [UITextView new];
  if(showDelete) {
    textLabel.text = [NSString stringWithFormat:@"%@    x", tag.name];
  } else {
    textLabel.text = tag.name;
  }
  [textLabel sizeToFit];
  CGRect frame = textLabel.frame;
  frame.size.width = frame.size.width+30;
  return textLabel;
}


- (UIEdgeInsets)collectionView:(UICollectionView *)theCollectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
  
  if(theCollectionView==collectionView) {
    if([theCollectionView numberOfItemsInSection:section]==1) {
      // this is hacky but for some reason when there is only one tag in the section the cell gets centered and this undoes that!
      NSArray *arr;
      arr = [tagTypeDictionary objectForKey:[listOfSections objectAtIndex:section]];
      UITextView *tempView = [self getLabelView:[arr objectAtIndex:0] showDelete:NO];
      return UIEdgeInsetsMake(0, tempView.frame.size.width+17-theCollectionView.frame.size.width, 10, 0);
    } else {
      return UIEdgeInsetsMake(0, 0, 0, 0);
    }

  } else {
    return UIEdgeInsetsMake(20, 10, 20, 10);
  }
}

- ( UICollectionReusableView * ) collectionView : ( UICollectionView * ) theCollectionView viewForSupplementaryElementOfKind : ( NSString * ) kind atIndexPath : ( NSIndexPath * ) indexPath
{
  UICollectionReusableView * reusableview = nil ;
//  if(theCollectionView&&theCollectionView==collectionView) {
    NSArray *testArray;
    testArray = [tagTypeDictionary objectForKey:[listOfSections objectAtIndex:indexPath.section]];
    NSString *sectionTitle = @"";
    if(testArray.count>0) {
      SearchTag *tag = [testArray objectAtIndex:indexPath.item];
      sectionTitle = tag.type;
    }
    
    if (kind == UICollectionElementKindSectionHeader) {
      reusableview = [theCollectionView dequeueReusableSupplementaryViewOfKind:kind
                                                           withReuseIdentifier:@"AdvancedSearchSectionTitle"
                                                                  forIndexPath:indexPath];
      UILabel *sectionLabel = [UILabel new];
      [sectionLabel setTag:54];
      sectionLabel.text = sectionTitle;
      sectionLabel.textColor = [UIColor blackColor];
      [sectionLabel sizeToFit];
      for(UIView *view in reusableview.subviews) {
        if(view.tag==54) {
          [view removeFromSuperview];
        }
      }
      if(![sectionTitle isEqualToString:@""]) {
        [reusableview addSubview:sectionLabel];
        CGRect frame = sectionLabel.frame;
        frame.origin.y = 50-sectionLabel.frame.size.height-10;
        [sectionLabel setFrame:frame];
      }
      //      [reusableview sizeToFit];
    }
    return reusableview;
//  }
}

- (IBAction)doSearch:(id)sender {
  if(resultsCollectionView.alpha == 0) {
    resultsCollectionView.alpha = 0;
    typeof(self) __weak weakSelf = self;
    [UIView animateWithDuration:0.15f animations:^{
      weakSelf.resultsCollectionView.alpha = 1;
      [clearButton setHidden:YES];
    }];
    [searchButton setSelected:YES];
  } else {
    resultsCollectionView.alpha = 1;
    typeof(self) __weak weakSelf = self;
    [UIView animateWithDuration:0.15f animations:^{
      weakSelf.resultsCollectionView.alpha = 0;
      [clearButton setHidden:NO];
    }];
    [searchButton setSelected:NO];
    
  }
  [self refreshSearchResults];
}

- (IBAction)doClearTags:(id)sender {
  for(SearchTag *tag in selectedTags) {
    for(mediaTagCell * cell in collectionView.visibleCells) {
      if(cell.tagID == tag.searchTagId) {
        typeof(mediaTagCell *) __weak weakSelf = cell;
        float randomNum = ((float)rand() / RAND_MAX) * 0.35;
        [UIView animateWithDuration:0.5 delay:randomNum options:nil animations:^{
          weakSelf.backgroundColor = tag.color;
          weakSelf.label.textColor = UIColor.whiteColor;
          weakSelf.alpha = 1.f;
          [cell layoutSubviews];
        } completion: nil];
      
      }
    }
  }
  selectedTags = [NSMutableArray new];
  [selectedTagCollection reloadData];
  searchBar.text = @"";
  [self refreshSearchResults];
}

-(void)goBack:(UIGestureRecognizer *)gr {
  [self dismissViewControllerAnimated:YES completion:nil];
}

@end
