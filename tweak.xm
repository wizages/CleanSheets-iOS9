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

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
* Hook into UIAlertController																			 		     *
* Header url: https://github.com/nst/iOS-Runtime-Headers/blob/master/Frameworks/UIKit.framework/UIAlertController.h  *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
%hook UIAlertController

-(id)visualStyleForAlertControllerStyle:(long long)arg1 traitCollection:(id)arg2 descriptor:(id)arg3{
	if (isActivity && enabled)
		arg1 = 0;
	return %orig;
}

-(int) preferredStyle 
{
	if(enabled)
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
	if(enabled){
		CGRect screenRect = [[UIScreen mainScreen] bounds];
		CGFloat screenWidth = screenRect.size.width;
		if (isActivity)
			self.view.frame = CGRectMake(self.view.frame.origin.x,0, screenWidth, self.view.frame.size.height);
	}
}

- (void)viewWillAppear:(BOOL)arg1{
	%orig;
	if (enabled && customRadius){
		for (UIView *subview in [self.view subviews])
		{
			for (UIView *subview2 in [subview subviews])
			{
				[subview2.layer setCornerRadius:conRadius];
					for (UIView *subview3 in [subview2 subviews])
					{	
						[subview3.layer setCornerRadius:conRadius];
						for (UIView *subview4 in [subview3 subviews])
						{
							[subview4.layer setCornerRadius:conRadius];
						}
						
					}
			}
		}
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
	if(enabled)
		self.view.frame = CGRectMake(self.view.frame.origin.x, (screenHeight-self.view.frame.size.height)/2 , screenWidth, self.view.frame.size.height);
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
    }
    [prefs release];
}

%ctor 
{
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("com.dopeteam.cleansheets9/settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    loadPrefs();
}

