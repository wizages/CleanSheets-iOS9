#import "cleansheetsRootListController.h"
#import <CepheiPrefs/HBSupportController.h>
#import "Generic.h"


@implementation cleansheetsRootListController

+ (NSString *)hb_specifierPlist {
    return @"Root";
}

+ (NSString *)hb_shareText {
    return @"I mustache you a question, why you not using #CleanSheets9 by @Wizages & @iBuzzeh because dirty was so yesterday.";
}

+(NSString *)hb_shareURL {
    return @"";
}

+ (UIColor *)hb_tintColor {
    return [UIColor colorWithRed:0.17 green:0.24 blue:0.31 alpha:1.0];
}

+ (UIColor *)hb_navigationBarTintColor {
    return [UIColor colorWithRed:0.17 green:0.24 blue:0.31 alpha:1.0];
}

+ (BOOL)hb_invertedNavigationBar {
    return YES;
}

-(void) viewWillAppear:(BOOL) animated{
    [super viewWillAppear:animated];
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad){
        self.table.contentInset = UIEdgeInsetsMake(-15, 0, 0, 0);
    }
    [self setupHeader];
    //[self setupTitle];
}


-(void)setupTitle{
    UIImage *titleImage;
    if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_8_0) {
        titleImage = [UIImage imageNamed:@"Icon/navBarIcon.png" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil];
    }
    else {
        titleImage = [UIImage imageNamed:@"Icon/navBarIcon.png" inBundle:[NSBundle bundleForClass:self.class]];
    }
    UIImageView *titleView = [[UIImageView alloc] initWithImage:titleImage];
    [self.navigationItem setTitleView:titleView];
}

-(void)setupHeader{
    UIView *header = nil;
    header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 100)];
    HBLogDebug(@"%f", self.view.bounds.size.width);
    UIImage *headerImage;
    if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_8_0) {
        headerImage = [UIImage imageNamed:@"Icon/banner.png" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil];
    }
    else {
        headerImage = [UIImage imageNamed:@"Icon/banner.png" inBundle:[NSBundle bundleForClass:self.class]];
    }
    UIImageView *imageView = [[UIImageView alloc] initWithImage:headerImage];
    //header.frame = (CGRect){ header.frame.origin, headerImage.size };
    imageView.frame = CGRectMake(header.frame.origin.x, 10, self.view.bounds.size.width, 100);
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [header addSubview:imageView];
    [self.table setTableHeaderView:header];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [self setupHeader];
}

-(void)_returnKeyPressed:(id)arg1 {
     //[super _returnKeyPressed:arg1];
     [self.view endEditing:YES];
}

- (void)showSupportEmailController {
    UIViewController *viewController = (UIViewController *)[HBSupportController supportViewControllerForBundle:[NSBundle bundleForClass:self.class] preferencesIdentifier:@"com.dopeteam.cleansheets9"];
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)respring
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
system("killall -9 SpringBoard");
#pragma clang diagnostic pop
}


@end
