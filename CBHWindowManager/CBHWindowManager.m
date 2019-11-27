//  CBHWindowManager.m
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

#import "CBHWindowManager.h"

#import "_CBHWindowManagerContainer.h"


NS_ASSUME_NONNULL_BEGIN

@interface CBHWindowManager ()
{
	NSMutableDictionary<NSString *, _CBHWindowManagerContainer *> *_byKey;
	NSMutableDictionary<NSValue *, _CBHWindowManagerContainer *> *_byWindow;
	NSMutableDictionary<NSValue *, _CBHWindowManagerContainer *> *_byController;
}


#pragma mark - Container Management

- (void)manageContainer:(_CBHWindowManagerContainer *)container;
- (void)unmanageContainer:(_CBHWindowManagerContainer *)container;


#pragma mark - Notification Handlers

- (void)windowWillClose:(NSNotification *)notification;

@end

NS_ASSUME_NONNULL_END


@implementation CBHWindowManager

#pragma mark - Singleton

+ (instancetype)sharedManager
{
	static CBHWindowManager *sharedManager = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedManager = [[self alloc] init];
	});
	return sharedManager;
}


#pragma mark - Initialization

- (instancetype)init
{
	if ( (self = [super init]) )
	{
		_byKey = [[NSMutableDictionary alloc] init];
		_byWindow = [[NSMutableDictionary alloc] init];
		_byController = [[NSMutableDictionary alloc] init];
	}

	return self;
}


#pragma mark - Deallocation

- (void)dealloc
{
	[_byWindow enumerateKeysAndObjectsUsingBlock:^(NSValue *key, _CBHWindowManagerContainer *container, BOOL *stop) {
		[[NSNotificationCenter defaultCenter] removeObserver:self name:NSWindowWillCloseNotification object:[container window]];
	}];
}


#pragma mark - Window Management

- (void)manageWindow:(NSWindow *)window
{
	[self manageWindow:window shouldRelease:YES];
}

- (void)manageWindow:(NSWindow *)window shouldRelease:(BOOL)shouldRelease
{
	[self manageContainer:[_CBHWindowManagerContainer containerWithWindow:window controller:nil key:nil andShouldReleaseOnClose:shouldRelease]];
}

- (void)manageWindow:(NSWindow *)window withKey:(NSString *)key
{
	[self manageWindow:window withKey:key shouldRelease:YES];
}

- (void)manageWindow:(NSWindow *)window withKey:(NSString *)key shouldRelease:(BOOL)shouldRelease
{
	[self manageContainer:[_CBHWindowManagerContainer containerWithWindow:window controller:nil key:key andShouldReleaseOnClose:shouldRelease]];
}


- (void)unmanageWindow:(NSWindow *)window
{
	_CBHWindowManagerContainer *container = [_byWindow objectForKey:[NSValue valueWithNonretainedObject:window]];
	if ( !container ) { return; }

	[self unmanageContainer:container];
}


#pragma mark - Controller Management

- (void)manageController:(NSWindowController *)controller
{
	[self manageController:controller shouldRelease:YES];
}

- (void)manageController:(NSWindowController *)controller shouldRelease:(BOOL)shouldRelease
{
	NSWindow *window = [controller window];
	[self manageContainer:[_CBHWindowManagerContainer containerWithWindow:window controller:controller key:nil andShouldReleaseOnClose:shouldRelease]];
}

- (void)manageController:(NSWindowController *)controller withKey:(NSString *)key
{
	[self manageController:controller withKey:key shouldRelease:YES];
}

- (void)manageController:(NSWindowController *)controller withKey:(NSString *)key shouldRelease:(BOOL)shouldRelease
{
	NSWindow *window = [controller window];
	[self manageContainer:[_CBHWindowManagerContainer containerWithWindow:window controller:controller key:key andShouldReleaseOnClose:shouldRelease]];
}


- (void)unmanageController:(NSWindowController *)controller
{
	_CBHWindowManagerContainer *container = [_byController objectForKey:[NSValue valueWithNonretainedObject:controller]];
	if ( !container ) { return; }

	[self unmanageContainer:container];
}


#pragma mark - Container Management

- (void)manageContainer:(_CBHWindowManagerContainer *)container
{
	[_byWindow setObject:container forKey:[container windowKey]];
	
	if ( [container controllerKey] != nil ) { [_byController setObject:container forKey:[container controllerKey]]; }
	if ( [container key] != nil ) { [_byKey setObject:container forKey:[container key]]; }

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowWillClose:) name:NSWindowWillCloseNotification object:[container window]];
}

- (void)unmanageContainer:(_CBHWindowManagerContainer *)container
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:NSWindowWillCloseNotification object:[container window]];
	[_byWindow removeObjectForKey:[container windowKey]];

	NSValue *controllerKey = [container controllerKey];
	if ( controllerKey ) { [_byController removeObjectForKey:controllerKey]; }

	NSString *key = [container key];
	if ( key ) { [_byKey removeObjectForKey:key]; }
}


#pragma mark - Notification Handlers

- (void)windowWillClose:(NSNotification *)notification
{
	NSWindow *window = (NSWindow *)[notification object];
	if ( !window ) { return; }
	if ( ![window isKindOfClass:[NSWindow class]] ) { return; }

	_CBHWindowManagerContainer *container = [_byWindow objectForKey:[NSValue valueWithNonretainedObject:window]];
	if ( !container ) { return; }
	if ( ![container shouldReleaseOnClose] ) { return; }

	[self unmanageContainer:container];
}


#pragma mark - Queries

- (NSWindowController *)controllerForKey:(NSString *)key
{
	_CBHWindowManagerContainer *container = [_byKey objectForKey:key];
	if ( !container ) { return nil; }

	return [container controller];
}

- (NSWindowController *)controllerForWindow:(NSWindow *)window
{
	_CBHWindowManagerContainer *container = [_byWindow objectForKey:[NSValue valueWithNonretainedObject:window]];
	if ( !container ) { return nil; }

	return [container controller];
}

- (NSWindow *)windowForKey:(NSString *)key
{
	_CBHWindowManagerContainer *container = [_byKey objectForKey:key];
	if ( !container ) { return nil; }

	return [container window];
}


- (BOOL)isManagingController:(NSWindowController *)controller
{
	return ( [_byController objectForKey:[NSValue valueWithNonretainedObject:controller]] != nil );
}

- (BOOL)isManagingWindow:(NSWindow *)window
{
	return ( [_byWindow objectForKey:[NSValue valueWithNonretainedObject:window]] != nil );
}

- (BOOL)isManagingWithKey:(NSString *)key
{
	return ( [_byKey objectForKey:key] != nil );
}

@end
