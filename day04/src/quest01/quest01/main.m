//
//  main.m
//  quest01
//
//  Created by Sergey Patrakov on 25.08.2024.
//

#import <Foundation/Foundation.h>
#import "Coffee.h"
#import "Barista.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSArray *menu = @[
            [[Coffee alloc] initWithName:@"Cappuccino" andPrice:2.0],
            [[Coffee alloc] initWithName:@"Americano" andPrice:1.5],
            [[Coffee alloc] initWithName:@"Latte" andPrice:2.3]
        ];
        
        NSLog(@"Choose coffee in menu:");
        for (int i = 0; i < menu.count; i++) {
            Coffee *coffee = menu[i];
            NSLog(@"%d. %@ $%.2f", i + 1, coffee.name, coffee.price);
        }

        NSLog(@"");
        
        char input[256];
        fgets(input, sizeof(input), stdin);

        NSString *userInput = [NSString stringWithUTF8String:input];
        userInput = [userInput stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        NSInteger choice = [userInput integerValue];

        if (choice > 0 && choice <= menu.count) {
            Coffee *chosenCoffee = menu[choice - 1];

            Barista *barista = [[Barista alloc] initWithFirstName:@"John" lastName:@"Doe" andExperienceYears:5];
            [barista brew:chosenCoffee];
        } else {
            NSLog(@"Try again!");
        }
    }
    return 0;
}
