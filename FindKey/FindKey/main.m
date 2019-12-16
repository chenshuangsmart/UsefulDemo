//
//  main.m
//  FindKey
//
//  Created by chenshuang on 2019/11/25.
//  Copyright © 2019 chenshuang. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AppDelegate.h"

int main(int argc, const char * argv[]) {
//    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        AppDelegate *delegate = [[AppDelegate alloc] init];
        [NSApplication sharedApplication].delegate = delegate;
//    }
    return NSApplicationMain(argc, argv);
}
