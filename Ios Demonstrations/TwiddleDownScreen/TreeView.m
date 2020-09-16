//
//  TreeView.m
//  TreeView
//
//  Created By Nathan Walsh 1-15-18
//  
//

#import "TreeView.h"
#import "UIColor+hex.h"
#import "UIColor+hex.h"
#define CELL_HEIGHT 70
#define FEATURED_CELL_HEIGHT 110

@implementation TreeView {
    void (^sizeChangedBlock)(NSString *);

  NSInteger featuredBeginningIndexPathRow;
  BOOL previousNodeWasFeatured;
}

@synthesize cat,treeViewFont,selectedArray;

@synthesize featuredBeginningIndexPathRow;

@synthesize previousNodeWasFeatured;

-(id)initWithFrame:(CGRect)frame andData:(NSMutableDictionary *)dict
{
    self = [super initWithFrame:frame];
    self.delegate=self;
    self.dataSource=self;
    treeNode = [[TreeNode alloc] initWithValue:@"Root" showMe:YES];
    selectedArray= [[NSMutableArray alloc] init];
    if (self) {
        NSArray* accounts;
//        accounts = [AppDataRoomService sharedInstance].session.selectableAccounts.allObjects;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                ^{
//                  [self createTerritoryNode:accounts andSuperView:treeNode];
                });
        self.separatorStyle= UITableViewCellSeparatorStyleNone;
        treeViewFont = [UIFont fontWithName:@"Ariel" size:20];
    }
    return self;
}
- (id)initWithFrame:(CGRect)rect andData:(void *)data sizeChangedBlock:(void (^)(NSString *))block onInitializedBlock:(void(^)(void))initializedBlock {
    self = [super initWithFrame:rect];
    self.delegate=self;
    self.dataSource=self;
    self.initialized = NO;
    treeNode = [[TreeNode alloc] initWithValue:@"Root" showMe:YES];
    selectedArray= [[NSMutableArray alloc] init];
    sizeChangedBlock = block;
    if (self) {
        NSArray* accounts;
//        accounts = [AppDataRoomService sharedInstance].session.selectableAccounts.allObjects;

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                ^{
                  [self createTerritoryNode:accounts andSuperView:treeNode];
                  dispatch_async(dispatch_get_main_queue(), ^{
                    self.initialized = YES;
                    [self reloadData];
                    initializedBlock();
                  });
                });
        self.separatorStyle= UITableViewCellSeparatorStyleNone;
        treeViewFont = [UIFont fontWithName:@"Ariel" size:20];
    }
    sizeChangedBlock( [NSString stringWithFormat:@"%@ %@",[self sizeOfSelected],@"Chosen"]);
    return self;
}
-(void)createTerritoryNode:(NSArray *)accounts andSuperView:(TreeNode *)treenode
{
    TreeNode *node1 ;
    NSMutableSet *territories = [NSMutableSet new];
  NSArray *sortby = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
    int *territoryIdCreator = 0;
    NSString *color = nil;
    NSMutableArray *categoryTextColors = nil;
    NSMutableArray *categoryBackgroundColors = nil;
    if([[NSUserDefaults standardUserDefaults] mutableArrayValueForKey:@"categoryTextColors"]&&[[NSUserDefaults standardUserDefaults] boolForKey:@"multipleCategoryColors"]) {
      categoryTextColors = [[NSUserDefaults standardUserDefaults]  mutableArrayValueForKey:@"categoryTextColors"];
    }
  
    if([[NSUserDefaults standardUserDefaults] mutableArrayValueForKey:@"categoryColors"]&&[[NSUserDefaults standardUserDefaults] boolForKey:@"multipleCategoryColors"]) {
      categoryBackgroundColors = [[NSUserDefaults standardUserDefaults]  mutableArrayValueForKey:@"categoryColors"];
    }

    int index = 0;
    index = 0;
  AccountInfo *acct = [accounts objectAtIndex:0];
    if([SettingsManager boolForKey:@"showAllTopLevelCategoriesForDC"] || acct.contentGroups.count<=1) {
        sortby = @[[NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES]];
        [self createTopLevelCategoryNode:[[Category fetchAllTopLevelCategories:[AppDataRoomService sharedInstance].uiContext] sortedArrayUsingDescriptors:sortby] andSuperView:treenode color:nil textColor:nil];
    } else {
      if(accounts.count <=1) {
        AccountInfo *acct = [accounts objectAtIndex:0];
        NSArray *territorySort = @[[NSSortDescriptor sortDescriptorWithKey:@"sortForTerritory" ascending:YES]];
        for(ContentGroup *grp in [acct.contentGroups sortedArrayUsingDescriptors:territorySort]) {
          if(grp.territoryName) {
            [territories addObject:grp.territoryName];
          }
        }
      
        if(territories.count > 0) {
          NSArray *terr = [[territories allObjects] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
          for(NSString *territory in terr) {
            NSArray *territoryGroups = [ContentGroup fetchGroupsByTerritoryName:territory context:[AppDataRoomService sharedInstance].uiContext];
            BOOL isSelected = YES;
            for(ContentGroup *group in territoryGroups) {
              if(!group.isSelectedForDownloadValue) {
                isSelected = NO;
              }
            }
            node1 = [[TreeNode alloc] initWithValue:territory showMe:NO];
            node1.category_id = (int) territoryIdCreator;
            territoryIdCreator += 1;
            node1.isTerritory = YES;
            node1.parent_id = 0;
            node1.isSelected = isSelected;
            if(categoryBackgroundColors && categoryBackgroundColors.count>0) {
              color = [categoryBackgroundColors objectAtIndex:[ThemeHelper getIndexForCategoryColors:index]];
            }
            index+=1;
            node1.backgroundColor = color;
            if(node1.value.length > 0) {
              [treenode addChild:node1];
              [self createGroupyNode:territoryGroups andSuperView:node1 color:color];
            }
          }
        } else {
          // its category_id will be 0 -> n incrememnted during the loop
          [self createGroupyNode:acct.contentGroups.allObjects andSuperView:treeNode color:nil];
        }
      } else {
        for(AccountInfo *acc in accounts) {
          BOOL isSelected = NO;
          node1 = [[TreeNode alloc] initWithValue:acc.title showMe:NO];
          node1.category_id = (int) territoryIdCreator;
          territoryIdCreator += 1;
          node1.isTerritory = YES;
          node1.parent_id = 0;
          node1.isSelected = isSelected;
          if(categoryBackgroundColors && categoryBackgroundColors.count>0) {
            color = [categoryBackgroundColors objectAtIndex:[ThemeHelper getIndexForCategoryColors:index]];
          }
          index+=1;
          node1.backgroundColor = color;
          if(node1.value.length > 0) {
            [treenode addChild:node1];
            [self createNodesFromAccount:acc andSuperView:node1 color:color];
          }
        }
      }
    }
}
-(void)createNodesFromAccount:(AccountInfo *)account andSuperView:(TreeNode *)treenode color:(NSString *)backgroundColor
{
  TreeNode *node1 ;
  NSMutableSet *territories = [NSMutableSet new];
  NSArray *sortby = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
  int *territoryIdCreator = 0;
  NSString *color = nil;
  NSMutableArray *categoryTextColors = nil;
  NSMutableArray *categoryBackgroundColors = nil;
  if([[NSUserDefaults standardUserDefaults] mutableArrayValueForKey:@"categoryColors"]&&[[NSUserDefaults standardUserDefaults] boolForKey:@"multipleCategoryColors"]) {
    categoryBackgroundColors = [[NSUserDefaults standardUserDefaults]  mutableArrayValueForKey:@"categoryColors"];
  }
  int index = 0;
  index = 0;
  NSArray *territorySort = @[[NSSortDescriptor sortDescriptorWithKey:@"sortForTerritory" ascending:YES]];
  for(ContentGroup *grp in [account.contentGroups sortedArrayUsingDescriptors:territorySort]) {
    if(grp.territoryName) {
      [territories addObject:grp.territoryName];
    }
  }
  if(territories.count > 0) {
    NSArray *terr = [[territories allObjects] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    for(NSString *territory in terr) {
      NSArray *territoryGroups = [ContentGroup fetchGroupsByTerritoryName:territory context:[AppDataRoomService sharedInstance].uiContext];
      BOOL isSelected = YES;
      for(ContentGroup *group in territoryGroups) {
        if(!group.isSelectedForDownloadValue) {
          isSelected = NO;
        }
      }
      node1 = [[TreeNode alloc] initWithValue:territory showMe:NO];
      node1.category_id = (int) territoryIdCreator;
      territoryIdCreator += 1;
      node1.isTerritory = YES;
      node1.parent_id = treenode.category_id;
      node1.isSelected = isSelected;
      if(categoryBackgroundColors && categoryBackgroundColors.count>0) {
        color = [categoryBackgroundColors objectAtIndex:[ThemeHelper getIndexForCategoryColors:index]];
      }
      index+=1;
      node1.backgroundColor = color;
      if(node1.value.length > 0) {
        [treenode addChild:node1];
        [self createGroupyNode:territoryGroups andSuperView:node1 color:color];
      }
    }
  } else {
    // its category_id will be 0 -> n incrememnted during the loop
    [self createGroupyNode:[account.contentGroups allObjects] andSuperView:treenode color:nil];
  }
}
-(void)createGroupyNode:(NSArray *)territoryGroups andSuperView:(TreeNode *)treenode color:(NSString *)backgroundColor
{
    NSArray *childdict;
    TreeNode *node1 ;
    int index = 0;
    index = 0;

    NSArray *sortby = @[[NSSortDescriptor sortDescriptorWithKey:@"territorySort" ascending:YES],
                        [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
    NSArray *sortedArray = [territoryGroups sortedArrayUsingDescriptors:sortby];
    if(backgroundColor) {
        for (ContentGroup *group in sortedArray) {
            // NSLog(@"%@",[[parentdict valueForKey:@"name"] objectAtIndex:y]);
            node1 = [[TreeNode alloc] initWithValue:group.title showMe:NO];
            node1.category_id = [group.groupId intValue];
            if(treenode.value == @"Root") {
                node1.parent_id = 0;
            } else {
                node1.parent_id = treenode.category_id;
            }
            node1.isGroup = YES;
            node1.backgroundColor = backgroundColor;
            node1.isSelected = [group.isSelectedForDownload boolValue];
            if(node1.isSelected) {
                [selectedArray addObject:node1];
            } else {
                [selectedArray removeObject:node1];
                
            }
            if(node1.value.length > 0) {
                [treenode addChild:node1];
                childdict = group.rootCategories.allObjects;
                [self createCategoryNode:childdict andSuperView:node1 color:backgroundColor textColor:NULL];
            }
        }
    } else {
        NSString *color = nil;
        NSMutableArray *categoryBackgroundColors = nil;
        if([[NSUserDefaults standardUserDefaults] mutableArrayValueForKey:@"categoryColors"]) {
            categoryBackgroundColors = [[NSUserDefaults standardUserDefaults]  mutableArrayValueForKey:@"categoryColors"];
        }
        for (ContentGroup *group in sortedArray) {
            // NSLog(@"%@",[[parentdict valueForKey:@"name"] objectAtIndex:y]);
            node1 = [[TreeNode alloc] initWithValue:group.title showMe:NO];
            node1.category_id = [group.groupId intValue];
            if(treenode.value == @"Root") {
                node1.parent_id = 0;
            } else {
                node1.parent_id = treenode.category_id;
            }
            node1.isGroup = YES;
            if(categoryBackgroundColors && categoryBackgroundColors.count>0) {
                color = [categoryBackgroundColors objectAtIndex:[ThemeHelper getIndexForCategoryColors:index]];
            }
            index+=1;

            node1.backgroundColor = color;
            node1.isSelected = [group.isSelectedForDownload boolValue];
            if(node1.isSelected) {
                [selectedArray addObject:node1];
            } else {
                [selectedArray removeObject:node1];
                
            }
            if(node1.value.length > 0) {
                [treenode addChild:node1];
                childdict = group.rootCategories.allObjects;
                [self createCategoryNode:childdict andSuperView:node1 color:color textColor:nil];
            }
            
        }
    }
}
- (void)createTopLevelCategoryNode:(NSArray *)categories andSuperView:(TreeNode *)treenode color:(NSString *)backgroundColor textColor:(NSString *)runningTextColor {
    int index = 0;
    NSArray *childdict;
    TreeNode *node1 ;
    NSArray *sortby = @[[NSSortDescriptor sortDescriptorWithKey:@"featured" ascending:NO],
            [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES],
            [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
    NSString *color = nil;

    NSString *textColor = nil;
    NSMutableArray *categoryTextColors = nil;
    NSMutableArray *categoryBackgroundColors = nil;
    if([[NSUserDefaults standardUserDefaults] mutableArrayValueForKey:@"categoryTextColors"]) {
        categoryTextColors = [[NSUserDefaults standardUserDefaults]  mutableArrayValueForKey:@"categoryTextColors"];

    }
    if([[NSUserDefaults standardUserDefaults] mutableArrayValueForKey:@"categoryColors"]) {
        categoryBackgroundColors = [[NSUserDefaults standardUserDefaults]  mutableArrayValueForKey:@"categoryColors"];
    }
    NSArray *sortedArray = [categories sortedArrayUsingDescriptors:sortby];
    for (Category *cat in sortedArray) {
        if(![cat.title isEqualToString:@"Link to Jarvis"]) {
            node1 = [[TreeNode alloc] initWithValue:cat.title showMe:NO];
            if(cat.hasAnyFeaturedChildren)
              node1.hasFeaturedChildren = YES;
            node1.category_id = [cat.categoryId intValue];
            node1.parent_id = [cat.parent.categoryId intValue];
            if(categoryBackgroundColors && categoryBackgroundColors.count>0) {
                color = [categoryBackgroundColors objectAtIndex:[ThemeHelper getIndexForCategoryColors:index]];
            }
            if(categoryTextColors && categoryTextColors.count>0) {
                textColor = [categoryTextColors objectAtIndex:[ThemeHelper getIndexForCategoryTextColors:index]];
            }
            index+=1;
            node1.backgroundColor = color;
            node1.textColor = textColor;
            node1.isFeatured = [cat featuredValue];
            node1.isSelected = [cat.isDownloaded boolValue];
            if(node1.isSelected) {
                [selectedArray addObject:node1];
            } else {
                [selectedArray removeObject:node1];
            }
            [treenode addChild:node1];
            childdict = [cat.subcategories allObjects];
            if(childdict.count>0) {
                [self createCategoryNode:childdict andSuperView:node1 color:color textColor:textColor];
            }
        }
    }

}
- (void)createCategoryNode:(NSArray *)categories andSuperView:(TreeNode *)treenode color:(NSString *)backgroundColor textColor:(NSString *)runningTextColor {
    int index = 0;
    NSArray *childdict;
    TreeNode *node1 ;
    NSArray *sortby = @[[NSSortDescriptor sortDescriptorWithKey:@"featured" ascending:NO],
            [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES],
            [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
    NSString *color = nil;
    NSString *textColor = nil;
    NSArray *sortedArray = [categories sortedArrayUsingDescriptors:sortby];
    for (Category *cat in sortedArray) {
        node1 = [[TreeNode alloc] initWithValue:cat.title showMe:NO];
        node1.category_id = [cat.categoryId intValue];
        node1.parent_id = [cat.parent.categoryId intValue];
        index+=1;
        if(backgroundColor) {
            color = backgroundColor;
        }
        if(runningTextColor) {
            textColor = runningTextColor;
        }
        node1.backgroundColor = color;
        node1.textColor = textColor;
        node1.isFeatured = [cat featuredValue];
        node1.isSelected = [cat.isDownloaded boolValue];
        if(node1.isSelected) {
            [selectedArray addObject:node1];
        } else {
            [selectedArray removeObject:node1];
        }
        [treenode addChild:node1];
        childdict = [cat.subcategories allObjects];
        if(childdict.count>0) {
            [self createCategoryNode:childdict andSuperView:node1 color:color textColor:textColor];
        }
    }
    
}

#pragma mark -
#pragma mark Table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.initialized)
        return [treeNode descendantCount];
    else
        return 0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
   	TreeNode *node = [[treeNode flattenElements] objectAtIndex:indexPath.row + 1];
  int64_t newSize = 0;
    if(node.isTerritory) {
        newSize = [self territorySize:node];
    } else {
        if(node.isGroup) {
            newSize = [self groupSize:node];
        } else {
//            if([self findSelectedChildNodes:node].count>0||node.isSelected||[[NSUserDefaults standardUserDefaults] boolForKey:@"showTwiddleDownScreenSizeAlways"]) {
                newSize = [self categorySize:node];
//            }
        }
    }
  node.size = newSize;
  bool childrenAreSelected = [self hasSelectedChild:node];
  TreeViewCell *cell = [[TreeViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier level:[node levelDepth] - 1 expanded:node.inclusive isSelected:node.isSelected hasChildren:node.hasChildren size:node.size featured:[self isIndexPathFeatured:indexPath]];
  cell.valueLabel.text = node.value;
  Session *sess = [AppDataRoomService sharedInstance].session;
  AccountInfo *acct = sess.selectedAccount;
  if(childrenAreSelected) {
    if([[NSUserDefaults standardUserDefaults] stringForKey:@"selectedCellColorForDCs"]) {
       cell.valueLabel.textColor = [UIColor colorWithHexString:[[NSUserDefaults standardUserDefaults] stringForKey:@"selectedCellColorForDCs"]];
    } else {
       cell.valueLabel.textColor = acct.tintColor;
    }
  }
  if(node.isGroup && [SettingsManager boolForKey:@"boldGroupNamesForTwiddle"]) {
    [cell.valueLabel setFont:acct.boldClientFont];
  } else {
    [cell.valueLabel setFont:acct.clientFont];
  }
  cell.selectionStyle=UITableViewCellSelectionStyleNone;
  cell.delegate=self;
  if(!childrenAreSelected && !node.isSelected) {
    cell.size.hidden = YES;
  } else {
    cell.size.hidden = NO;
  }
  if(node.backgroundColor){
      cell.subContentView.backgroundColor = [UIColor colorWithHexString:node.backgroundColor];
  } else {
      cell.backgroundColor = [UIColor clearColor];
  }
  if(node.textColor) {
      cell.valueLabel.textColor =  [UIColor colorWithHexString:node.textColor];
  }
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if([self isIndexPathFeatured:indexPath]) {
        return FEATURED_CELL_HEIGHT;
    }
    return CELL_HEIGHT;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  TreeNode *node = [[treeNode flattenElements] objectAtIndex:indexPath.row + 1];

  DLog(@"%d", node.category_id);
  UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  DLog(@"%d", cell.isSelected);

  if (!node.hasChildren) return;

  node.inclusive = !node.inclusive;
  [treeNode flattenElementsWithCacheRefresh:YES];
  [tableView reloadData];
}

-(BOOL) isIndexPathFeatured:(NSIndexPath*)indexPath {
  TreeNode *node = [[treeNode flattenElements] objectAtIndex:indexPath.row + 1];

  BOOL isFeatured = NO;

  if(!node.parent.hasFeaturedChildren)
    return NO;

  if(node.isFeatured)
    previousNodeWasFeatured = YES;
  
  if(!node.isFeatured && !featuredBeginningIndexPathRow && previousNodeWasFeatured)
    featuredBeginningIndexPathRow = indexPath.row;

  if(featuredBeginningIndexPathRow && indexPath.row == featuredBeginningIndexPathRow)
    isFeatured = YES;

  return isFeatured;
}


-(void)setTreeViewFont:(UIFont *)font
{
//    NSLog(@"%@",font);
    treeViewFont = font;
    [self reloadData];
}
-(BOOL)CellChecked:(BOOL)value andCell:(UITableViewCell *)cell
{
    NSIndexPath *indexPath = [self indexPathForCell:cell];
    TreeNode *node = [[treeNode flattenElements] objectAtIndex:indexPath.row + 1];
    if(!node.isTerritory)
    {
        node.isSelected=!value;
        [self setChildrenNodesTo:node];
        if(node.isSelected) {
            [selectedArray removeObject:node];
            [selectedArray addObject:node];
        } else {
          node.size = 0;
          [selectedArray removeObject:node];
          NSArray *unselectedParents = [node unselectParents];
          for(TreeNode *parent in unselectedParents) {
            [selectedArray removeObject:parent];
          }
        }
         NSString *size = [self sizeOfSelected];
         sizeChangedBlock( [NSString stringWithFormat:@"%@ %@",size,@"Chosen"]);
         [self reloadData];
    }
    return node.isSelected;
}

- (void)MyParentsSize:(TreeNode *)node {
    NSSet *mediaResources = [NSSet new];
    if(node.parent) {
        mediaResources = [self findSelectedChildNodes:node];
    }
    if(node.isTerritory) {
        node.size = [self territorySize:node];
    } else {
        int64_t out = 0;
        for(MediaLite *med in mediaResources) {
            out = out + [[med size] longLongValue];
        }
        node.size = out;
    }
    if(node.parent) {
        [self MyParentsSize:node.parent];
    }
}
- (int64_t)groupSize:(TreeNode *)node {
    int64_t out = 0;
    NSSet *mediaResources = [NSSet new];
    for(TreeNode *toad in node.children) {
        mediaResources = [mediaResources setByAddingObjectsFromSet:[self findSelectedChildNodes:toad]];
    }
    for(MediaLite *med in mediaResources) {
        out = out + [[med size] longLongValue];
    }
    if(out > 0) {
        ContentGroup *group = [ContentGroup fetchById:node.category_id fromContext:[AppDataRoomService sharedInstance].uiContext];
        out = out + group.thumbSizesForCategoriesAndMediaValue;
    }
    return out;
}
- (int64_t)categorySize:(TreeNode *)node {
    int64_t out = 0;
    NSSet *mediaResources = [NSSet new];
    if(node.isSelected||[[NSUserDefaults standardUserDefaults] boolForKey:@"showTwiddleDownScreenSizeAlways"]) {
        mediaResources = [mediaResources setByAddingObjectsFromSet:[Category fetchSetOfMediasForCategoryAndSubcategories:[Category fetchById:node.category_id fromContext:[AppDataRoomService sharedInstance].uiContext]]];
    } else {
        mediaResources = [mediaResources setByAddingObjectsFromSet:[self findSelectedChildNodes:node]];
    }
    for(MediaLite *med in mediaResources) {
        out = out + [[med size] longLongValue];
    }
    return out;
}

- (bool)hasSelectedChild:(TreeNode *)node {
  bool retVal = NO;
  for(TreeNode *childnode in node.children) {
    if(childnode.isSelected) {
      retVal = YES;
      break;
    } else {
      retVal = [self hasSelectedChild:childnode];
      if(retVal) {
        break;
      }
    }
  }
  return retVal;
}

- (int64_t)territorySize:(TreeNode *)node {
    int64_t out = 0;
    NSSet *mediaResources = [NSSet new];
    NSMutableSet *mutableSet = [NSMutableSet new];
    for(TreeNode *groups in node.children) {
        mediaResources = [mediaResources setByAddingObjectsFromSet:[self findSelectedChildNodes:groups]];
    }
    for(ContentGroup *group in mutableSet) {
        out = out + group.thumbSizesForCategoriesAndMediaValue;
    }
    for(MediaLite *med in mediaResources) {
        out = out + [[med size] longLongValue];
    }
    return out;
}
- (NSSet *)findSelectedChildNodes:(TreeNode *)node {
    NSSet *mediaResources = [NSSet new];
        for(TreeNode *toad in node.children) {
            if(toad.isSelected) {
                mediaResources = [mediaResources setByAddingObjectsFromSet:[Category fetchSetOfMediasForCategoryAndSubcategories:[Category fetchById:toad.category_id fromContext:[AppDataRoomService sharedInstance].uiContext]]];
            } else {
                mediaResources = [mediaResources setByAddingObjectsFromSet:[self findSelectedChildNodes:toad]];
            }
        }
        if(node.isSelected) {
            mediaResources = [mediaResources setByAddingObjectsFromSet:[Category fetchSetOfMediasForCategoryAndSubcategories:[Category fetchById:node.category_id fromContext:[AppDataRoomService sharedInstance].uiContext]]];
        }
    return mediaResources;
}

- (void)setChildrenNodesTo:(TreeNode *)NodeForConvert {
    for(TreeNode *node in NodeForConvert.children) {
        node.isSelected=NodeForConvert.isSelected;
        if(NodeForConvert.isSelected) {
            [selectedArray addObject:node];
        } else {
            node.size = 0;
            [selectedArray removeObject:node];
        }
        if(node.hasChildren) {
            [self setChildrenNodesTo:node];
        }
    }
}

-(NSMutableArray *)getSelectedValue
{  
    NSMutableArray *retArray = [NSMutableArray new];
    for(TreeNode *node in selectedArray) {
        [retArray addObject:[NSString stringWithFormat:@"%d",node.category_id ]];
    }
    return retArray;
}


- (NSString *)sizeOfSelected {
    int64_t sizeOfCategories = 0;
    NSSet *mediaResources = [NSSet new];
    NSMutableSet *chosengroups = [NSMutableSet new];
    for(TreeNode *node in selectedArray) {
        if(!node.isGroup&&!node.isTerritory) {
          Category *cat = [Category fetchById:node.category_id fromContext:[AppDataRoomService sharedInstance].uiContext];
          if(cat.group) {
            [chosengroups addObject:cat.group];
          }
          if(cat.litemedias) {
            mediaResources = [mediaResources setByAddingObjectsFromSet:cat.litemedias];
          }
        }
    }

    for(MediaLite *med in mediaResources) {
        sizeOfCategories = sizeOfCategories + [[med size] longLongValue];
    }
    for(ContentGroup *group in chosengroups) {
        sizeOfCategories = sizeOfCategories + group.thumbSizesForCategoriesAndMediaValue;
    }
    double convertedValue = (double) sizeOfCategories;

    return [StringHelper downloadSizeForBytes:convertedValue];
}

- (double)sizeOfSelectNumber {
    int64_t sizeOfCategories = 0;
    NSSet *mediaResources = [NSSet new];
    NSMutableSet *chosengroups = [NSMutableSet new];
    int categoryCount = 0;
    for(TreeNode *node in selectedArray) {
      if (!node.isGroup && !node.isTerritory) {
        categoryCount++;
        Category *cat = [Category fetchById:node.category_id fromContext:[AppDataRoomService sharedInstance].uiContext];
        [chosengroups addObject:cat.group];
        mediaResources = [mediaResources setByAddingObjectsFromSet:cat.litemedias];
      }
    }
    DLog(@"Found %d categories in tree", categoryCount);
    for(MediaLite *med in mediaResources) {
        sizeOfCategories = sizeOfCategories + [[med size] longLongValue];
    }
    DLog(@"Category Size: %d", sizeOfCategories);
    for(ContentGroup *group in chosengroups) {
        sizeOfCategories+=group.thumbSizesForCategoriesAndMediaValue;
    }
    double convertedValue = (double) sizeOfCategories;

    return convertedValue;
}

-(void) reloadData{
  self.featuredBeginningIndexPathRow = nil;
  previousNodeWasFeatured = NO;
  [super reloadData];
}

@end
