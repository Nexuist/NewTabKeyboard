// MobileSafari

@interface TabController : NSObject
@end

@interface NavigationBar: UIView
@property (nonatomic,readonly) UITextField *textField;
-(void)_URLTapped:(id)arg1 ;
@end

static NavigationBar *navbar = nil;

%hook NavigationBar
-(id)initWithFrame:(CGRect)arg1
{
	navbar = %orig(arg1);
	return navbar;
}
%end



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


// Google Chrome

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
