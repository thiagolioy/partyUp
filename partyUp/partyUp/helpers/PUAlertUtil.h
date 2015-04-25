
#import <Foundation/Foundation.h>

@interface PUAlertUtil : NSObject


+(void)showAlertWithTitle:(NSString *)title andMessage:(NSString*) message andCancelButtonTitle:(NSString*) cancelButtonTitle andOtherButtonTitles:(NSString*)otherButtonTitle andDelegate:(id<UIAlertViewDelegate>)delegate;
+(void)showAlertWithTitle:(NSString *)title andMessage:(NSString*) message andCancelButtonTitle:(NSString*) cancelButtonTitle;
+(void) showAlertWithMessage:(NSString*)message;

@end
