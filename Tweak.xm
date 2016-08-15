/* MobileSafari */

// Declare classes that will be used
@interface TabController : NSObject
@end

@interface NavigationBar: UIView
-(void)_URLTapped:(id)arg1; // Through trial and error I found that this is the method that gets called when you tap the URL text field, so all we will do is invoke it artifically
@end

/* Why this is necessary:
	We need a reference to the navbar in the TabController hooks, to activate the keyboard. Rather than hunting it down through view traversal (which can change in any new iOS release), we will simply keep a reference to it when it is made.

	The NavigationBar will be created before the user is able to open a new tab, so we can safely assume that the reference will be set before we need it.
*/
static NavigationBar *navbar = nil;

%hook NavigationBar
-(id)initWithFrame:(CGRect)arg1
{
	navbar = %orig(arg1);
	return navbar;
}
%end

/*
	It's been over two years since I wrote this code, so I'm not really sure why I picked out these two methods. Regardless, it's pretty obvious why I use them - they get called when a new tab is entered by the user. This is when we would want to invoke the keyboard, so that's what we do.
*/
%hook TabController

-(void)tiltedTabViewDidPresent:(id)arg1
{
	%orig;
	%log;
	[navbar _URLTapped:nil];
}
-(void)tabBarAddTab:(id)arg1
{
	%orig;
	%log;
	[navbar _URLTapped:nil];
}
%end

/* Google Chrome */

// This is essentially exactly the same operating procedure as MobileSafari, except with custom Google Chrome components.

@interface OmniboxTextFieldIOS : UITextField
@end

@interface NewTabPageView : UIView
@end

static OmniboxTextFieldIOS *omnibox = nil;

%hook OmniboxTextFieldIOS
-(id)initWithFrame:(CGRect)arg1
{
	omnibox = %orig(arg1);
	return omnibox;
}
%end

%hook NewTabPageView
- (void)layoutSubviews
{
	%orig;
	[omnibox becomeFirstResponder];
}
%end
