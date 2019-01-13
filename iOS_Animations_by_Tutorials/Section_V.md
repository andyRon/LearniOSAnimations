# 系统学习iOS动画之五：使用UIViewPropertyAnimator



`UIViewPropertyAnimator`是从iOS10开始引入，它能够创建易于交互，可中断和/或可逆的视图动画。

这个类让某些类型的视图动画更容易创建，值得学习。

`UIViewPropertyAnimator`可以在同一个类中方便地将许多API包装在一起，这样更容易使用。

此外，这个新类不能完全取代了`UIView.animate(withDuration...)`API集。



**内容预览：**

[20-UIViewPropertyAnimator入门](#20-UIViewPropertyAnimator入门) 

[21-深入UIViewPropertyAnimator](#21-深入UIViewPropertyAnimator)  

[22-用UIViewPropertyAnimator进行交互式动画](#22-用UIViewPropertyAnimator进行交互式动画)  

[23-用UIViewPropertyAnimator自定义视图控制器转场](#23-用UIViewPropertyAnimator自定义视图控制器转场)  



> 本文的四个章节都是使用同一个项目 **LockSearch**



## 20-UIViewPropertyAnimator入门


在iOS10之前，创建基于视图的动画的唯一选择是`UIView.animate(withDuration: ...)`I，但这组API没有为开发人员提供暂停或停止已经运行的动画的处理方式。此外，对于反转，加速或减慢动画，开发人员只能使用基于图层的`CAAnimation`（核心动画）。

`UIViewPropertyAnimator`就是为了解决上述问题而出现的，它是一个允许保持运行动画的类，允许开发者调整当前运行的动画，并提供有关动画当前状态的详细信息。

当然，简单单一的视图动画直接使用`UIView.animate(withDuration: ...)`就可以了。

### 基础动画

本章的[开始项目](README.md#关于代码) **LockSearch** 。 类似于iOS锁屏时的屏幕。 初始视图控制器有搜索栏，单个窗口小部件和编辑按钮等：

![](https://ws1.sinaimg.cn/large/006tNbRwgy1fxukdn545vj31c00u0gy0.jpg)

[开始项目](README.md#关于代码) 已经实现了一些与动画无关的功能。 例如，如果点击**Show More**按钮，窗口小部件将展开并显示更多项目。 如果点击编辑，会转到另一个视图控制器，这是一个简单的TableView。

当然，该项目只是模拟iOS中的锁定屏幕，用来学习动画，没有实际的功能，。

打开`LockScreenViewController.swift`并向该视图控制器添加一个新的`viewWillAppear(_:)`方法：

```swift
override func viewWillAppear(_ animated: Bool) {
    tableView.transform = CGAffineTransform(scaleX: 0.67, y: 0.67)
    tableView.alpha = 0
}
```

为了创建简单的缩放和淡入淡出视图动画，首先缩小整个表视图并使其透明。

接下来，在视图控制器的视图出现在屏幕上时创建一个动画师。 将以下内容添加到`LockScreenViewController`：

```swift
override func viewDidAppear(_ animated: Bool) {
    let scale = UIViewPropertyAnimator.init(duration: 0.33, curve: .easeIn) {
    }
}
```

在这里，您使用`UIViewPropertyAnimator`的一个[便利构造器](http://andyron.com/2017/swift-14-initialization.html#5-类的继承和构造过程)：`UIViewPropertyAnimator.init(duration:curve:animations:)`。

通过构造器创建动画实例并设置动画的总持续时间和时间曲线。 后一个参数的类型为`UIViewAnimationCurve`，这是一个枚举类型，有四个类型：`easeInOut`、`easeIn`、`easeOut`、`linear`。这与`UIView.animate(withDuration:...)`中的[`option`](Section_I.md#动画缓动)是类似的。



#### 添加动画

在`viewDidAppear(_:)`中添加：

```swift
scale.addAnimations {
    self.tableView.alpha = 1.0
}
```

使用`addAnimations`添加动画代码块，就像`UIView.animate(withDuration...)`的闭包参数`animations`。 使用动画师的不同之处在于可以添加多个动画块。

除了能够有条件地构建复杂的动画外，还可以添加具有不同延迟的动画。 另一个版本的`addAnimations`，有两个参数：
`animation`  动画代码
`delayFactor`  动画开始前的延迟

`delayFactor`与`UIView.animate(withDuration...)`中`delay`不同，它介于0.0到1.0，不是绝对时间是相对时间。



在同一个动画师添加第二个动画，但有一些延迟。继续在上面的代码后添加：

```swift
scale.addAnimations({
    self.tableView.transform = .identity
}, delayFactor: 0.33)
```

实际延迟时间是`delayFactor`乘以动画师的剩余持续时间(remaining duration)。 目前尚未启动动画，因此剩余持续时间等于总持续时间。
所以在上面的情况：

```swift
delayFactor(0.33) * remainingDuration(=duration 0.33) = delay of 0.11 seconds
```



**为什么第二个参数不是一个简单的秒数值？**
想象动画师已经在运行了，你决定在中途添加一些新的动画。 在这种情况下，剩余持续时间不会等于总持续时间，因为自启动动画以来已经过了一段时间。

![image-20181204120317868](https://ws4.sinaimg.cn/large/006tNbRwgy1fxuky4tem3j30e2055q37.jpg)

在这种情况下，`delayFactor`将允许开发者根据剩余可用时间设置延迟动画。 此外，这样设计也确保了不能将延迟设置为长于剩余运行时间。

![image-20181204120335113](https://ws4.sinaimg.cn/large/006tNbRwgy1fxukyfk6x4j30co054glu.jpg)

#### 添加完成闭包

在`viewDidAppear(_:)`中添加：

```swift
scale.addCompletion { (_) in
    print("ready")
}
```

`addCompletion(_:)`就是动画完成闭包，当然，它也可多次调用，来完成多了处理程序。

下面要启动动画，在`viewWillAppear(_:)`的末尾添加：

```swift
scale.startAnimation()
```



### 提取动画

为了代码的清晰，可以把动画代码集中放到一个类中。

创建一个名为`AnimatorFactory.swift`的新文件，并将其默认内容替换为：

```swift
import UIKit

class AnimatorFactory {
  
}
```

然后添加一个类型方法，其中包含刚刚编写的动画代码，但默认情况下不运行动画，而是返回动画师：

```swift
static func scaleUp(view: UIView) -> UIViewPropertyAnimator {
    let scale = UIViewPropertyAnimator(duration: 0.33, curve: .easeIn)

    scale.addAnimations {
        view.alpha = 1.0
    }

    scale.addAnimations({
        view.transform = .identity
    }, delayFactor: 0.33)

    scale.addCompletion { (_) in
                         print("ready")
                        }

    return scale
}
```

该方法将视图作为参数，并在该视图上创建所有动画，最后它返回准备好的动画师。

将`LockScreenViewController`中的`viewDidAppear(_:)`替换为：

```swift
override func viewDidAppear(_ animated: Bool) {
    AnimatorFactory.scaleUp(view: tableView).startAnimation()
}
```

这样看上去代码更加简洁，清晰，把动画代码从视图控制器移出。

这个动画师工厂🏭类`AnimatorFactory`集中处理动画代码，这是设计模式中的工厂模式的一个简单应用。😀



### 运行动画师

<!--

此时你可能会问自己”如果动画对象的唯一目的是立即开始，那么创建动画对象有什么意义呢？“
这是个好问题！

如果您需要运行单个动画块并且不再需要更改，请继续使用`UIView.animate(withDuration: ...)`。您决定使用哪个API的转折点取决于您是想简单地运行动画 - 还是运行动画并最终与之交互。

如果你想使用UIViewPropertyAnimator但你仍然只有一个动画和完成块，并想立即运行它会怎么样？是不是有更简化的方式来创建这样的动画？
为什么，是的，有！你问我很高兴。这就是本章的这一部分被称为运行动画师的原因。在UIViewPropertyAnimator上有一个类方法，它创建一个动画师并立即为你启动它。

-->

当用户使用搜索栏时，将淡入模糊图层（blurView），并在用户完成搜索时将其淡出。

向`LockScreenViewController`类添加一个新方法：

```swift
func toggleBlur(_ blurred: Bool) {
    UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0.1, options: .curveEaseOut, animations: {
        self.blurView.alpha = blurred ? 1 : 0
    }, completion: nil)
}
```

`UIViewPropertyAnimator.runningPropertyAnimator(withDuration:...)`与`UIView.animate(withDuration:...)`有完全相同的参数，使用也相同。

虽然看起来这可能是一种**“即发即忘”**(“fire-and-forget” )的API，但请注意它确实会返回一个动画实例。 因此，您可以添加更多动画，更多完成块，并且通常与当前正在运行的动画进行交互。

现在让我们看看淡入淡出动画的样子。 LockScreenViewController已设置为搜索栏的委托，因此您只需实现所需的方法即可在正确的时间触发动画。

以扩展的方式为`LockScreenViewController`遵守搜索栏的代理协议：

```swift
extension LockScreenViewController: UISearchBarDelegate {
  
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    toggleBlur(true)
  }
  
  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    toggleBlur(false)
  }
}
```

 要为用户提供取消搜索的功能，还要添加以下两种方法：

```swift
  func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if searchText.isEmpty{
      searchBar.resignFirstResponder()
    }
  }
```

这将允许用户通过点击右侧按钮解除搜索。 

运行，效果：

![](https://ws1.sinaimg.cn/large/006tNbRwgy1fxulof5jzqg308q09lwov.gif)

点按搜索栏文本字段，小部件在模糊效果视图下消失；点击搜索栏右侧的按钮时，模糊视图会淡出。



### 基础关键帧动画

`UIViewPropertyAnimator`也可以使用`UIView.addKeyframe`([5-视图的关键帧动画](Section_I.md#5-关键帧动画))。下面创建一个简单的图标抖动动画来展示。



在`AnimatorFactory`中添加类型方法：

```swift
  static func jiggle(view: UIView) -> UIViewPropertyAnimator {
    return UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.33, delay: 0
      , animations: {
        UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.25, animations: {
          view.transform = CGAffineTransform(rotationAngle: -.pi/8)
        })
        UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.75, animations: {
          view.transform = CGAffineTransform(rotationAngle: +.pi/8)
        })
        UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 1.0, animations: {
          view.transform = CGAffineTransform.identity
        })
    }, completion: { (_) in
      
    })
  }
```

第一个关键帧向左旋转，第二个关键帧向右旋转，最后第三个关键帧回到原点 。

要确保图标保持在其初始位置，在完成闭包中添加：

```swift
view.transform = .identity
```

下面就可以在想要运行这个动画的视图上添加动画了。



打开`IconCell.swift`（该文件位于Widget子文件夹中）。这是自定义单元类，对应于窗口小部件视图中的每个图标。
在`IconCell`中添加：

```swift
func iconJiggle() {
    AnimatorFactory.jiggle(view: icon)
}
```

现在**Xcode**抱怨`AnimatorFactory.jiggle`方法返回一个结果没有被使用，这是Xcode善意的提醒😊。

![image-20181204124154609](https://ws1.sinaimg.cn/large/006tNbRwgy1fxum2bblu4j31gy032t98.jpg)

这个问题很容易解决，只需要在`jiggle`方法前添加`@discardableResult`，让Xcode知道这个方法的结果我不要了😏。

> `discardableResult`的[官方解释](https://docs.swift.org/swift-book/ReferenceManual/Attributes.html)：
>
> Apply this attribute to a function or method declaration to suppress the compiler warning when the function or method that returns a value is called without using its result.

```swift
  @discardableResult
  static func jiggle(view: UIView) -> UIViewPropertyAnimator {
```


要最终运行动画，在`WidgetView.swift` 的`collectionView(_:didSelectItemAt:)`中添加：

```swift
if let cell = collectionView.cellForItem(at: indexPath) as? IconCell {
    cell.iconJiggle()
}
```

效果：

![](https://ws3.sinaimg.cn/large/006tNbRwgy1fxumdsesopg308q06075c.gif)







### 提取模糊动画

把前面的模糊动画也提取到`AnimatorFactory`中。

```swift
@discardableResult
static func fade(view: UIView, visible: Bool) -> UIViewPropertyAnimator {
    return UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0.1, options: .curveEaseOut, animations: {
        view.alpha = visible ? 1.0 : 0.0
    }, completion: nil)
}
```

替代`LockScreenViewController`中的`toggleBlur（_:）`方法：

```swift
func toggleBlur(_ blurred: Bool) {
    AnimatorFactory.fade(view: blurView, visible: blurred)
}
```



### 防止动画重叠

**如何检查动画师当前是否正在执行其动画？**



如果在同一个图标上快速连续点击，会发现抖动动画没有结束就重新开始了。

![](https://ws2.sinaimg.cn/large/006tNbRwgy1fxumve35v2g308k06076o.gif)

解决这个问题，就需要检测视图是否有动画正在运行。

为`IconCell`添加一个属性，并修改`iconJiggle()`：

```swift
  var animator: UIViewPropertyAnimator?

  func iconJiggle() {
    if let animator = animator, animator.isRunning {
      return
    }

    animator = AnimatorFactory.jiggle(view: icon)
  }
```

对比可以发现有所不同：

![](https://ws1.sinaimg.cn/large/006tNbRwgy1fxumwxwqd0g308k0600uv.gif)









## 21-深入UIViewPropertyAnimator

上一章节学习了`UIViewPropertyAnimator`的基本使用，这一章节学习更多关于`UIViewPropertyAnimator`的知识。

>  本章的[开始项目](README.md#关于代码) 使用上一章节完成的项目。



### 自定义动画计时

前文已经多次提到：`easeInOut`、`easeIn`、`easeOut`、`linear`（可以理解为物体运动轨迹的曲线类型）。可以参考[视图动画中的动画缓动](Section_I.md#动画缓动) 或者[图层动画中的动画缓动](Section_III.md#动画缓动)，这边就不再介绍了。

#### 内置时间曲线

目前，当您激活搜索栏时，您会在窗口小部件顶部的模糊视图中淡入淡出。 在此示例中，您将删除该淡入淡出动画并为模糊效果本身设置动画。

之前，激活搜索栏时，就会有一个模糊视图中淡入淡出效果。这个部分删除这个效果，修改成对模糊效果本身设置动画。什么意思呢？ 看完下面的操作，应该能明白。

向`LockScreenViewController`类添加一个新方法：

```swift
func blurAnimations(_ blured: Bool) -> () -> Void {
    return {   
    	self.blurView.effect = blured ? UIBlurEffect(style: .dark) : nil
		self.tableView.transform = blured ? CGAffineTransform(scaleX: 0.75, y: 0.75) : .identity
		self.tableView.alpha = blured ? 0.33 : 1.0
    }
}
```

删除`viewDidLoad()`中的两行代码：

```swift
    blurView.effect = UIBlurEffect(style: .dark)
    blurView.alpha = 0
```

替代`toggleBlur(_:)`内容为：

```swift
func toggleBlur(_ blurred: Bool) {
    UIViewPropertyAnimator(duration: 0.55, curve: .easeOut, animations: blurAnimations(blurred)).startAnimation()
}
```

运行，效果：

![](https://ws4.sinaimg.cn/large/006tNbRwgy1fxur7gcxngg308k09u11x.gif)



请注意模糊不仅仅是淡入或淡出，实际上它会在效果视图中插入模糊量。



#### 贝塞尔曲线

有时想要对动画的时间非常具体时，使用这些曲线简单地“开始减速”或“慢慢结束”是不够的。

在[10-动画组和时间控制](Section_III.md#10-动画组和时间控制) 中学习了使用`CAMediaTimingFunction`控制图层动画的时间。

之前没有了解背后的原理**贝塞尔曲线**，这边介绍一下它。这边的内容也可应用到图层动画中。

**贝塞尔曲线是什么？**

让我们从简单的事情开始 —— 一条线。它非常简洁，需要在屏幕上画一条线，只需要定义它的两个点的坐标，开始 *(A)* 和结束 *(B)*：

![image-20181204154619268](https://ws3.sinaimg.cn/large/006tNbRwgy1fxure6zmgcj309q036aa0.jpg)



现在让我们来看看曲线。曲线比线条更有趣，因为它们可以在屏幕上绘制任何东西。例如：

![image-20181204154744302](https://ws1.sinaimg.cn/large/006tNbRwgy1fxurfnsi7zj30c706cq37.jpg)

在上面看到的是四条曲线放在一起;它们的两端在小白方块的地方相遇。图中有趣的是小绿圈，它们定义了每条曲线。

所以曲线不是随机的。它们也有一些细节，就像线条一样，可以帮助我们通过坐标定义它们。

您可以通过向线条添加控制点来定义曲线。 让我们在之前的行中添加一个控制点：

![image-20181204154909038](https://ws1.sinaimg.cn/large/006tNbRwgy1fxurh4vhhdj30aw052gly.jpg)

可以想象由连接到线的铅笔绘制的曲线，其起点沿着线AC移动，其终点沿着线CB移动：

![image-20181204154949279](https://ws4.sinaimg.cn/large/006tNbRwgy1fxurhti255j30fu03ljrn.jpg)

网上找了一个动图：

![](https://ws3.sinaimg.cn/large/006tNbRwgy1fyayz6r66pg30a0046tax.gif)

具有一个控制点的Bézier曲线称为 *二次曲线*。有两个控制点的Bézier曲线叫做 *三次曲线*（立方贝塞尔曲线）。
我们使用的内置曲线就是三次曲线。

核心动画使用始终以坐标（0,0）开始的三次曲线，它表示动画持续时间的开始。 当然，这些时间曲线的终点始终是（1,1），表示 动画的持续时间和进度的结束。

让我们来看看 *ease-in* 曲线：

![image-20181204155458179](https://ws4.sinaimg.cn/large/006tNbRwgy1fxurn6i2vqj309107kdg7.jpg)

随着时间的推移（在坐标空间中从左向右水平移动），曲线在垂直轴上的进展非常小，然后大约在动画持续时间的一半时间后，曲线在垂直轴上的进展非常大，最终在(1, 1)处结束。

*ease-out* 和 *ease-in-out*曲线分别是：

![image-20181204155513973](https://ws4.sinaimg.cn/large/006tNbRwgy1fxurngb6dwj30f306tt9l.jpg)



现在已了解Bézier曲线的工作原理，剩下的问题是如何在视觉上设计一些曲线并获得控制点的坐标，方便可以将它们用于iOS动画。

可以使用网站：http://cubic-bezier.com。 这是计算机科学研究员和演讲者Lea Verou的非常方便的网站。 它可以拖动立方Bézier的两个控制点并查看即时动画预览，非常nice😊😊。

![](https://ws4.sinaimg.cn/large/006tNbRwgy1fxurmuxor9j31br0i5n0t.jpg)

> 上面贝塞尔的原理说的不够深刻🤦‍♀️，现在只需了解曲线，通过两个控制点可以画曲线。



接下来，向项目中添加自定义计时动画。

把`LockScreenViewController`中的`toggleBlur()`的现有动画替换为：

```swift
func toggleBlur(_ blurred: Bool) {
    UIViewPropertyAnimator(duration: 0.55, controlPoint1: CGPoint(x: 0.57, y: -0.4), controlPoint2: CGPoint(x: 0.96, y: 0.87), animations: blurAnimations(blurred)).startAnimation()
}
```

这边的`controlPoint1` 和`controlPoint2`两个点，就是我们自定义三次曲线的控制点。

可以通过 http://cubic-bezier.com 网站来选着控制点。



#### 弹簧动画

另一个便利构造器`UIViewPropertyAnimator(duration:dampingRatio:animations:)`，用于定义弹簧动画。

这与`UIView.animate(withDuration: delay: usingSpringWithDamping: initialSpringVelocity: options: animations: completion:) `类似，只不过初始速度为0。



#### 自定义时间曲线 

`UIViewPropertyAnimator`类还有一个构造器`UIViewPropertyAnimator(duration:timingParameters:)`。

参数`timingParameters`必须遵守`UITimingCurveProvider`协议，有两个类可供我们使用：[`UICubicTimingParameters`](https://developer.apple.com/documentation/uikit/uicubictimingparameters)和[`UISpringTimingParameters`](https://developer.apple.com/documentation/uikit/uispringtimingparameters)。

下面看看这个构造器的使用方式。



#### 阻尼和速度

添加阻尼和速度的方式如下：

```swift
let spring = UISpringTimingParameters(dampingRatio:0.5, initialVelocity: CGVector(dx: 1.0, dy: 0.2))

let animator = UIViewPropertyAnimator(duration: 1.0, timingParameters: spring)
```

注意初始速度`initialVelocity`是**矢量类型**，这个参数是一个可选参数。



#### 自定义弹簧动画

如果想对弹簧动画更加具体的设置，可以`UISpringTimingParameters`的另一个构造器`init(mass:stiffness:damping:initialVelocity:)`，代码如下：

```swift
let spring = UISpringTimingParameters(mass: 10.0, stiffness: 5.0, damping: 30, initialVelocity: CGVector(dx: 1.0, dy: 0.2))

let animator = UIViewPropertyAnimator(duration: 1.0, timingParameters: spring) 
```

上面这些参数的工作原理，可以查看之前的文章[11-图层弹簧动画](Section_III.md#11-图层弹簧动画)。


### 自动布局动画

前面的文章[系统学习iOS动画之二：自动布局动画](Section_II.md) 学习了自动布局动画。

使用`UIViewPropertyAnimator`的布局约束动画与使用`UIView.animate(withDuration: ...)`创建它们的方式非常相似。 诀窍是更新约束，在动画块中调用`layoutIfNeeded()`。

在`AnimatorFactory`中添加一个新的工厂方法：

```swift
@discardableResult
static func animateConstraint(view: UIView, constraint: NSLayoutConstraint, by: CGFloat) -> UIViewPropertyAnimator {
    let spring = UISpringTimingParameters(dampingRatio: 0.55)
    let animator = UIViewPropertyAnimator(duration: 1.0, timingParameters: spring)

    animator.addAnimations {
        constraint.constant += by
        view.layoutIfNeeded()
    }
    return animator
}
```



在`LockScreenViewController`中`viewWillAppear`里添加：

```swift
dateTopConstraint.constant -= 100
view.layoutIfNeeded()
```

在`viewDidAppear`里添加：

```swift
AnimatorFactory.animateConstraint(view: view, constraint: dateTopConstraint, by: 150).startAnimation()
```

这让时间标签的位置，在应用打开时有一个动画。



接下来，在添加一个约束动画。当点击“Show more”时，窗口小部件会加载内容，并需要更改其高度约束。

重新定义`WidgetCell.swift`中的`toggleShowMore(_:)`方法：

```swift
@IBAction func toggleShowMore(_ sender: UIButton) {
    self.showsMore = !self.showsMore

    let animations = {
        self.widgetHeight.constant = self.showsMore ? 230 : 130
        if let tableView = self.tableView {
            tableView.beginUpdates()
            tableView.endUpdates()
            tableView.layoutIfNeeded()
        }
    }
    let spring = UISpringTimingParameters(mass: 30, stiffness: 10, damping: 300, initialVelocity: CGVector(dx: 5, dy: 0))

    toggleHeightAnimator = UIViewPropertyAnimator(duration: 0.0, timingParameters: spring)
    toggleHeightAnimator?.addAnimations(animations)
    toggleHeightAnimator?.startAnimation()
}
```



在`toggleShowMore(_:)`方法的底部，添加以下代码用来加载窗口小部件中的图标：

```swift
widgetView.expanded = showsMore
widgetView.reload()
```

![](https://ws4.sinaimg.cn/large/006tNbRwgy1fxuvd8a3hwg308k08cqhn.gif)



### 视图过渡

在[视图动画的3-过渡动画](Section_I.md#3-过渡动画)，学习了视图过渡。现在用`UIViewPropertyAnimator`做视图过渡。

显示更多按钮的title，"Show More" 和 "Show Less" 两者相互淡入淡出动画。



在`toggleShowMore（_ :)`的`toggleHeightAnimator`定义之前添加这段代码：

```swift
let textTransition = {
    UIView.transition(with: sender, duration: 0.25, options: .transitionCrossDissolve, animations: {
        sender.setTitle(self.showsMore ? "Show Less" : "Show More", for: .normal)
    }, completion: nil)
}
```

在`toggleHeightAnimator`开始之前添加：

```swift
toggleHeightAnimator?.addAnimations(textTransition, delayFactor: 0.5)
```

这将改变按钮标题，具有很好的交叉淡入淡出效果：

![](https://ws1.sinaimg.cn/large/006tNbRwgy1fxuvtnlvmbg303m03s772.gif)

效果也可以尝试`.transitionFlipFromTop`等






## 22-用UIViewPropertyAnimator进行交互式动画



前面两个章节介绍了许多`UIViewPropertyAnimator` 的使用，例如基本动画，自定义计时和弹簧动画，以及动画的提取。但是，与以前视图动画 **“即发即忘”**("fire-and-forget")API相比，尚未研究使`UIViewPropertyAnimator`真正有趣的地方。

`UIView.animate(withDuration:...)`提供了动画的设置方法，但是一旦定义动画结束状态，那么动画就会开始执行，而无法控制。 

**但是如果我们想在动画运行时与之交互，怎么办？** 细说，就是动画不是静态的，而是由用户手势或麦克风输入驱动的，就像在前面图层动画 [系统学习iOS动画之三：图层动画](Section_III.md) 所学的一样。

使用`UIViewPropertyAnimator` 创建的动画是完全交互式的：可以启动，暂停，改变速度，甚至可以直接调整进度。

由于`UIViewPropertyAnimator`可以同时驱动预设动画和交互式动画，因而在描述动画师当前的状态时，就有点复杂了😵。下面就看看如何处理动画师的状态。



> 本章的[开始项目](README.md#关于代码) 使用上一章节完成的项目。



### 动画状态机



`UIViewPropertyAnimator`可以检查动画是否已启动(`isRunning`)，是否已暂停或完全停止(`state`)，或动画是否已颠倒(`isReversed`)。

<!--最后，您可以检查动画“完成”的位置，例如从所需的最终状态开始，或者介于两者之间的某个位置。-->

`UIViewPropertyAnimator`有三个描述当前状态的属性：

![image-20181204183027143](https://ws4.sinaimg.cn/large/006tNbRwgy1fxuw4ytvcqj30et02eaa7.jpg)



`isRunning`（只读）：动画当前是否处于运动状态。 默认为`false`，在调用`startAnimation()`时变为`true`，如果暂停或停止动画，或者动画自然完成，它将再次变为`false`。

`isReversed`：默认为`false`，因为我们总是向前开始动画，即动画从开始状态播放到结束状态。 如果更改为`true`，则动画将颠倒，即从介绍状态到开始状态。

`state` （只读）：



`state`默认为`inactive`，这通常意味着刚刚创建了动画师，并且还没有调用任何方法。请注意，这与将`isRunning`设置为`false`不同，`isRunning`实际上只关注正在进行的动画，而当`state`处于`inactive`时，这实际上意味着动画师还没有做任何事情。

`state` 变成 `active`的情况有：

- 调用`startAnimation()`来启动动画

- 在没有开始动画的情况下调用`pauseAnimation()`

- 设置`fractionComplete`属性以将动画“倒回”到某个位置



动画自然完成后，`state`切换回`.inactive`。

如果在动画师上调用`stopAnimation()`，它会将其`state`属性设置为`.stopped`。在这种状态下，你唯一能做的就是完全放弃动画师或者调用`finishAnimation(at:)`来完成动画并让动画师回到`.inactive`。

正如你可能想到的那样，`UIViewPropertyAnimator`只能按特定顺序在状态之间切换。 它不能直接从`inactive`到`stopped`，也不能从`stopped`直接转为`active`。

如果设置了`pausesOnCompletion`，一旦动画师完成了动画的运行而不是自动停止，而是暂停。 这将使我们有机会在暂停状态下继续使用它。

状态流程图：

![image-20181204183357332](https://ws4.sinaimg.cn/large/006tNbRwgy1fxuw8m1813j30fj05iwf8.jpg)

可能有点绕，之后的使用中，如果有疑问，可以再回到这个部分查看。



### 交互式3D touch动画

从这个部分开始，将学习创建类似于3D touch交互的交互式动画：

![image-20190101223452030](https://ws1.sinaimg.cn/large/006tNc79gy1fz4852t7l1j30eg055jvh.jpg)



> 注意：对于本章项目，需要兼容3D touch的iOS设备（没记错的话是6S+）。 
>
> 听闻👂，3D touch这个技术会被在iPhone上取消，好吧，这边是学习类似3D touch 的动画，它的未来如何，就不过问了。

3D touch的动画，可以这样描述：当我们手指按压屏幕上的图标时，动画交互式开始，背景越来越模糊，从图标旁渐渐呈现一个菜单，这个过程会随着手指按压的力度变化而前后变化。

放慢的效果为：

![ScreenRecording_01-04-2019 11-13-10.2019-01-04 11_24_37](https://ws4.sinaimg.cn/large/006tNc79gy1fz4859kx1gg309q0ha7my.gif)



`WidgetView.swift`中，`WidgetView`通过扩展遵守`UIPreviewInteractionDelegate`协议。这个协议中就包括了3D touch过程中一些委托方法。

为了让您开始开发动画本身，`UIPreviewInteractionDelegate`方法已经连接到LockScreenViewController上调用相关方法。
WidgetView中的代码如下：

- 3D Touch开始时调用`LockScreenViewController.startPreview(for:)`。

- 当用户按下的过程中，可能更硬（或更柔和）时，反复调用`LockScreenViewController.updatePreview(percent:)`。

- 当peek交互成功完成时，调用`LockScreenViewController.finishPreview()`。

- 最后，如果用户在未完成预览手势的情况下抬起手指，则调用`LockScreenViewController.cancelPreview()`。



在`LockScreenViewController`中添加这三个属性，您需要这些属性来创建窥视交互：

```swift
var startFrame: CGRect?
var previewView: UIView?
var previewAnimator: UIViewPropertyAnimator?
```

`startFrame`  来跟踪动画的开始位置。

 `previewView`  图标的快照视图，动画期间暂时使用它。
`previewAnimator`  将成为驱动预览动画的交互式动画师。



再添加一个属性以保持模糊效果以显示图标框：

```swift
let previewEffectView = IconEffectView(blur: .extraLight)
```

`IconEffectView`是自定义的`UIVisualEffectView`的子类，它包含单个标签的简单模糊视图，使用它来模拟从按下的图标弹出的菜单：

![image-20181219112216359](https://ws2.sinaimg.cn/large/006tNc79gy1fz485fxzrwj307l04jdgg.jpg)

在`LockScreenViewController`遵守`WidgetsOwnerProtocol`协议的扩展中，实现`startPreview(for:)`方法：

```swift
func startPreview(for forView: UIView) {
    previewView?.removeFromSuperview()
    previewView = forView.snapshotView(afterScreenUpdates: false)
    view.insertSubview(previewView!, aboveSubview: blurView)
}
```

`WidgetsOwnerProtocol`协议是一个自定义协议。

只要用户开始按下图标，`WidgetView`就会调用`startPreview(for:)`。 参数`for`是用户开始手势的集合单元格图像。



首先删除任何现有的`previewView`视图，以防万一在屏幕上留下之前的视图。 然后，您可以创建集合视图图标的快照，最后将其添加到模糊效果视图上方的屏幕上。

运行，按压图标。发现图标出现在左上角！😰

![](https://ws3.sinaimg.cn/large/006tNc79gy1fyupp9utvjg309o0ag0tk.gif)



因为尚未设置其位置。 继续添加：

```swift
previewView?.frame = forView.convert(forView.bounds, to: view)
startFrame = previewView?.frame
addEffectView(below: previewView!)
```

现在图标副本位置正确了，完全覆盖在原有图标上。 `startFrame`用来存储起始`frame`，以供之后使用。

 函数`addEffectView(below:)`添加图标快照下方的模糊框。代码为：

```swift
func addEffectView(below forView: UIView) {
    previewEffectView.removeFromSuperview()
    previewEffectView.frame = forView.frame

    forView.superview?.insertSubview(previewEffectView, belowSubview: forView)
}
```



下面创建动画本身，在`AnimatorFactory`中添加类方法：

```swift
static func grow(view: UIVisualEffectView, blurView: UIVisualEffectView) -> UIViewPropertyAnimator {

    view.contentView.alpha = 0
    view.transform = .identity

    let animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeIn)

    return animator
}
```

两个参数，`view`是动画视图，`blurView` 是动画的模糊背景。

在返回动画师之前，为动画师添加动画和完成闭包：

```swift
animator.addAnimations {
    blurView.effect = UIBlurEffect(style: .dark)
    view.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
}

animator.addCompletion { (_) in
    blurView.effect = UIBlurEffect(style: .dark)
}
```

动画代码为`blurView`创建了模糊过渡，为`view`创建一个普通的转换。

之后，在`LockScreenViewController.swift`的`startPreview()`中完成调用：

```swift
previewAnimator = AnimatorFactory.grow(view: previewEffectView, blurView: blurView)
```

现在运行，还没有效果，还需要实现`updatePreview(percent:)`方法：

```swift
func updatePreview(percent: CGFloat) {
    previewAnimator?.fractionComplete = max(0.01, min(0.99, percent))
}
```

当`WidgetView`被按压时，上面个方法会被重复调用。`fractionComplete`在0.01和0.99范围内，因为我不希望在动画才这段结束，我另外指定的方法完成或取消动画。

运行，效果（放慢）：

![ScreenRecording_01-04-2019 18-29-21.2019-01-04 18_40_04](https://ws2.sinaimg.cn/large/006tNc79gy1fz485pn1f7g309q0ewart.gif)



你会（惊喜！）需要更多的动画师。 打开AnimatorFactory.swift并添加一个动画师，它可以解除你的“成长”动画师所做的一切。
您需要此动画师的一种情况是用户取消手势。 当您需要清理UI时，另一个是成功交互的最后阶段。

在`AnimatorFactory`中添加方法：

```swift
static func reset(frame: CGRect, view: UIVisualEffectView, blurView: UIVisualEffectView) -> UIViewPropertyAnimator {

    return UIViewPropertyAnimator(duration: 0.5, dampingRatio: 0.7, animations: {
        view.transform = .identity
        view.frame = frame
        view.contentView.alpha = 0

        blurView.effect = nil
    })
}
```

此方法的三个参数分别是原始动画的起始帧，动画视图和背景模糊视图。 动画块将重置交互开始之前状态中的所有属性。

在`LockScreenViewController.swift`中，实现`WidgetsOwnerProtocol`协议的另一个方法：

```swift
func cancelPreview() {
    if let previewAnimator = previewAnimator {
        previewAnimator.isReversed = true
        previewAnimator.startAnimation()
    }
}
```

`cancelPreview()`是`WidgetView`被按压后，突然抬起手指时调用的方法，取消正在进行的手势。







到目前为止，你还没有开始你的动画师。 您一直在重复设置`fractionComplete`，这会以交互方式驱动动画。
但是，一旦用户取消交互，您就无法继续以交互方式驱动动画，因为您没有更多输入。 相反，通过将`isReversed`设置为`true`并调用`startAnimation()`，可以将动画播放到其初始状态。 现在这是`UIView.animate(withDuration: ...)`无法做到的事情！

再试一次互动。按下动画的一半，然后开始测试`cancelPreview()`。



当您抬起手指时动画会正确播放，但最终黑暗模糊会突然重新出现。

这个问题植根于你的成长动画师的代码。切换回AnimatorFactory.swift并查看grow中的代码（view：UIVisualEffectView，blurView：UIVisualEffectView） - 更具体地说，这部分：

```swift
animator.addCompletion { (_) in
	blurView.effect = UIBlurEffect(style: .dark)
}
```

动画可以向前或向后播放，需要在完成闭包中处理。

`addCompletion()` 的闭包的参数用`_`省略掉了，它其实是一个枚举类型`UIViewAnimatingPosition`，表示动画当前进行的情况。它的值可有三个，可以是`.start`，`.end`或`.current`。

将完成闭包替代为：

```swift
animator.addCompletion { (position) in
	switch position {
	    case .start:
	    blurView.effect = nil
	    case .end:
	    blurView.effect = UIBlurEffect(style: .dark)
	    default:
	    break
	}
}
```

如果动画被返回，则删除模糊效果。 如果成功完成，则明确将效果调整为暗模糊效果。



现在有一个新问题。 *如果取消对某个图标上的按压，则无法再按下它！*
这是因为图标快照仍然位于原始图标上方，挡住按压手势操作。 要解决该问题，值需要在重置动画完成后立即删除快照。

在`LockScreenViewController.swift`的`cancelPreview()`中继续添加：

```swift
previewAnimator.addCompletion { (position) in
	switch position {
	case .start:
	  self.previewView?.removeFromSuperview()
	  self.previewEffectView.removeFromSuperview()
	default:
	  break
	}
}
```

**注意：**，`addCompletion(_:)`可以调用多次，不会被下一个替代。



让我们再添加一个动画师来显示图标菜单。 切换到AnimatorFactory.swift并添加到它：

```swift
static func complete(view: UIVisualEffectView) -> UIViewPropertyAnimator {

	return UIViewPropertyAnimator(duration: 0.3, dampingRatio: 0.7, animations: {
	  view.contentView.alpha = 1
	  view.transform = .identity
	  view.frame = CGRect(x: view.frame.minX - view.frame.minX/2.5,
	                      y: view.frame.maxY - 140,
	                      width: view.frame.width + 120,
	                      height: 60)
	})
}
```

这一次你创建了一个简单的弹簧动画师。 对于动画师，您可以执行以下操作：

- 淡入“自定义操作”菜单项。

- 重置转换。
- 将视图框架直接设置为图标正上方的位置。

菜单的位置根据用户按下的图标而变化。

您将水平位置设置为 `view.frame.minX - view.frame.minX/2.5`，如果图标位于屏幕左侧，则显示右侧菜单，如果图标位于左侧，则显示左侧菜单在屏幕的右侧。请参阅以下差异：

![image-20190102115412511](https://ws3.sinaimg.cn/large/006tNc79gy1fz48605cgfj30eq068ta7.jpg)

动画师准备好了，所以打开LockScreenViewController.swift并在WidgetsOwnerProtocol扩展中添加最后一个必需的方法：

```swift
func finishPreview() {

    previewAnimator?.stopAnimation(false)

    previewAnimator?.finishAnimation(at: .end)

    previewAnimator = nil
}
```

当您感觉到触觉反馈时，用户按下3D触摸手势时会调用finishPreview（）。

`stopAnimation(_:)`是停止当前在屏幕上运行的动画。参数为`false`，动画师状态为`stopped`；参数为`true`，动画师状态为`inactive`并清除所有动画，而且不调用完成闭包。





一旦你将动画师置于停止状态，你就有了一些选择。你在finishPreview（）中追求的是告诉动画师完成它的最终状态。因此，您调用finishAnimation（at：.end）;这将使用计划动画的目标值更新所有视图并调用您的完成。

此手势不再需要previewAnimator，因此您可以将其删除。

您可以使用以下方法之一调用finishAnimation（at :)：

`start`：将动画重置为初始状态。
`current`：从动画的当前进度更新视图的属性并完成。



调用`finishAnimation(at:)`后，您的动画师处于`inactive`。

回到Widgets项目。由于你摆脱了预览动画师，你可以运行完整的动画师来显示菜单。将以下内容附加到finishPreview（）的末尾：

```swift
AnimatorFactory.complete(view: previewEffectView).startAnimation()
```



运行，按压图标：

![image-20190102115643202](https://ws2.sinaimg.cn/large/006tNc79gy1fz48675dazj30f9049mz0.jpg)



### 关闭模糊视图

目前，菜单弹出，模糊视图显示后，还没有回到原来视图的操作，下面添加这个操作。

在`finishPreview()`中添加以下代码,以准备交互式模糊：

```swift
blurView.effect = UIBlurEffect(style: .dark)
blurView.isUserInteractionEnabled = true
blurView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissMenu)))
```

先确保将模糊效果设置为`.dark`，然后模糊视图本身上启用用户交互，并未模糊视图添加点击手势操作，允许用户点击图标周围的任何位置用来关闭菜单。

`dismissMenu()`代码为：

```swift
@objc func dismissMenu() {
    let reset = AnimatorFactory.reset(frame: startFrame!, view: previewEffectView, blurView: blurView)
    reset.addCompletion { (_) in
                         self.previewEffectView.removeFromSuperview()
                         self.previewView?.removeFromSuperview()
                         self.blurView.isUserInteractionEnabled = false
                        }
    reset.startAnimation()
}
```



### 交互式关键帧动画

在[20-UIViewPropertyAnimator入门](#基础关键帧动画)学习了 用`UIViewPropertyAnimator`制作关键帧动画，现在再给关键帧动画添加交互式操作。

为了尝试一下，你将为成长动画添加一个额外的元素 - 在用户按下图标时以交互方式擦洗的元素。

删除`AnimatorFactory`的`grow()`方法中的代码：

```swift
animator.addAnimations {
  blurView.effect = UIBlurEffect(style: .dark)
  view.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
}
```

替换为：

```swift
animator.addAnimations {
    UIView.animateKeyframes(withDuration: 0.5, delay: 0.0, animations: {

        UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0, animations: {
            blurView.effect = UIBlurEffect(style: .dark)
            view.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        })

        UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
            view.transform = view.transform.rotated(by: -.pi/8)
        })

    })
}
```

第一个关键帧运行您之前的相同动画。
第二个关键帧是简单旋转，效果：

![ScreenRecording_01-04-2019 23-29-27.2019-01-04 23_32_31](https://ws1.sinaimg.cn/large/006tNc79gy1fz486eupoyg309b08njzk.gif)





## 23-用UIViewPropertyAnimator自定义视图控制器转场



在[系统学习iOS动画之四：视图控制器的转场动画](Section_IV.md)中，学习了如何创建自定义视图控制器转场。这个章节学习使用`UIViewPropertyAnimator`来自定义视图控制器转场。 



>  本章的[开始项目](README.md#关于代码) 使用上一章节完成的项目。



### 静态视图控制器转场

现在，点击**”Edit“**按钮时，体验非常糟糕😰。



首先创建一个新文件`PresentTransition.swift`，从名字也能看出这个类是用来转场的。 将其默认内容替换为：

```swift
import UIKit

class PresentTransition: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.75
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

    }
}
```



`UIViewControllerAnimatedTransitioning`协议已经在[系统学习iOS动画之四：视图控制器的转场动画](Section_IV.md)中学过。

我将创建一个转场动画：原视图逐渐模糊图，新视图慢慢移动出来。

在`PresentTransition`中添加一个新方法：

```swift
func transitionAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
    let duration = transitionDuration(using: transitionContext)
    
    let container = transitionContext.containerView
    let to = transitionContext.view(forKey: .to)!
    
    container.addSubview(to)
}
```

在上面的代码中，为视图控制器转场做了一些必要的准备工作。 首先获取动画持续时间，然后获取目标视图控制器的视图，最后将此视图添加到过渡容器中。

接下来，可以设置动画并运行它。 将下面代码添加到上面的方法`transitionAnimator(using:)`中：

```swift
to.transform = CGAffineTransform(scaleX: 1.33, y: 1.33).concatenating(CGAffineTransform(translationX: 0.0, y: 200))
to.alpha = 0
```

这会向上伸展，然后向下移动目标视图控制器的视图，最后将其淡出。 

在`to.alpha = 0`之后添加动画师来运行转换：

```swift
let animator = UIViewPropertyAnimator(duration: duration, curve: .easeOut)

animator.addAnimations({
    to.transform = CGAffineTransform(translationX: 0.0, y: 100)
}, delayFactor: 0.15)

animator.addAnimations({
    to.alpha = 1.0
}, delayFactor: 0.5)
```

动画师中有两个动画：将目标视图控制器的视图移动到最终位置和淡入。

最后添加完成闭包：

```swift
animator.addCompletion { (_) in                    			  
  transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
}

return animator

```

在`animateTransition(using:)`中调用上面的方法`transitionAnimator(using:)`：

```swift
transitionAnimator(using: transitionContext).startAnimation()
```





在`LockScreenViewController`中定义常量属性：

```swift
let presentTransition = PresentTransition()
```





让`LockScreenViewController`遵守`UIViewControllerTransitioningDelegate`协议：

```swift
// MARK: - UIViewControllerTransitioningDelegate
extension LockScreenViewController: UIViewControllerTransitioningDelegate {
  
  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return presentTransition
  }
}
```

`UIViewControllerTransitioningDelegate`协议在 [系统学习iOS动画之四：视图控制器的转场动画](Section_IV.md) 中学习过。

`animationController(forPresented:presents:source:)`方法是告诉UIKit，我想自定义视图控制器转场。

在`LockScreenViewController`中，找到点击**Edit**按钮的Action`presentSettings(_:)`，添加代码：

```swift
settingsController = storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
settingsController.transitioningDelegate = self
present(settingsController, animated: true, completion: nil)
```

运行，点击**Edit**按钮，`SettingsViewController`有点问题：

![](https://ws3.sinaimg.cn/large/006tNbRwgy1fyc6z0vsfjj309q07cwfz.jpg)

在`Main.storyboard`中将视图的背景更改为**Clear Color**。

运行，变成：

![](https://ws4.sinaimg.cn/large/006tNbRwgy1fyc7232ygoj309q09z78p.jpg)



下面向动画师添加新属性，为了可以将任何自定义动画注入转场动画， 使用相同的转场类来生成略有不同的动画。

在`PresentTransition`中添加两个新属性：

```swift
var auxAnimations: (() -> Void)?
var auxAnimationsCancel: (() -> Void)?
```

在`transitionAnimator(using:)`方法中动画师返回之前添加：

```swift
if let auxAnimations = auxAnimations {
    animator.addAnimations(auxAnimations)
}
```

这样可以根据具体情况在转换中添加自定义动画。 例如，要为当前转场添加模糊动画。

打开`LockScreenViewController`并在`presentSettings()`的开始处插入：

```swift
presentTransition.auxAnimations = blurAnimations(true)
```


再试一次过渡，看看这一行如何改变它：

![image-20190111123452428](https://ws4.sinaimg.cn/large/006tNc79gy1fz486tm602j309505zgm8.jpg)

模糊动画重复使用了。



另外，当用户解除控制器时，还需要隐藏模糊视图。

在`presentSettings(_:)`中的`present(_:animated:completion:)`前添加：

```swift
    settingsController.didDismiss = { [unowned self] in
      self.toggleBlur(false)
    }
```

现在，运行，点击`SettingsViewController`视图中的**Cancel**或其他选项，先有的模糊视图，然后恢复到第一个视图控制器：

![](https://ws4.sinaimg.cn/large/006tNbRwgy1fyc7kqfivvg309q0ha45w.gif)



### 交互视图控制器转场

这个部分通过下拉的手势来时学习实现交互视图控制器转场。



首先，让我们使用强大的`UIPercentDrivenInteractionTransition`类来启用视图控制器转场的交互性。

打开`PresentTransition.swift`把下面：

```swift
class PresentTransition: NSObject, UIViewControllerAnimatedTransitioning
```

替换为：

```swift
class PresentTransition: UIPercentDrivenInteractiveTransition, UIViewControllerAnimatedTransitioning {
```

`UIPercentDrivenInteractiveTransition`是一个定义基于“百分比”的转场方法的类，例如有三个方法：

- `update(_:)`  回退转场。
- `cancel() ` 取消视图控制器转场。
- `finish()`  播放转场直到完成。

之前学习的[19-交互式导航控制器转场](Section_IV.md#19-交互式导航控制器转场)中也提到相关内容。

`UIPercentDrivenInteractiveTransition`的一些属性：

- `timingCurve`：如果以交互方式驱动转场，并且是播放转场时直到结束，就可以通过设置此属性为动画提供自定义时序曲线。 
- `wantsInteractiveStart`：默认是`true`，是否使用交互式转场。

- `pause()` ：调用此方法暂停非交互式转场并切换到交互模式。



向`PresentTransition`添加一个新方法：

```swift
  func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
    return transitionAnimator(using: transitionContext)
  }
```

这是`UIViewControllerAnimatedTransitioning`协议的一个方法。 它允许我们UIKit提供可中断的动画师。

转场动画师类现在有两种不同的行为：

1. 如果以非交互方式使用它（当用户按下编辑按钮时），UIKit将调用`animateTransition(using:)`来设置转场动画。
2. 如果以交互方式使用它，UIKit将调用`interruptibleAnimator(using:)`，获取动画师，并使用它来推动这种转场。

![image-20190111124837379](https://ws3.sinaimg.cn/large/006tNc79gy1fz48719aayj30ek0a3wfo.jpg)



切换到`LockScreenViewController.swift`， 在`UIViewControllerTransitioningDelegate`扩展中添新方法：

```swift
func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    return presentTransition
}
```

接下来，在`LockScreenViewController`中添加两个新属性，用来跟踪用户的手势：

```swift
  var isDragging = false
  var isPresentingSettings = false
```

当用户向下拉时，将`isDragging`标志设置为`true`，当拉得足够远，也将将`isPresentingSettings`设置为`true`。

实现`UISearchBarDelegate`的一个方法：

```swift
func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    isDragging = true
}
```

这可能看起来有点多余，因为`UITableView`已经有一个属性来跟踪它当前是否被拖动，但现在要自己做一些自定义跟踪。

接下来继续实现`UISearchBarDelegate`协议的另一个方法，用来跟踪用户的进度：

```swift
func scrollViewDidScroll(_ scrollView: UIScrollView) {
    guard isDragging else { return }

    if !isPresentingSettings && scrollView.contentOffset.y < -30 {
        isPresentingSettings = true
        presentTransition.wantsInteractiveStart = true
        presentSettings()
        return
    }
}
```



接下来，需要添加代码以交互方式更新。 将以下内容追加到上面方法的末尾：

```swift
if isPresentingSettings {
    let progess = max(0.0, min(1.0, ((-scrollView.contentOffset.y) - 30) / 90.0))
    presentTransition.update(progess)
}
```

根据拉出TableView的距离计算0.0到1.0范围内的进度，并在转场动画师上调用`update(_:)`以将动画定位到当前进度。
运行，当向下拖动时，将看到表格视图逐渐模糊。

![2019-01-11 13-16-13.2019-01-11 13_22_39](https://ws1.sinaimg.cn/large/006tNc79gy1fz4876589cg308o0fh1f2.gif)



还需要注意完成取消转场，实现`UISearchBarDelegate`协议的另一个方法：

```swift
func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    let progress = max(0.0, min(1.0, ((-scrollView.contentOffset.y) - 30) / 90.0))

    if progress > 0.5 {
        presentTransition.finish()
    } else {
        presentTransition.cancel()
    }

    isPresentingSettings = false
    isDragging = false
}
```

这段代码看起来与[19-交互式导航控制器转场](Section_IV.md)中相似。如果用户下拉已经超过距离的一半，则认为转场成功；如果用户未下拉超过一半，则取消转场。



把`transitionAnimator(using:)`方法中的`addCompletion`代码块替换为：

```swift
    animator.addCompletion { (position) in
      switch position {
      case .end:
        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
      default:
        transitionContext.completeTransition(false)
      }
    }
```

运行，上下拉动，可能会出现下面这种像素化问题情况（iOS10可能会出现，iOS11之后应该修复了）：



![image-20190111133132818](https://ws4.sinaimg.cn/large/006tNc79gy1fz487groy8j3095094q7d.jpg)



使用之前在`PresentTransition`中添加的`auxAnimationsCancel`属性。
在`transitionAnimator(using:)`中找到`animator.addCompletion`的调用，并在`default:`添加：

```swift
self.auxAnimationsCancel?()
```

到`LockScreenViewController`的`presentSettings(_:)`方法。在设置`auxAnimations`属性后，添加：

```swift
presentTransition.auxAnimationsCancel = blurAnimations(false)
```

运行，像素化问题应该已经消失。



但是还有另一个问题。点击**Edit**按钮的非交互式转场没反应了！😱

只要用户点击**Edit**按钮，就需要更改代码以将视图控制器转场设置为非交互式。

到`LockScreenViewController`的`tableView(_:cellForRowAt:)`，在`self.presentSettings()`之前插入：

```swift
self.presentTransition.wantsInteractiveStart = false
```

运行，效果:

![2019-01-11 13-40-54.2019-01-11 13_41_51](https://ws2.sinaimg.cn/large/006tNc79gy1fz487orsyng308o0dj4qp.gif)





### 可中断的转场动画

接下来，要考虑转场期间在非交互模式和交互模式之间切换。

在这一部分，将实现点击**Edit**按钮后开始执行显示设置控制器的动画，但如果用户在动画期间再次点击屏幕，则暂停转场。

切换到`PresentTranstion.swift`。需要稍微改变动画师，不仅要分别处理交互式和非交互式模式，还要同时处理相同的过渡。
在`PresentTranstion`中再添加两个属性：

```swift
var context: UIViewControllerContextTransitioning?
var animator: UIViewPropertyAnimator?
```

使用这两个属性来跟踪动画的上下文以及动画师。
在`transitionAnimator(using:)`方法的`return animator`前插入：

```swift
self.animator = animator
self.context = transitionContext
```

每次为转场创建新的动画师时，也会存储对它的引用。

转场完成后释放这些资源也很重要。 继续添加：

```swift
animator.addCompletion { [unowned self] _  in
	self.animator = nil
	self.context = nil
}
```

在`PresentTranstion`中再添加一个方法：

```swift
func interruptTransition() {
    guard let context = context else { return }
    context.pauseInteractiveTransition()
    pause()
}
```

 

在`transitionAnimator(using:)`方法的`return animator`前插入：

```swift
animator.isUserInteractionEnabled = true
```

确保转场动画是交互式的，这样用户可以在暂停后继续与屏幕进行交互。



允许用户向上或向下滚动以分别完成或取消转场。 为此，在`LockScreenViewController`中添加一个新属性：

```swift
var touchesStartPointY: CGFloat? 
```

如果用户在转场期间触摸屏幕，可以将其暂停并存储第一次触摸的位置：

```swift
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard presentTransition.wantsInteractiveStart == false, presentTransition.animator != nil else {
      return
    }
    
    touchesStartPointY = touches.first!.location(in: view).y
    presentTransition.interruptTransition()
  }
```



跟踪用户触摸并查看用户是向上还是向下平移，添加：

```swift
 override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
  guard let startY = touchesStartPointY else { return }
  
  let currentPoint = touches.first!.location(in: view).y
  if currentPoint < startY - 40 {
    touchesStartPointY = nil
    presentTransition.animator?.addCompletion({ (_) in
      self.blurView.effect = nil
    })
    presentTransition.cancel()
    
  } else if currentPoint > startY + 40 {
    touchesStartPointY = nil
    presentTransition.finish()
  }
}
```

运行，点击**Edit**按钮后，立即点击屏幕，这个时候转场会暂停，此时向下滑动会完成转场，向上滑动会取消转场，效果如下：

![](https://ws1.sinaimg.cn/large/006tNc79gy1fz4qlv71nqg308o0erwqa.gif)



