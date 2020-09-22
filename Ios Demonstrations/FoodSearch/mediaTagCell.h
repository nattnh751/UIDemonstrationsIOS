//
//  mediaTagCell.h
//  AppDataRoom
//
//  Created by Nathan Walsh on 10/4/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface mediaTagCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet NSNumber *tagID;
- (void)setCellWidth:(CGFloat) width;
- (void)setParentView:(UIView *) view;
- (void)setXPosition:(UICollectionView *)view;
@end

NS_ASSUME_NONNULL_END
