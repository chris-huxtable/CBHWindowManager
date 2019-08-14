//  CBHWindowManager.h
//  CBHWindowManager
//
//  Created by Christian Huxtable <chris@huxtable.ca>, April 2019.
//  Copyright (c) 2019 Christian Huxtable. All rights reserved.
//
//  Permission to use, copy, modify, and/or distribute this software for any
//  purpose with or without fee is hereby granted, provided that the above
//  copyright notice and this permission notice appear in all copies.
//
//  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
//  WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
//  MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
//  ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
//  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
//  ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
//  OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

@import Foundation;

FOUNDATION_EXPORT double CBHWindowManagerVersionNumber;
FOUNDATION_EXPORT const unsigned char CBHWindowManagerVersionString[];

@import AppKit.NSWindow;
@import AppKit.NSWindowController;


NS_ASSUME_NONNULL_BEGIN

@interface CBHWindowManager : NSObject


#pragma mark - Singleton

+ (instancetype)sharedManager;


#pragma mark - Initialization

- (instancetype)init;


#pragma mark - Window Management

- (void)manageWindow:(NSWindow *)window;
- (void)manageWindow:(NSWindow *)window shouldRelease:(BOOL)shouldRelease;

- (void)manageWindow:(NSWindow *)window withKey:(NSString *)key;
- (void)manageWindow:(NSWindow *)window withKey:(NSString *)key shouldRelease:(BOOL)shouldRelease;

- (void)unmanageWindow:(NSWindow *)window;


#pragma mark - Controller Management

- (void)manageController:(NSWindowController *)controller;
- (void)manageController:(NSWindowController *)controller shouldRelease:(BOOL)shouldRelease;

- (void)manageController:(NSWindowController *)controller withKey:(NSString *)key;
- (void)manageController:(NSWindowController *)controller withKey:(NSString *)key shouldRelease:(BOOL)shouldRelease;

- (void)unmanageController:(NSWindowController *)controller;


#pragma mark - Queries

- (nullable NSWindowController *)controllerForKey:(NSString *)key;
- (nullable NSWindowController *)controllerForWindow:(NSWindow *)window;

- (nullable NSWindow *)windowForKey:(NSString *)key;


- (BOOL)isManagingController:(NSWindowController *)controller;
- (BOOL)isManagingWindow:(NSWindow *)window;

@end

NS_ASSUME_NONNULL_END
