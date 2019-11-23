//  _CBHWindowManagerContainer.m
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

#import "_CBHWindowManagerContainer.h"


NS_ASSUME_NONNULL_BEGIN

@interface _CBHWindowManagerContainer ()
{
	NSWindow *_window;
	NSWindowController * __nullable _controller;
	NSString * __nullable _key;
	BOOL _releaseOnClose;
}

@end

NS_ASSUME_NONNULL_END


@implementation _CBHWindowManagerContainer

#pragma mark - Factories

+ (instancetype)containerWithWindow:(NSWindow *)window controller:(nullable NSWindowController *)controller key:(nullable NSString *)key andShouldReleaseOnClose:(BOOL)releaseOnClose
{
	return [[[self class] alloc] initWithWindow:window controller:controller key:key andShouldReleaseOnClose:releaseOnClose];
}


#pragma mark - Initialization

- (instancetype)initWithWindow:(NSWindow *)window controller:(nullable NSWindowController *)controller key:(nullable NSString *)key andShouldReleaseOnClose:(BOOL)releaseOnClose
{
	if ( (self = [super init]) )
	{
		_window = window;
		_controller = controller;
		_key = [key copy];
		_releaseOnClose = releaseOnClose;
	}

	return self;
}


#pragma mark - Properties

@synthesize window = _window;
@synthesize controller = _controller;
@synthesize key = _key;
@synthesize shouldReleaseOnClose = _releaseOnClose;

- (NSValue *)windowKey
{
	return [NSValue valueWithNonretainedObject:_window];
}

- (NSValue *)controllerKey
{
	if ( !_controller ) return nil;
	return [NSValue valueWithNonretainedObject:_controller];
}

@end
