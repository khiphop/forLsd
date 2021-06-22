//
//  BlockUIAlertView.h
//  Nbgame
//
//  Created by Shiqi Xu on 17/3/7.
//
//
#import <UIKit/UIKit.h>
typedef void(^AlertBlock)(NSInteger);

@interface BlockUIAlertView : UIAlertView

@property(nonatomic,copy)AlertBlock block;

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
  cancelButtonTitle:(NSString *)cancelButtonTitle
        clickButton:(AlertBlock)_block
  otherButtonTitles:(NSString *)otherButtonTitles;
@property(nonatomic, assign) BOOL notDisMiss;
@end
