# 系统学习iOS动画之一：视图动画

这个部分介绍**UIKit动画API**，这些API专门用于轻松制作**视图动画(View Animations)**，同时避免**核心动画(Core Animation)**(见[系统学习iOS动画之三：图层动画](Section_III))的复杂性。

**UIKit动画**API不仅易于使用，而且提供了大量灵活性和强大功能，可以处理大多数（当然不是全部）动画要求。

**UIKit动画**API可以在屏幕上为最终继承自`UIView`的任何对象设置动画，例如：`UILabel`，`UIImageView`，`UIButton`等等，也可以是自己创建的任何自定义最终继承自`UIView`类。



本文包括五个章节，完成两个项目**BahamaAirLoginScreen**和**Flight Info**。

*BahamaAirLoginScreen* 是一个登录页面项目，1、2、3章节为这个项目的一些UI添加各种动画。

[1-视图动画入门](#1-视图动画入门) —— 学习如何移动，缩放和淡化视图等基本的UIKit API。  
[2-弹簧动画](#2-弹簧动画) —— 在线性动画的概念基础上，使用弹簧动画创造出更引人注目的效果。😊  
[3-过渡动画](#3-过渡动画) —— 视图的出现和消失。      

*Flight Info* 是一个航班状态变化项目，4、5章节用一些高级一点动画来完成这个项目。

[4-练习视图动画](#4-练习视图动画) —— 练习前面学到的动画技术。  
[5-关键帧动画](#5-关键帧动画) —— 使用关键帧动画来创建由许多不同阶段组成的复杂动画。  



## 1-视图动画入门



### 第一个动画

[开始项目](README.md#关于代码) **BahamaAirLoginScreen**是一个简单的登录页面，有两个TextField，一个Label，一个Button，4个云图片和一个背景图片，效果如下：

![](https://ws1.sinaimg.cn/large/006tNbRwgy1fx9ypkbsm2j307r07e746.jpg)

让Label和两个TextField在视图显示之前移动到屏幕外。在`viewWillAppear()`中添加：

  ```swift
heading.center.x    -=  view.bounds.width
username.center.x   -=  view.bounds.width
password.center.x   -=  view.bounds.width
  ```

  ![](https://ws4.sinaimg.cn/large/006tNbRwgy1fw8zt5x34nj30cm05na9x.jpg)

添加Label和两个TextField进入屏幕的动画，在`viewDidAppear()`中添加：

```swift
UIView.animate(withDuration: 0.5) {
	self.heading.center.x += self.view.bounds.width
}

UIView.animate(withDuration: 0.5, delay: 0.3, options: [],
  animations: {
    self.username.center.x += self.view.bounds.width
  }, 
  completion: nil
)

UIView.animate(withDuration: 0.5, delay: 0.4, options: [],
  animations: {
    self.password.center.x += self.view.bounds.width
  }, 
  completion: nil
)
```

这样heading和TextField就有了前后分别进入屏幕的动画。

类似`UIView.animate(...)`的方法，根据参数的不同有好几个，不同参数的意义：

 `withDuration` ：动画持续时间。

 `delay` ：动画开始之前的延迟时间。

 `options` ：`UIView.AnimationOptions`的数组，用来定义动画的变化形式，之后会详细说明。

 `animations` ：提供动画的闭包，也就是动画代码。

 `completion` ：动画执行完成后的闭包 。 

还有 `usingSpringWithDamping`和`initialSpringVelocity`之后章节会提到。



### 可动画属性

前面，使用`center`创建简单的位置变化视图动画。

并非所有视图属性都可以设置动画，但所有视图动画（从最简单到最复杂）都可以通过动画视图上的属性来构建。下面来看看可用于动画的属性有哪些：

#### 位置的大小
`bounds`  `frame` `center`  

![](https://ws3.sinaimg.cn/large/006tNbRwgy1fxa1kn5wvyj30c3045jrb.jpg)

#### 外形(Appearance)  
`backgroundColor`  
`alpha` : 可创建淡入和淡出效果。

  ![](https://ws2.sinaimg.cn/large/006tNbRwgy1fxaa9ghw07j309703k0t1.jpg)



#### 转换(Transformation)  
`transform` ： 设置视图的旋转，缩放和/或位置的动画。



  ![image-20181116174323974](https://ws1.sinaimg.cn/large/006tNbRwgy1fxaa9nort9j309v033glr.jpg)



这些看起来像是非常基本的动画，可以制作令人惊讶的复杂动画效果！😉



### 动画选项

动画选项(Animation options)就是之前提到的`options`参数，它是`UIView.AnimationOptions`的数组。`UIView.AnimationOptions`是结构体，有很多常量值，具体可查看[官方文档](https://developer.apple.com/documentation/uikit/uiview/animationoptions) 。

下面说明几个常用的

#### 重复

`.repeat`  ：动画一直重复。

 `.autoreverse` ：如果仅有`.repeat`参数动画的过程，就像是 `b->e   b->e  ...`，而有了`.autoreverse`，动画过程就像是`b->e->b->e ...`。看下图很容易看出区别。

![](https://ws4.sinaimg.cn/large/006tNbRwgy1fw6k7ynuqlg30k40ga0ut.gif)



#### 动画缓动

Animation easing，我暂且把它叫做 **动画缓动**。

> curve:弯曲；使弯曲。ease：减轻，缓和。

在现实生活中，事物并不只是突然开始或停止移动。 像汽车或火车这样的物体会慢慢加速直到达到目标速度，除非它们碰到砖墙，否则它们会逐渐减速直到它们完全停在最终目的地。

为了使动画看起来更逼真，可以在开始时慢慢加速，在结束前放慢速度，一般称为**缓入(ease-in)**和**缓出(ease-out)**。

`.curveLinear` ：不对动画应用加速或减速。
`.curveEaseIn` ：动画的开始时慢，结束时快。

```
UIView.animate(withDuration: 1, delay: 0.6, options: [.repeat, .autoreverse, .curveEaseIn], animations: {
  self.password.center.x += self.view.bounds.width
}, completion: nil)
```

`.curveEaseOut` ：动画开始时快，结束时慢。 

```swift
UIView.animate(withDuration: 1, delay: 0.6, options: [.repeat, .autoreverse, .curveEaseOut], animations: {
          self.password.center.x += self.view.bounds.width
      }, completion: nil)
```

   

![](https://ws3.sinaimg.cn/large/006tNbRwgy1fw6k8dv4rhg30k40gago8.gif)



 `.curveEaseInOut`  ：动画开始结束都慢，中间快



### 云的淡入动画

这个很好理解，就是云的`UIImageView`的透明度变化动画。先在`viewWillAppear()`中把云设置成透明：

```swift
cloud1.alpha = 0.0
cloud2.alpha = 0.0
cloud3.alpha = 0.0
cloud4.alpha = 0.0
```

然后在`viewDidAppear()`中添加动画。

```swift
UIView.animate(withDuration: 0.5, delay: 0.5, options: [], animations: {
    self.cloud1.alpha = 1.0
}, completion: nil)
UIView.animate(withDuration: 0.5, delay: 0.7, options: [], animations: {
    self.cloud2.alpha = 1.0
}, completion: nil)
UIView.animate(withDuration: 0.5, delay: 0.9, options: [], animations: {
    self.cloud3.alpha = 1.0
}, completion: nil)
UIView.animate(withDuration: 0.5, delay: 1.1, options: [], animations: {
    self.cloud4.alpha = 1.0
}, completion: nil)
```





## 2-弹簧动画



[1-视图动画入门](#1-视图动画入门)中动画是单一方向上的动作，可以理解为一点移动到另一个。

 这一章节是稍微复杂一点的**弹簧动画(Springs)**：

![](https://ws3.sinaimg.cn/large/006tNbRwgy1fw90biqpzjj306x057a9x.jpg)

用点变化描述弹簧动画：

![](https://ws1.sinaimg.cn/large/006tNbRwgy1fw90cubqxvj307u04smx2.jpg)

视图从A点到B点，在B点来回递减振荡，直到视图在B点停止。这是一个很好的效果， 让我们的动画添加了一种活泼，真实的感觉。 

本章的[开始项目](README.md#关于代码) **BahamaAirLoginScreen**是上一章节的完成项目。

在`viewWillAppear()`中添加:

```swift
loginButton.center.y += 30.0
loginButton.alpha = 0.0
```

然后再在`viewDidAppear()`中添加：

```swift
UIView.animate(withDuration: 0.5, delay: 0.5, 
usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: [], animations: {
  self.loginButton.center.y -= 30.0
  self.loginButton.alpha = 1.0
}, completion: nil)
```

这样**Log In**按钮就有个向上移动的动画变成了两个属性同时变化的动画。

`usingSpringWithDamping` ：阻尼参数， 介于0.0 ~ 1.0，接近0.0的值创建一个更有弹性的动画，而接近1.0的值创建一个看起来很僵硬的效果。 您可以将此值视为弹簧的**“刚度”**。

`initialSpringVelocity` ：  初始速度， 要平滑开始动画，请将此值与视图之前的视图速度相匹配。

效果：

![](https://ws2.sinaimg.cn/large/006tNbRwgy1fxa8xbxmwyg308o0600tk.gif)





### 与用户交互的动画

让登录按钮产生一个与用户交互的动画，在**Log In**按钮的Action `logIn()`方法中添加：

```swift
UIView.animate(withDuration: 1.5, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.0, options: [], animations: {
  self.loginButton.bounds.size.width += 80.0
}, completion: nil)
```

点击后有个宽度变大的简单动画。

继续在`logIn()`中添加：

```swift
UIView.animate(withDuration: 0.33, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: [], animations: {
  self.loginButton.center.y += 60.0
}, completion: nil) 
```

点击后宽度变大的同时向下移动移动位置。

给用户反馈的另一个好方法是通过颜色变化。 在上面动画闭包中添加:

```swift
self.loginButton.backgroundColor = UIColor(red: 0.85, green: 0.83, blue: 0.45, alpha: 1.0)
```

最后一个给用户反馈的方法：activity indicator(活动指示器，俗称菊花转😅)。 登录按钮应该通过网络启动用户身份验证活动，通过菊花转让用户知道登录操作正在进行。

继续在上面动画闭包中添加(`spinner`已经在`viewDidLoad`中初始化了，并且`alpha`设置为0.0)：

```swift
self.spinner.center = CGPoint(x: 40.0, y: self.loginButton.frame.size.height/2)
self.spinner.alpha = 1.0
```

让菊花转也随着登录按钮的向下移动而移动，最终登录按钮的效果：

![](https://ws3.sinaimg.cn/large/006tNbRwgy1fxa9oee75sg308o0600xz.gif)





### 把文本框的动画修改为弹簧动画

把之前`viewDidAppear()`中的

```swift
UIView.animate(withDuration: 0.5, delay: 0.3, options: [], animations: {
    self.username.center.x += self.view.bounds.width
}, completion: nil)
UIView.animate(withDuration: 1, delay: 0.6, options: [], animations: {
    self.password.center.x += self.view.bounds.width
}, completion: nil)
```

修改为：

```swift
UIView.animate(withDuration: 0.5, delay: 0.3, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0, options: [], animations: {
    self.username.center.x += self.view.bounds.width
}, completion: nil)

UIView.animate(withDuration: 0.5, delay: 0.4, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0, options: [], animations: {
    self.password.center.x += self.view.bounds.width
}, completion: nil)
```

效果为：

![](https://ws4.sinaimg.cn/large/006tNbRwgy1fxaa0o57jkg308o0600uw.gif)





## 3-过渡动画

**过渡动画(Transitions)**

向您展示如何使用过渡为您的视图的任何更改设置动画

过渡是您可以应用于视图的预定义动画。 这些预定义的动画不会尝试在视图的开始和结束状态之间进行插值。 相反，你将设计动画，以便状态的各种变化看起来很自然。





`transition(with:duration: options:animations:completion:) `

使用上一章节[2-弹簧动画](#2-弹簧动画)完成的项目 **BahamaAirLoginScreen**或者本章节的[开始项目](README.md#开始项目)。

### 过渡的例子

使用过渡动画的各种动画场景。

#### 添加视图

要在屏幕上添加新视图的动画，可以调用类似于前面章节中使用的方法。 这次的不同之处在于，需要预先选择一个预定义的过渡效果，并为动画容器视图设置动画。
过渡动画是设置在容器视图上，因此动画为作用在添加到容器视图的所有子视图。

下面做一个测试（结束后，删除相应代码继续之后内容）：

```swift
var animationContainerView: UIView!

override func viewDidLoad() {
  super.viewDidLoad()
  //设置动画容器视图
  animationContainerView = UIView(frame: view.bounds)
  animationContainerView.frame = view.bounds
  view.addSubview(animationContainerView)
}

override func viewDidAppear(_ animated: Bool) {
  super.viewDidAppear(animated)

  //创建新视图
  let newView = UIImageView(image: UIImage(named: "banner"))
  newView.center = animationContainerView.center

  //通过过渡动画增加新视图
  UIView.transition(with: animationContainerView, 
    duration: 0.33, 
    options: [.curveEaseOut, .transitionFlipFromBottom], 
    animations: {  
      self.animationContainerView.addSubview(newView)
    }, 
    completion: nil
  )
}
```

效果：

![](https://ws3.sinaimg.cn/large/006tNbRwgy1fxacr7vt00g308o060gnr.gif)

`transitionFlipFromBottom`被`transitionFlipFromLeft`替代后的效果：

![](https://ws1.sinaimg.cn/large/006tNbRwgy1fxadarv6e8g308o0600us.gif)



完整的预定义过渡动画的选项如下，这些动画选项和上两节中出现`options`一样属于`UIView.AnimationOptions`。

```
.transitionFlipFromLeft
.transitionFlipFromRight
.transitionCurlUp
.transitionCurlDown
.transitionCrossDissolve
.transitionFlipFromTop
.transitionFlipFromBottom
```



#### 删除视图

从屏幕中删除子视图的过渡动画操作和添加类似。

![](https://ws2.sinaimg.cn/large/006tNbRwgy1fxacyc0ddpj30ce058dft.jpg)

参考代码：

```swift
UIView.transition(with: animationContainerView, duration: 0.33,
                  options: [.curveEaseOut, .transitionFlipFromBottom],
                  animations: {
                      self.newView.removeFromSuperview()
                  },
                  completion: nil
)
```



#### 隐藏或显示视图

![](https://ws2.sinaimg.cn/large/006tNbRwgy1fxad2gmf6qj30bk04odft.jpg)

添加和删除都会改变视图层次结构，这也是需要一个容器视图的原因。隐藏或显示的过渡动画使用视图本身作为动画容器。

参考代码：

```swift
UIView.transition(with: self.newView, duration: 0.33, 
  options: [.curveEaseOut, .transitionFlipFromBottom], 
  animations: {
    self.newView.isHidden = true
  }, 
  completion: nil
)
```



#### 一个视图替代另个视图

![](https://ws4.sinaimg.cn/large/006tNbRwgy1fxad4mayy0j30d404kmx5.jpg)

参考代码：

```swift

UIView.transition(from: oldView, to: newView, duration: 0.33, 
  options: .transitionFlipFromTop, completion: nil)
```



### 组合过渡动画

这一部分将模拟一些用户身份验证过程，几个不同的进度消息变化的动画。 一旦用户点击登录按钮，将向他们显示消息，包括“Connecting...”，“Authorizing”和“Failed”。

在`ViewController`中添加方法`showMessage()`：

```swift
func showMessage(index: Int) {
    label.text = messages[index]

    UIView.transition(with: status, duration: 0.33, options: [.curveEaseOut, .transitionCurlDown], animations: {
        self.status.isHidden = false
    }, completion: { _ in

    })  
}
```



并在登录按钮的Action`logIn`方法的下移动画的`completion`闭包中添加调用`self.showMessage(index: 0)`：

```swift
UIView.animate(withDuration: 1.5, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.0, options:[], animations: {
    self.loginButton.bounds.size.width += 80.0
}, completion: { _ in
    self.showMessage(index: 0)
})
```



动画选项`.transitionCurlDown`的效果，就像一张纸翻下来，看起来如下：

![](https://ws1.sinaimg.cn/large/006tNbRwgy1fxaw38os0lg308o060mz4.gif)

这种效果很好的让静态文本标签的消息得到用户的关注。

> 注意：iPhone模拟器提供了慢动画查看，方便看清那些比较快动画的过程，**Debug/Slow Animations**(`Command + T`)。

添加一个状态信息消除动画方法:

```swift
func removeMessage(index: Int) {
    UIView.animate(withDuration: 0.33, delay: 0.0, options: [], animations: {
        self.status.center.x += self.view.frame.size.width
    }) { (_) in
        self.status.isHidden = true
        self.status.center = self.statusPosition

        self.showMessage(index: index+1) 
     }
}
```



这个信息消除方法在什么地方调用呢？当然是状态信息显示结束后调用，因此在`showMessage`方法的`completion`闭包中添加：

```swift
delay(2.0) {
  if index < self.messages.count-1 {
    self.removeMessage(index: index)
  } else {
    //reset form
  }
}
```



### 恢复初始状态

当“Connecting...”、“Authorizing”和“Failed”等几个信息显示完后，需要将信息标签删除和将登录按钮恢复原样。

添加`resetForm()`函数：

```swift
func resetForm() {
    // 状态信息标签消失动画
    UIView.transition(with: status, duration: 0.2, options: .transitionFlipFromTop, animations: {
        self.status.isHidden = true
        self.status.center = self.statusPosition
    }, completion: nil)
    // 登录按钮和菊花转恢复原来状态的动画
    UIView.animate(withDuration: 0.2, delay: 0.0, options: [], animations: {
        self.spinner.center = CGPoint(x: -20.0, y: 16.0)
        self.spinner.alpha = 0.0
        self.loginButton.backgroundColor = UIColor(red: 0.63, green: 0.84, blue: 0.35, alpha: 1.0)
        self.loginButton.bounds.size.width -= 80.0
        self.loginButton.center.y -= 60.0
    }, completion: nil)
}
```

在之前的`//reset form`处调用，`resetForm()`。

结合之前的效果：

![](https://ws1.sinaimg.cn/large/006tNbRwgy1fxaxrpmv62g308o060qae.gif)



### 背景中☁️的动画

如果背景中的那些云在屏幕上缓慢移动，并从左侧移动到右侧，然后到右侧消失后再左侧从新开始缓慢移动，那不是很酷吗？（之前的gif可以看到云在移动，到目前为止，云只有透明度变化动画，实际上是因为我做GIF时项目已经完成了，GIF是我补做的，所以就。。😬）

添加一个`animateCloud(cloud: UIImageView)`方法，代码为:

```swift
func animateCloud(cloud: UIImageView) {
    // 假设云从进入屏幕到离开屏幕需要大约60.0s，可以计算出云移动的速度
    let cloudSpeed = view.frame.size.width / 60.0
    // 云的初始位置不一定是在座边缘
    let duration:CGFloat = (view.frame.size.width - cloud.frame.origin.x) / cloudSpeed
    UIView.animate(withDuration: TimeInterval(duration), delay: 0.0, options: .curveLinear, animations: {
        cloud.frame.origin.x = self.view.frame.size.width
    }) { (_) in
        cloud.frame.origin.x = -cloud.frame.size.width
        self.animateCloud(cloud: cloud)
    }
}
```

代码解释：

1. 首先，计算☁️平均移动速度。*假设云从进入屏幕到离开屏幕需要大约60.0s（当然这个时间自定义）*。

2. 接下来，计算☁️移动到屏幕右侧的持续时间。这边要注意，☁️不是从屏幕的左边缘开始，☁️移动的距离是`view.frame.size.width - cloud.frame.origin.x`。

3. 然后创建动画方法`animate(withDuration:delay:options:animations:completion:)`。这边`TimeInterval`是`Double`别名，动画选项使用`.curveLinear`(不加速也不减速)，这种情况很少见，但作为☁️的缓慢移动非常适合。

   动画闭包中`cloud.frame.origin.x = self.view.frame.size.width`，就把☁️移动到屏幕右边区域外。

   到屏幕右区域外，立即在完成闭包中让☁️到左边缘外，`cloud.frame.origin.x = -cloud.frame.size.width`。

最后不要忘记，把开始四个☁️的动画，在`viewDidAppear()`中添加：

```swift
animateCloud(cloud: cloud1)
animateCloud(cloud: cloud2)
animateCloud(cloud: cloud3)
animateCloud(cloud: cloud4)
```



整体效果：

![整体效果](https://ws1.sinaimg.cn/large/006tNbRwgy1fw6f5gckt8g30900fytpt.gif)





## 4-练习视图动画

你将在本章中稍作休息，学习一些技巧，结合你已经获得的技能，产生一些新的和令人印象深刻的效果。
话虽如此，请注意本章是可选的。 如果您想继续学习新的API，请随意跳到下一章 - 没有难过的感觉！
但是，如果你想弯曲你的动画肌肉并学习一些新的提示和技巧，那么你肯定会喜欢在本章的项目中工作，这将使您的彩妆航空公司Bahama Air的应用程序提升到一个新的水平。。
在本章中，您将添加一些很酷的动画来装扮航班摘要屏幕，如下所示：

本章中有一些新的效果基于您在前几章中学到的动画基础：



`CAEmitterCell`

Crossfade Animation  			同时淡出淡入
Cube transition animation  		立体转换
Fade and bounce transition   	对于简单的动画，辅助视图和你到目前为止学到的所有其他内容的组合略有不同。



本章节的[开始项目](README.md#开始项目) **Flight Info**  是定时改变几个视图（几个图片和一个Label），代码也非常简单：

```swift
  func changeFlight(to data: FlightData) {
    
    // populate the UI with the next flight's data
    summary.text = data.summary
    flightNr.text = data.flightNr
    gateNr.text = data.gateNr
    departingFrom.text = data.departingFrom
    arrivingTo.text = data.arrivingTo
    flightStatus.text = data.flightStatus
    bgImageView.image = UIImage(named: data.weatherImageName)
    snowView.isHidden = !data.showWeatherEffects
    
    // schedule next flight
    delay(seconds: 3.0) {
      self.changeFlight(to: data.isTakingOff ? parisToRome : londonToParis)
    }
  }
```

其中雪花❄️将在后面的章节[26.粒子发射器](Section_VII.md#粒子发射器)学习，效果为：

![开始项目图示](https://ws2.sinaimg.cn/large/006tNbRwgy1fxb39hzhp8g308s0fp474.gif) 






### 淡出淡入动画(Crossfading animations) 

首先需要让两个背景图像之间平滑过渡。 第一直觉可能是简单地淡出当前的图像然后淡入新的图像（透明度的变化）。 但是当alpha接近零时，这种方法会显示图像背后的内容，效果看上去不好。如下所示：

![](https://ws2.sinaimg.cn/large/006tNbRwgy1fxb3n4t33fj30cw06pjrd.jpg)

在`ViewController`中添加背景图片淡入淡出的效果：

```swift
func fade(imageView: UIImageView, toImage: UIImage, showEffects: Bool) {
    UIView.transition(with: imageView, duration: 1.0, options: .transitionCrossDissolve, animations: {
        imageView.image = toImage
    }, completion: nil)

    UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseOut, animations: {
        self.snowView.alpha = showEffects ? 1.0 : 0.0
    }, completion: nil)
}
```

`showEffects`参数表示显示或隐藏降雪效果。



给`changeFlight`方法添加一个是否有动画的参数`animated`，并更新`changeFlight`方法:

```swift
func changeFlight(to data: FlightData, animated: Bool = false) {
    summary.text = data.summary
    flightNR.text = data.flightNr
    gateNr.text = data.gateNr
    departingFrom.text = data.departingFrom
    arrivingTo.text = data.arrivingTo
    flightStatus.text = data.flightStatus

    if animated {
        fade(imageView: bgImageView,
             toImage: UIImage(named: data.weatherImageName)!,
             showEffects: data.showWeatherEffects)
    } else {
        bgImageView.image = UIImage(named: data.weatherImageName)
        snowView.isHidden = !data.showWeatherEffects
    }
}
```

继续在`changeFlight`加一段让背景图不停循环变换的代码：

```swift
delay(seconds: 3.0) {
    self.changeFlight(to: data.isTakingOff ? parisToRome : londonToParis, animated: true)
}
```

现在的效果是：

![](https://ws3.sinaimg.cn/large/006tNbRwgy1fxb4ib3jfhg308s0fp7ix.gif)

对比开始时的效果，现在图像之间过渡非常流畅，因为在背景图淡入淡出的同时也对雪景效果进行了淡入淡出，动画看起来很无缝。 你甚至可以在罗马看到它一瞬间下雪！😝😝

不知不觉掌握了一种重要的技术：**过渡动画可用于视图的不可动画属性。**（[1-视图动画入门](#可动画属性)中的可用于动画的属性中没有`image`）

动画选项`.transitionCrossDissolve`很适合当前项目的效果，其它如`.transitionFlipFromLeft`转换就不大适合，可以试试看。



### 立体过渡(Cube transitions)

假装3d转换时文字背景颜色

![](https://ws2.sinaimg.cn/large/006tNbRwgy1fw6g60qxyuj30oe06mgmf.jpg)

这不是一个真正的3D效果，但它看起来非常接近。可以通过辅助视图来实现立体过渡动画。
具体的方法是添加一个临时Label，同时对这个两个标签的高度进行动画，最后再删除。

在`ViewController`中添加一个枚举：

```swift
enum AnimationDirection: Int {
    case positive = 1
    case negative = -1
}
```

  这个枚举的1和-1在之后表示在y轴变换时是向下还是向上。



添加一个`cubeTransition`方法：

```swift
func cubeTransition(label: UILabel, text: String, direction: AnimationDirection) {
    let auxLabel = UILabel(frame: label.frame)
    auxLabel.text = text
    auxLabel.font = label.font
    auxLabel.textAlignment = label.textAlignment
    auxLabel.textColor = label.textColor
    auxLabel.backgroundColor = label.backgroundColor
}
```

  这是在构造一个临时辅助的Label，把原来Label属性复制给它，除了`text`使用新的值。



在Y轴方向变换辅助Label，向`cubeTransition`方法中添加：

```swift
let auxLabelOffset = CGFloat(direction.rawValue) * label.frame.size.height/2.0
auxLabel.transform = CGAffineTransform(translationX: 0.0, y: auxLabelOffset).scaledBy(x: 1.0, y: 0.1)
label.superview?.addSubview(auxLabel)
```


 当单独在Y轴缩放文本时，看起来就像一个竖着的平面被渐渐被推到，从而形成了**假远景效果**（faux-perspective effect）：

![](https://ws1.sinaimg.cn/large/006tNbRwgy1fw6jejb346j30ew04wmx3.jpg)

动画代码，继续在`cubeTransition`方法中添加：

```swift
UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
    auxLabel.transform = .identity
    // 原本的Label在Y轴上向反方向转换
    label.transform = CGAffineTransform(translationX: 0.0, y: -auxLabelOffset).scaledBy(x: 1.0, y: 0.1)
},completion: { _ in
    // 把辅助Label的文本赋值给原来的Label，然后删除辅助Label
    label.text = auxLabel.text
    label.transform = .identity

    auxLabel.removeFromSuperview()
})
```



最后要在`changeFlight`方法中添加这个假的3D转动效果动画：

```swift
if animated {
    fade(imageView: bgImageView,
         toImage: UIImage(named: data.weatherImageName)!,
         showEffects: data.showWeatherEffects)

    let direction: AnimationDirection = data.isTakingOff ?
    .positive : .negative
    cubeTransition(label: flightNr, text: data.flightNr, direction: direction)
    cubeTransition(label: gateNr, text: data.gateNr, direction: direction)
} else {
    // 不需要动画
    bgImageView.image = UIImage(named: data.weatherImageName)
    snowView.isHidden = !data.showWeatherEffects

    flightNr.text = data.flightNr
    gateNr.text = data.gateNr

    departingFrom.text = data.departingFrom
    arrivingTo.text = data.arrivingTo

    flightStatus.text = data.flightStatus
}
```



最终，航班号和入口号的Label转换效果（我故意加长了动画`duration`，方便观看）：

![](https://ws1.sinaimg.cn/large/006tNbRwgy1fxyhhins84g308j03z0wl.gif)





### 淡入淡出和反弹的过渡

为启程地和目的地Label添加**淡入淡出和反弹的过渡**(Fade and bounce transitions)动画。

先添加方法`moveLabel`，和上面的类似，创建一个辅助Label，并把原Label的一些属性复制给它。

```swift
func moveLabel(label: UILabel, text: String, offset: CGPoint) {
    let auxLabel = UILabel(frame: label.frame)
    auxLabel.text = text
    auxLabel.font = label.font
    auxLabel.textAlignment = label.textAlignment
    auxLabel.textColor = label.textColor
    auxLabel.backgroundColor = .clear

    auxLabel.transform = CGAffineTransform(translationX: offset.x, y: offset.y)
    auxLabel.alpha = 0
    view.addSubview(auxLabel)
}
```



为原Label添加偏移转换和透明度渐渐降低动画，在`moveLabel`方法里添加：

```swift
UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
    label.transform = CGAffineTransform(translationX: offset.x, y: offset.y)
    label.alpha = 0.0
}, completion: nil)
```



为辅助Label添加动画，并在动画结束后删除，在`moveLabel`方法里添加：

```swift
UIView.animate(withDuration: 0.25, delay: 0.1, options: .curveEaseIn, animations: {
    auxLabel.transform = .identity
    auxLabel.alpha = 1.0
}, completion: { _ in
    auxLabel.removeFromSuperview()
    label.text = text
    label.alpha = 1.0
    label.transform = .identity
})
```



最后还是在`changeFlight`方法的`if animated {`中添加：

```swift
// 启程地和目的地Label动画
let offsetDeparting = CGPoint(x: CGFloat(direction.rawValue * 80), y: 0.0)
moveLabel(label: departingFrom, text: data.departingFrom, offset: offsetDeparting)
let offsetArriving = CGPoint(x: 0.0, y: CGFloat(direction.rawValue * 50))
moveLabel(label: arrivingTo, text: data.arrivingTo, offset: offsetArriving)
```

启程地和目的地Label动画的方向可以修改。

效果图：

![](https://ws3.sinaimg.cn/large/006tNbRwgy1fxc3lp861sg308e060tfd.gif)





### 航班状态条的动画

可以使用前面的假的3D转动效果动画，`changeFlight`的`if animated {`中添加：

```swift
cubeTransition(label: flightStatus, text: data.flightStatus, direction: direction)

```

![](https://ws1.sinaimg.cn/large/006tNbRwgy1fxyhrbg9xzg308g04i76e.gif)



本章节最终的效果：

![](https://ws3.sinaimg.cn/large/006tNbRwgy1fxc3uwcwnig308m0foap6.gif)





## 5-关键帧动画



很多时候，需要多个连续的动画。 前面的章节，已经使用动画闭包和completion闭包包含两个动画效果。
这种方法适用于链接两个简单的动画，但是当你想要将三个，四个或更多动画组合在一起时，就会导致一些令人难以置信的混乱和复杂的代码。
让我们看看如果想将多个动画链接在一起并以矩形模式移动视图，它会是什么样子：

假设实现如下效果：
![](https://ws2.sinaimg.cn/large/006tNbRwgy1fw6pom0519j30ai05kgll.jpg)

为了达到这个目的，可以将几个动画和完成闭包链接起来：

~~~swift
UIView.animate(withDuration: 0.5, 
  animations: {
    view.center.x += 200.0
  }, 
  completion: { _ in
    UIView.animate(withDuration: 0.5, 
      animations: {
        view.center.y += 100.0
      }, 
      completion: { _ in
        UIView.animate(withDuration: 0.5, 
          animations: {
            view.center.x -= 200.0
          }, 
          completion: { _ in
            UIView.animate(withDuration: 0.5, 
              animations: {
                view.center.y -= 100.0
              }
            )
          }
        )
      }
    )
  }
)
```
~~~



看上去复杂繁琐，这个时候就需要，使用本章节将要学习的**关键帧动画(Keyframe Animations)**，它可以代替上面繁琐的嵌套。

[开始项目](READM.md#关于代码)使用上一章节的完成项目**Flight Info**，通过用让✈️“飞机来”，学习关键帧动画。



![image-20181013172100870](https://ws2.sinaimg.cn/large/006tNbRwgy1fxc49qm354j30dm05eaa8.jpg)

让飞机✈️起飞可以分成四个不同阶段的动画(当然具体怎么分可以视情况而定)：

1. 在跑道上移动

2. 给✈️一点高度，向上倾斜飞行

3. 给飞机更大的倾斜和更快的速度，向上倾斜加速飞行

4. 最后10%时飞机渐渐淡出视图


完整的动画可能会让人难以置信，但将动画分解为各个阶段会使其更易于管理。 一旦为每个阶段定义了关键帧，就会容易解决问题。

### 设置关键帧动画

将让飞机从起始位置起飞，绕圈，然后降落并滑行回到起点。 每次屏幕在航班背景之间切换时，都会运行此动画。完整的动画将看起来像这样：

![](https://ws2.sinaimg.cn/large/006tNbRwgy1fw6q1i7cigj30ef04jweh.jpg)



在`ViewController`中添加`planeDepart()`方法:

```swift
func planeDepart() {
  let originalCenter = planeImage.center

  UIView.animateKeyframes(withDuration: 1.5, delay: 0.0,
    animations: {
      //add keyframes
    }, 
    completion: nil
  )
} 
```

并在`changeFlight`的 `if animated {}`调用`planeDepart()`：

```swift
if animated {
    planeDepart()

    ...
```

添加第一个keyframe，在上面`//add keyframes`添加：

```swift
UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.25, animations: {
    self.planeImage.center.x += 80.0
    self.planeImage.center.y -= 10.0
})
```

`addKeyframe（withRelativeStartTime:relativeDuration:animations:)` 与之前动画参数设置不同。`withRelativeStartTime`和`relativeDuration`都是相对时间百分比，相对于`withDuration`。

使用相对值可以指定`keyframe`应该持续总时间的一小部分; UIKit获取每个`keyframe`的相对持续时间，并自动计算每个`keyframe`的确切持续时间，为我们节省了大量工作。
上面的代码的意思就是从`1.5*0.0`开始，持续时间`1.5*0.25`，✈️向右移动80.0，向上移动10.0。



接着上面，添加第二个keyframe：

```swift
UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.4, animations: {
    self.planeImage.transform = CGAffineTransform(rotationAngle: -.pi/8)
})
```

这一步是让✈️有个向上倾斜的角度。



接着，添加第三个keyframe：

```swift
UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.25, animations: {
    self.planeImage.center.x += 100.0
    self.planeImage.center.y -= 50.0
    self.planeImage.alpha = 0.0
})
```

这一步在移动同时逐渐消失。



添加第四个keyframe：

```swift
UIView.addKeyframe(withRelativeStartTime: 0.51, relativeDuration: 0.01, animations: {
    self.planeImage.transform = .identity
    self.planeImage.center = CGPoint(x: 0.0, y: originalCenter.y)
})
```

 这一步让✈️回到与原来高度相同的屏幕左边缘，不过现在换处于透明度为0状态。



添加第五个keyframe：

```swift
UIView.addKeyframe(withRelativeStartTime: 0.55, relativeDuration: 0.45, animations: {
    self.planeImage.alpha = 1.0
    self.planeImage.center = originalCenter
})
```

让飞机回到原来位置。



现在来看这个五个keyframe的开始时间，它们不是一个接着一个的，而是有交集的，这是因为分步动画本身就有交叉，✈️在跑道上移动过程中也会有向上移动，机头也会渐渐向上倾斜，我把每一步的开始和持续时间列出来，得到这个时间可能需要之前不停调节，看什么时间分隔比较流畅🙂，下面是比较流畅的时间分隔方式。

```
(0.0, 0.25)
(0.1, 0.4)
(0.25, 0.25)
(0.51, 0.01)
(0.55, 0.45)
```

效果为：

![](https://ws4.sinaimg.cn/large/006tNbRwgy1fxca0wyg3sg308m0607ce.gif)





### 关键帧动画中的计算模式



关键帧动画不支持标准视图动画中可用的内置[缓动曲线](#缓动动画(Animation easing))。 这是设计好的; 关键帧应该在特定时间开始和结束并相互流动。

如果上面动画的每个阶段都有一个缓动曲线，那么飞机就会抖动，而不是从一个动画平稳地移动到下一个动画。 

上面没有提到[`animateKeyframes(withDuration:delay:options:animations:completion:)`](https://developer.apple.com/documentation/uikit/uiview/1622552-animatekeyframes)方法，这方法有一个`options`参数（`UIViewKeyframeAnimationOptions`），可以提供几种计算模式的选择，每种模式提供了一种不同的方法来计算动画的中间帧以及不同的优化器，以实现帧之前的转化， 有关更多详细信息，可查看文档[`UIViewKeyframeAnimationOptions`](https://developer.apple.com/documentation/uikit/uiviewkeyframeanimationoptions?language=objc)。





### 航班出发时间动画

由于航班出发时间在屏幕顶部，变化时可以简单先向上移动到屏幕外，然后变化后再向下移动到屏幕内。

```swift
func summarySwitch(to summaryText: String) {
    UIView.animateKeyframes(withDuration: 1.0, delay: 0.0, animations: {
        UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.45, animations: {
            self.summary.center.y -= 100.0
        })
        UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.45, animations: {
            self.summary.center.y += 100.0
        })
    }, completion: nil)

    delay(seconds: 0.5) {
        self.summary.text = summaryText
    }
}
```

同样在`changeFlight`的 `if animated {}`中调用`summarySwitch()`。



本章最后效果：

![](https://ws1.sinaimg.cn/large/006tNbRwgy1fxcajmwugeg308m0fndxy.gif)



