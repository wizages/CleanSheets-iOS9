#import "cleansheetsGeneralListController.h"
#import "Generic.h"


@implementation cleansheetsGeneralListController

+ (NSString *)hb_specifierPlist {
    return @"Settings";
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


@end
