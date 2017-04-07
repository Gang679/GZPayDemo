# GZPayDemo
GZPayAndShareDemo主要集成了支付宝 微信 支付功能，友盟社会化分享 统计！

如果我们项目中已经导入了友盟的SDK，那么我们就不必在导入微信 支付宝官方的SDK。

在使用友盟SDK时我们会遇到各种各样的问题，报错，例如：#import <UMSocialCore/UMSocialCore.h> not found #import <AlipaySDK/AlipaySDK.h> not found这一类报错的话，一般都是我们的地址不对，只需要在TARGETS-Build Settings - Header Search Paths里面修改找不到的类的地址就好。

在我们对接微信支付的时候解析XMl文件时报错ARC 文件提前 释放时 我们需要在Buils Phases - Compile Sources 里面的集体的某个控制器或者类的后面添加-fno-objc-arc字段。

支付宝支付存在APP支付和网页支付，微信支付只有App支付，

我们分享的View可以添加到任何位置，并不局限与下方。

分享的话有微信好友  朋友圈 QQ 空间  微博的分享，为了防止苹果审核被拒，友盟已经为我们做好了显示我们手机安装的可分享的第三方。

```
#pragma mark - 判断平台是否安装
- (BOOL)gz_UMSocialIsInstall:(UMSocialPlatformType)platformType
{
    return [GZUMSocialData isInstall:platformType];
}
```

友盟分享也为我们提供了多种分享模式，纯文本 ，带图片文  ，纯图片 ，一般的分享是这种，title、content、缩略图、URL ， 文本 + 图片【暂时只对新浪分享有效】 ，音乐 ，视频 ，gif 动图等等，完全可以满足我们的需求。

支付方面的问题绝大多数出现在回调函数这块，我们只要按照每个平台的官方文档进行书写，一般不会出什么大的问题。


![gangzi](https://github.com/Gang679/GZPayDemo/blob/master/图示/Simulator%20Screen%20Shot%202017年4月7日%2017.04.40.png)
