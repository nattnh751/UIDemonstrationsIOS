//
//  UIColor+hex.h
//  WhenIWork
//
//  Created by thisclicks on 10/20/11.
//  Copyright 2011 ThisClicks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIColor(hex)

+(UIColor *)colorWithHexString:(NSString *)cssColorCode;

+ (UIColor *)colorWithHexString:(NSString *)cssColorCode alpha:(CGFloat)alpha;

-(NSString *)hexString;

-(BOOL)isWhite;
-(BOOL)isClear;

// white or black depending on approximate Y.
-(UIColor *)contrastingColor;

// small slug image of solid color
-(UIImage *)colorChip:(CGSize)dimensions;

@end
