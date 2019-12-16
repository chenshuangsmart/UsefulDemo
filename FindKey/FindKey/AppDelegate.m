//
//  AppDelegate.m
//  FindKey
//
//  Created by chenshuang on 2019/11/25.
//  Copyright © 2019 chenshuang. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"

@interface AppDelegate ()
/** homeVC */
@property(nonatomic, strong)HomeViewController *homeVC;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // window
    NSUInteger style = NSWindowStyleMaskTitled | NSWindowStyleMaskClosable | NSWindowStyleMaskMiniaturizable | NSWindowStyleMaskResizable;
    float width = [[NSScreen mainScreen] frame].size.width * 0.35;
    float height = [[NSScreen mainScreen] frame].size.height * 0.5;
    self.window = [[NSWindow alloc] initWithContentRect:NSMakeRect(0, 0, width, height) styleMask:style backing:NSBackingStoreBuffered defer:NO];
    self.window.title = @"查询未翻译的文案";
    
    // 如果没有这句话，会导致窗口不会显示出来
    [self.window makeKeyAndOrderFront:nil];
    [self.window center];
    
    self.homeVC = [[HomeViewController alloc] init];
    [self.window setContentViewController:self.homeVC];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
