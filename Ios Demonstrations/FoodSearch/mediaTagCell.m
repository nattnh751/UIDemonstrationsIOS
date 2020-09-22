//
//  mediaTagCell.m
//  AppDataRoom
//
//  Created by Nathan Walsh on 10/4/18.
//

#import "mediaTagCell.h"
@interface mediaTagCell()
@property (nonatomic, strong) NSLayoutConstraint *cellWidthConstraint;
@property (nonatomic, strong) NSLayoutConstraint *cellHeightConstraint;
@property (nonatomic, strong) NSLayoutXAxisAnchor *cellLeftJustifyInContainer;
@property (nonatomic, strong) NSLayoutConstraint *cellLeftAnchor;

@end

@implementation mediaTagCell
- (void)awakeFromNib {
  [super awakeFromNib];
  self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
                                              [self.contentView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
                                              [self.contentView.rightAnchor constraintEqualToAnchor:self.rightAnchor],
                                              [self.contentView.topAnchor constraintEqualToAnchor:self.topAnchor],
                                              [self.contentView.leftAnchor constraintEqualToAnchor:self.leftAnchor]
                                              ]
     ];
//  self.cellWidthConstraint = [self.contentView.widthAnchor constraintEqualToConstant:0.f];
//  self.cellHeightConstraint = [self.contentView.heightAnchor constraintEqualToConstant:0.f];
//  self.cellHeightConstraint.constant = 30;
//  self.cellHeightConstraint.active = YES;
}
//- (void)setCellWidth:(CGFloat) width {
//    self.cellWidthConstraint.constant = width;
//    self.cellWidthConstraint.active = YES;
//}
@end
