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

#pragma mark - Shared Manager

/**
 * @name Shared Manager
 */

/**
 * Global accessor for the shared window manager.
 *
 * @return              The shared window manager.
 */
+ (instancetype)sharedManager;


#pragma mark - Window Management

/**
 * @name Window Management
 */

/** Have the receiver manage the given window.
 *
 * @param window        The window to manage.
 */
- (void)manageWindow:(NSWindow *)window;

/** Have the receiver manage the given window while indicating if the receiver should release the window when closed.
 *
 * @param window        The window to manage.
 * @param shouldRelease Should the window be released when its close?
 */
- (void)manageWindow:(NSWindow *)window shouldRelease:(BOOL)shouldRelease;

/** Have the receiver manage the given window while having it accessible by a given key.
 *
 * @param window        The window to manage.
 * @param key           The key by which the window is accessible by.
 */
- (void)manageWindow:(NSWindow *)window withKey:(NSString *)key;

/** Have the receiver manage the given window while having it accessible by a given key and indicating if the receiver should release the window when closed.
 *
 * @param window        The window to manage.
 * @param key           The key by which the window is accessible by.
 * @param shouldRelease Should the window be released when its close?
 */
- (void)manageWindow:(NSWindow *)window withKey:(NSString *)key shouldRelease:(BOOL)shouldRelease;

/** Stop managing the given window.
 *
 * @param window        The window to manage.
 */
- (void)unmanageWindow:(NSWindow *)window;


#pragma mark - Controller Management

/**
 * @name Controller Management
 */

/** Have the receiver manage the given window controller and its window.
 *
 * @param controller    The window controller to manage.
 */
- (void)manageController:(NSWindowController *)controller;

/** Have the receiver manage the given window controller and its window while indicating if the receiver should release the controller and window when closed.
 *
 * @param controller    The window controller to manage.
 * @param shouldRelease Should the window be released when its close?
 */
- (void)manageController:(NSWindowController *)controller shouldRelease:(BOOL)shouldRelease;

/** Have the receiver manage the given window controller and its window while having it accessible by a given key.
 *
 * @param controller    The window controller to manage.
 * @param key           The key by which the window controller is accessible by.
 */
- (void)manageController:(NSWindowController *)controller withKey:(NSString *)key;

/** Have the receiver manage the given window controller and its window while having it accessible by a given key and indicating if the receiver should release the window when closed.
 *
 * @param controller    The window to manage.
 * @param key           The key by which the window controller is accessible by.
 * @param shouldRelease Should the window be released when its close?
 */
- (void)manageController:(NSWindowController *)controller withKey:(NSString *)key shouldRelease:(BOOL)shouldRelease;

/** Stop managing the given window controller and window.
 *
 * @param controller    The window to manage.
 */
- (void)unmanageController:(NSWindowController *)controller;


#pragma mark - Queries

/** Have the receiver retrieve the managed window controller for a given key.
 *
 * @param key           The key for the window controller to requested.
 *
 * @return              The requested window controller or `nil` if not found.
 */
- (nullable NSWindowController *)controllerForKey:(NSString *)key;

/** Have the receiver retrieve the managed window controller for a given window.
 *
 * @param window        The window for the requested controller.
 *
 * @return              The requested window controller or `nil` if not found.
 */
- (nullable NSWindowController *)controllerForWindow:(NSWindow *)window;

/** Have the receiver retrieve the managed window for a given key.
 *
 * @param key           The key for the window requested.
 *
 * @return              The requested window controller or `nil` if not found.
 */
- (nullable NSWindow *)windowForKey:(NSString *)key;


/** Check is the given window controller is managed by the receiver.
 *
 * @param controller    The window controller to check for.
 *
 * @return              Whether the given window controller is managed by the receiver.
 */
- (BOOL)isManagingController:(NSWindowController *)controller;

/** Check if the given window is managed by the receiver.
 *
 * @param window        The window to check for.
 *
 * @return              Whether the given window is managed by the receiver.
 */
- (BOOL)isManagingWindow:(NSWindow *)window;

/** Check if the given key manages a window or window controller.
 *
 * @param key           The key for check for.
 *
 * @return              Whether the given key is associated with a window or window controller thats managed by the receiver.
 */
- (BOOL)isManagingWithKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
