//
//  TreeView.h
//  TreeView
//
//  Created by Varun Naharia on 26/08/15.
//  
//

#import <UIKit/UIKit.h>
#import "TreeNode.h"
#import "TreeViewCell.h"


@interface TreeView : UITableView<UITableViewDataSource,UITableViewDelegate,CellSelectedDelegate>{
    TreeNode *treeNode;
}

@property(nonatomic,retain)NSMutableArray *cat;
@property(nonatomic,retain)UIFont *treeViewFont;
@property(nonatomic,retain)NSMutableArray *selectedArray;

@property(nonatomic) BOOL initialized;

@property(nonatomic) NSInteger featuredBeginningIndexPathRow;

@property(nonatomic) BOOL previousNodeWasFeatured;

-(id)initWithFrame:(CGRect)frame andData:(NSMutableDictionary *)dict;

- (id)initWithFrame:(CGRect)rect andData:(void *)data sizeChangedBlock:(void (^)(NSString *))block onInitializedBlock:(void (^)(void))initializedBlock;

- (BOOL)isIndexPathFeatured:(NSIndexPath *)indexPath;

-(void)setTreeViewFont:(UIFont *)font;

-(NSMutableArray *)getSelectedValue;

- (NSString *)sizeOfSelected;

- (double)sizeOfSelectNumber;
@end
