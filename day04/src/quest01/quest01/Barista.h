//
//  Barista.h
//  quest01
//
//  Created by Sergey Patrakov on 25.08.2024.
//

#import <Foundation/Foundation.h>
#import "Coffee.h"

@interface Barista : NSObject

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, assign) int experienceYears;

- (instancetype)initWithFirstName:(NSString *)firstName lastName:(NSString *)lastName andExperienceYears:(int)experienceYears;
- (void)brew:(Coffee *)coffee;

@end
