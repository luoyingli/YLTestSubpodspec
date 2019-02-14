//
//  YLUIManager.m
//  TestPodSpecDemo
//
//  Created by luoyingli on 2019/2/13.
//  Copyright © 2019 luoyingli. All rights reserved.
//

#import "YLUIManager.h"
//#import "MJExtension.h"
#import <objc/runtime.h>

NSString *const kClassName = @"kClassName";
NSString *const kClassParameters = @"kClassParameters";

@interface YLUIManager ()

@property (nonatomic, strong) UINavigationController *navigationController;
@property (nonatomic, strong) UINavigationController *presentNavigationController;
@property (nonatomic, assign) BOOL isTabbarHidden;

@end

@implementation YLUIManager


#pragma clang diagnostic push //收集当前的警告
#pragma clang diagnostic ignored "-Wdeprecated-implementations"

SINGLETON_IMPLEMENTION(YLUIManager, shareUIManager)
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

- (void)registerNavigationController:(UINavigationController *)navigationController
{
    self.navigationController = navigationController;
}

#pragma mark - push
//controllerName
- (void)showViewControllerWithName:(NSString *)name
{
    [self showViewControllerWithName:name parameters:nil];
}

- (void)showViewControllerWithName:(NSString *)name parameters:(NSDictionary *)parameters
{
    [self showViewControllerWithName:name parameters:parameters animated:YES];
}

- (void)showViewControllerWithName:(NSString *)name parameters:(NSDictionary *)parameters animated:(BOOL)animated
{
    Class viewClass = NSClassFromString(name);
    [self showViewControllerWithClass:viewClass parameters:parameters animated:animated];
}

//controllerClass
- (void)showViewControllerWithClass:(Class)controllerClass
{
    [self showViewControllerWithClass:controllerClass parameters:nil];
}

- (void)showViewControllerWithClass:(Class)controllerClass parameters:(NSDictionary *)parameters
{
    [self showViewControllerWithClass:controllerClass parameters:parameters animated:YES];
}

- (void)showViewControllerWithClass:(Class)controllerClass parameters:(NSDictionary *)parameters animated:(BOOL)animated
{
    UIViewController *viewController = [self viewControllerWithClass:controllerClass];
    [self showViewControllerWithController:viewController parameters:parameters animated:animated];
}

//controller
- (void)showViewControllerWithController:(UIViewController *)viewController
{
    [self showViewControllerWithController:viewController parameters:nil];
}

- (void)showViewControllerWithController:(UIViewController *)viewController parameters:(NSDictionary *)parameters
{
    [self showViewControllerWithController:viewController parameters:parameters animated:YES];
}

- (void)showViewControllerWithController:(UIViewController *)viewController parameters:(NSDictionary *)parameters animated:(BOOL)animated
{
    if (!viewController) {
        return;
    }
    
    [self setParametersForViewController:viewController parameters:parameters];
    
    [[self currentNavigationController] pushViewController:viewController animated:animated];
}

#pragma mark - pop
- (UIViewController *)popViewController
{
    return [self popViewController:YES];
}

- (UIViewController *)popViewController:(BOOL)animated
{
    UIViewController *viewController = [[self currentNavigationController] popViewControllerAnimated:animated];
    return viewController;
}

- (UIViewController *)popToViewController:(Class)controllerClass
{
    return [self popToViewController:controllerClass animated:YES];
}

- (UIViewController *)popToViewController:(Class)controllerClass animated:(BOOL)animated
{
    UIViewController *targetViewController = nil;
    NSArray *controllerArray = [[self currentNavigationController] viewControllers];
    for (UIViewController *viewController in controllerArray) {
        if ([viewController isKindOfClass:controllerClass]) {
            targetViewController = viewController;
            [[self currentNavigationController] popToViewController:viewController animated:animated];
            break;
        }
    }
    
    return targetViewController;
}

- (void)popToRootViewControllerOnly
{
    [self popToRootViewControllerWithAnimation:YES];
}

- (void)popToRootViewControllerWithAnimation:(BOOL)animated
{
//    UIWindow *mainWindow = [UIApplication sharedApplication].keyWindow;
//    UINavigationController *splashVC = (UINavigationController*)mainWindow.rootViewController;
//    UITabBarController *tabController = [splashVC.viewControllers objectAtIndex:0];
//    [tabController setTabBarHidden:NO];
    
    [[self currentNavigationController] popToRootViewControllerAnimated:animated];
}

- (void)popToRootViewController:(NSInteger)index
{
    [self popToRootViewController:index animated:NO];
}

- (void)popToRootViewController:(NSInteger)index animated:(BOOL)animated
{
    UIWindow *mainWindow = [UIApplication sharedApplication].keyWindow;
    UINavigationController *splashVC = (UINavigationController*)mainWindow.rootViewController;
    UITabBarController *tabController = [splashVC.viewControllers objectAtIndex:0];
    NSArray *tabBarViewControllers = [tabController viewControllers];
    UINavigationController *nextNavigationController = [tabBarViewControllers objectAtIndex:index];

    [self.navigationController setViewControllers:@[[self.navigationController.viewControllers firstObject]]];
    [nextNavigationController setViewControllers:@[[nextNavigationController.viewControllers firstObject]] animated:animated];

    [tabController setSelectedIndex:index];
    
    self.navigationController = nextNavigationController;
    self.presentNavigationController = nil;
}

- (void)switchTabbar:(NSInteger)index classInfoArray:(NSArray *)classInfoArray
{
    [self switchTabbar:index classInfoArray:classInfoArray animated:NO];
}

- (void)switchTabbar:(NSInteger)index classInfoArray:(NSArray *)classInfoArray animated:(BOOL)animated
{
    UIWindow *mainWindow = [UIApplication sharedApplication].keyWindow;
    UINavigationController *splashVC = (UINavigationController*)mainWindow.rootViewController;
    UITabBarController *tabController = [splashVC.viewControllers objectAtIndex:0];
    NSArray *tabBarViewControllers = [tabController viewControllers];
    UINavigationController *nextNavigationController = [tabBarViewControllers objectAtIndex:index];
    
    __block NSMutableArray *controllers = [NSMutableArray array];
    [controllers addObject:[nextNavigationController.viewControllers firstObject]];
    [classInfoArray enumerateObjectsUsingBlock:^(NSDictionary *classDic, NSUInteger idx, BOOL * _Nonnull stop) {
        id classPage = classDic[kClassName];
        
        UIViewController *controller = nil;
        if ([classPage isKindOfClass:[NSString class]]) {
            NSString *className = (NSString *)classPage;
            controller = [self viewControllerWithClass:NSClassFromString(className)];
            
        } else if ([classPage isKindOfClass:[UIViewController class]]) {
            controller = (UIViewController *)classPage;
        }
        
        NSDictionary *parameters = classDic[kClassParameters];
        
        if (controller && parameters && parameters.count > 0 ) {
            [self setParametersForViewController:controller parameters:parameters];
        }
        
        [controllers addObject:controller];
    }];
    
    [self.navigationController setViewControllers:@[[self.navigationController.viewControllers firstObject]]];
    [nextNavigationController setViewControllers:controllers animated:animated];
    
    [tabController setSelectedIndex:index];
    
    self.navigationController = nextNavigationController;
    self.presentNavigationController = nil;
}

#pragma mark - presentViewController
- (void)presentViewControllerWithName:(NSString *)name
{
    [self presentViewControllerWithName:name parameters:nil];
}

- (void)presentViewControllerWithName:(NSString *)name parameters:(NSDictionary *)parameters
{
    [self presentViewControllerWithName:name parameters:parameters animated:YES];
}

- (void)presentViewControllerWithName:(NSString *)name parameters:(NSDictionary *)parameters animated:(BOOL)animated
{
    Class viewClass = NSClassFromString(name);
    [self presentViewControllerWithClass:viewClass parameters:parameters animated:animated];
}

- (void)presentViewControllerWithName:(NSString *)name parameters:(NSDictionary *)parameters animated:(BOOL)animated completion:(void(^)(void))completion
{
    Class viewClass = NSClassFromString(name);
    
    [self presentViewControllerWithClass:viewClass parameters:parameters animated:animated completion:completion];
}

- (void)presentViewControllerWithClass:(Class)viewClass
{
    [self presentViewControllerWithClass:viewClass parameters:nil];
}

- (void)presentViewControllerWithClass:(Class)viewClass parameters:(NSDictionary *)parameters
{
    [self presentViewControllerWithClass:viewClass parameters:parameters animated:YES];
}

- (void)presentViewControllerWithClass:(Class)viewClass parameters:(NSDictionary *)parameters animated:(BOOL)animated
{
    UIViewController *viewController = [self viewControllerWithClass:viewClass];
    
    [self presentViewController:viewController parameters:parameters animated:animated];
}

- (void)presentViewControllerWithClass:(Class)viewClass parameters:(NSDictionary *)parameters animated:(BOOL)animated completion:(void(^)(void))completion
{
    UIViewController *viewController = [self viewControllerWithClass:viewClass];
    
    [self presentViewController:viewController parameters:parameters animated:animated completion:completion];
}

- (void)presentViewController:(UIViewController *)viewController
{
    [self presentViewController:viewController parameters:nil];
}

- (void)presentViewController:(UIViewController *)viewController parameters:(NSDictionary *)parameters
{
    [self presentViewController:viewController parameters:parameters animated:YES];
}

- (void)presentViewController:(UIViewController *)viewController parameters:(NSDictionary *)parameters animated:(BOOL)animated
{
    [self obtainOrResetTabbar:NO];
    
    [self setParametersForViewController:viewController parameters:parameters];
    UINavigationController *presentNavigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    self.presentNavigationController = presentNavigationController;
    
    [self.navigationController presentViewController:self.presentNavigationController animated:animated completion:^{
        
    }];
}

- (void)presentViewController:(UIViewController *)viewController parameters:(NSDictionary *)parameters animated:(BOOL)animated completion:(void(^)(void))completion
{
    [self obtainOrResetTabbar:NO];
    
    [self setParametersForViewController:viewController parameters:parameters];
    UINavigationController *presentNavigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    self.presentNavigationController = presentNavigationController;
    
    [self.navigationController presentViewController:self.presentNavigationController animated:animated completion:^{
        if (completion) {
            completion();
        }
    }];
}

#pragma mark - dismiss
- (void)dismissViewControllerCompletion:(void(^)(void))completion
{
    [self dismissViewControllerAnimated:YES completion:completion];
}

- (void)dismissViewControllerAnimated:(BOOL)animated completion:(void(^)(void))completion
{
    __weak typeof (&*self) weakSelf = self;
    [self.navigationController dismissViewControllerAnimated:animated completion:^{
        weakSelf.presentNavigationController = nil;
        
        [weakSelf obtainOrResetTabbar:YES];
        
        if (completion) {
            completion();
        }
    }];
}

#pragma mark - tool methods
- (UIViewController *)viewControllerWithClass:(Class)controllerClass
{
    UIViewController *viewController = nil;
    if (![controllerClass isSubclassOfClass:[UIViewController class]]) {
        return nil;
    }
    
    if ([controllerClass respondsToSelector:@selector(storyboardName)]) {
        NSString *storyboardName = [controllerClass  storyboardName];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
        viewController = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass(controllerClass)];
        
    } else if ([controllerClass respondsToSelector:@selector(xibName)]) {
        NSString *xibName = [controllerClass xibName];
        viewController = [[controllerClass alloc] initWithNibName:xibName bundle:nil];
        
    } else {
        viewController = [[controllerClass alloc] init];
    }
    
    return viewController;
}

- (void)setParametersForViewController:(UIViewController *)viewController parameters:(NSDictionary *)parameters
{
    if (![parameters isKindOfClass:[NSDictionary class]] ||
        [parameters count] <= 0) {
        return;
    }
    
    // paramDic里值的类型可能会和targetViewController属性匹配不上，比如属性是个NSNumber类型，而值是NSString
    // 为了避免这样的情况，在设置参数的时候，对于这两种类型做特殊处理
    NSMutableDictionary *propertyParameters = [NSMutableDictionary dictionary];
    [parameters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (![key isKindOfClass:[NSString class]]) {
            return;
        }
        
        if ([obj isKindOfClass:[NSString class]] ||
            [obj isKindOfClass:[NSNumber class]]) {
            propertyParameters[key] = obj;
            return;
        }
        
        NSString *upperKey = [key stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[[key substringToIndex:1] uppercaseString]];
        
        SEL setMethod = NSSelectorFromString([NSString stringWithFormat:@"set%@:",upperKey]);
        
        if (![viewController respondsToSelector:setMethod]) {
            return;
        }
        
        [viewController setValue:obj forKeyPath:key];
    }];
    
//    [viewController mj_setKeyValues:propertyParameters];
}

- (UINavigationController *)currentNavigationController
{
    if (self.navigationController.presentedViewController &&
        self.navigationController.presentedViewController == self.presentNavigationController) {
        return self.presentNavigationController;
    }
    
    return self.navigationController;
}

- (UIViewController *)topViewController
{
    return [self currentNavigationController].topViewController;
}

- (UIViewController *)controllerInNavigationStackWithClass:(Class)viewClass
{
    NSArray *viewControllers = [[self currentNavigationController] viewControllers];
    for (UIViewController *existedViewController in viewControllers) {
        if ([existedViewController isKindOfClass:viewClass]) {
            return existedViewController;
        }
    }
    
    return nil;
}

- (UIViewController *)presentedViewController
{
    return self.navigationController.presentedViewController;
}

- (void)resetTabbarHideStatus:(BOOL)hide
{
//    UIWindow *mainWindow = [UIApplication sharedApplication].keyWindow;
//    UINavigationController *splashVC = (UINavigationController*)mainWindow.rootViewController;
//    UITabBarController *tabController = [splashVC.viewControllers objectAtIndex:0];
//
//    [tabController setTabBarHidden:hide];
}

- (void)obtainOrResetTabbar:(BOOL)reset
{
//    UIWindow *mainWindow = [UIApplication sharedApplication].keyWindow;
//    UINavigationController *splashVC = (UINavigationController*)mainWindow.rootViewController;
//    UITabBarController *tabController = [splashVC.viewControllers objectAtIndex:0];
//    if (reset) {
//        [tabController setTabBarHidden:self.isTabbarHidden];
//    } else {
//        self.isTabbarHidden = tabController.tabBarHidden;
//    }
}

#pragma clang diagnostic pop //弹出所有的警告

@end
