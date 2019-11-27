//  CBHWindowManagerTests.m
//  CBHWindowManagerTests
//
//  Created by Christian Huxtable <chris@huxtable.ca>, August 2019.
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

@import XCTest;

@import CBHWindowManager;


#define TEST_KEY @"TestKey"


@interface CBHWindowManagerTests : XCTestCase
{
	NSWindowController *_controller;
	NSWindow *_window;
}

@end

@interface CBHWindowManager (TESTING)

- (void)windowWillClose:(NSNotification *)notification;

@end


@implementation CBHWindowManagerTests

#pragma mark - Overrides

- (void)setUp
{
	NSWindowStyleMask mask = (NSWindowStyleMaskTitled|NSWindowStyleMaskClosable);
	_window = [[NSWindow alloc] initWithContentRect:NSZeroRect styleMask:mask backing:NSBackingStoreBuffered defer:YES];

	_controller = [[[NSWindowController class] alloc] init];
	[_controller setWindow:_window];
}

- (void)tearDown
{
	[[CBHWindowManager sharedManager] unmanageWindow:_window];
	_controller = nil;
	_window = nil;
}


#pragma mark - Windows

- (void)test_addWindow
{
	[[CBHWindowManager sharedManager] manageWindow:_window];
	XCTAssertTrue([[CBHWindowManager sharedManager] isManagingWindow:_window], @"Window should be managed.");
}

- (void)test_addWindowWithKey
{
	[[CBHWindowManager sharedManager] manageWindow:_window withKey:TEST_KEY];
	XCTAssertTrue([[CBHWindowManager sharedManager] isManagingWindow:_window], @"Window should be managed.");

	NSWindow *window = [[CBHWindowManager sharedManager] windowForKey:TEST_KEY];
	XCTAssertNotNil(window, @"Returned controller is nil.");
	XCTAssertEqual(_window, window, @"Returned controller is not the correct controller.");
}

- (void)test_addWindowWithKeyAndClose
{
	[[CBHWindowManager sharedManager] manageWindow:_window withKey:TEST_KEY];
	XCTAssertTrue([[CBHWindowManager sharedManager] isManagingWindow:_window], @"Window should be managed.");

	NSWindow *window = [[CBHWindowManager sharedManager] windowForKey:TEST_KEY];
	XCTAssertNotNil(window, @"Returned controller is nil.");
	XCTAssertEqual(_window, window, @"Returned controller is not the correct controller.");

	XCTNSNotificationExpectation *expectation = [[XCTNSNotificationExpectation alloc] initWithName:NSWindowWillCloseNotification object:_window];

	[window makeKeyAndOrderFront:self];
	[window performClose:self];

	[self waitForExpectations:@[expectation] timeout:1.0];

	XCTAssertFalse([[CBHWindowManager sharedManager] isManagingWindow:_window], @"Window should not be managed.");

	window = [[CBHWindowManager sharedManager] windowForKey:TEST_KEY];
	XCTAssertNil(window, @"Returned window should be nil.");
}

- (void)test_addWindowNoReleaseOnClose
{
	[[CBHWindowManager sharedManager] manageWindow:_window withKey:TEST_KEY shouldRelease:NO];
	XCTAssertTrue([[CBHWindowManager sharedManager] isManagingWindow:_window], @"Window should be managed.");

	NSWindow *window = [[CBHWindowManager sharedManager] windowForKey:TEST_KEY];
	XCTAssertNotNil(window, @"Returned controller is nil.");
	XCTAssertEqual(_window, window, @"Returned controller is not the correct controller.");

	XCTNSNotificationExpectation *expectation = [[XCTNSNotificationExpectation alloc] initWithName:NSWindowWillCloseNotification object:_window];

	[window makeKeyAndOrderFront:self];
	[window performClose:self];

	[self waitForExpectations:@[expectation] timeout:1.0];

	XCTAssertTrue([[CBHWindowManager sharedManager] isManagingWindow:_window], @"Window not be managed.");

	window = [[CBHWindowManager sharedManager] windowForKey:TEST_KEY];
	XCTAssertNotNil(window, @"Returned controller is nil.");
	XCTAssertEqual(_window, window, @"Returned controller is not the correct controller.");
}

- (void)test_unmanageWindow
{
	[[CBHWindowManager sharedManager] manageWindow:_window];
	XCTAssertTrue([[CBHWindowManager sharedManager] isManagingWindow:_window], @"Window should be managed.");

	[[CBHWindowManager sharedManager] unmanageWindow:_window];
	XCTAssertFalse([[CBHWindowManager sharedManager] isManagingWindow:_window], @"Window should not be managed.");

	/// Unmanage already unmanaged window
	[[CBHWindowManager sharedManager] unmanageWindow:_window];
}

- (void)test_noWindowForKey
{
	XCTAssertNil([[CBHWindowManager sharedManager] windowForKey:@"Missing Key"], @"There should be no window for this key.");
}

- (void)test_dealloc
{
	CBHWindowManager *customManager = [[CBHWindowManager alloc] init];

	[customManager manageWindow:_window];
	XCTAssertTrue([customManager isManagingWindow:_window], @"Window should be managed.");

	customManager = nil;
}

- (void)test_windowDidClose
{
	[[CBHWindowManager sharedManager] manageWindow:_window shouldRelease:NO];
	NSWindowStyleMask mask = (NSWindowStyleMaskTitled|NSWindowStyleMaskClosable);
	NSWindow *window = [[NSWindow alloc] initWithContentRect:NSZeroRect styleMask:mask backing:NSBackingStoreBuffered defer:YES];

	/// No Object
	[[CBHWindowManager sharedManager] windowWillClose:[NSNotification notificationWithName:NSWindowWillCloseNotification object:nil]];

	/// Wrong Object Type
	[[CBHWindowManager sharedManager] windowWillClose:[NSNotification notificationWithName:NSWindowWillCloseNotification object:@"Invalid Object"]];

	/// Non-Managed Window
	[[CBHWindowManager sharedManager] windowWillClose:[NSNotification notificationWithName:NSWindowWillCloseNotification object:window]];

	/// Managed Window that doesn't release
	[[CBHWindowManager sharedManager] windowWillClose:[NSNotification notificationWithName:NSWindowWillCloseNotification object:_window]];
}


#pragma mark - Window Controllers

- (void)test_addController
{
	[[CBHWindowManager sharedManager] manageController:_controller];
	XCTAssertTrue([[CBHWindowManager sharedManager] isManagingController:_controller], @"Controller should be managed.");
	XCTAssertTrue([[CBHWindowManager sharedManager] isManagingWindow:_window], @"Window should be managed.");

	NSWindowController *controller = [[CBHWindowManager sharedManager] controllerForWindow:_window];
	XCTAssertNotNil(controller, @"Returned controller is nil.");
	XCTAssertEqual(_controller, controller, @"Returned controller is not the correct controller.");
}

- (void)test_addControllerWithKey
{
	[[CBHWindowManager sharedManager] manageController:_controller withKey:TEST_KEY];
	XCTAssertTrue([[CBHWindowManager sharedManager] isManagingController:_controller], @"Controller should be managed.");

	NSWindowController *controller = [[CBHWindowManager sharedManager] controllerForKey:@"TestKey"];

	XCTAssertNotNil(controller, @"Returned controller is nil.");
	XCTAssertEqual(_controller, controller, @"Returned controller is not the correct controller.");
}

- (void)test_addControllerWithKeyAndClose
{
	[[CBHWindowManager sharedManager] manageController:_controller withKey:TEST_KEY];
	XCTAssertTrue([[CBHWindowManager sharedManager] isManagingController:_controller], @"Controller should be managed.");
	XCTAssertTrue([[CBHWindowManager sharedManager] isManagingWindow:_window], @"Window should be managed.");

	NSWindowController *controller = [[CBHWindowManager sharedManager] controllerForWindow:_window];
	XCTAssertNotNil(controller, @"Returned controller is nil.");
	XCTAssertEqual(_controller, controller, @"Returned controller is not the correct controller.");

	XCTNSNotificationExpectation *expectation = [[XCTNSNotificationExpectation alloc] initWithName:NSWindowWillCloseNotification object:_window];

	[_window makeKeyAndOrderFront:self];
	[_window performClose:self];

	[self waitForExpectations:@[expectation] timeout:1.0];

	XCTAssertFalse([[CBHWindowManager sharedManager] isManagingController:_controller], @"Controller should not be managed.");

	controller = [[CBHWindowManager sharedManager] controllerForWindow:_window];
	XCTAssertNil(controller, @"Returned controller should be nil.");
}

- (void)test_addControllerNoReleaseOnClose
{
	[[CBHWindowManager sharedManager] manageController:_controller withKey:TEST_KEY shouldRelease:NO];
	XCTAssertTrue([[CBHWindowManager sharedManager] isManagingController:_controller], @"Controller should be managed.");
	XCTAssertTrue([[CBHWindowManager sharedManager] isManagingWindow:_window], @"Window should be managed.");

	NSWindowController *controller = [[CBHWindowManager sharedManager] controllerForWindow:_window];
	XCTAssertNotNil(controller, @"Returned controller is nil.");
	XCTAssertEqual(_controller, controller, @"Returned controller is not the correct controller.");

	XCTNSNotificationExpectation *expectation = [[XCTNSNotificationExpectation alloc] initWithName:NSWindowWillCloseNotification object:_window];

	[_window makeKeyAndOrderFront:self];
	[_window performClose:self];

	[self waitForExpectations:@[expectation] timeout:1.0];

	XCTAssertTrue([[CBHWindowManager sharedManager] isManagingController:_controller], @"Controller should be managed.");
	XCTAssertTrue([[CBHWindowManager sharedManager] isManagingWindow:_window], @"Window should be managed.");

	controller = [[CBHWindowManager sharedManager] controllerForKey:TEST_KEY];
	XCTAssertNotNil(controller, @"Returned controller is nil.");
	XCTAssertEqual(_controller, controller, @"Returned controller is not the correct controller.");
}

- (void)test_noControllerForKey
{
	XCTAssertNil([[CBHWindowManager sharedManager] controllerForKey:@"Missing Key"], @"There should be no controller for this key.");
}

- (void)test_unmanageController
{
	[[CBHWindowManager sharedManager] manageController:_controller];
	XCTAssertTrue([[CBHWindowManager sharedManager] isManagingController:_controller], @"Controller should be managed.");

	[[CBHWindowManager sharedManager] unmanageController:_controller];
	XCTAssertFalse([[CBHWindowManager sharedManager] isManagingController:_controller], @"Controller should not be managed.");

	/// Unmanage already unmanaged controller
	[[CBHWindowManager sharedManager] unmanageController:_controller];
}


#pragma mark - Keys

- (void)test_managingKey
{
	[[CBHWindowManager sharedManager] manageController:_controller withKey:TEST_KEY];
	XCTAssertTrue([[CBHWindowManager sharedManager] isManagingWithKey:TEST_KEY], @"There should be something managed with this key.");
}

- (void)test_notManagingKey
{
	XCTAssertFalse([[CBHWindowManager sharedManager] isManagingWithKey:@"Missing Key"], @"There should be nothing managed with this key.");
}

@end
