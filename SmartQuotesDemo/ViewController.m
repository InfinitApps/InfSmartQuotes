//
//  ViewController.m
//  SmartQuotesDemo
//
//  Created by Troy Gaul on 3/6/15.
//  Copyright (c) 2015 InfinitApps LLC. All rights reserved.
//

#import "ViewController.h"

#import "InfSmartQuotes.h"

@interface ViewController () <UITextViewDelegate, UITextFieldDelegate>

@property (nonatomic) IBOutlet UITextView *textView;
@property (nonatomic) IBOutlet UITextView *textField;

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	[UIMenuController sharedMenuController].menuItems = [InfSmartQuotes menuItems];
}

#pragma mark - UITextViewDelegate protocol

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
	return [InfSmartQuotes textView:textView shouldChangeTextInRange:range replacementText:text];
}

#pragma mark - UITextViewDelegate protocol

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	return [InfSmartQuotes textField:textField shouldChangeCharactersInRange:range replacementString:string];
}

#pragma mark - InfSmartQuotes support

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
	return [InfSmartQuotes canPerformAction:action];
}

- (void)enableSmartQuotes: (id) sender {
	[InfSmartQuotes setSmartQuotesEnabled:YES];
}

- (void)disableSmartQuotes: (id) sender {
	[InfSmartQuotes setSmartQuotesEnabled:NO];
}

@end
