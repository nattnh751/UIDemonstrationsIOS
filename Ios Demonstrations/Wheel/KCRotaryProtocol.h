//
//  KCRotaryProtocol.h
//  AppDataRoom
//
//  Created by Nathan Walsh on 1/4/19.
//

#import <Foundation/Foundation.h>

@protocol KCRotaryProtocol <NSObject>

- (void) wheelDidChangeValue:(NSString *)newValue;

@end
