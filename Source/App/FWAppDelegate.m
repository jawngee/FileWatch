//
//  AppDelegate.m
//  FileWatch
//
//  Created by Jon Gilkison on 5/17/18.
//  Copyright © 2018 Jon Gilkison. All rights reserved.
//

#import "FWAppDelegate.h"
#import "FWItemManager.h"

@interface FWAppDelegate()<FWItemManagerDelegate> {
    FWItemManager *itemManager;
    NSStatusItem *statusItem;
}

@property (weak) IBOutlet NSWindow *window;

@end

@implementation FWAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    itemManager = [FWItemManager new];
    itemManager.delegate = self;
    
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
    statusItem.image = [NSImage imageNamed:@"icon-folder"];
    
    [self buildMenu];
}

-(void)buildMenu {
    NSMenu *itemsMenu = [NSMenu new];
    for(NSInteger i=0; i<itemManager.items.count; i++) {
        FWItem *item = itemManager.items[i];
        if ([item.title isEqualToString:@"-"]) {
            [itemsMenu addItem:NSMenuItem.separatorItem];
        } else {
            NSMenuItem *menuItem = [itemsMenu addItemWithTitle:item.title action:(item.enabled) ? @selector(itemSelected:) : nil keyEquivalent:@""];
            menuItem.tag = i;
            item.objTag = menuItem;
        }
    }
    
    if (itemManager.items.count > 0) {
        [itemsMenu addItem:NSMenuItem.separatorItem];
    }
    
    [itemsMenu addItemWithTitle:@"Reload Config ..." action:@selector(reloadConfig:) keyEquivalent:@""];
    [itemsMenu addItemWithTitle:@"Open Config Directory ..." action:@selector(openConfigDir:) keyEquivalent:@""];
    [itemsMenu addItem:NSMenuItem.separatorItem];
    [itemsMenu addItemWithTitle:@"Quit" action:@selector(terminate:) keyEquivalent:@""];
    
    statusItem.menu = itemsMenu;
}

#pragma mark - Actions

-(void)itemSelected:(NSMenuItem *)menuItem {
    FWItem *item = itemManager.items[menuItem.tag];
    [item run];
}

-(void)reloadConfig:(NSMenuItem *)menuItem {
    [itemManager reload];
    [self buildMenu];
}

-(void)openConfigDir:(NSMenuItem *)menuItem {
    NSString *homeDir = NSHomeDirectory();
    NSURL *itemsDataURL = [[NSURL fileURLWithPath:homeDir] URLByAppendingPathComponent:@".filewatch/"];
    if (![NSFileManager.defaultManager fileExistsAtPath:itemsDataURL.path]) {
        [NSFileManager.defaultManager createDirectoryAtPath:itemsDataURL.path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    [NSWorkspace.sharedWorkspace openURL:itemsDataURL];
}

#pragma mark - FWItemManagerDelegate

-(void)itemScriptStarted:(FWItem *)item {
    if (item.objTag && ([item.objTag isKindOfClass:NSMenuItem.class])) {
        ((NSMenuItem *)item.objTag).image = [NSImage imageNamed:@"icon-play"];
    }
}

-(void)itemScriptFinished:(FWItem *)item exitCode:(NSInteger)exitCode {
    if (item.objTag && ([item.objTag isKindOfClass:NSMenuItem.class])) {
        ((NSMenuItem *)item.objTag).image = (exitCode == 0) ? nil : [NSImage imageNamed:@"icon-error"];
    }
}


@end
