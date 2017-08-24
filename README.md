# TPRouter 一种中间Router设计

## 设计由来
Router作为一种常用的跳转设计,在项目中使用越来越多,但是三方库对于项目的压力通常是比较大的,因为有很多功能可能我们根本就用不到,就造成了项目空间的浪费.所以自己结合使用的经验设计了这样一个Router来帮助跳转.

### 原理
* 生成一张plist表,用于维护控制器的名称,app启动的时候指定协议头.
* 解析URL来截取scheme,host,和query.
* 根据scheme和host获取指定控制器,query用于参数传递

### 方法

* 方法一:使用静态方法直接调用(这时默认的根控制器是UINavigationController,不能指定根控制器)

```
/**
 默认根控制器,跳转本地URL

 @param URL 跳转协议
 @param param 参数
 @param Yes 是否动画
 */
+ (void)pushViewControllerWithNativeURL:(NSString *)URL withParams:(NSDictionary *)param animated:(BOOL)Yes;

/**
 跳转外部URL

 @param URL 跳转协议
 @param Yes 是否动画
 */
+ (void)pushViewControllerWithRemoteURL:(NSString *)URL animated:(BOOL)Yes;

/**
 默认根控制器,跳转本地URL,带block
 
 @param URL 跳转协议
 @param param 参数
 @param Yes 是否动画
 */
+ (void)pushViewControllerWithNativeURL:(NSString *)URL withParams:(NSDictionary *)param animated:(BOOL)Yes withBlock:(reverseBlock)block;
```
* 方法二:使用动态方法调用(可以指定根控制器作为跳转控制器)

```
/**
 用户指定的跳转根控制器,本地URL

 @param URL 跳转协议
 @param param 参数
 @param Yes 是否动画
 */
- (void)pushViewControllerWithNativeURL:(NSString *)URL withParams:(NSDictionary *)param animated:(BOOL)Yes;
/**
 跳转外部URL
 
 @param URL 跳转协议
 @param Yes 是否动画
 */
- (void)pushViewControllerWithRemoteURL:(NSString *)URL animated:(BOOL)Yes;

/**
 跳转外部URL,带block
 
 @param URL 跳转协议
 @param param 参数
 @param Yes 是否动画
 */
- (void)pushViewControllerWithNativeURL:(NSString *)URL withParams:(NSDictionary *)param animated:(BOOL)Yes withBlock:(reverseBlock)block;
```
### 使用 在需要的地方导入TPRouter.h
1. 首先在appDelegate中指定scheme
```
[[TPRouterConfig tp_routerConfigManager] configSchemeWithScheme:@"tprouter"];
```
2. 跳转的地方使用静态或者动态方法

```
[TPRouter pushViewControllerWithNativeURL:@"tprouter://home?name=allen" withParams:@{@"age" : @"27"} animated:YES];
或者
[[TPRouter tp_routerManager] pushViewControllerWithNativeURL:@"tprouter://home?name=allen&password=123" withParams:nil animated:YES];
```
3. 如果需要指定根控制器进行跳转

```
UINavigationController *root = (UINavigationController *)[[UIApplication sharedApplication].delegate window].rootViewController;
[TPRouterConfig tp_routerConfigManager].rootNavigationController = root;
//指定根的控制器必须使用动态方法
[[TPRouter tp_routerManager] pushViewControllerWithNativeURL:@"tprouter://home?name=allen&password=123" withParams:nil animated:YES];
```
4. 如果需要跳转到webView

```
[TPRouter pushViewControllerWithRemoteURL:@"https://www.baidu.com" animated:YES];
```
5. 如果需要回调参数

```
[TPRouter pushViewControllerWithNativeURL:@"tprouter://home" withParams:@{@"name":@"唐鹏"} animated:YES withBlock:^(id reverseValue) {
      NSLog(@"回调的值%@",reverseValue);
}];
//在目标控制器内,回调值即可
if (self.callBackBlock) {
        self.callBackBlock(@"回调成功");
    }
```
6. 目标控制器的参数接收
>routerParams:传递过来的参数
tp_remoteURL:传递过来的url
```
NSLog(@"传入的参数是%@,传入的url是:%@",self.routerParams,self.tp_remoteURL);
```

