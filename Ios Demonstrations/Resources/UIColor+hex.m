//
//  UIColor+hex.m
//  WhenIWork
//
//  Created by thisclicks on 10/20/11.
//  Copyright 2011 ThisClicks. All rights reserved.
//

#import "UIColor+hex.h"

@implementation UIColor(hex)

+(UIColor *)colorWithHexString:(NSString *)cssColorCode
{
  cssColorCode = [cssColorCode stringByTrimmingCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789abcdefABCDEF"] invertedSet]];
  if (cssColorCode.length == 0)
    return nil;
  
  NSScanner *scan = [NSScanner scannerWithString:cssColorCode];
  NSUInteger rawrgb = 0, r, g, b;
  if ([scan scanHexInt:&rawrgb])
  {
    r = (rawrgb >> 16) & 0x000000ff;
    g = (rawrgb >> 8) & 0x000000ff;
    b = rawrgb & 0x000000ff;
    return [UIColor colorWithRed:(r/256.0f) green:(g/256.0f) blue:(b/256.0f) alpha:1.0f];
  }
  else
    return nil;
}

+(UIColor *)colorWithHexString:(NSString *)cssColorCode alpha: (CGFloat)alpha
{
  cssColorCode = [cssColorCode stringByTrimmingCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789abcdefABCDEF"] invertedSet]];
  if (cssColorCode.length == 0)
    return nil;

  NSScanner *scan = [NSScanner scannerWithString:cssColorCode];
  NSUInteger rawrgb = 0, r, g, b;
  if ([scan scanHexInt:&rawrgb])
  {
    r = (rawrgb >> 16) & 0x000000ff;
    g = (rawrgb >> 8) & 0x000000ff;
    b = rawrgb & 0x000000ff;
    return [UIColor colorWithRed:(r/256.0f) green:(g/256.0f) blue:(b/256.0f) alpha:alpha];
  }
  else
    return nil;
}

-(NSString *)hexString
{
  CGColorSpaceModel csm = CGColorSpaceGetModel(CGColorGetColorSpace(self.CGColor));
  CGFloat red, green, blue;
  
  if (csm == kCGColorSpaceModelRGB)
  {
    const CGFloat *c = CGColorGetComponents(self.CGColor);
    red = c[0];
    green = c[1];
    blue = c[2];
  }
  else if (csm == kCGColorSpaceModelMonochrome)
  {
    const CGFloat *c = CGColorGetComponents(self.CGColor);
    red = green = blue = c[0];
  }
  else
    red = green = blue = 0.5f; // fallback case

  red = fminf(255, fmaxf(0, red * 256));
  green = fminf(255, fmaxf(0, green * 256));
  blue = fminf(255, fmaxf(0, blue * 256));
  NSString *out = [NSString stringWithFormat:@"%02X%02X%02X", (int)red, (int)green, (int)blue];
  
//  NSLog(@"%@ -> %d %d %d -> %@", self, (int)red, (int)green, (int)blue, out);
  
  return out;
}

-(BOOL)isWhite
{
  CGColorSpaceModel csm = CGColorSpaceGetModel(CGColorGetColorSpace(self.CGColor));
  
  const CGFloat *c = CGColorGetComponents(self.CGColor);
  if (csm == kCGColorSpaceModelRGB)
  {
    return c[0] >= 1.0f && c[1] >= 1.0f && c[2] >= 1.0f;
  }
  else if (csm == kCGColorSpaceModelMonochrome)
  {
    return c[0] >= 1.0f;
  }
  else
    return NO;
}

-(BOOL)isClear
{
  size_t nc = CGColorGetNumberOfComponents(self.CGColor);  
  const CGFloat *c = CGColorGetComponents(self.CGColor);
  return c[nc-1] <= .001f; // alpha is always the last component?
}

-(UIColor *)contrastingColor
{
  CGColorSpaceModel csm = CGColorSpaceGetModel(CGColorGetColorSpace(self.CGColor));
  CGFloat y = 1;
  
  const CGFloat *c = CGColorGetComponents(self.CGColor);
  if (csm == kCGColorSpaceModelRGB)
  {
    y = c[0] * 0.299f + c[1] * 0.587f + c[2] * 0.114f;
  }
  else if (csm == kCGColorSpaceModelMonochrome)
  {
    y = c[0];
  }
  return  y >= 0.33f ? [UIColor blackColor] : [UIColor whiteColor];
}

-(UIImage *)colorChip:(CGSize)dimensions
{
  UIGraphicsBeginImageContextWithOptions(dimensions, YES, 1);
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  CGContextSetFillColorWithColor(ctx, self.CGColor);
  CGContextFillRect(ctx, CGRectMake(0, 0, dimensions.width, dimensions.height));
  UIImage *out = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return out;
}

@end
