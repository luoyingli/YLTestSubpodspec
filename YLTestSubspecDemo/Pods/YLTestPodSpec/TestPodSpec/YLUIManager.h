//
//  YLUIManager.h
//  TestPodSpecDemo
//
//  Created by luoyingli on 2019/2/13.
//  Copyright © 2019 luoyingli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "YLSingleDefine.h"


FOUNDATION_EXPORT NSString *const kClassName;
FOUNDATION_EXPORT NSString *const kClassParameters;

#define UIManager [YLUIManager shareUIManager]

@protocol YLUIManagerDelegate <NSObject>

+ (NSString *)storyboardName;
+ (NSString *)xibName;

@end


@interface YLUIManager : NSObject

SINGLETON_INTERFACE(YLUIManager, shareUIManager)

//注册根试图
- (void)registerNavigationController:(UINavigationController *)navigationController;

#pragma mark - push
//controllerName
/**
 *  push视图控制器，根据类名
 *
 *  @param name 视图控制器类名
 */
- (void)showViewControllerWithName:(NSString *)name;

/**
 *  push视图控制器，根据类名
 *
 *  @param name  视图控制器类名
 *  @param parameters 视图控制器参数
 */
- (void)showViewControllerWithName:(NSString *)name parameters:(NSDictionary *)parameters;

/**
 *  push视图控制器，根据类名
 *
 *  @param name     视图控制器类名
 *  @param parameters    视图控制器参数
 *  @param animated 是否带动画
 */
- (void)showViewControllerWithName:(NSString *)name parameters:(NSDictionary *)parameters animated:(BOOL)animated;

//controllerClass
/**
 *  push视图控制器，根据class
 *
 *  @param controllerClass 视图控制器class
 */
- (void)showViewControllerWithClass:(Class)controllerClass;

/**
 *  push视图控制器，根据class
 *
 *  @param controllerClass   视图控制器class
 *  @param parameters 视图控制器参数
 */
- (void)showViewControllerWithClass:(Class)controllerClass parameters:(NSDictionary *)parameters;

/**
 *  push视图控制器，根据class
 *
 *  @param controllerClass      视图控制器class
 *  @param parameters    视图控制器参数
 *  @param animated 是否带动画
 */
- (void)showViewControllerWithClass:(Class)controllerClass parameters:(NSDictionary *)parameters animated:(BOOL)animated;

//controller
/**
 *  push视图控制器
 *
 *  @param viewController 视图控制器
 */
- (void)showViewControllerWithController:(UIViewController *)viewController;

/**
 *  push视图控制器
 *
 *  @param viewController 视图控制器
 *  @param parameters     视图控制器参数
 */
- (void)showViewControllerWithController:(UIViewController *)viewController parameters:(NSDictionary *)parameters;

/**
 *  push视图控制器
 *
 *  @param viewController 视图控制器
 *  @param parameters     视图控制器参数
 *  @param animated       是否带动画
 */
- (void)showViewControllerWithController:(UIViewController *)viewController parameters:(NSDictionary *)parameters animated:(BOOL)animated;

#pragma mark - pop
/**
 *  pop当前视图控制器(默认animated为YES)
 *
 *  @return pop掉的视图控制器
 */
- (UIViewController *)popViewController;

/**
 *  pop当前视图控制器
 *
 *  @param animated 是否带动画
 *
 *  @return pop掉的视图控制器
 */
- (UIViewController *)popViewController:(BOOL)animated;

/**
 *  pop栈队列中指定视图(animated为YES)
 *
 *  @param controllerClass 需要pop的视图控制器类
 *
 *  @return pop掉的视图控制器
 */
- (UIViewController *)popToViewController:(Class)controllerClass;

/**
 *  pop栈队列中指定视图
 *
 *  @param controllerClass 需要pop的视图控制器类
 *  @param animated            是否带动画
 *
 *  @return pop掉的视图控制器
 */
- (UIViewController *)popToViewController:(Class)controllerClass animated:(BOOL)animated;

/**
 *  pop到栈底部视图(默认animated为YES)
 */
- (void)popToRootViewControllerOnly;

/**
 *  pop到栈底部视图(默认animated为YES)
 *
 *  @param animated 是否带动画
 */
- (void)popToRootViewControllerWithAnimation:(BOOL)animated;

/**
 *  pop到栈底部视图(默认animated为YES)
 *
 *  @param index tabbarController的索引值
 */
- (void)popToRootViewController:(NSInteger)index;

/**
 *  pop到栈底部视图
 *
 *  @param index    tabbarController的索引值
 *  @param animated 是否带动画
 */
- (void)popToRootViewController:(NSInteger)index animated:(BOOL)animated;

/**
 *  切换到某个tabbar,并且设置栈中已有的页面
 *
 *  @param index    tabbarController的索引值
 *  @param classInfoArray 栈中已有页面（类名+参数）
 */
- (void)switchTabbar:(NSInteger)index classInfoArray:(NSArray *)classInfoArray;

/**
 *  切换到某个tabbar,并且设置栈中已有的页面
 *
 *  @param index    tabbarController的索引值
 *  @param classInfoArray 栈中已有页面（类名+参数、viewController+参数）
 *  @param animated 是否带动画
 */
- (void)switchTabbar:(NSInteger)index classInfoArray:(NSArray *)classInfoArray animated:(BOOL)animated;

#pragma mark - presentViewController
/**
 *  present视图控制器，根据类名
 *
 *  @param name 视图控制器类名
 */
- (void)presentViewControllerWithName:(NSString *)name;

/**
 *  present视图控制器，根据类名
 *
 *  @param name  视图控制器类名
 *  @param parameters 视图控制器参数
 */
- (void)presentViewControllerWithName:(NSString *)name parameters:(NSDictionary *)parameters;

/**
 *  present视图控制器，根据类名
 *
 *  @param name     视图控制器类名
 *  @param parameters    视图控制器参数
 *  @param animated 是否带动画
 */
- (void)presentViewControllerWithName:(NSString *)name parameters:(NSDictionary *)parameters animated:(BOOL)animated;

/**
 *  present视图控制器，根据类名
 *
 *  @param name     视图控制器类名
 *  @param parameters    视图控制器参数
 *  @param animated 是否带动画
 *  @param completion 结束后回调
 */
- (void)presentViewControllerWithName:(NSString *)name parameters:(NSDictionary *)parameters animated:(BOOL)animated completion:(void(^)(void))completion;

/**
 *  present视图控制器，根据class
 *
 *  @param viewClass 视图控制器class
 */
- (void)presentViewControllerWithClass:(Class)viewClass;

/**
 *  present视图控制器，根据controllerClass
 *
 *  @param viewClass   视图控制器class
 *  @param parameters  视图控制器参数
 */
- (void)presentViewControllerWithClass:(Class)viewClass parameters:(NSDictionary *)parameters;

/**
 *  present视图控制器，根据controllerClass
 *
 *  @param viewClass      视图控制器class
 *  @param parameters    视图控制器参数
 *  @param animated 是否带动画
 */
- (void)presentViewControllerWithClass:(Class)viewClass parameters:(NSDictionary *)parameters animated:(BOOL)animated;

/**
 *  present视图控制器，根据controllerClass
 *
 *  @param viewClass      视图控制器class
 *  @param parameters    视图控制器参数
 *  @param animated 是否带动画
 *  @param completion 结束后回调
 */
- (void)presentViewControllerWithClass:(Class)viewClass parameters:(NSDictionary *)parameters animated:(BOOL)animated completion:(void(^)(void))completion;

/**
 *  present视图控制器
 *
 *  @param viewController 视图控制器
 */
- (void)presentViewController:(UIViewController *)viewController;

/**
 *  present视图控制器
 *
 *  @param viewController 视图控制器
 *  @param parameters     视图控制器参数
 */
- (void)presentViewController:(UIViewController *)viewController parameters:(NSDictionary *)parameters;

/**
 *  present视图控制器,带动画
 *
 *  @param viewController 视图控制器
 *  @param parameters     视图控制器参数
 *  @param animated       是否开启动画
 */
- (void)presentViewController:(UIViewController *)viewController parameters:(NSDictionary *)parameters animated:(BOOL)animated;

/**
 *  present视图控制器,带动画
 *
 *  @param viewController 视图控制器
 *  @param parameters     视图控制器参数
 *  @param animated       是否开启动画
 *  @param completion 结束后回调
 */
- (void)presentViewController:(UIViewController *)viewController parameters:(NSDictionary *)parameters animated:(BOOL)animated completion:(void(^)(void))completion;

#pragma mark - dismiss
/**
 *  dismiss当前视图控制器(默认animated为YES)
 *
 *  @param completion dismiss完成后的回调block
 */
- (void)dismissViewControllerCompletion:(void(^)(void))completion;

/**
 *  dismiss当前视图控制器
 *
 *  @param animated   是否带动画
 *  @param completion dismiss完成后的回调block
 */
- (void)dismissViewControllerAnimated:(BOOL)animated completion:(void(^)(void))completion;

#pragma mark - tool methods
/**
 *  根据类生成页面
 *
 *  @param controllerClass 页面所属类
 */
- (UIViewController *)viewControllerWithClass:(Class)controllerClass;

/**
 *  返回当前的导航视图控制器
 *
 *  @return 导航视图控制器
 */
- (UINavigationController *)currentNavigationController;

/**
 *  返回当前导航视图控制器栈顶的视图控制器
 *
 *  @return 顶层视图控制器
 */
- (UIViewController *)topViewController;

/**
 *  返回当前导航控制器栈中指定的视图控制器
 *
 *  @param viewClass 视图控制器class
 *
 *  @return 指定的视图控制器
 */
- (UIViewController *)controllerInNavigationStackWithClass:(Class)viewClass;

/**
 *  返回当前present的视图控制器
 *
 *  @return 视图控制器
 */
- (UIViewController *)presentedViewController;

/**
 *  设置tabbar显示状态
 *
 *  @hide 是否隐藏
 */
- (void)resetTabbarHideStatus:(BOOL)hide;


@end

