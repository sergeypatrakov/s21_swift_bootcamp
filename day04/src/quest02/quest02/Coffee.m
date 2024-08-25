//
//  Coffee.m
//  quest02
//
//  Created by Sergey Patrakov on 25.08.2024.
//

#import <Foundation/Foundation.h>
#import "Coffee.h"

@implementation Coffee

- (instancetype)initWithName:(NSString *)name andPrice:(float)price {
    self = [super init];
    if (self) {
        _name = name;
        _price = price;
    }
    return self;
}

@end
