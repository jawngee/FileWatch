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
#import "DDHotKeyCenter.h"

@interface FWAppDelegate()<FWItemManagerDelegate> {
    FWItemManager *itemManager;
    NSStatusItem *statusItem;
}

@property (weak) IBOutlet NSWindow *window;

@end

@implementation FWAppDelegate

#pragma mark - NSApplicationDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    itemManager = [FWItemManager new];
    itemManager.delegate = self;
    
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
    statusItem.image = [NSImage imageNamed:@"icon-eye"];
    
    if (itemManager.loaded) {
        [self buildMenu];
    } else {
        [self installDefault];
    }
}

#pragma mark - Item Processing

-(void)buildMenu {
    [DDHotKeyCenter.sharedHotKeyCenter unregisterAllHotKeys];
    
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
    menu.autoenablesItems = NO;
    
    for(NSInteger i=0; i<items.count; i++) {
        FWItem *item = items[i];
        if ([item.title isEqualToString:@"-"]) {
            [menu addItem:NSMenuItem.separatorItem];
        } else if (item.items.count == 0) {
            NSMenuItem *menuItem = [menu addItemWithTitle:item.title action:@selector(itemSelected:) keyEquivalent:@""];
            menuItem.fileWatchItem = item;
            menuItem.enabled = item.enabled;
            item.objTag = menuItem;
            
            if (item.watch) {
                menuItem.image = [NSImage imageNamed:@"icon-eye-small"];
            }
            
            if (item.hotKey && item.hotKey.key) {
                menuItem.keyEquivalent = item.hotKey.key;
                if (item.hotKey.modifiers != 0) {
                    menuItem.keyEquivalentModifierMask = item.hotKey.modifiers;
                }
                
                [DDHotKeyCenter.sharedHotKeyCenter registerHotKeyWithKeyCode:item.hotKey.keyCode
                                                               modifierFlags:item.hotKey.modifiers
                                                                      target:item
                                                                      action:@selector(hotkey:)
                                                                      object:item
                                                                       error:nil];
            }
        } else {
            NSMenuItem *submenuItem = [menu addItemWithTitle:item.title action:nil keyEquivalent:@""];
            submenuItem.image = [NSImage imageNamed:@"icon-folder"];
            NSMenu *submenu = [NSMenu new];
            [self processItems:item.items forMenu:submenu];
            [submenuItem setSubmenu:submenu];
        }
    }
}

-(void)installDefault {
    NSString *homeDir = NSHomeDirectory();
    NSURL *filewatchDir = [[NSURL fileURLWithPath:homeDir] URLByAppendingPathComponent:@".filewatch/"];
    NSURL *scriptsDir = [filewatchDir URLByAppendingPathComponent:@"scripts"];
    [NSFileManager.defaultManager createDirectoryAtURL:scriptsDir
                           withIntermediateDirectories:YES
                                            attributes:nil
                                                 error:nil];
    
    [NSFileManager.defaultManager copyItemAtURL:[NSBundle.mainBundle URLForResource:@"sample-config" withExtension:@"json"]
                                          toURL:[filewatchDir URLByAppendingPathComponent:@"config.json"]
                                          error:nil];

    [NSFileManager.defaultManager copyItemAtURL:[NSBundle.mainBundle URLForResource:@"sample-script-1" withExtension:@"sh"]
                                          toURL:[scriptsDir URLByAppendingPathComponent:@"sample-script-1.sh"]
                                          error:nil];

    [NSFileManager.defaultManager copyItemAtURL:[NSBundle.mainBundle URLForResource:@"sample-script-2" withExtension:@"sh"]
                                          toURL:[scriptsDir URLByAppendingPathComponent:@"sample-script-2.sh"]
                                          error:nil];
    
    [NSFileManager.defaultManager setAttributes:@{NSFilePosixPermissions: @0755}
                                   ofItemAtPath:[scriptsDir URLByAppendingPathComponent:@"sample-script-1.sh"].path
                                          error:nil];

    [NSFileManager.defaultManager setAttributes:@{NSFilePosixPermissions: @0755}
                                   ofItemAtPath:[scriptsDir URLByAppendingPathComponent:@"sample-script-2.sh"].path
                                          error:nil];
    
    [@"Edit me\n" writeToURL:[filewatchDir URLByAppendingPathComponent:@"sample-1.txt"]
                atomically:NO
                  encoding:NSUTF8StringEncoding
                     error:nil];

    [@"Edit me\n" writeToURL:[filewatchDir URLByAppendingPathComponent:@"sample-2.txt"]
                atomically:NO
                  encoding:NSUTF8StringEncoding
                     error:nil];
    
    if ([itemManager reload]) {
        [self buildMenu];
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
    if ([itemManager reload]) {
        [self buildMenu];
    }
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
        if (exitCode != 0) {
            ((NSMenuItem *)item.objTag).image = [NSImage imageNamed:@"icon-error"];
        } else if (item.watch) {
            ((NSMenuItem *)item.objTag).image = [NSImage imageNamed:@"icon-eye-small"];
        }

        NSUserNotification *notification = [NSUserNotification new];
        notification.title = [NSString stringWithFormat:@"Finished '%@'.", item.title];
        [NSUserNotificationCenter.defaultUserNotificationCenter deliverNotification:notification];
    }
}

-(void)itemManagerReloaded:(FWItemManager *)manager {
    [self buildMenu];
}


@end
