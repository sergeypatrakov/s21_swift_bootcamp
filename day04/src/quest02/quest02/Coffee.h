//
//  Coffee.h
//  quest02
//
//  Created by Sergey Patrakov on 25.08.2024.
//

#import <Foundation/Foundation.h>

@interface Coffee : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) float price;

- (instancetype)initWithName:(NSString *)name andPrice:(float)price;

@end
