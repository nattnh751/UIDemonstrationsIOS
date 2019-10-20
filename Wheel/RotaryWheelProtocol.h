//
//  KCRotaryProtocol.h
//  AppDataRoom
//
//  Created by Nathan Walsh on 1/4/19.
//

#import <Foundation/Foundation.h>

@protocol RotaryWheelProtocol <NSObject>

- (void) wheelDidChangeValue:(NSString *)newValue;

@end
