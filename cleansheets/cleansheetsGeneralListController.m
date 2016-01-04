#import "cleansheetsGeneralListController.h"
#import "Generic.h"


@implementation cleansheetsGeneralListController

+ (NSString *)hb_specifierPlist {
    return @"Settings";
}

+ (UIColor *)hb_tintColor {
    return [UIColor colorWithRed:0.33 green:0.11 blue:0.45 alpha:1.0];
}

+ (UIColor *)hb_navigationBarTintColor {
    return [UIColor colorWithRed:0.33 green:0.11 blue:0.45 alpha:1.0];
}

+ (BOOL)hb_invertedNavigationBar {
    return YES;
}


@end
