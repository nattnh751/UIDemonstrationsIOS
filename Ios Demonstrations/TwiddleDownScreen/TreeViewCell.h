//
//  TreeViewCell.h
//  TreeViewPrototype
//
//  Created by Varun Naharia on 26/08/15.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@protocol CellSelectedDelegate

- (BOOL *)CellChecked:(BOOL)value andCell:(UITableViewCell *)cell ;

@end

@interface TreeViewCell : UITableViewCell {
	UITextView *valueLabel;
	UIImageView *arrowImage;
	
	int level;
	BOOL expanded;
}

@property (nonatomic, retain) UITextView *valueLabel;
@property (nonatomic, retain) UIImageView *arrowImage;

@property (nonatomic, retain) UIImageView *featuredImage;
@property (nonatomic, retain) UITextView *featuredText;

@property (nonatomic, retain) UIView *underLine;
@property (nonatomic, retain) UITextView *size;
@property(strong)UIButton *cloudImage;
@property (nonatomic) int level;
@property (nonatomic) BOOL expanded;
@property(nonatomic)BOOL isSelected;
@property (nonatomic, assign) id <CellSelectedDelegate> delegate;

@property(nonatomic,retain)UIButton *btnCheck;

@property(nonatomic, strong) UIImageView *cornerImage;

@property(nonatomic, strong) UIView *selectedView;
@property(nonatomic, strong) UIView *subContentView;

@property(nonatomic) bool featured;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier level:(NSUInteger)_level expanded:(BOOL)_expanded isSelected:(BOOL)value hasChildren:(BOOL)_hasChildren size:(int64_t)size1 featured:(bool)feat;

- (void)Checked:(BOOL)value;
@end
