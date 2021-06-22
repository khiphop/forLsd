#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import <conchRuntime.h>

@interface ViewController : GLKViewController
{
@public
    
    GLKView*                    m_pGLKView;
    
    EAGLContext*                m_pGLContext;
    
    conchRuntime*               m_pConchRuntime;
}
+(ViewController*)GetIOSViewController;
-(id)init;
- (UIImage *)getScreenShot;//获取屏幕截图
-(void)show7YuService:(NSString*)userName;//显示7鱼客服页面
-(void)onBack:(id)sender;//7鱼客服页面返回按钮事件
@end

