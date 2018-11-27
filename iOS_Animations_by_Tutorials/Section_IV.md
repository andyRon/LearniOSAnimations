## Section IV: View Controller Transition Animations



现在是时候学习如何在更广泛的应用程序导航和布局环境中使用这些动画技术。 您已经为多个视图和图层设置了动画，但现在可以采用更大的视角，并考虑制作整个视图控制器的动画！

iOS中最容易识别的动画之一是将新视图控制器推入导航堆栈，如下所示：

在iOS 7中，Apple在旧导航控制器开始在新的导航控制器移动之前增加了一点延迟，为该动画添加了一些天赋。 这是一个很好的效果 - 但是当你想要建立自己的品牌形象时，自定义过渡动画可能会有很大的帮助。

在本节中，您将学习如何使用动画创建自己的自定义视图控制器转换。

### Chapter 17: Presentation Controller & Orientation Animations



#### 初始项目

![](https://ws2.sinaimg.cn/large/006tNbRwgy1fx8i1nv0jdg308o0fq1ky.gif)

问题？？：

scrollview 第一个

container view 透明但这个视图的子视图不透明



#### Behind the scences of custom transitions 

`animationController(forPresented:presenting:source:) `

` animateTransition(using:)`



#### Implementing transition delegates

协议： `UIViewControllerAnimatedTransitioning`  



#### Creating your transition animator



- Adding a pop transition

![](https://ws1.sinaimg.cn/large/006tNbRwgy1fx8l5p1abdg308o0fqni0.gif)







- Adding a dismiss transition



#### Device orientation transition

您可以将设备方向更改视为从视图控制器到其自身的演示过渡，只是在不同的大小。



#### Challenges ??



### Chapter 18: UINavigationController Custom Transition Animations

将一个新的视图控制器推入导航堆栈或弹出一个视图控制器可以为您提供一个时尚的动画，而您无需做任何工作。 一个新的屏幕来自右侧，并推迟旧屏幕，略有滞后：
![](https://ws4.sinaimg.cn/large/006tNbRwgy1fx94f1ynj9j307b06q0sl.jpg)

上面的屏幕截图显示了iOS如何将新视图控制器推送到设置应用中的导航堆栈：新视图从右侧滑入以覆盖旧视图，新标题淡入，而旧标题标题从视图中消失。

iOS中的导航范例已经成为用户的老头，因为相同的动画已经使用了很多年。 这样就可以让你在不抛弃用户的情况下修饰你的导航控制器过渡。

#### 初始项目

点击默认屏幕任意地方（`MasterViewController`），跳转展示vacation packing list页面(`DetailViewController`)

#### The navigation controller delegate

#### Taking care of the rough edges

??选中.xcodeproj工程文件 --》显示包含内容 --》打开project.pbxproj文件 --》全文搜索ORGANIZATIONNAME --》 修改  ORGANIZATIONNAME = "公司名称" ; 

修改了project.pbxproj文件导致项目打不开

### Chapter 19: Interactive UINavigationController Transitions