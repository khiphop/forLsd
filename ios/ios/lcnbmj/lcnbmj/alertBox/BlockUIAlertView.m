//
//  BlockUIAlertView.m
//  Nbgame
//
//  Created by Shiqi Xu on 17/3/7.
//
//

#import <Foundation/Foundation.h>
#import "BlockUIAlertView.h"

@implementation BlockUIAlertView

@synthesize block;

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
  cancelButtonTitle:(NSString *)cancelButtonTitle
        clickButton:(AlertBlock)_block
  otherButtonTitles:(NSString *)otherButtonTitles {
    
    self = [super initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles,nil];
    
    if (self) {
        self.block = _block;
    }
    
    return self;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.block(buttonIndex);
}

-(void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated {
    
    if (_notDisMiss)
        
    {
        
        return;
        
    }
    
    [super dismissWithClickedButtonIndex:buttonIndex animated:animated];
    
}

@end
