# Section III: 图层动画(Layer Animations)



之前学习了创建视图动画（View Animations），这一部分学习功能更强大、更偏底层的**Core Animation APIs**。（暂时把核心动画理解为这边视图动画）

在本书的这一部分中，您将学习动画层而不是视图以及如何使用特殊图层。

图层是一个简单的模型类，它公开了许多属性来表示一些基于图像的内容。 每个`UIView`都有一个图层支持(都有一个`layer`属性)。

由于以下原因，图层(Layers)与视图(Views)（相对于动画）不同：

- 图层是一个模型对象 - 它公开数据属性并且不实现任何逻辑。 它没有复杂的自动布局依赖关系，也不用处理用户交互。
- 图层具有预定义的可见特征 - 这些特征是许多影响内容在屏幕上呈现的数据属性，例如边框线，边框颜色，位置和阴影。
- 最后，**Core Animation**优化了图层内容的缓存并直接在**GPU**上快速绘图。

视图：

- 复杂视图层次结构布局，自动布局等。
- 用户交互。
- 通常具有在CPU上的主线程上执行的自定义逻辑或自定义绘图代码。
- 非常灵活，功能强大，子类很多类。

图层：

- 更简单的层次结构，更快地解决布局，绘制速度更快。
- 没有响应者链开销。
- 默认情况下没有自定义逻辑 并直接在GPU上绘制。
- 不那么灵活，子类的类更少。

视图和图层的选择技巧：

*任何时候都可以选择视图动画; 当需要更高的性能时，就需要使用图层动画。*

![](https://ws2.sinaimg.cn/large/006tNbRwgy1fxdhuq4gvcj30eo0aumxf.jpg)



## Chapter 8: 图层动画基础知识(Getting Started with Layer Animations)



**图层动画**的工作方式与**视图动画**非常相似; 只需在定义的时间段内为起始值和结束值之间的属性设置动画，然后让**Core Animation**处理两者之间的渲染。

但是，**图层动画**具有比**视图动画**更多的**可动画属性**; 在设计效果时，这会提供了很多选择和灵活性; **图层动画**还有许多专门的CALayer子类（如`CATextLayer`、 `CAShapeLayer` 、 `CATransformLayer` 、`CAGradientLayer`、`CAReplicatorLayer`、`CAScrollLayer`、`CAEmitterLayer`、`AVPlayerLayer`等），这些子类有提供了许多其他属性。

本章介绍CALayer和Core Animation的基础知识。 

### 可动画属性(Animatable properties)

可与视图动画的[可动画属性]()对照着看。

- 位置 和 大小 

  `bounds`、`position`、`transform`

![](https://ws2.sinaimg.cn/large/006tNbRwgy1fw8y8bkr03j30do05qglq.jpg)



- 边

`borderColor`、 `borderWidth`、`cornerRadius`





![image-20181015154228090](https://ws4.sinaimg.cn/large/006tNbRwgy1fw8ybp1rc8j30dx05o754.jpg)



- 阴影

  `![image-20181015154548338](https://ws2.sinaimg.cn/large/006tNbRwgy1fxde6lbbg1j30d004zjsm.jpg)

  `shadowOffset`：修改此项以使阴影看起来更接近或更远离图层。
  `shadowOpacity`：修改此项以使阴影淡入或淡出。
  `shadowPath`：修改它以更改图层阴影的形状。 可以创建不同的3D效果，使图层看起来像浮动在不同的阴影形状和位置上。
  `shadowRadius`：修改它以控制阴影的模糊; 当模拟视图朝向或远离投射阴影的表面移动时，这尤其有用。

- 内容

  `contents`

  `mask` ：修改它将用于掩盖图层可见内容的形状或图像。 这个属性在[Chapter 13]()将详细介绍和使用。

  `opacity`


### 第一个图层动画

使用[Chapter 3]()完成的项目，或这个章节的**开始项目**。

把原本head的视图动画替换为图层动画。

- 分别删除**ViewController**的`viewWillAppear()`中：

  ```swift
  heading.center.x    -=  view.bounds.width
  ```

  和`viewDidAppear()`中:

  ```swift
  UIView.animate(withDuration: 0.5) {
       self.heading.center.x += self.view.bounds.width
  }
  ```




- 在`viewWillAppear()`的开始（`super`调用后）添加：

  ```swift
    let flyRight = CABasicAnimation(keyPath: "position.x")
    flyRight.fromValue = -view.bounds.size.width/2
    flyRight.toValue = view.bounds.size.width/2
    flyRight.duration = 0.5	
  ```

  核心动画中的动画对象只是**简单的数据模型**; 上面的代码创建了`CABasicAnimation`模型的实例，并设置了一些数据属性。
  这个个实例描述了一个**潜在**的图层动画：*可以选择立即运行，稍后运行，或者根本不运行*。

  由于动画未绑定到特定图层，因此可以在其他图层上**重复使用动画**，每个图层将独立运行动画的副本。

  在动画模型中，您可以将要设置为动画的属性指定为`keypath`参数(比如上面设置是`"position.x"`); 这很方便，因为动画总是在图层中设置。



  接下来，为在`keypath`上指定的属性设置`fromValue`和`toValue`。需要动画对象（此处我要处理的是heading）从屏幕左侧到屏幕中央。动画持续时间的概念没有改变; `duration`设置为0.5秒。

- 动图已经设置完成，现在需要把它添加需要运行此动画的动画对象。 在刚添加的代码下方添加，将动画添加到heading的图层：

  ```swift
  heading.layer.add(flyRight, forKey: nil)
  ```

  `add(_:forKey:)`会把动画做个一个拷贝给将要添加的图层。 如果之后需要更改或停止动画，可以添加`forKey`参数用于识别动画。

此时的动画看上去和之前视图动画没有什么区别。



### 更多图层动画知识(More elaborate layer animations)

- 同一样的方法应用在**Username Filed**上，删除`viewWillAppear()`和`viewDidAppear()`中对应代码。再把之前的动画添加的**Username Filed**的layer上：

  ```swift
  username.layer.add(flyRight, forKey: nil)
  ```

  此时运行项目，看上去会有点别扭，因为**heading Label**，**Username Filed**的动画是相同的，**Username Filed**没有之前的延迟效果。

- 再添加动画到**Username Filed**的layer上之前，添加：

  ```swift
  flyRight.beginTime = CACurrentMediaTime() + 0.3
  ```

  动画的`beginTime`属性设置动画应该开始的绝对时间; 在这种情况下，可以使用`CACurrentMediaTime()`获取当前时间(系统的一个绝对时间，机器开启时间，取自机器时间 `mach_absolute_time()`)，并以秒为单位添加所需的延迟。

  此时，如果仔细观察会发现有个问题，**Username Filed**在开始动画之前已经出现了，这就涉及到另外一个图层动画属性 `fillMode`  了。


- 关于 `fillMode`  

  以**Username Field**的移动动画来看看`fillMode`不同值的区别，为了方便观察，我把`beginTime`时间变大，代码类似于：

  ```swift
  let flyRight = CABasicAnimation(keyPath: "position.x")
  flyRight.fromValue = -view.bounds.size.width/2
  flyRight.toValue = view.bounds.size.width/2
  flyRight.duration = 0.5
  heading.layer.add(flyRight, forKey: nil)
  
  flyRight.beginTime = CACurrentMediaTime() + 2.3
  flyRight.fillMode = kCAFillModeRemoved
  username.layer.add(flyRight, forKey: nil)
  ```

  * `kCAFillModeRemoved`  是`fillMode`的默认值

    在定义的`beginTime`处启动动画(如果未设置`beginTime`，也就是`beginTime`等于`CACurrentMediaTime()`，则立即启动动画)， 并在动画完成时删除动画期间所做的更改：

    ![](https://ws3.sinaimg.cn/large/006tNbRwgy1fxk4aqik4wj30ee04bglh.jpg)

    实际效果：
    ![](https://ws3.sinaimg.cn/large/006tNbRwgy1fxk4qcfn85g308q060ta9.gif)
    
    *now* 到 *begin* 这段时间动画没有开始，**Username Field**直接显示了，然后到 *begin*时动画才开始，这就是之前遇到的情况。

  * `kCAFillModeBackwards`

    无论动画的实际开始时间如何，`kCAFillModeBackwards`都会立即在屏幕上显示动画的第一帧，并在以后启动动画:

    ![](https://ws3.sinaimg.cn/large/006tNbRwgy1fxk4h0w3ncj30du03w3yf.jpg)

    实际效果：

    ![](https://ws4.sinaimg.cn/large/006tNbRwgy1fxk4klai6yg308q06075v.gif)

    第一帧在`fromValue`处，也就是`"position.x"`是负的在屏幕外，因此开始时没有看见**Username Field**，等2.3s动画开始。

  * `kCAFillModeForwards`

    `kCAFillModeForwards`像往常一样播放动画，但在屏幕上保留动画的最后一帧，直到您删除动画：

    ![](https://ws2.sinaimg.cn/large/006tNbRwgy1fxk53tocyvj30dw049a9z.jpg)



    实际效果：
    
    ![](https://ws1.sinaimg.cn/large/006tNbRwgy1fxk57t0yj4g308q060jsx.gif)
    
    除了设置kCAFillModeForwards之外，您还需要对图层进行一些其他更改以使最后一帧“粘贴”。 你将在本章后面稍后了解这一点。
    
    ？？和第一个有点类似，但还是有区别的。

  * `kCAFillModeBoth`

    `kCAFillModeBoth`是`kCAFillModeForwards`和`kCAFillModeBackwards`的组合; 这会使动画的第一帧立即出现在屏幕上，并在动画结束时在屏幕上保留最终帧：

    ![](https://ws1.sinaimg.cn/large/006tNbRwgy1fxk5cg26eoj30ea048weg.jpg)

    实际效果：

    ![](https://ws4.sinaimg.cn/large/006tNbRwgy1fxk5bvgjmcg308q060wgg.gif)



  要解决之前发现的问题，您将使用`kCAFillModeBoth`。

  同样对于**Password Field**，也删除其视图动画的代码，改换成类似**Username Field**的图层动画，不过`beginTime`要晚一点，具体代码：

  ```swift
  flyRight.beginTime = CACurrentMediaTime() + 0.3
  flyRight.fillMode = kCAFillModeBoth
  username.layer.add(flyRight, forKey: nil)
  
  flyRight.beginTime = CACurrentMediaTime() + 0.4
  password.layer.add(flyRight, forKey: nil)
  ```



到目前为止，您的动画恰好在表单元素最初位于Interface Builder中的确切位置结束。 但是，很多时候情况并非如此。 在本章的下一部分中，您将了解如何处理图层在不同位置结束的情况 - 您将学习如何在整个过程中调试动画！

### 调试动画(Debugging basic animations)

在上面的动画后继续添加：

```swift
username.layer.position.x -= view.bounds.width
password.layer.position.x -= view.bounds.width
```

这就是把两个文本框的图层移动到屏幕外，类似于`flyRight.fromValue = -view.bounds.size.width/2`（此时这段代码可以暂时注释掉），运行后发现问题，动画结束后两个文本框消失了，这是怎么回事呢？



![](https://ws1.sinaimg.cn/large/006tNbRwgy1fw9uakzv3kg308s0fo0v1.gif)



继续在上面的代码后添加一个延迟函数：

```swift
delay(seconds: 5.0)
  print("where are the fields?")
}
```

并打断点后运行。

![image-20181125123017131](/Users/andyron/Library/Application Support/typora-user-images/image-20181125123017131.png)

进入**UI hierarchy** 窗口

![](https://ws2.sinaimg.cn/large/006tNbRwgy1fw9v6cjqdmj30xa0meacn.jpg)



![](https://ws3.sinaimg.cn/large/006tNbRwgy1fw9v6q3kc4j30uq0iadj0.jpg)



**UI hierarchy** 模式下可以查看当前运行时的UI层次结构，包括已经隐藏或透明视图以及在屏幕外的视图。还可以3D查看。

![](https://ws1.sinaimg.cn/large/006tNbRwgy1fw9vjxwr0dg31140oz1hp.gif)



当然还可以在右侧检测器中查看实时属性：

![image-20181125124028215](https://ws1.sinaimg.cn/large/006tNbRwgy1fxk7g2vfjzj31ek0u0e81.jpg)



动画完成后，代码更改会导致字段跳回其初始位置。 但为什么？

### Animations vs. real content

当你为**Text Field**设置动画时，你实际上并没有看到**Text Field**本身是动画的; 相反，你会看到它的缓存版本，称为**presentation layer**（显示层）。动画完成后原始图层再次到原本位置，则从屏幕上移除**presentation layer**。
首先，请记住您在`viewWillAppear(_:)`中将**Text Field**设置在屏幕外：

![image-20181125145909389](https://ws1.sinaimg.cn/large/006tNbRwgy1fxkbgcncy0j30ea03874p.jpg)

动画开始时，**Text Field**暂时隐藏，预渲染的动画对象将替代它：

![image-20181125145923978](https://ws3.sinaimg.cn/large/006tNbRwgy1fxkbgli16zj30do03f0t5.jpg)

您无法点击动画对象，输入任何文本或使用任何其他特定文本字段功能，因为它不是真正的文本字段，只是可见的“幻像”。
动画一旦完成，它就会从屏幕上消失，原始**Text Field**将被取消隐藏。但它此时的位置还在屏幕左侧！

![image-20181125150009137](https://ws2.sinaimg.cn/large/006tNbRwgy1fxkbhdich6j30dh03saah.jpg)

要解决这个难题，您需要使用另一个`CABasicAnimation`属性：`isRemovedOnCompletion`。
将fillMode设置为kCAFillModeBoth可指示动画在完成后保留在屏幕上，并在动画开始之前显示动画的第一帧。要完成效果，您需要相应地设置removedOnCompletion;两者的组合将使动画在屏幕上可见。
在设置fillMode之后，将以下行添加到viewWillAppear（）：

flyRight.isRemovedOnCompletion = false

isRemovedOnCompletion默认为true，因此动画一完成就会消失。将其设置为false并将其与正确的fillMode组合可将动画保留在屏幕上 - 并且也可见。
立即构建并运行您的项目;一旦动画完成，您应该看到所有元素都按预期保留在屏幕上：

成功！现在点击用户名字段输入您的用户名 - 哦，等等。还记得前面关于实际文本字段和表示层之间差异的说明吗？您无法对此文本字段的预渲染图像执行任何操作。
要完成所需的效果，您需要删除动画并在其位置显示真实文本字段。



- Updating the layer model

从屏幕上删除图层动画后，图层将回退到其当前位置和其他属性值。 这意味着您通常需要更新图层的属性以反映动画的最终值。



虽然你知道当设置为false时isRemovedOnCompletion是如何工作的，但尽可能避免使用它。 在屏幕上保留动画会影响性能，因此您可以自动删除它们并更新原始图层的位置。



现在需要把原来图层设置到屏幕中间：

```swift
username.layer.position.x = view.bounds.size.width/2
password.layer.position.x = view.bounds.size.width/2
```

当然此时要注意把之前注释掉`flyRight.fromValue = -view.bounds.size.width/2`，去掉注释，也要把调试动画时的代码去掉。

如果可能，请在Interface Builder中使用其最终值设计图层，并使用fromValue作为起始值和中间值。这降低了保持模型和表示层同步的复杂性。

### 最佳做法

哇 - 这是一个很长的篇章！你尝试了大量不同的图层动画技术，这才刚刚开始！
此时你可能会感到有点不知所措并问自己“我应该使用fillMode吗？我应该删除我的动画吗？如何更新我的图层以使动画完成顺畅？“
根据经验：删除动画并考虑从不使用fillMode，除非您想要实现的效果不可能。 fillMode使您的UI元素失去交互性，并使屏幕不反映图层对象中的实际值。
在极少数情况下，当您为非交互式视觉元素设置动画时，fillMode将保存您的培根;您将在第16章“复制动画”中阅读更多相关内容。
至于更新图层属性：考虑在将动画添加到图层后立即执行此操作。有时你可能会在初始和最终动画值之间得到奇怪的闪光

### 使用图层动画实现☁️的淡入

删除`viewWillAppear()`中把四个☁️透明度设为0.0的代码，和`viewDidAppear()`的☁️的视图动画。

然后在`viewDidAppear()`加入：

```swift
let cloudFade = CABasicAnimation(keyPath: "alpha")
cloudFade.duration = 0.5
cloudFade.fromValue = 0.0
cloudFade.toValue = 1.0
cloudFade.fillMode = kCAFillModeBackwards

cloudFade.beginTime = CACurrentMediaTime() + 0.5
cloud1.layer.add(cloudFade, forKey: nil)

cloudFade.beginTime = CACurrentMediaTime() + 0.7
cloud2.layer.add(cloudFade, forKey: nil)

cloudFade.beginTime = CACurrentMediaTime() + 0.9
cloud3.layer.add(cloudFade, forKey: nil)

cloudFade.beginTime = CACurrentMediaTime() + 1.1
cloud4.layer.add(cloudFade, forKey: nil)
```



### 登录按钮背景颜色变化的动画

把原本登录按钮背景颜色变化的动画修改成图层动画。

删除`logIn()`中的：

```swift
self.loginButton.backgroundColor = UIColor(red: 0.85, green: 0.83, blue: 0.45, alpha: 1.0)
```

删除`resetForm()`中的：

```swift
self.loginButton.backgroundColor = UIColor(red: 0.63, green: 0.84, blue: 0.35, alpha: 1.0)
```

在**ViewController.swift**文件中创建一个全局的背景颜色变化动画函数：

```swift
func tintBackgroundColor(layer: CALayer, toColor: UIColor) {
    let tint = CABasicAnimation(keyPath: "backgroundColor")
    tint.fromValue = layer.backgroundColor
    tint.toValue = toColor.cgColor
    tint.duration = 0.5
    layer.add(tint, forKey: nil)
    layer.backgroundColor = toColor.cgColor
}
```



在`logIn()`中添加：

```swift
let tintColor = UIColor(red: 0.85, green: 0.83, blue: 0.45, alpha: 1.0)
tintBackgroundColor(layer: loginButton.layer, toColor: tintColor)
```

在`resetForm()`中登录按钮动画方法的`completion`闭包中添加：

```swift
completion: { _ in
     let tintColor = UIColor(red: 0.63, green: 0.84, blue: 0.35, alpha: 1.0)
     tintBackgroundColor(layer: self.loginButton.layer, toColor: tintColor)
})
```



### 登录按钮的圆角动画

在**ViewController.swift**文件中创建一个全局的圆角变化动画函数：

```swift
func roundCorners(layer: CALayer, toRadius: CGFloat) {
    let round = CABasicAnimation(keyPath: "cornerRadius")
    round.fromValue = layer.cornerRadius
    round.toValue = toRadius
    round.duration = 0.33
    layer.add(round, forKey: nil)
    layer.cornerRadius = toRadius
}
```

在`logIn()`中添加：

```swift
roundCorners(layer: loginButton.layer, toRadius: 25.0)
```

在`resetForm()`中登录按钮动画方法的`completion`闭包中添加：

```swift
roundCorners(layer: self.loginButton.layer, toRadius: 10.0)
```

两种状态的变化：

![image-20181125155719946](https://ws2.sinaimg.cn/large/006tNbRwgy1fxkd4voqrwj30pu05mmxk.jpg)



两个动画函数`tintBackgroundColor`和`roundCorners`最后都需要把动画最变化最终值赋值给动画的属性，这对应于前面的 [Animations vs](#user-content-animations-vs-real-content) 章节






## Chapter 9: Animation Keys and Delegates



关于UIKit动画和相应的闭包语法的一个棘手部分是，一旦您创建并运行视图动画，您就无法暂停，停止或以任何方式访问它。

但是，使用Core Animation，您可以轻松检查在图层上运行的动画，并在需要时停止它们。 此外，您甚至可以在动画上设置委托对象并对动画事件做出反应。



>  使用上一章完成的项目或使用原书对应章节的**开始项目**



### 介绍动画代理

![](https://ws1.sinaimg.cn/large/006tNbRwgy1fx4io22vm1j30de06qjre.jpg)



`CAAnimationDelegate`的两个代理方法：

```swift
func animationDidStart(_ anim: CAAnimation)
func animationDidStop(_ anim: CAAnimation, finished flag: Bool)
```

做个小测试，在`flyRight`初始化时，添加：

```swift
flyRight.delegate = self
```

对`ViewController`添加扩展，并实现一个代理方法：

```swift
extension ViewController: CAAnimationDelegate {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        print(anim.description, "动画完成")
    }
}
```

运行，打印结果：

```swift
<CABasicAnimation: 0x6000032376e0> 动画完成
<CABasicAnimation: 0x600003237460> 动画完成
<CABasicAnimation: 0x600003237480> 动画完成
```

会发现`animationDidStop(_:finished:)`方法被调用三次，并且每次调用的动画都不同，这因为当每一次调用`layer.add(_:forKey:)`把动画添加给图层时，都会拷贝一份，这在前面的图层动画基础知识中说明过。



### Key-value coding compliance

`CAAnimation`类及其子类是用Objective-C编写的，并且符合键值编码(KVO)，这意味着您可以将它们视为字典，并在运行时向它们添加新属性。(关于KVO，可查看的小结文章 [OC中的键/值编码(KVC)](http://andyron.com/2018/ios-oc-kvc-begin))

使用此机制为`flyRight`动画指定名称，以便之后可以从其他活动动画中识别它。

在`viewWillAppear()`中的`flyRight.delegate = self`后添加：

```swift
flyRight.setValue("form", forKey: "name")
flyRight.setValue(heading.layer, forKey: "layer")
```

在上面的代码中，在`flyRight`动画上创建键为`"name"`，值为`"form"`的键值对，可以从委托回调方法调用识别；

也创建了一个键为`"layer"`，值为`heading.layer`的键值对，以方便之后引用动画所属的图层。

同样的可以添加(之前已经说过每次动画都会拷贝一份，所以不会覆盖)：

```swift
flyRight.setValue(username.layer, forKey: "layer")

// ...

flyRight.setValue(password.layer, forKey: "layer")
```





### Switching on key values

在代理回调方法中验证上面的代码，上面的移动动画结束后再添加一个简单的脉动动画：

```swift
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        // print(anim.description, "动画完成")
        guard let name = anim.value(forKey: "name") as? String else {
            return
        }
    
        if name == "form" {
            // `value(forKey:)`的结果总是`Any`，因此需要转换为所需类型
            let layer = anim.value(forKey: "layer") as? CALayer
            anim.setValue(nil, forKey: "layer")
            // 简单的脉动动画
            let pulse = CABasicAnimation(keyPath: "transform.scale")
            pulse.fromValue = 1.25
            pulse.toValue = 1.0
            pulse.duration = 0.25
            layer?.add(pulse, forKey: nil)
        }
    }	
```



> 注意: `layer?.add()`这边是可选的，意味着如果动画中没有存储图层，则会跳过`add(_:forKey:)`的 调用。 



移动动画结束后有一个简单变大的脉动动画效果：

![](https://ws2.sinaimg.cn/large/006tNbRwgy1fx4zbw6nt9g308q060q4l.gif)



这照顾已经停止的动画; 但是你如何使用仍在运行的动画呢？ 这就是**animation keys**的用武之地。



### Animation Keys

`add(_:forKey:)`中的参数`forKey`(注意不要和`setValue(_:forKey:)`中的`forKey`混淆)，之前一直没使用。

在这部分中，您将创建另一个图层动画，学习如何一次运行多个动画，并了解如何使用Animation Keys控制正在运行的动画。

添加一个新标签，新标签将从右到左缓慢动画，用来提示用户输入。 一旦用户开始输入他们的用户名或密码（**Text Field**获得焦点），该标签将停止移动并直接跳到其最终位置（居中位置）。 一旦用户知道该怎么做就没有必要继续动画。



- 在`ViewController`中添加属性 `let info = UILabel()`，并在`viewDidLoad()`中配置：

```swift
info.frame = CGRect(x: 0.0, y: loginButton.center.y + 60.0,  width: view.frame.size.width, height: 30)
info.backgroundColor = UIColor.clear
info.font = UIFont(name: "HelveticaNeue", size: 12.0)
info.textAlignment = .center
info.textColor = UIColor.white
info.text = "Tap on a field and enter username and password"
view.insertSubview(info, belowSubview: loginButton)
```



- 为`info`添加两个动画:

  ```swift
  // 提示信息Label的两个动画
  let flyLeft = CABasicAnimation(keyPath: "position.x")
  flyLeft.fromValue = info.layer.position.x + view.frame.size.width
  flyLeft.toValue = info.layer.position.x
  flyLeft.duration = 5.0
  info.layer.add(flyLeft, forKey: "infoappear")
  
  let fadeLabelIn = CABasicAnimation(keyPath: "opacity")
  fadeLabelIn.fromValue = 0.2
  fadeLabelIn.toValue = 1.0
  fadeLabelIn.duration = 4.5
  info.layer.add(fadeLabelIn, forKey: "fadein")
  ```

  `flyLeft`是从左到右移动的动画，`fadeLabelIn`是透明度渐渐变大的动画。

  此时的动画效果如下：

  ![](https://ws1.sinaimg.cn/large/006tNbRwgy1fx524dojubg308q0600vk.gif)

- 为**Text Field**添加代理。通过扩展，让`ViewController`遵循`UITextFieldDelegate`协议：

  ```swift
  extension ViewController: UITextFieldDelegate {
      func textFieldDidBeginEditing(_ textField: UITextField) {
          guard let runningAnimations = info.layer.animationKeys() else {
              return
          }
          print(runningAnimations)
      }
  }
  ```

  在`viewDidAppear()`中添加：

  ```swift
  username.delegate = self
  password.delegate = self
  ```

  此时运行，`info`动画还在进行时点击文本框，会打印动画key值：

  ```
  ["infoappear", "fadein"]
  ```

- 在 `textFieldDidBeginEditing(:)`里添加:

  ```swift
  info.layer.removeAnimation(forKey: "infoappear")
  ```

  删除从左向右移动的动画，点击文本框后，`info`立即到达终点，也就是屏幕中央：

  ![](https://ws1.sinaimg.cn/large/006tNbRwgy1fxkpgdflv2g308q07t0vk.gif)

  当然也可以通过`removeAllAnimations()`方法删除`layer`上的所有动画。

> **注意：**动画进行完了，会被从`layer`上删除，也就是`animationKeys()`方法将获得不到动画key了。

### 修改☁️的动画

通过本章所学的动画代理和动画KVO修改☁️的动画

- 先在`ViewController`中添加动画方法：

  ```swift
  /// 云的图层动画
  func animateCloud(layer: CALayer) {
      let cloudSpeed = 60.0 / Double(view.layer.frame.size.width)
      let duration: TimeInterval = Double(view.layer.frame.size.width - layer.frame.origin.x) * cloudSpeed
      
      let cloudMove = CABasicAnimation(keyPath: "position.x")
      cloudMove.duration = duration
      cloudMove.toValue = self.view.bounds.width + layer.bounds.width/2
      cloudMove.delegate = self
      cloudMove.setValue("cloud", forKey: "name")
      cloudMove.setValue(layer, forKey: "layer")
      layer.add(cloudMove, forKey: nil)
  }
  ```

- 把`viewDidAppear()`中的四个`animateCloud`方法调用替代为：

  ```swift
  animateCloud(layer: cloud1.layer)
  animateCloud(layer: cloud2.layer)
  animateCloud(layer: cloud3.layer)
  animateCloud(layer: cloud4.layer)
  ```

- 在动画代理方法`animationDidStop`中添加：

  ```swift
  if name == "cloud" {
      if let layer = anim.value(forKey: "layer") as? CALayer {
          anim.setValue(nil, forKey: "layer")
          
          layer.position.x = -layer.bounds.width/2
          delay(0.5) {
              self.animateCloud(layer: layer)
          }
      }
  }
  ```

  上面代码，让动画重复进行



## Chapter 10: Groups and Advaced Timing

在上一章[9]()中，学习了如何向单个图层添加多个独立动画。 但是，如果您希望您的动画同步工作并保持彼此一致，该怎么办？ 不必分别掌握所有动画的数学和时间，这没什么好玩的。 这就是**animation groups**进来的地方。

本章介绍如何使用`CAAnimationGroup`对动画进行分组，该动画允许您向组中添加多个动画并同时调整持续时间，委托和`timingFunction`等属性。
对动画进行分组会产生简化的代码，并确保您的所有动画将作为一个实体单元同步。

> 使用上一章完成的项目或使用原书对应章节的**开始项目**



### CAAnimationGroup

删除`viewWillAppear()`中的:

```swift
loginButton.center.y += 30.0
loginButton.alpha = 0.0
```

删除`viewDidAppear()`中登录按钮的显示动画：

```swift
UIView.animate(withDuration: 0.5, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: [], animations: {
    self.loginButton.center.y -= 30.0
    self.loginButton.alpha = 1.0
}, completion: nil)
```

在`viewDidAppear()`中组动画添加：

```swift
let groupAnimation = CAAnimationGroup()
groupAnimation.beginTime = CACurrentMediaTime() + 0.5
groupAnimation.duration = 0.5
groupAnimation.fillMode = kCAFillModeBackwards 
```

`CAAnimationGroup`继承于`CAAnimation`，也有`beginTime`, `duration`, `fillMode`, `delegate`等属性。

继续三个动画，并把它们加入到上面的组动画中：

```swift
let scaleDown = CABasicAnimation(keyPath: "transform.scale")
scaleDown.fromValue = 3.5
scaleDown.toValue = 1.0

let rotate = CABasicAnimation(keyPath: "transform.rotation")
rotate.fromValue = .pi / 4.0
rotate.toValue = 0.0

let fade = CABasicAnimation(keyPath: "opacity")
fade.fromValue = 0.0
fade.toValue = 1.0

groupAnimation.animations = [scaleDown, rotate, fade]
loginButton.layer.add(groupAnimation, forKey: nil)
```

效果为：



![](https://ws3.sinaimg.cn/large/006tNbRwgy1fx5fkh3qgjg308q0bjjwx.gif)





### Animation easing 

图层动画中的easing与[Chapter1]()中介绍的视图动画的动画选项的，在概念上是相同的， 只是语法有所不同。

`CAMediaTimingFunction`   `CAMediaTimingFunction(controlPoints: _: _: _:)`



`kCAMediaTimingFunctionLinear`  速度不变化

`kCAMediaTimingFunctionEaseIn`  速度从慢到块，也就加速

`kCAMediaTimingFunctionEaseIn`  速度从快到慢，也就是在减速

`kCAMediaTimingFunctionEaseInEaseOut`  

![image-20181126112903447](https://ws4.sinaimg.cn/large/006tNbRwgy1fxlb038a98j30ba04n74l.jpg)

用法，

```swift
groupAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
```





### More timing options



- 重复动画

```swift
flyLeft.repeatCount = 4
```



```swift
flyLeft.autoreverses = true
```



这很容易看起来很酷，但你的动画还是有点不完美。 指令动画四次，但标签然后直接跳到屏幕的中心。
这是因为单个动画循环将标签移动到屏幕中心然后再次移出。 因此，当您运行动画四次时，最后一个循环以标签离开屏幕结束。 这就是标签似乎跳到屏幕中心的原因。 你不能跑半个动画周期 - 或者你可以吗？

```swift
flyLeft.repeatCount = 2.5
```

- 改变动画的速度

可以通过设置速度属性来独立于持续时间来控制动画的速度。

```swift
flyLeft.speed = 2.0
```



只是为了好玩，你可以通过调整顶层视图控制器层的速度属性来使屏幕上的所有内容都超级快速地运行。



玩动画speeds, reversing and repeating很有趣，但你的用户可能不会喜欢这样的UI元素！
但如果您确实需要在本地调整动画速度，现在可以在动画级别以及整个图层上执行此操作。



### 利用组动画修改三个form元素的动画



```swift
    let flyRight = CABasicAnimation(keyPath: "position.x")
    flyRight.fromValue = -view.bounds.size.width/2
    flyRight.toValue = view.bounds.size.width/2
    flyRight.duration = 0.5
    flyRight.fillMode = kCAFillModeBoth
    flyRight.delegate = self
    flyRight.setValue("form", forKey: "name")
    flyRight.setValue(heading.layer, forKey: "layer")
    
    heading.layer.add(flyRight, forKey: nil)
    
    flyRight.setValue(username.layer, forKey: "layer")
    
    flyRight.beginTime = CACurrentMediaTime() + 0.3
    username.layer.add(flyRight, forKey: nil)
    
    flyRight.setValue(password.layer, forKey: "layer")
    
    flyRight.beginTime = CACurrentMediaTime() + 0.4
    password.layer.add(flyRight, forKey: nil)
```

修改为：

```swift
    let formGroup = CAAnimationGroup()
    formGroup.duration = 0.5
    formGroup.fillMode = kCAFillModeBackwards
    
    let flyRight = CABasicAnimation(keyPath: "position.x")
    flyRight.fromValue = -view.bounds.size.width/2
    flyRight.toValue = view.bounds.size.width/2
    
    let fadeFieldIn = CABasicAnimation(keyPath: "opacity")
    fadeFieldIn.fromValue = 0.25
    fadeFieldIn.toValue = 1.0
    
    formGroup.animations = [flyRight, fadeFieldIn]
    heading.layer.add(formGroup, forKey: nil)
    
    formGroup.delegate = self
    formGroup.setValue("form", forKey: "name")
    formGroup.setValue(username.layer, forKey: "layer")
    
    formGroup.beginTime = CACurrentMediaTime() + 0.3
    username.layer.add(formGroup, forKey: nil)
    
    formGroup.setValue(password.layer, forKey: "layer")
    formGroup.beginTime = CACurrentMediaTime() + 0.4
    password.layer.add(formGroup, forKey: nil)
```



将两个动画添加到动画组，并在表单标题标签和两个文本字段视图上运行该组。
由于您希望在组动画完成时启动动画委托方法，因此您需要在动画组对象上设置委托和键，而不是在单个动画上设置。
在将动画添加到每个文本字段之前，不要忘记使用setValue（_：forKey :)在动画上设置名称和图层键，以便正确调用委托方法。
此外，您需要调整动画组对象的beginTime参数，以便像以前一样为正在设置动画的不同图层提供正确的延迟。
通过这一挑战，您可以在与团队和代表合作方面获得更多宝贵的经验。 此时，您已准备好继续下一章，并为您的图层动画添加一些灵活性。





## Chapter 11: Layer Springs

UIKit的[Springs]()可以让你创建一个有点过于简单的弹簧式动画，但核心动画Layer Springs对应物会呈现一个看起来和感觉更自然的正确物理模拟。

本章介绍了UIKit和Core Animation弹簧动画之间的差异，向**BahamaAirLoginScreen**项目中添加一些新的图层弹簧动画。

先说一些理论知识：

### Damped harmonic oscillators（阻尼谐振子，逐渐衰减的振动）

UIKit API简化了弹簧动画的制作; 你不需要了解它们的原理。 但是，由于您现在是核心动画专家，因此您需要深入研究细节。

钟摆。理想状况下钟摆是不停的摆动，像下面的一样：

![](https://ws2.sinaimg.cn/large/006tNbRwgy1fx5ndd6e2wj308106kaa0.jpg)

对应的运动轨迹图就像：

![](https://ws4.sinaimg.cn/large/006tNbRwgy1fx5ne165xmj30a5048wed.jpg)

但现实中由于能力的损耗，钟摆的摇摆的幅度在逐渐减小：

![image-20181112222946546](https://ws4.sinaimg.cn/large/006tNbRwgy1fx5nf8yf71j30a206saap.jpg)

钟摆的摇摆的幅度在逐渐减小的运动轨迹：

![image-20181112223028487](https://ws3.sinaimg.cn/large/006tNbRwgy1fx5nfxvbhij30c204kt8s.jpg)



这是一个阻尼谐振子 - 有一些力作用于（或阻尼）振荡，所以它每次都会减慢一点点，直到它停下来。
那不是那么糟糕，是吗？
钟摆稳定所需的时间长度，以及最终振荡器图形的方式取决于振荡系统的以下参数：

阻尼(damping)：这是由于空气摩擦，机械摩擦和其他作用在系统上的外部减速力。
质量(mass)：摆锤越重，摆动的时间越长。
刚度(stiffness)：振荡器的“弹簧”越硬，在这种情况下是地球的引力，摆锤首先摆动越困，系统稳定得越快。想象一下，如果你在月球或木星上使用这个摆锤;在低重力和高重力情况下的运动将是完全不同的。

初始速度(initial velocity)：你的爷爷只是让钟摆走了，还是他把钟摆推了一下？“



“这一切都非常有趣，”你可能会想，“但它与弹簧动画有什么关系呢？”
一个很好的问题，有一个很好的答案！ 阻尼谐振子系统是推动iOS中弹簧动画的动力。 下一节将更详细地讨论这个问题。

### UIKit vs Core Animation springs

UIKit以动态方式调整所有其他变量，使系统在给定的持续时间内稳定下来。 这就是为什么UIKit弹簧动画有时有点*被迫* 停下来的感觉。 如果仔细观察会防线UIKit动画有点不太自然。

幸运的是，**Core Animation**允许通过`CASpringAnimation`类为图层属性创建合适的弹簧动画。 `CASpringAnimation`在幕后为UIKit创建弹簧动画，但是当你直接调用它时，你可以设置系统的各种变量，让动画自己稳定夏利。 这种方法的缺点是不能设置固定的持续时间（duration）; 持续时间取决于提供的变量，然后系统计算所得。

`CASpringAnimation`的一些属性：

`damping`    阻尼系数，阻止弹簧伸缩的系数，阻尼系数越大，停止越快

`mass`   质量，影响图层运动时的弹簧惯性，质量越大，弹簧拉伸和压缩的幅度越大

`stiffness `    刚度系数(劲度系数/弹性系数)，刚度系数越大，形变产生的力就越大，运动越快

`initialVelocity`   初始速率，动画视图的初始速度大小。
速率为正数时，速度方向与运动方向一致，速率为负数时，速度方向与运动方向相反



### first layer spring animation

两个文本框移动动画结束后有个脉动动画，让用户知道该字段处于活动状态并可以使用。 然而，动画有些突然结束。 通过用`CASpringAnimation`来让脉动动画更加自然一点。

把`animationDidStop(_:finished:)`动画代码：

```swift
// 简单的脉动动画
let pulse = CABasicAnimation(keyPath: "transform.scale")
pulse.fromValue = 1.25
pulse.toValue = 1.0
pulse.duration = 0.25
layer?.add(pulse, forKey: nil)
```

转变为：

```swift
let pulse = CASpringAnimation(keyPath: "transform.scale")
pulse.damping = 2.0
pulse.fromValue = 1.25
pulse.toValue = 1.0
pulse.duration = pulse.settlingDuration
layer?.add(pulse, forKey: nil)
```

效果图前后对比：

![CABasicAnimation](https://ws2.sinaimg.cn/large/006tNbRwgy1fx4zbw6nt9g308q060q4l.gif)

![CASpringAnimation](https://ws2.sinaimg.cn/large/006tNbRwgy1fx647m132mg308o060464.gif)



这边要注意`duration`。要使用系统根据当前参数估算的弹簧动画从开始到结束的时间`pulse.settlingDuration`。

这是你的代码完全按照你的要求做的事情：

  您使用自定义阻尼值和所有其他系统变量的默认值创建了弹簧动画
  但你也通过设置其持续时间属性告诉它运行0.25秒。

弹簧系统不能在0.25秒内稳定下来; 你提供的变量意味着动画应该在它停止前再运行一段时间。
这是一个关于如何切断弹簧动画的视觉演示：

![](https://ws3.sinaimg.cn/large/006tNbRwgy1fx64fgnaecj30bw03sq2u.jpg)



`settlingDuration`是怎么计算的呢？！

如果抖动时间太长，可以加大阻尼系数`damping`，比如：`pulse.damping = 7.5`。



### Spring animation propertiers

`CASpringAnimation`预定义的弹簧动画属性的默认值分别是：

```
damping: 10.0
mass: 1.0
stiffness: 100.0
initialVelocity: 0.0
```

实现文本框的一个代理方法：

```swift
func textFieldDidEndEditing(_ textField: UITextField) {
    guard let text = textField.text else {
        return
    }
    if text.count < 5 {
        let jump = CASpringAnimation(keyPath: "position.y")
        jump.fromValue = textField.layer.position.y + 1.0
        jump.toValue = textField.layer.position.y
        jump.duration = jump.settlingDuration
        textField.layer.add(jump, forKey: nil)
    }
}
```

上面代码，表示当用户在文本中输入结束后，如果输入字符数小于5，出现一个小幅度的抖动动画，提醒用户太短了。

- `initialVelocity`

此属性允许您指定动画的起始速度。 默认值0表示动画在开始时没有按下; 好像有人只是抱着重量而放手。
正值使动画在平衡点的方向上推动，而负值使动画从平衡点开始移动。
你的跳跃动画应该非常明显，所以在开始时给它一个很好的推动100.0。 在初始化动画对象的位置之后添加以下行（重要的是在计算和设置持续时间之前添加它）：



- `mass`

  它看起来更好，但跳跃动画安定得太快了。 增加初始速度会使动画持续时间更长，但这也意味着场地跳得太远。
  对于动画持续时间更长的情况，如果增加附加重量的质量怎么办？ 听起来不错！
  默认质量值为1.0（在您看来，您可以选择磅，公斤或您想要的任何其他测量单位），您可以使用任何有助于达到预期效果的正值。
  对于当前动画，将质量增加到10.0，如下所示：

- `stiffness`

- `damping`



??





### Specific layer properties



验证动画现在可能有点过于微妙和流畅。 您将在包含无效输入的文本字段周围添加一个不那么微妙的闪烁红色边框。



文本框颜色边的动画



一个简单的CABasicAnimation会将边框颜色从红色变为白色。 但是因为你选择了一个弹簧动画，边框颜色从红色开始，并围绕最终的白色振动。
运行应用程序以欣赏最终效果; 野外边界在落下并消失前闪烁几次：

![](https://ws4.sinaimg.cn/large/006tNbRwgy1fxlrvczonsg308q060tap.gif)

### 

### Convert corner radius and background animations to springs

### 把登录按钮的圆角和背景色变化动画转化为弹性动画

```swift
func tintBackgroundColor(layer: CALayer, toColor: UIColor) {    
    let tint = CASpringAnimation(keyPath: "backgroundColor")
    tint.damping = 5.0
    tint.initialVelocity = -10.0
    tint.fromValue = layer.backgroundColor
    tint.toValue = toColor.cgColor
    tint.duration = tint.settlingDuration
    layer.add(tint, forKey: nil)
    layer.backgroundColor = toColor.cgColor
}

func roundCorners(layer: CALayer, toRadius: CGFloat) {    
    let round = CASpringAnimation(keyPath: "cornerRadius")
    round.damping = 5.0
    round.fromValue = layer.cornerRadius
    round.toValue = toRadius
    round.duration = round.settlingDuration
    layer.add(round, forKey: nil)
    layer.cornerRadius = toRadius
}
```





## Chapter 12: Layer KeyFrame Animations and Struct Properties

Layer上的关键帧动画与UIView上的关键帧动画略有不同。 查看关键帧动画是将独立简单动画组合在一起的简单方法; 它们可以为不同的视图和属性设置动画，动画可以重叠或在两者之间存在间隙。
相比之下，`CAKeyframeAnimation`允许您为给定图层上的单个属性设置动画。 您可以定义动画的不同关键点，但动画中不能有任何间隙或重叠。 尽管起初听起来有些限制，但你可以使用CAKeyframeAnimation创建一些非常引人注目的效果。



![](https://ws1.sinaimg.cn/large/006tNbRwgy1fx690o3li9g308m060dho.gif)



眼睛敏锐的读者可能已经注意到我还没有介绍过结构属性的动画。 大多数情况下，你可以放弃动画结构的单个组件，例如CGPoint的x组件，或CATransformation3D的旋转组件，但是接下来你会发现动态结构值的动画比 你可能会先考虑一下。



### Animating struct values

结构实例是Swift中的一等公民。 实际上，在使用类和结构之间语法上几乎没有区别。
但是，Core Animation是一个基于C构建的Objective-C框架，这意味着结构的处理方式截然不同。 Objective-C API喜欢处理对象，因此结构需要一些特殊的处理。
这就是为什么对图层属性（如颜色或数字）进行动画制作相对容易的原因，但是为CGPoint等结构属性设置动画并不容易。
CALayer有许多可动画的属性，它们包含struct值，包括CGPoint类型的位置，CATransform3D类型的转换和CGRect类型的边界。 为了帮助管理这个问题，Cocoa包含了NSValue类，它将一个struct值“包装”或“包装”为一个对象。





### Intermediate keyframe animations

如果您需要在屏幕上显示图像但不需要使用UIView的所有好处（例如自动布局约束，附加手势识别器等），您可以简单地使用上面的代码示例中的CALayer。



![](https://ws3.sinaimg.cn/large/006tNbRwgy1fx69jdo8zrj30d606zglk.jpg)



![](https://ws1.sinaimg.cn/large/006tNbRwgy1fx69ltw09dg308s0avwtn.gif)



## Chapter 13: Shapes and Masks

本章标志着本书这一部分的一个转变：你不仅要开始使用不同的示例项目，而且还要使用多层效果，创建看起来与物理交互的图层动画。 彼此在动画运行时在形状之间变换。

`CAShapeLayer`



本章中的形状将由CAShapeLayer处理，这是一个CALayer子类，可以让您在屏幕上绘制各种形状，从非常简单到非常复杂：

您可以在屏幕上绘制CALayer CGPath，而不是接受绘图说明。 这很方便，因为Core Graphics已经为构建CGPath形状定义了非常广泛的绘图指令API。
如果您更熟悉UIBezierPath，可以使用它来定义形状，然后使用其cgPath属性来获取其Core Graphics表示。 你将在本章稍后再试一试。



### 开始项目



### avatar view

`photoLayer`：头像的图像层。
`circleLayer`：用于绘制圆的形状图层。
`maskLayer`：另一个用于绘制蒙版的形状图层。
`label`：显示玩家姓名的标签。



![](https://ws2.sinaimg.cn/large/006tNbRwgy1fx6ami0kayj30e405r74e.jpg)



### Creating the bounce-off animation



![](https://ws1.sinaimg.cn/large/006tNbRwgy1fx6g7btqrug308s08u77g.gif)



### Morphing shapes(变形图形)



![](https://ws1.sinaimg.cn/large/006tNbRwgy1fx6gl8vr2tg308s08uwhy.gif)



```swift
        maskLayer.add(morphAnimation, forKey: nil)
```



??





## Chapter 14: Gradient Animations





```swift
let gradientLayer = CAGradientLayer()
        
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        let colors = [
            UIColor.black.cgColor,
            UIColor.white.cgColor,
            UIColor.black.cgColor
        ]
        gradientLayer.colors = colors
        let locations: [NSNumber] = [0.25, 0.5, 0.75]
        gradientLayer.locations = locations
        
        return gradientLayer
```



![](https://ws2.sinaimg.cn/large/006tNbRwgy1fx6k8b06x9j30b403udfp.jpg)



![](https://ws2.sinaimg.cn/large/006tNbRwgy1fx6kb2e2fjj308v0fp3yc.jpg)





### Animating gradients



```swift
        let gradientAnimation = CABasicAnimation(keyPath: "locations")
        gradientAnimation.fromValue = [0.0, 0.0, 0.25]
        gradientAnimation.toValue = [0.75, 1.0, 1.0]
        gradientAnimation.duration = 3.0
        gradientAnimation.repeatCount = .infinity
        gradientLayer.add(gradientAnimation, forKey: nil)
```



![](https://ws1.sinaimg.cn/large/006tNbRwgy1fx6kjtzpg0g308k08r3za.gif)

在这一层动画中，首先将三个颜色里程碑推到渐变框架的左边缘，然后结束动画，将所有三个里程碑推向右边缘：





```swift
        gradientLayer.frame = CGRect(x: -bounds.size.width, y: bounds.origin.y, width: 3 * bounds.size.width, height: bounds.size.height)
```



![](https://ws3.sinaimg.cn/large/006tNbRwgy1fx6kqy3tycg308k060gna.gif)



### Creating a text mask





![](https://ws4.sinaimg.cn/large/006tNbRwgy1fx6l41g457g308k0600t0.gif)





### 滑动手势动画

![](https://ws1.sinaimg.cn/large/006tNbRwgy1fx6l9mrd4sg308k0fmaf4.gif)





### 彩色渐变动画



![](https://ws3.sinaimg.cn/large/006tNbRwgy1fx6lgtu9xhg308k0600ss.gif)





## Chapter 15: Stroke and Path Animations



Pull-to-refresh animation



### Animating both stroke ends



```swift
        let strokeStartAnimation = CABasicAnimation(keyPath: "strokeStart")
        strokeStartAnimation.fromValue = -0.5
        strokeStartAnimation.toValue = 1.0
        
        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.fromValue = 0.0
        strokeEndAnimation.toValue = 1.0
        
        let strokeAnimationGroup = CAAnimationGroup()
        strokeAnimationGroup.duration = 1.5
        strokeAnimationGroup.repeatDuration = 5.0
        strokeAnimationGroup.animations = [strokeEndAnimation, strokeEndAnimation]
        ovalShapeLayer.add(strokeAnimationGroup, forKey: nil)
```



![](https://ws1.sinaimg.cn/large/006tNbRwgy1fx7ioqqx88g308q08rjw3.gif)



#### Creating path keyframe animations



```swift
 		// 飞机动画
        let flightAnimation = CAKeyframeAnimation(keyPath: "position")
        flightAnimation.path = ovalShapeLayer.path
        flightAnimation.calculationMode = CAAnimationCalculationMode.paced
        
        let flightAnimationGroup = CAAnimationGroup()
        flightAnimationGroup.duration = 1.5
        flightAnimationGroup.repeatDuration = 5.0
        flightAnimationGroup.animations = [flightAnimation]
        airplaneLayer.add(flightAnimationGroup, forKey: nil)
```



![](https://ws2.sinaimg.cn/large/006tNbRwgy1fx7ixtawarg308q08r0y7.gif)





调整飞机移动时角度

```swift
        let airplaneOrientationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        airplaneOrientationAnimation.fromValue = 0
        airplaneOrientationAnimation.toValue = 2.0 * .pi
```



最终效果

![](https://ws4.sinaimg.cn/large/006tNbRwgy1fx7j42np9ig308q08r0w0.gif)



?? 飞机线太长？



## Chapter 16: Replicating Animations(复制动画)

`CAReplicatorLayer`



“CAReplicatorLayer背后的想法很简单。 你创建了一些内容 - 它可以是一个形状，一个图像或任何你可以用图层绘制的东西 - 而CAReplicatorLayer会在屏幕上复制它，如下所示：

![](https://ws3.sinaimg.cn/large/006tNbRwgy1fx7m9wkg4dj30bb05g74a.jpg)

“为什么我需要克隆形状或图像？”你会问。 你这样问是对的; 通常情况下，你不需要克隆任何东西的确切外观。“



![](https://ws4.sinaimg.cn/large/006tNbRwgy1fx7maaq340j30a2043a9u.jpg)

![image-20181114152157889](https://ws4.sinaimg.cn/large/006tNbRwgy1fx7maqjd0yj309i050weq.jpg)



但最好的功能是能够设置动画延迟以跟随每个副本。 当您设置0.2秒的`instanceDelay`并为原始内容添加动画时，第一个副本将以0.2秒的延迟动画，第二个副本将在0.4秒内动画，第三个副本将在0.6秒内动画，依此类推。
您可以使用它来创建引人入胜且复杂的动画，您可以以同步方式为多个元素设置动画。



一个迷幻的正弦波

plist文件中添加



### Replicating like rabbits







![](https://ws3.sinaimg.cn/large/006tNbRwgy1fx7onwmyoeg308q08rdkr.gif)





### Replicating multiple animations

注意按钮事件

- Scale animation

```swift
        let scale = CABasicAnimation(keyPath: "transform")
        scale.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
        scale.toValue = NSValue(caTransform3D: CATransform3DMakeScale(1.4, 15, 1.0))
        scale.duration = 0.33
        scale.repeatCount = .infinity
        scale.autoreverses = true
        scale.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        dot.add(scale, forKey: "dotScale")
```



![](https://ws1.sinaimg.cn/large/006tNbRwgy1fx7p9fze8bg308o0cxgqy.gif)



- Opacity animation

![](https://ws4.sinaimg.cn/large/006tNbRwgy1fx7pc183k6j308x02jwec.jpg)

```swift
        let fade = CABasicAnimation(keyPath: "opacity")
        fade.fromValue = 1.0
        fade.toValue = 0.2
        fade.duration = 0.33
        fade.beginTime = CACurrentMediaTime() + 0.33
        fade.repeatCount = .infinity
        fade.autoreverses = true
        fade.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        dot.add(fade, forKey: "dotOpacity")
```







![](https://ws2.sinaimg.cn/large/006tNbRwgy1fx7pj4kg1hg308o0cxtcg.gif)



- Tint animation

```swift
        let tint = CABasicAnimation(keyPath: "backgroundColor")
        tint.fromValue = UIColor.magenta.cgColor
        tint.toValue = UIColor.cyan.cgColor
        tint.duration = 0.66
        tint.beginTime = CACurrentMediaTime() + 0.28
        tint.fillMode = CAMediaTimingFillMode.backwards
        tint.repeatCount = .infinity
        tint.autoreverses = true
        tint.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        dot.add(tint, forKey: "dotColor")
```





![](https://ws4.sinaimg.cn/large/006tNbRwgy1fx7pqcu6p9g308o0cx0zm.gif)



### Animation CAReplicatorLayer properties

```swift
        let initialRotation = CABasicAnimation(keyPath:
            "instanceTransform.rotation")
        initialRotation.fromValue = 0.0
        initialRotation.toValue   = 0.01
        initialRotation.duration = 0.33
        initialRotation.isRemovedOnCompletion = false
        initialRotation.fillMode = CAMediaTimingFillMode.forwards
        initialRotation.timingFunction = CAMediaTimingFunction(name:
            CAMediaTimingFunctionName.easeOut)
        replicator.add(initialRotation, forKey: "initialRotation")
```



![](https://ws3.sinaimg.cn/large/006tNbRwgy1fx7pvr18n8g308o0cxtjy.gif)



??这一章暂停到p248

