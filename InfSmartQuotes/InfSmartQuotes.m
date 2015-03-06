//
//  InfSmartQuotes.m
//  Watercooler
//
//  Created by Troy Gaul on 7/1/13.
//  Copyright (c) 2013 InfinitApps LLC. All rights reserved.
//

#import "InfSmartQuotes.h"

//------------------------------------------------------------------------------

static NSString* replaceSmartQuotes(NSString* text, unichar beforeChar,
									NSString* straightQuote,
									NSString* leftSmart, NSString* rightSmart)
{
	static NSCharacterSet* whitespace;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
	});
	
	BOOL changed = NO;
	
	while (true) {
		NSRange r;
		unichar prevChar = beforeChar;
		r = [text rangeOfString: straightQuote];
		
		if (r.location == NSNotFound)
			break;
		
		if (r.location > 0)
			prevChar = [text characterAtIndex: r.location - 1];
		
		NSString* quote = [whitespace characterIsMember: prevChar] ? leftSmart : rightSmart;
		text = [text stringByReplacingCharactersInRange: r withString: quote];
		
		changed = YES;
	}
	
	return text;
}

//------------------------------------------------------------------------------

static NSString* replacedWithSmartQuotes(NSString* startText, NSRange range,
										 NSString* replacementText, NSInteger* outLength)
{
	unichar beforeChar = ' ';
	if (range.location > 0)
		beforeChar = [startText characterAtIndex: range.location - 1];
	
	NSString* newText = replacementText;
	
	newText = replaceSmartQuotes(newText, beforeChar, @"\"", @"“", @"”");
	newText = replaceSmartQuotes(newText, beforeChar, @"'",  @"‘", @"’");
	
	if (newText != replacementText) {
		NSString* viewText = startText;
		viewText = [viewText stringByReplacingCharactersInRange: range
													 withString: newText];
		if (outLength) {
			*outLength = newText.length;
		}
		
		return viewText;
	}
	
	return nil;
}

//------------------------------------------------------------------------------

@implementation InfSmartQuotes

#pragma mark - Delegate method implementations

+ (BOOL)           textView: (UITextView*) textView
	shouldChangeTextInRange: (NSRange) range
			replacementText: (NSString*) text
{
	if (![self smartQuotesEnabled])
		return YES;
	
	NSInteger length;
	NSString* newViewText = replacedWithSmartQuotes(textView.text, range, text, &length);
	
	if (newViewText) {
		textView.text = newViewText;
		textView.selectedRange = NSMakeRange(range.location + length, 0);
		
		return NO;
	}
	
	return YES;
}

+ (BOOL)                textField: (UITextField*) textField
	shouldChangeCharactersInRange: (NSRange) range
				replacementString: (NSString*) text
{
	if (![self smartQuotesEnabled])
		return YES;
	
	NSInteger length;
	NSString* newViewText = replacedWithSmartQuotes(textField.text, range, text, &length);
	
	if (newViewText) {
		textField.text = newViewText;
		UITextPosition* caratPos = [textField positionFromPosition: textField.beginningOfDocument
													   inDirection: UITextLayoutDirectionRight
															offset: range.location + length];
		textField.selectedTextRange = [textField textRangeFromPosition: caratPos toPosition:caratPos];
		
		return NO;
	}
	
	return YES;
}

#pragma mark - UIMenu support

+ (BOOL) isQuoteAction: (SEL) action
{
	return action == @selector(enableSmartQuotes:)
		|| action == @selector(disableSmartQuotes:);
}

+ (BOOL) canPerformAction: (SEL) action
{
	BOOL hasEnglish = NO;
	for (UITextInputMode* mode in [UITextInputMode activeInputModes]) {
		if ([mode.primaryLanguage hasPrefix: @"en"]) {
			hasEnglish = YES;
			break;
		}
	}
	
	if (hasEnglish) {
		if (action == @selector(enableSmartQuotes:))
			return ![self smartQuotesEnabled];
		
		if (action == @selector(disableSmartQuotes:))
			return [self smartQuotesEnabled];
	}
	
	return NO;
}

+ (BOOL) smartQuotesEnabled
{
	return ![[NSUserDefaults standardUserDefaults] boolForKey: @"InfSmartQuotes_useDumbQuotes"];
}

+ (void) setSmartQuotesEnabled: (BOOL) newEnabled
{
	[[NSUserDefaults standardUserDefaults] setBool: !newEnabled
											forKey: @"InfSmartQuotes_useDumbQuotes"];
}

+ (NSArray*) menuItems
{
	return @[
		[[UIMenuItem alloc] initWithTitle: NSLocalizedString(@"Smart Quotes", @"")
								   action: @selector(enableSmartQuotes:)],
		
		[[UIMenuItem alloc] initWithTitle: NSLocalizedString(@"Dumb Quotes", @"")
								   action: @selector(disableSmartQuotes:)]
	];
}

@end
