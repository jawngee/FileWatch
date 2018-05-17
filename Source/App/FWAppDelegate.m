//
//  AppDelegate.m
//  FileWatch
//
//  Created by Jon Gilkison on 5/17/18.
//  Copyright © 2018 Jon Gilkison. All rights reserved.
//

#import "FWAppDelegate.h"
#import "FWItemManager.h"
#import "NSMenuItem+FWItem.h"

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
    [self processItems:itemManager.items forMenu:itemsMenu];
    
    if (itemManager.items.count > 0) {
        [itemsMenu addItem:NSMenuItem.separatorItem];
    }
    
    [itemsMenu addItemWithTitle:@"Reload Config ..." action:@selector(reloadConfig:) keyEquivalent:@""];
    [itemsMenu addItem:NSMenuItem.separatorItem];
    [itemsMenu addItemWithTitle:@"Edit Configuration ..." action:@selector(editConfig:) keyEquivalent:@""];
    [itemsMenu addItemWithTitle:@"Open Config Directory ..." action:@selector(openConfigDir:) keyEquivalent:@""];
    [itemsMenu addItem:NSMenuItem.separatorItem];
    [itemsMenu addItemWithTitle:@"Quit" action:@selector(terminate:) keyEquivalent:@""];
    
    statusItem.menu = itemsMenu;
}

-(void)processItems:(NSArray<FWItem *> *)items forMenu:(NSMenu *)menu {
    for(NSInteger i=0; i<items.count; i++) {
        FWItem *item = items[i];
        if ([item.title isEqualToString:@"-"]) {
            [menu addItem:NSMenuItem.separatorItem];
        } else if (item.items.count == 0) {
            NSMenuItem *menuItem = [menu addItemWithTitle:item.title action:(item.enabled) ? @selector(itemSelected:) : nil keyEquivalent:@""];
            menuItem.tag = i;
            menuItem.fileWatchItem = item;
            item.objTag = menuItem;
        } else {
            NSMenuItem *submenuItem = [menu addItemWithTitle:item.title action:nil keyEquivalent:@""];
            NSMenu *submenu = [NSMenu new];
            [self processItems:item.items forMenu:submenu];
            [submenuItem setSubmenu:submenu];
        }
    }
}

#pragma mark - Actions

-(void)itemSelected:(NSMenuItem *)menuItem {
    FWItem *item = menuItem.fileWatchItem;
    
    if (item) {
        [item run];
    }
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

-(void)editConfig:(NSMenuItem *)menuItem {
    NSString *homeDir = NSHomeDirectory();
    NSURL *itemsDataURL = [[NSURL fileURLWithPath:homeDir] URLByAppendingPathComponent:@".filewatch/config.json"];
    if ([NSFileManager.defaultManager fileExistsAtPath:itemsDataURL.path]) {
        [NSWorkspace.sharedWorkspace openURL:itemsDataURL];
    }
}

#pragma mark - FWItemManagerDelegate

-(void)itemScriptStarted:(FWItem *)item {
    if (item.objTag && ([item.objTag isKindOfClass:NSMenuItem.class])) {
        ((NSMenuItem *)item.objTag).image = [NSImage imageNamed:@"icon-play"];
        
        NSUserNotification *notification = [NSUserNotification new];
        notification.title = [NSString stringWithFormat:@"Started '%@' ...", item.title];
        [NSUserNotificationCenter.defaultUserNotificationCenter deliverNotification:notification];
    }
}

-(void)itemScriptFinished:(FWItem *)item exitCode:(NSInteger)exitCode {
    if (item.objTag && ([item.objTag isKindOfClass:NSMenuItem.class])) {
        ((NSMenuItem *)item.objTag).image = (exitCode == 0) ? nil : [NSImage imageNamed:@"icon-error"];

        NSUserNotification *notification = [NSUserNotification new];
        notification.title = [NSString stringWithFormat:@"Finished '%@'.", item.title];
        [NSUserNotificationCenter.defaultUserNotificationCenter deliverNotification:notification];
    }
}


@end
