# InfSmartQuotes

Helper code so iOS apps can implement smart quotes for text fields and text views.

## Adding to your Project

Simply drag the InfSmartQuotes.m and .h files into your project, whereever you deem appropriate.

## How to Use

For any text field or text view you want to support smart quotes, have the
delegate for that view (usually the view controller) call the corresponding
"shouldChange" method in InfSmartQuotes:

	- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
	{
		return [InfSmartQuotes textView:textView shouldChangeTextInRange:range replacementText:text];
	}

	-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
	{
		return [InfSmartQuotes textField:textField shouldChangeCharactersInRange:range replacementString:string];
	}

In order to support the Smart Quotes and Dumb Quotes menu items (which enable
and disable turing quotes into smart quotes, but don't change any existing ones),
you need to include the following in your view controller:

	- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
		return [InfSmartQuotes canPerformAction:action];
	}

	- (void)enableSmartQuotes: (id) sender {
		[InfSmartQuotes enableSmartQuotes:YES];
	}

	- (void)disableSmartQuotes: (id) sender {
		[InfSmartQuotes enableSmartQuotes:NO];
	}

Then from someplace in your app, you need to add the menu items to the
shared UIMenuContoller perhaps as follows (or by adding them to an array
of other menu items):

	[UIMenuController sharedMenuController].menuItems = [InfSmartQuotes menuItems];

## License

This code is covered under the MIT license.
