# 系统学习iOS动画之四：视图控制器的转场动画



之前学习了视图动画、图层动画、自动布局动画等。这个部分让视野更大一点，学习整个视图控制器的动画，**视图控制器的转场动画(View Controller Transition Animations)**。

iOS中最容易识别的动画之一是将新视图控制器推入导航堆栈的动画，当我们想让APP有自己的特色，自定义转场动画是非常好的方式。



在本文中，将学习如何使用动画创建自己的自定义视图控制器转换。

[17-视图控制器转场和屏幕旋转转场](#17-视图控制器转场和屏幕旋转转场)   了解如何通过自定义动画转场**呈现**视图控制器 - 作为奖励，您将创建动画转场以处理设备方向更改。

[18-导航控制器转场](#18-导航控制器转场)

[19-交互式导航控制器转场](#19-交互式导航控制器转场)



Chapter 18-19 学习如何创建自定义导航控制器转换，包括一个很酷的效果，在该效果中，徽标会逐渐显示，以显示下一个屏幕的内容



实现自定义视图控制器转换需要一些编码，但结果很有趣，可以查看和使用。 同样在本书的这一部分中，您将深入了解动画制作者，它们提供了一种更简单，更简化的方式来构建自定义转场。 无论您使用哪种API，自定义转场都是一项重要的动画技术，真正让应用程序脱颖而出！



## 17-视图控制器转场和屏幕旋转转场

无论是**呈现** 照相机视图控制器、地址簿还是自定义的模态屏幕，每次都调用相同的**UIKit**方法：`present(_:animated:completion:)`。 此方法将当前屏幕“放弃”，然后跳到另一个视图控制器。

下图呈现一个“New Contact”视图控制器向上滑动以覆盖当前视图（联系人列表），这是默认的动画方式：

![image-20181202162829195](https://ws3.sinaimg.cn/large/006tNbRwgy1fxshdgh771j308k0a1gm3.jpg)



在本章中，学习创建自己的自定义演示控制器动画，以替换默认的动画，并使本章的项目更加生动。



### 开始项目

本章[开始项目](README.md#关于代码)是一个新项目，叫**BeginnerCook**。

这个开始项目可以简单概括 如下，`ViewController`中包括一个背景图`UIImageView`，一个标题`UILabel`，一个文本视图`UITextView`，下面是一个可以左右移动的`UIScrollView`。这个`UIScrollView`里会用代码加入一些香草(herb)图片，点击图片会跳转到另个展示详情的视图控制器`HerbDetailsViewController`，这个转场是标准的从下到上的垂直覆盖转场动画。



开始项目预览一下：

![](https://ws2.sinaimg.cn/large/006tNbRwgy1fx8i1nv0jdg308o0fq1ky.gif)



下面工作是为这个应用添加一些自定义转场动画，替代默认的转场动画。



### 自定义转场的原理

**UIKit**实现自定义转场动画是通过代理模式完成的。因此首先需要让`ViewController`遵守`UIViewControllerTransitioningDelegate`协议。

每次**呈现**新的视图控制器时，UIKit都会询问其代理是否要使用自定义转场。以下是自定义转场动画的第一步：

![image-20181202172719920](https://ws1.sinaimg.cn/large/006tNbRwgy1fxsj2owhp1j30d9068mye.jpg)

需要实现`animationController(forPresented:presenting:source:) `方法，这个方法如果返回`nil`，则进行默认的转场动画，如果返回时遵守`UIViewControllerAnimatedTransitioning`协议的对象，则将这个对象作为自定义转场的**Animator**（可以翻译为动画师）。



在UIKit使用自定义**Animator**之前，还需要一些步骤：

![image-20181202172932834](https://ws2.sinaimg.cn/large/006tNbRwgy1fxsj4zacy0j30ey06q75k.jpg)

`transitionDuration(using:)`返回动画持续时间。

`animateTransition(using:)`方法时实际动画代码所在的地方。在这个方法中可以访问屏幕上的当前视图控制器以及将要显示的新视图控制器，可以自己根据需要淡化，缩放，旋转等操作现有视图和新视图。

下面开始实现自定义转场！💪

### 实现转场代理

新建一个`NSObject`子类`PopAnimator`(就是之前提到的**Animator**)，并遵守协议 `UIViewControllerAnimatedTransitioning`  。并在这个动画类中添加两个函数的存根：

```swift
func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0
}
    
func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
}
```

让`ViewController`遵守`UIViewControllerTransitioningDelegate`协议：

```swift
extension ViewController: UIViewControllerTransitioningDelegate {
    
}
```



在`didTapImageView(_:)`中的`present(herbDetails, animated: true, completion: nil)`前添加：

```
herbDetails.transitioningDelegate = self
```

现在，每次在屏幕上显示详情页的视图控制器时，UIKit都会向`ViewController`询问动画对象。 但是，目前仍然没有实现任何`UIViewControllerTransitioningDelegate`中的相关方法，因此UIKit仍将使用默认转换。



在 `ViewController`中创建动画属性：

```swift
let transition = PopAnimator()
```



实现呈现时动画的协议方法：

```swift
func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {  
    return transition
}
```

实现解除（dismiss）时动画的协议方法：

```swift
func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return transition
}
```

现在点击香草🌿图片时，没有反应，这是因为，把默认的转场动画修改成了自定义，但自定义动画目前是空的。



### 创建转场动画师

在`PopAnimator`添加：

```swift
let duration = 1.0
var presenting = true
var originFrame = CGRect.zero
```

`duration` 是动画持续时间。

`presenting` 是用判断当前是**呈现**还是**解除**。

`originFrame`用来存储用户点击的图像的原始 *frame* —— **呈现**动画就是需要它从原始*frame*到全屏图像*frame*，对应的**解除**动画正好相反。 

用以下内容替换`transitionDuration()`中的代码：

```swift
return duration
```

#### 设置转场动画的上下文

是时候为`animateTransition(using:)`添加代码了。 此方法有一个类型为`UIViewControllerContextTransitioning`的参数，通过该参数可以访问转场的相关参数和视图控制器。

在开始写动画代码之前，了解动画上下文实际上是什么很重要。

当两个视图控制器之间的转场开始时，现有视图将添加到**转场容器视图**(transition container view)中，并且新视图控制器的视图已创建但尚未可见，如下所示：

![image-20181202105011119](https://ws2.sinaimg.cn/large/006tNbRwgy1fxs7li884gj30f607cjtg.jpg)

因此，现在的任务是将新视图添加到`animateTransition()`中的转场容器中，以特定动画将其显示，如有需要也是特定动画的方式**解除**旧视图。

默认情况下，转场动画完成后，旧视图将从转场容器中删除。

![image-20181202105026911](https://ws2.sinaimg.cn/large/006tNbRwgy1fxs7lpwd9ij30ep07840o.jpg)

下面👇先实现简单的转场动画。



#### 淡出转场

获得动画将在其中进行的容器视图，然后您将获取新视图并将其存储在toView中，在`animateTransition()`中添加：

```swift
let containerView = transitionContext.containerView
let toView = transitionContext.view(forKey: .to)!
```

`view(forKey:)`和`viewController(forKey:)`两个方法非常类似，分别获得转场动画对应的视图和视图控制器。

继续在`animateTransition()`中添加：

```swift
containerView.addSubview(toView)
toView.alpha = 0.0
UIView.animate(withDuration: duration, animations: {
    toView.alpha = 1.0
}, completion: { _ in
    transitionContext.completeTransition(true)
})
```

在动画完成闭包中调用用`completeTransition()`，告诉UIKit你的转场动画已经完成，UIKit可以自由地结束视图控制器转场。

目前的效果就是：

![](https://ws2.sinaimg.cn/large/006tNbRwgy1fxtalfnhalg308q0fnqv6.gif)



#### pop转场

上面的fade效果不是最终想要的，把`animateTransition()`中的代码替换为：

```swift
let containerView = transitionContext.containerView
let toView = transitionContext.view(forKey: .to)!
let herbView = presenting ? toView : transitionContext.view(forKey: .from)!
```



`containerView`是动画将存在的地方，而`toView`是要**呈现**的新视图。 如果是**呈现**（`presenting`为`true`），`herbView`是`toView`，否则将从上下文中获取。 对于**呈现**和**解除**，`herbView`将始终是表现动画的视图。 当呈详细页的控制器视图时，它将逐渐占用整个屏幕。 当被**解除**时，它将缩小到图像的原始帧。

在上面代码后添加：

```swift
let initialFrame = presenting ? originFrame : herbView.frame
let finalFrame = presenting ? herbView.frame : originFrame

let xScaleFactor = presenting ? initialFrame.width / finalFrame.width : finalFrame.width / initialFrame.width
let yScaleFactor = presenting ? initialFrame.height / finalFrame.height : finalFrame.height / initialFrame.height
```

`initialFrame`和`finalFrame`分别是初始和最终动画的`frame`，`xScaleFactor` 和`yScaleFactor`分别是x轴和y轴上视图变化的**比例因子（scale factor）** 。

继续在上面代码后添加：

```swift
let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
        
if presenting {
    herbView.transform = scaleTransform
    herbView.center = CGPoint(x: initialFrame.midX, y: initialFrame.midY)
    herbView.clipsToBounds = true
}
```

当需要**呈现**新视图时，设置`transform`，并且定位（设置`center`）



继续在上面代码后添加：

```swift
containerView.addSubview(toView)
containerView.bringSubview(toFront: herbView)
UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.0, options: [], animations: {
    herbView.transform = self.presenting ? CGAffineTransform.identity : scaleTransform
    herbView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
}) { (_) in
    transitionContext.completeTransition(true)
}
```

首先将`toView`添加到容器中，并确保`herbView`位于顶部，因为这是动画的唯一视图。

然后，实现动画，在这里使用弹簧动画。在动画表达式中，可以更改`herbView`的`transform`和位置。在**呈现**时，将从底部的小尺寸变为全屏；在**解除**时，将全屏缩小变为原始图像大小。

最后，您调用了`completeTransition()`告诉**UIKit**转场动画已经完成。

现在的效果：

![](https://ws3.sinaimg.cn/large/006tNbRwgy1fxtc46bmy7g308q0fnkjl.gif)

动画从左上角开始; 这是因为originFrame的默认值的原点是*(0,0)* 。

在**ViewController.swift**的`animationController(forPresented:presenting:source:)` 返回代码前添加：

```swift
transition.originFrame = selectedImage!.superview!.convert(selectedImage!.frame, to: nil)
transition.presenting = true
selectedImage!.isHidden = true
```

这会将转场动画的`originFrame`设置为`selectedImage`的`frame`，并在动画期间隐藏初始图像。

目前的效果是初始小视图转场到全屏了，没有问题，但是**解除**详情页时就有问题，详情页突然就消失了：

![](https://ws3.sinaimg.cn/large/006tNbRwgy1fxtcugg85pg308q0fn7wj.gif)



#### 解除转场

剩下要做的就是**解除**详细页视图的动画。 

在**ViewController.swift**的`animationController(forDismissed:)`中添加：

```swift
transition.presenting = false
return transition
```

上面的代表 `transition`对象也作为解除转场动画使用。

转场动画看起来很棒，但解除详细页面后，原始的小尺寸的图片消失了。下面就解决这个问题。

在类`PopAnimator`中添加一个闭包属性，作为**解除**动画完成后处理：

```swift
var dismissCompletion: (()->Void)?
```

在`animateTransition(using:)`的`transitionContext.completeTransition(true)`之前添加(也就是通知**UIKit**转场动画结束之前，如果是**解除**动画，就进行一些处理)：

```swift
if !self.presenting {
    self.dismissCompletion?()
}
```

在`ViewController`实现具体闭包内容，在`viewDidLoad()`中添加：

```swift
transition.dismissCompletion = {
    self.selectedImage!.isHidden = false
}
```

那么，目前效果：

![](https://ws2.sinaimg.cn/large/006tNbRwgy1fxtdmixexpg308q0fnnpd.gif)





### 屏幕旋转转场

设备方向更改视为从视图控制器到其自身的转场过程。

iOS 8中引入的`viewWillTransition(to:with:)`方法，用来提供了一种简单直接的方法来处理设备方向的变化。 不需要构建单独的纵向或横向布局，而只需要对视图控制器视图的大小进行更改。

在`ViewController`中添加：

```swift
override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)

    coordinator.animate(alongsideTransition: { context in
                                              self.bgImage.alpha = (size.width > size.height) ? 0.25 : 0.55
                                             }, completion: nil)
}
```



第一个参数（`size`）指视图控制器变换后的大小。 第二个参数（`coordinator`）是转场协调对象，它可以访问许多转场的属性。

`animate(alongsideTransition:completion:)`允许指定自己的自定义动画，与**UIKit**在更改方向时默认执行的旋转动画一起执行。当设备横向时，减少背景图像的透明度，让文本看上去更清晰，更容易阅读。

运行，旋转设备（模拟器中按**Cmd +向左箭头**）：

![](https://ws1.sinaimg.cn/large/006tNbRwgy1fxtf9wmj4eg30n00lpb29.gif)



将屏幕旋转为横向模式时，可以清楚地看到背景变深。



现在上面的动画看上去已经很不错，但如果仔细观看，会发现还有两个问题，**解除**动画时，全屏视图到小视图完成之前看到详细视图的文本；全屏视图是直角，直到动画要完成的最后一个才从直角突然变到圆角。

![](https://ws1.sinaimg.cn/large/006tNbRwgy1fxtfxqpzeog306y07mtq7.gif)



### 平滑转场动画



纠正了细节视图的文本在被解除时消失的问题。

在`animateTransition(using:)`中的动画(`UIView.animate(...)`)开始前添加：

```swift
let herbController = transitionContext.viewController(forKey: presenting ? .to : .from) as! HerbDetailsViewController

if presenting {
    herbController.containerView.alpha = 0.0
}
```

在`animateTransition(using:)`中的动画闭包中添加：

```swift
herbController.containerView.alpha = self.presenting ? 1.0 : 0.0
```



### 圆角动画

最后，为详情页视图的图层角半径设置动画，使其与主视图控制器中草本图像的圆角相匹配。

在`animateTransition(using:)`中的动画闭包中添加：

```swift
herbView.layer.cornerRadius = self.presenting ? 0.0 : 20.0/xScaleFactor
```

> 为了更方便的查看动画，可以把持续时间增大或用模拟器中满动画（**Command + T**）。

上面两个修改后的效果：

![](https://ws3.sinaimg.cn/large/006tNbRwgy1fxtgx7q5s5g308s0fqqv5.gif)







## 18-导航控制器转场



`UINavigationController`是iOS中为数不多的内置应用导航解决方案之一。 将一个新的视图控制器推入或弹出导航堆栈，这个过程自带一个时尚的动画。 

![](https://ws3.sinaimg.cn/large/006tNbRwgy1fy8go5czmog308q09fgp7.gif)



上图显示了iOS如何将新视图控制器推送到设置应用中的导航堆栈：新视图从右侧滑入以覆盖旧视图，新标题淡入，而旧标题淡出。

本章的自定义导航控制器转场与前一章中构建自定义视图控制器转场的方式类似。

### 开始项目

本章[开始项目](README.md#关于代码)是一个新项目，叫**LogoReveal**  。

![](https://ws2.sinaimg.cn/large/006tNbRwgy1fy8gxv524xj307o0amwet.jpg)

点击默认屏幕任意地方（`MasterViewController`），跳转展示vacation packing list页面(`DetailViewController`)，RW Logo是通过`UIBezierPath`绘制的`CAShapeLayer`图层。

### 自定义导航控制器转场的原理

自定义导航控制器转场的原理类似上一章节的[自定义转场的原理](#自定义转场的原理)，同样也可以用两个图概括：

![image-20181203214052969](https://ws1.sinaimg.cn/large/006tNbRwgy1fxtw0sqszej30dz05e3z5.jpg)



![image-20181203214104467](https://ws2.sinaimg.cn/large/006tNbRwgy1fxtw10skywj30e206374n.jpg)

### 导航控制器代理

首先需要新建一个**Animator**，新建一个`NSObject`子类`RevealAnimator`的类文件，并让它遵守`UIViewControllerAnimatedTransitioning`协议：

```swift
class RevealAnimator: NSObject, UIViewControllerAnimatedTransitioning {

}
```

在`RevealAnimator`中添加两个属性，并且实现`UIViewControllerAnimatedTransitioning`协议的两个方法：

```swift
    let animationDuration = 2.0
    var operation: UINavigationControllerOperation = .push
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) 
	{
        
    }
```

`operation`是`UINavigationControllerOperation`类型的属性，用于表示是在推送还是弹出控制器。



用扩展的方式让`MasterViewController`遵守`UINavigationControllerDelegate`协议：

```swift
extension MasterViewController: UINavigationControllerDelegate {
    
}
```

在调用任何*segues*或将某些内容推送到堆栈之前，需要在视图控制器生命周期的早期设置导航控制器的代理。在`MasterViewController`的`viewDidLoad()`中添加：

```swift
navigationController?.delegate = self
```

在`MasterViewController`中创建Animator属性：

```swift
let transition = RevealAnimator()
```

实现协议`UINavigationControllerDelegate`的方法`navigationController()`:

```swift
func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    transition.operation = operation
    return transition
}
```

这是一个方法名称非常长，参数有：

`navigationController`：当对象是多个导航控制器的委托时，这用来区分导航控制器，这不是太常见。

`operation`：这是一个枚举`UINavigationControllerOperation`，可以是`.push`或`.pop`。

`fromVC`：这是当前在屏幕上可见的视图控制器，它通常是导航堆栈中的最后一个视图控制器。

`toVC`：这是将转场到的视图控制器。

如果需要不同视图控制器有不同转场动画，则可以选择返回不同的**Animator**。为了简化此项目，在推送或弹出转场时，都返回`RevealAnimator`对象。

运行，点击，导航栏有一个两秒转场，但其他就没有反应了，这是因为`animateTransition()`中还没有编写任何代码。

![](https://ws4.sinaimg.cn/large/006tNbRwgy1fxtmk2z7xbg308s090mxf.gif)







### 添加自定义显示动画

自定义转场动画的计划相对简单。 您只需在`DetailViewController`上为蒙版设置动画，使其看起来像RW徽标的透明部分，显示底层视图控制器的内容。
你将不得不处理图层和一些动画任务，但是到目前为止你还没有完成任务。 对于像你这样的动画专业人士来说，创建转场动画将是一件轻松的事！

在`RevealAnimator`中创建一个存储动画上下文的属性：

```swift
weak var storedContext: UIViewControllerContextTransitioning?
```

再在`animateTransition()`中添加：

```swift
storedContext = transitionContext

let fromVC = transitionContext.viewController(forKey: .from) as! MasterViewController
let toVC = transitionContext.viewController(forKey: .to) as! DetailViewController

transitionContext.containerView.addSubview(toVC.view)
toVC.view.frame = transitionContext.finalFrame(for: toVC)
```

先获取`fromVC`并将其转换为`MasterViewController`；然后，获取`toVC`并转换为`DetailViewController`。
最后，只需将`toVC.view`添加到转场容器视图中，并将其`frame`设置为`transitionContext`中的最终`frame`，这是详情页面在主屏幕上的最终位置。



将以下内容添加到`animateTransition()`中：

```swift
let animation = CABasicAnimation(keyPath: "transform")
animation.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
animation.toValue = NSValue(caTransform3D: 		CATransform3DConcat(CATransform3DMakeTranslation(0.0, -10.0, 0.0), CATransform3DMakeScale(150.0, 150.0, 1.0)))
```

这个动画将logo的大小增加了150倍，并同时向上移动了一点。 为什么？ logo的形状不均匀，我希望后面的视图控制器通过RW形状的“孔”显示。 将其向上移动意味着缩放图像的底部将更快地覆盖屏幕。


如果使用像圆形或椭圆形这种对称的logo，就不会有这种问题。

现在将以下面代码添加到`animateTransition()`以稍微优化动画：

```swift
animation.duration = animationDuration
animation.delegate = self
animation.fillMode = kCAFillModeForwards
animation.isRemovedOnCompletion = false
animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
```

这些都是前面章节的知识。

`RevealAnimator`目前还不是动画代理，记得要让`RevealAnimator`遵守`CAAnimationDelegate` 协议。

在`animateTransition()`中添加图层：

```swift
let maskLayer: CAShapeLayer = RWLogoLayer.logoLayer()
maskLayer.position = fromVC.logo.position
toVC.view.layer.mask = maskLayer
maskLayer.add(animation, forKey: nil)
```



效果：

![](https://ws3.sinaimg.cn/large/006tNbRwgy1fxtnj606n9g308s0fq0uw.gif)





### 优化细节

细看上面的效果，会发现动画运行时，原来的logo还在那里，下面解决这个问题。

在`animateTransition()`中添加：

```swift
fromVC.logo.add(animation, forKey: nil)
```

运行后，没有有原始的logo了：

![](https://ws1.sinaimg.cn/large/006tNbRwgy1fxtnwpmszsg308s0fq777.gif)



还有一个稍微复杂一点的问题：在第一次推送转场后，导航不再工作了？





在 `RevealAnimator`中实现`CAAnimationDelegate`的`animationDidStop(_:finished:)`方法：

```swift
func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
    if let context = storedContext {
        context.completeTransition(!context.transitionWasCancelled)
        // reset logo
    }
    storedContext = nil
}
```

在方法结束时，只需将转场上下文设置为`ni`l。

由于显示动画在完成后不会自动删除，因此需要自己处理。

使用以下内容替换位于`animationDidStop()`中的`// reset logo`：

```swift
let fromVC = context.viewController(forKey: .from) as! MasterViewController

fromVC.logo.removeAllAnimations()
```

只需要在推送转场期间屏蔽视图控制器的内容，一旦视图控制器完成转场，就可以安全地移除屏蔽。

接着上面的代码t添加：

```swift
let toVC = context.viewController(forKey: .to) as! DetailViewController
toVC.view.layer.mask = nil
```

运行报错：

![image-20181203170902426](https://ws3.sinaimg.cn/large/006tNbRwgy1fxto5z7a9fj313y07kwgw.jpg)

这是因为，上面的代码只适用于推送，但不适用于弹出。



把`animateTransition()`中除了第一行`storedContext = transitionContext`的代码，都包含在if语句中：

```swift
if operation == .push {
    ...
}
```



### 淡入新视图控制器

转场时，给详情页面添加淡入的动画。

在`animateTransition(using:)`的`if operation == .push {`语句中添加：

```swift
let fadeIn = CABasicAnimation(keyPath: "opacity")
fadeIn.fromValue = 0.0
fadeIn.toValue = 1.0
fadeIn.duration = animationDuration
toVC.view.layer.add(fadeIn, forKey: nil)
```



### 弹出转场

前面都是推送转场，现在添加是弹出转场。

给在`animateTransition(using:)`的`if`语句添加一个`else` ：

```swift
else {
    let fromView = transitionContext.view(forKey: .from)!
    let toView = transitionContext.view(forKey: .to)!

    transitionContext.containerView.insertSubview(toView, belowSubview: fromView)

    UIView.animate(withDuration: animationDuration, delay: 0.0, options: .curveEaseIn, animations: {
        fromView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
    }) { (_) in
        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
       }
}
```



最终效果会是：

![](https://ws1.sinaimg.cn/large/006tNbRwgy1fxtxbxrvowg308s0fqan5.gif)





## 19-交互式导航控制器转场



您不仅可以为转换创建自定义动画 - 还可以使其交互并响应用户的操作。通常，您通过平移手势驱动此操作，这是您将在本章中采用的方法。
当您完成后，您的用户将能够通过在屏幕上滑动手指来来回穿过显示转场。那会有多酷？
是的，我以为你会感兴趣！继续阅读，了解它是如何完成的！

关于手势处理，可看我的一篇简单的小结 [iOS tutorial 13：手势处理](http://andyron.com/2017/ios-tutorial-13.html)。

本章[开始项目](README.md#关于代码)使用上一章节完成的项目。

### 创建交互式转场

当导航控制器向其代理询问动画控制器（就是之前提到Animator）时，可能会发生两件事。返回nil，在这种情况下，导航控制器会运行标准转场动画； 如果返回一个动画控制器，那么导航控制器除了会向其代理询问转场动画控制器，也会询问交互控制器，如下所示：

![image-20181216165544709](https://ws1.sinaimg.cn/large/006tNbRwgy1fy8ou4nshrj30fm06lt9a.jpg)



交互控制器根据用户的操作移动转场，而不是简单地从开始到结束动画更改。 交互控制器不一定需要是与动画控制器分开的类；实际上，当两个控制器在同一个类中时，执行某些任务会更容易一些。 您只需要确保所述类遵守`UIViewControllerAnimatedTransitioning`和`UIViewControllerInteractiveTransitioning`两个协议。

`UIViewControllerInteractiveTransitioning`只有一个必需实现的方法 `startInteractiveTransition(_:)` ，它将转换上下文作为参数。 然后，交互控制器会定期调用updateInteractiveTransition（_ :)来移动转换。 首先，您需要更改处理用户输入的方式。



### 处理平移手势



把点击手势修改成平移手势。平移手势可观察到转场的开始、过程和结束的状态。

先把底部的标签的文本修改成 **Slide to start**。



接下来，在`MasterViewController.swift`的`viewDidAppear(_:)`中删除以下代码：

```swift
let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
view.addGestureRecognizer(tap)
```

替代为平移手势识别代码：

```swift
let pan = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
view.addGestureRecognizer(pan)
```

当用户在屏幕上滑动是，会被识别然后调用`didPan(_:)`方法。

在`MasterViewController`中添加空`didPan(_:)`。



### 使用交互式动画师类

为了处理上面的转场，需要使用内置的交互式动画师类：`UIPercentDrivenInteractiveTransition`。 此类遵守`UIViewControllerInteractiveTransitioning`协议，并可以将转场的进度表示为完成百分比。



打开**RevealAnimator.swift**，并更新文件顶部的类定义，如下所示：

```swift
class RevealAnimator: UIPercentDrivenInteractiveTransition, UIViewControllerAnimatedTransitioning, CAAnimationDelegate {
    
```

请注意，`UIPercentDrivenInteractiveTransition`是一个类，而不是其他协议，所以需要处于第一位置。 

添加一个属性，来表示是否已交互方式驱动转场动画：

```swift
var interactive = false
```

添加方法到`RevealAnimator`中：

```swift
func handlePan(_ recognizer: UIPanGestureRecognizer) {

}
```

当用户在屏幕上平移时，识别器将被传递给`RevealAnimator`中的`handlePan(_:)`处理，来更新当前的转场进度。 



在**MasterViewController.swift**中添加委托方法：

```swift
func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    if !transition.interactive {
        return nil
    }
    return transition
}
```

当希望转场为交互式时，只需返回交互式控制器，否则返回`nil`。

现在，需要将平移手势识别器连接到交互控制器。 在`didPan(_:)`中添加：

```swift
switch recognizer.state {
    case .began:
    	transition.interactive = true
    	performSegue(withIdentifier: "details", sender: nil)
    default:
    	transition.handlePan(recognizer)
}
```

当平移手势开始时，确保交互设置为`true`，然后通过 *segue* 连接到下一个视图控制器。 执行segue将启动转场，这时动画控制器和交互控制器的委托方法将返回转场动画。

如果手势已经开始，只需将操作交给交互控制器，如下图所示：

![image-20181203233104113](https://ws4.sinaimg.cn/large/006tNbRwgy1fxtz7gpuxxj30bh06zdgi.jpg)





### 计算转场动画的进度

平移手势处理程序中最重要的一点是要弄清楚转场的进度。

打开**RevealAnimator.swift**，并将以下代码添加到`handlePan`中：

```swift
let translation = recognizer.translation(in: recognizer.view!.superview!)
var progress: CGFloat = abs(translation.x / 200.0)
progress = min(max(progress, 0.01), 0.99)
```

通过平移手势识别器计算转场的经度。从逻辑上讲，用户离开初始位置越远，转场的进度就越大。

`200.0`是一个合理的任意数字，来表示转场完成所需要的距离。

下面更新转场动画的进度，将以下代码添加到`handlePan()`中：

```swift
switch recognizer.state {
    case .changed:
    	update(progress)
    default:
    	break
}
```

`update()` 是来自`UIPercentDrivenInteractiveTransition`的方法，它设置转场动画的当前进度。

当用户在屏幕上平移时，手势识别器会重复调用`MasterViewController`中`didPan()`，从而不停的调用`RevealAnimator`中 的`handlePan()`来更新转场进度。


在`RevealAnimator`中添加属性：

```swift
private var pausedTime: CFTimeInterval = 0
```

现在，通过将以下代码添加到`animateTransition(using:)`来控制图层：

```swift
if interactive {
    let transitionLayer = transitionContext.containerView.layer
    pausedTime = transitionLayer.convertTime(CACurrentMediaTime(), from: nil)
    transitionLayer.speed = 0
    transitionLayer.timeOffset = pausedTime
}
```

这里做的是阻止图层运行自己的动画。 这将冻结所有子图层动画。 

重写`update(_:)`，以将图层与动画一起移动：

```swift
override func update(_ percentComplete: CGFloat) {
    super.update(percentComplete)

    let animationProgress = TimeInterval(animationDuration) * TimeInterval(percentComplete)
    storedContext?.containerView.layer.timeOffset = pausedTime + animationProgress
}
```



运行效果：

![](https://ws3.sinaimg.cn/large/006tNbRwgy1fy9iqrfex0g308q0fogwz.gif)

这边出现问题，就是手指离开屏幕后，动画立即停止，再次滑动时也没有反应。



### 处理提前终止

处理上面的问题。

在`handlePan()`的switch语句中添加`case`：

```swift
case .cancelled, .ended:
    if progress < 0.5 {
        cancel()
    } else {
        finish()
    }
```

在用户手指离开屏幕之前，如果平移得足够远，就表示转场完成，呈现新的视图控制器；相反，就滚回原来的视图控制器。
![](https://ws2.sinaimg.cn/large/006tNbRwgy1fy9kfeum2qj30db04zaae.jpg)

重写`cancel()` 和 `finish()`方法：

```swift
override func cancel() {
    restart(forFinishing: false)
    super.cancel()
}

override func finish() {
    restart(forFinishing: true)
    super.finish()
}

private func restart(forFinishing: Bool) {
    let transitionLayer = storedContext?.containerView.layer
    transitionLayer?.beginTime = CACurrentMediaTime()
    transitionLayer?.speed = forFinishing ? 1 : -1
}
```



在`.cancelled，.ended`的`case`中添加：

```swift
interactive = false
```



本章最后的效果：

![](https://ws1.sinaimg.cn/large/006tNbRwgy1fy9krwbad6g308q0fogzr.gif)