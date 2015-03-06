//
//  InfSmartQuotes.h
//  Watercooler
//
//  Created by Troy Gaul on 7/1/13.
//  Copyright (c) 2013 InfinitApps LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

// For any text field or text view you want to support smart quotes, have the
// delegate for that view (usually the view controller) call the corresponding
// "shouldChange" method in InfSmartQuotes.
//
// In order to support the Smart Quotes and Dumb Quotes menu items (which enable
// and disable turing quotes into smart quotes, but don't change any existing ones),
// you need to include the following in your view controller:
//
//	- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
//		return [InfSmartQuotes canPerformAction:action];
//	}
//
//	- (void)enableSmartQuotes: (id) sender {
//		[InfSmartQuotes setSmartQuotesEnabled:YES];
//	}
//
//	- (void)disableSmartQuotes: (id) sender {
//		[InfSmartQuotes setSmartQuotesEnabled:NO];
//	}
//
// Then from someplace in your app, you need to add the menu items to the
// shared UIMenuContoller perhaps as follows (or by adding them to an array
// of other menu items):
//
//	[UIMenuController sharedMenuController].menuItems = [InfSmartQuotes menuItems];

//------------------------------------------------------------------------------

@interface InfSmartQuotes : NSObject

+ (BOOL)           textView: (UITextView*) textView
	shouldChangeTextInRange: (NSRange) range
			replacementText: (NSString*) text;

+ (BOOL)                textField: (UITextField*) textField
	shouldChangeCharactersInRange: (NSRange) range
				replacementString: (NSString*) text;

// UIMenu support:

+ (BOOL) isQuoteAction: (SEL) action;
+ (BOOL) canPerformAction: (SEL) action;

+ (BOOL) smartQuotesEnabled;
+ (void) setSmartQuotesEnabled: (BOOL) newEnabled;

+ (NSArray*) menuItems;

@end

//------------------------------------------------------------------------------

@interface UIViewController(InfSmartQuotes)

- (void) enableSmartQuotes: (id) sender;
- (void) disableSmartQuotes: (id) sender;

@end

//------------------------------------------------------------------------------
