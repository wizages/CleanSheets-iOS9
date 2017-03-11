/*
*	Copyright 2015 Wizage
*
*	Licensed under the Apache License, Version 2.0 (the "License");
*	you may not use this file except in compliance with the License.
*	You may obtain a copy of the License at
*
*    http://www.apache.org/licenses/LICENSE-2.0
*
*	Unless required by applicable law or agreed to in writing, software
*	distributed under the License is distributed on an "AS IS" BASIS,
*	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
*	See the License for the specific language governing permissions and
*	limitations under the License.
*/
#import <Cephei/HBPreferences.h>

static BOOL seperators = true;
static BOOL enabled = true;
static BOOL isActivity = false;
static BOOL customRadius = true;
static BOOL tapDismiss = true;
static CGFloat conRadius = 15.0f;
static BOOL themeActivity = true;
static BOOL hideCancel = false;

#ifndef kCFCoreFoundationVersionNumber_iOS_9_0
#define kCFCoreFoundationVersionNumber_iOS_9_0 1240.10
#endif

#ifndef kCFCoreFoundationVersionNumber_iOS_10
#define kCFCoreFoundationVersionNumber_iOS_10 1348.00
#endif

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
* Hook into UIAlertController																			 		     *
* Header url: https://github.com/nst/iOS-Runtime-Headers/blob/master/Frameworks/UIKit.framework/UIAlertController.h  *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
%hook UIAlertController

-(id)visualStyleForAlertControllerStyle:(long long)arg1 traitCollection:(id)arg2 descriptor:(id)arg3{
	NSString *bundleName = [[NSBundle mainBundle] bundleIdentifier];
	if (isActivity && enabled && !([bundleName isEqualToString:@"com.apple.mobileslideshow"] || [bundleName isEqualToString:@"com.apple.camera"]))
		arg1 = 0;

	return %orig;
}

-(int) preferredStyle 
{
	NSString *bundleName = [[NSBundle mainBundle] bundleIdentifier];
	if( ( [bundleName isEqualToString:@"com.tapbots.Tweetbot4"]) 
	 && ( enabled
	  &&  isActivity
	  &&  [[[self.actions valueForKey:@"description"] componentsJoinedByString:@""] containsString:@"Cancel"] )
	  )
		return 0;
	else if(enabled && (!([bundleName isEqualToString:@"com.apple.mobileslideshow"] || [bundleName isEqualToString:@"com.apple.camera"]) || kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_10))
		return 1;
	else
		return %orig;
}

- (BOOL)_canDismissWithGestureRecognizer
{
	if(enabled && tapDismiss)
		return true;
	else
		return %orig;
}

- (void)viewDidLayoutSubviews
{
	
	//[self.view logViewHierarchy];
	%orig;
	NSString *bundleName = [[NSBundle mainBundle] bundleIdentifier];
	if(enabled && !([bundleName isEqualToString:@"com.apple.mobileslideshow"] || [bundleName isEqualToString:@"com.apple.camera"])){

		CGRect screenRect = [[UIScreen mainScreen] bounds];
		CGFloat screenWidth = screenRect.size.width;
		if (isActivity)
			self.view.frame = CGRectMake(self.view.frame.origin.x,0, screenWidth, self.view.frame.size.height);
	}
}

%end


/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* Hook into UIAlertControllerVisualStyle																			 		   *
* Header url: https://github.com/nst/iOS-Runtime-Headers/blob/master/Frameworks/UIKit.framework/UIAlertControllerVisualStyle.h *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
%hook UIAlertControllerVisualStyle

-(bool) hideActionSeparators{
	if (enabled)
		return seperators;
	else{
		return %orig;
	}
}

-(BOOL)hideCancelAction:(id)arg1 inAlertController:(id)arg2{
	if (enabled)
		return hideCancel;
	else{
		return %orig;
	}
}

%end

%hook UIInterfaceActionVisualStyle

-(id)newActionSeparatorViewForGroupViewState:(id)arg1 {
	NSString *bundleName = [[NSBundle mainBundle] bundleIdentifier];
	if (enabled && seperators && ![bundleName isEqualToString:@"com.apple.Music"])
		return nil;
	else{
		return %orig;
	}
}

%end

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* Hook into UIActivityViewController																			 		   *
* Header url: https://github.com/nst/iOS-Runtime-Headers/blob/master/Frameworks/UIKit.framework/UIActivityViewController.h *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
%hook UIActivityViewController

- (void)viewDidLoad
{
	isActivity = true;
	%orig;
}

- (void)viewWillDisappear:(BOOL)arg1
{
	isActivity = false;
	%orig;
}

- (void)viewDidLayoutSubviews
{
	
	CGRect screenRect = [[UIScreen mainScreen] bounds];
	CGFloat screenWidth = screenRect.size.width;
	CGFloat screenHeight = screenRect.size.height;
	%orig;
	if (themeActivity){
		NSString *bundleName = [[NSBundle mainBundle] bundleIdentifier];
		if(enabled && !([bundleName isEqualToString:@"com.apple.mobileslideshow"] || [bundleName isEqualToString:@"com.apple.camera"]) && kCFCoreFoundationVersionNumber < kCFCoreFoundationVersionNumber_iOS_10)
		{
			self.view.frame = CGRectMake(self.view.frame.origin.x, (screenHeight-self.view.frame.size.height)/2 , screenWidth, self.view.frame.size.height);
		}
		else if(enabled && !([bundleName isEqualToString:@"com.apple.mobileslideshow"] || [bundleName isEqualToString:@"com.apple.camera"]) && kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_10 && screenWidth < screenHeight){
			int theming = 0;
			for (UIView *subview in [self.view.superview subviews]){
				theming++;
				if(hideCancel){
					if (theming == 2 || theming == 3){
						subview.frame = CGRectMake(subview.frame.origin.x, subview.frame.origin.y-(screenHeight/9), subview.frame.size.width, subview.frame.size.height);
					}
					else if (theming == 4){
						subview.frame = CGRectMake(subview.frame.origin.x,subview.frame.origin.y,0,0);
					}
				} else{
					if (theming != 1){
						subview.frame = CGRectMake(subview.frame.origin.x, subview.frame.origin.y-(screenHeight/3)/2, subview.frame.size.width, subview.frame.size.height);
					}
				}
			}
		}
	}
}


%end

static void loadPrefs()
{
    HBPreferences *prefs =  [[HBPreferences alloc] initWithIdentifier:@"com.dopeteam.cleansheets9"];
    if(prefs)
    {
        [prefs registerBool:&enabled default:true forKey:@"enabled"];
        [prefs registerBool:&seperators default:true forKey:@"seperators_hide"];
        [prefs registerBool:&customRadius default:true forKey:@"customCorners"];
        [prefs registerBool:&tapDismiss default:true forKey:@"tapDismiss"];
        [prefs registerFloat:&conRadius default:15.0f forKey:@"radius"];
        [prefs registerBool:&hideCancel default:false forKey:@"hideCancel"];
        [prefs registerBool:&themeActivity default:true forKey:@"themeActivity"];
    }
}

%ctor 
{
    loadPrefs();
}

