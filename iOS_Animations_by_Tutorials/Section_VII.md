# 系统学习iOS动画之七：其它类型的动画



前面学习很多动画方面的知识，但有两个更专业的主题不适合前面的任何部分。



[26-粒子发射器](#26-粒子发射器) —— 将向您展示如何创建粒子发射器并创建以下降雪效果：



核心动画包括一个粒子，你将用它来产生一个充满独特雪花的虚拟暴风雪，它们拥有自己的生命周期，颜色色调和方向。



[27-使用UIImageView构建框架动画]() —— 将引导您将多个图像一起排序成一个翻书式动画，如下所示：



通过将帧动画与传统视图动画相结合，您可以使用良好的旧UIImageView创建类似卡通的效果，并在UIKit中创建游戏的第一步。




## 26-粒子发射器



瀑布，火，烟和雨的影响都涉及大量的视觉项目 —— 粒子 —— 它们具有共同的物理特征，但仍然可能有自己独特的大小，方向，旋转和轨迹。

粒子可以很好地创建逼真的效果，因为每个粒子都可以是随机的和不可预测的，就像物体在自然界中一样。例如，雷暴中的每个雨滴可能具有独特的大小，形状和速度。



以下是**粒子发射器(Particle Emitters)**可以实现的视觉效果的几个示例：

![image-20181205153401675](https://ws2.sinaimg.cn/large/006tNbRwgy1fxvwnp7bozj30bh05zq48.jpg)

在[系统学习iOS动画之一：视图动画](Section_I.md#4-练习视图动画)的第4、5章节的**Flight Info**项目中使用过雪花❄️的效果，但没有说明怎么使用，本章将单独学习雪花❄️效果的制作。



### 创建发射器层

本章节将使用`CALayer`的子类`CAEmitterLayer`来创建粒子效果。

> 注意：有许多用于创建粒子效果的第三方类，但它们通常的目标是与游戏框架集成。 对于UIKit应用程序中的粒子动画，`CAEmitterLayer`是一个很好的选择，因为它内置并且易于使用。

本章节的[开始项目](README.md#关于代码) **Snow Scene**。

打开`ViewController.swift`并将以下代码添加到`viewDidLoad()`的底部：

```swift
let rect = CGRect(x: 0.0, y: 100.0, width: view.bounds.width, height: 50.0)
let emitter = CAEmitterLayer()
emitter.frame = rect
view.layer.addSublayer(emitter)
```

此代码创建一个新的`CAEmitterLayer`，将图层的框架设置为占据屏幕的整个宽度，并将图层定位在屏幕顶部附近。
接下来，需要设置要与粒子效果一起使用的发射器类型。
将以下代码添加到`viewDidLoad()`：

```swift
emitter.emitterShape = kCAEmitterLayerRectangle
```

发射器的形状通常会影响创建新粒子的区域，但在您创建类似3D的粒子系统的情况下，它也会影响它们的z位置。
以下是三种最简单的发射器形状：

#### 1.点形状

`kCAEmitterLayerPoint`的发射器形状会导致所有粒子在同一点创建：发射器的位置。对于涉及火花或烟花的效果，这是一个不错的选择。

![image-20181205154724044](https://ws3.sinaimg.cn/large/006tNbRwgy1fxvx1m54wlj308903rq36.jpg)

例如，可以通过在同一点创建所有粒子，并使它们在消失前沿不同方向飞行来创建火花效果。

#### 2.线条形状

`kCAEmitterLayerLine`发射器形状，是沿发射器框架顶部线创建所有粒子。

这是一种可用于瀑布效果的发射器形状，水粒子出现在瀑布的顶部并向下移动：

![image-20181205154827937](https://ws3.sinaimg.cn/large/006tNbRwgy1fxvx2qka0oj308l02n74b.jpg)



#### 3.矩形形状
最后，`kCAEmitterLayerRectangle`，通过在给定的矩形区域随机创建粒子：

![image-20181205155005520](https://ws2.sinaimg.cn/large/006tNbRwgy1fxvx4fb1joj308w02odfv.jpg)

这种发射器形状非常适合许多不同的效果，包括碳酸饮料和爆米花中的气泡。

由于积雪从整个天空随机出现，矩形发射器形状是本章项目的不错选择。



> 注意：还有一些发射器形状 - 长方体，圆形和球形 - 但这些超出了本章的范围。 有关详细信息，请查看Apple文档中的CAEmitterLayer类的官方文档[**Emitter Shape**](https://developer.apple.com/documentation/quartzcore/caemitterlayer/emitter_shape)参考。

### 添加发射器帧

将以下代码添加到`viewDidLoad()`的末尾：

```swift
emitter.emitterPosition = CGPoint(x: rect.width/2, y: rect.height/2)
emitter.emitterSize = rect.siz
```

组合形状，位置和尺寸属性定义了发射器框架。 在这里，可以将发射器的位置设置为图层的中心，并将发射器大小设置为等于图层的大小。
这意味着发射器占用整个层帧，如下所示：

![image-20181205155701616](https://ws4.sinaimg.cn/large/006tNbRwgy1fxvxbn54o8j30d302oaab.jpg)

### 创建发射器单元

现在已配置了发射器的位置和大小，可以继续添加**发射器单元**。

发射器单元是表示一个粒子源的数据模型。 它与`CAEmitterLayer`是一个单独的类，因为单个发射器层可以包含一个或多个单元。

例如，在爆米花动画中，你可以有三个不同的单元来表示爆米花的不同状态：完全炸开，半炸开和那些顽固的未炸开：

![image-20181212211917849](https://ws2.sinaimg.cn/large/006tNbRwgy1fy49z422r4j309f04pq3o.jpg)

之后将使用不同的形状的❄️图片代表不同的发射器单元

将以下代码添加到`viewDidLoad()`的底部：

```swift
let emitterCell = CAEmitterCell()
emitterCell.contents = UIImage(named: "flake.png")?.cgImage
```

在上面的代码中，您创建一个新单元格并将*flake.png*设置为其内容。 `contents`属性包含将从中创建新粒子的模板。
下面是深色背景上的放大的*flake.png*屏幕截图：

![image-20181212212218466](https://ws4.sinaimg.cn/large/006tNbRwgy1fy4a29a3aij304l04lwee.jpg)

发射器将创建此图像的多个不同副本以模仿真实的雪花。

将以下代码添加到`viewDidLoad()`的底部：

```swift
emitterCell.birthRate = 20
emitterCell.lifetime = 3.5
emitter.emitterCells = [emitterCell]
```

上面的代码表示每秒创建20个雪花，并将它们保持在屏幕上3.5秒。 这意味着在任何给定时间屏幕上将有70个雪花，除了动画的最初几秒之前，最旧的粒子开始消失。

最后，使用所有发射器单元的数组设置`emitterCells`属性。 请记住，可以拥有多个发射器单元，目前只有一个。 一旦设置了发射器单元列表，发射器就会开始创建粒子。

运行，看到效果：

![](https://ws1.sinaimg.cn/large/006tNbRwgy1fxvxk5ojdzg308q03emxo.gif)

**flake.png**的多个副本在3.5秒后显示并消失。 然而，雪是奇怪的静态 —— ❄️没有移动。

### 控制粒子

目前，雪粒出现，在空中漂浮几秒钟，然后消失。 那令人难以置信的无聊 ！ 下一个任务是让这些漫无目的的粒子移动起来。

#### 改变粒子方向

将以下代码添加到`viewDidLoad()`的底部：

```swift
emitterCell.yAcceleration = 70.0
```

这将在y方向上增加一点加速度，因此粒子会像真雪一样向下漂移。

运行效果：

![](https://ws2.sinaimg.cn/large/006tNbRwgy1fxvxo702ikg308q0ck0w0.gif)

这看起来有点像雪 —— 但雪很少直线下降。

要解决此问题，就要向粒子添加以下水平加速度：

```swift
emitterCell.xAcceleration = 10.0
```

运行， 雪花朝向对角线方向移动：

![](https://ws3.sinaimg.cn/large/006tNbRwgy1fxvxqdqe1xg308q0ckte2.gif)

为了产生温和的坠落效果，添加以下代码：

```swift
emitterCell.velocity = 20.0
emitterCell.emissionLongitude = .pi * -0.5
```

`velocity`是初始速度。

发射经度（`emissionLongitude`）是粒子的初始角度，速度参数设置粒子的初始速度，如下所示：

![image-20181205161402211](https://ws4.sinaimg.cn/large/006tNbRwgy1fxvxtc4bsqj30a604nwep.jpg)

再次运行，效果：

![](https://ws1.sinaimg.cn/large/006tNbRwgy1fxvxvnv1stg308q0ckakz.gif)

每次更改时，动画看起来越来越好。 但是这些粒子看起来像雪花大小的杀戮机器人一致地移动。 这是因为每个粒子具有完全相同的初始角度，速度和加速度。 需要为粒子创建过程添加一些随机性。

#### 为粒子添加随机性

将以下代码添加到`viewDidLoad()`：

```swift
emitterCell.velocityRange = 200.0
```

这告诉发射器随机范围的值。 由于粒子动画的随机范围在本章中经常使用，因此值得花些时间来解释它们是如何工作的。
所有粒子的初始速度都是20; 添加速度范围为每个粒子分配随机速度，如下所示：

![image-20181205162140512](https://ws1.sinaimg.cn/large/006tNbRwgy1fxvy1a688lj30at04hq3l.jpg)

每个粒子的速度将是（20-200）= -180和（20 + 200）= 220之间的随机值。具有负初始速度的粒子根本不会飞起来; 一旦它们出现在屏幕上，它们就会开始飘落。 具有正速度的粒子将首先飞起，然后向下飘落。

运行，效果：

![](https://ws2.sinaimg.cn/large/006tNbRwgy1fxvxzeqoewg308q0aodjr.gif)

好吧，雪花是随机的：一些雪花跳到屏幕的顶部边缘，而其他雪花则出现，徘徊一会儿，然后向下飘落。



让初始粒子方向也随机化。将以下代码添加到`viewDidLoad()`：

```swift
emitterCell.emissionRange = .pi * 0.5
```


最初，所有粒子初始发射角度是-π/ 2。 上面的代码行表明发射器初始角度为（-π/ 2  - π/ 2）= 180度和（-π/ 2 +π/ 2）= 0度范围内的一个随机角度，如下图所示：

![image-20181205162200057](https://ws4.sinaimg.cn/large/006tNbRwgy1fxvy1mot9qj30b204tdg3.jpg)

运行，效果：

![](https://ws3.sinaimg.cn/large/006tNbRwgy1fxvy4c6vuwg308q0aogx7.gif)

现在这是随机的！ 虚拟暴风雪真的变得生动起来。

#### 改变粒子颜色

`CAEmitterLayer`的还有一个便利功能是能够为粒子设置颜色。 例如，可以将雪花淡蓝色而不是鲜明的白色，因为蓝色通常与雨，水，雪或冰有关。

将以下代码添加到`viewDidLoad()`的底部：

```swift
emitterCell.color = UIColor(red: 0.9, green: 1.0, blue: 1.0, alpha: 1.0).cgColor
```



这种变化看起来很有趣，但所有的雪花都是统一蓝色调。 如果可以随机化每个雪花的颜色，这不是很好吗？

需要做的就是为粒子颜色定义三个独立的范围：红色，绿色和蓝色各一个。
将以下代码添加到`viewDidLoad()`的末尾：

```swift
emitterCell.redRange = 0.3
emitterCell.greenRange = 0.3
emitterCell.blueRange = 0.3
```


上面的代码很好理解：绿色和蓝色是0.7到1.3之间的随机值，也就是0.7到1.0。 类似，红色介于0.6和1.0之间。

运行，看到五彩❄️：



![](https://ws2.sinaimg.cn/large/006tNbRwgy1fxvyaloz0eg308q0aon60.gif)

0.3的范围有点大了，这是为了展示效果，之后可以改为0.1。



#### 随机化粒子外观

即使在添加了所有自定义之后，雪花外观看起来是一样的，现实中不会是这样的。

下面将使每个粒子都成为一个美丽而独特的雪花。

让每个雪花大小是随机的，将以下代码添加到`viewDidLoad()`：

```swift
emitterCell.scale = 0.8
emitterCell.scaleRange = 0.8
```

将基本粒子大小设置为原始大小的80％，大小范围在 0.0 - 1.6之间。

不仅可以设置雪花的初始大小，还可以在雪花落下时修改雪花的大小。在接近地面时，❄️在温暖的雾气中会融化。

将以下行添加到`viewDidLoad()`：

```swift
emitterCell.scaleSpeed = -0.15
```

`scaleSpeed`属性表示，粒子按比例每秒缩小原始大小的15％。

大粒子在从视线中消失之前会大幅收缩，而小粒子会在它们结束前完全消失。不要心疼，这只是生活的雪花圈。

运行，效果，观察单个雪花大小的变化：

![](https://ws2.sinaimg.cn/large/006tNbRwgy1fxvykvnmcsg308q07cgp7.gif)




❄️看上去有点少，修改`birthRate`：

```swift
emitterCell.birthRate = 150
```


设置❄️的透明度，将以下内容添加到`viewDidLoad()`的底部：

```swift
emitterCell.alphaRange = 0.75
emitterCell.alphaSpeed = -0.15
```

设置了一个alpha范围，从0.25到1.0的上限值。 `alphaSpeed`与`scaleSpeed`非常相似，可以随时间更改粒子的alpha值。

运行，查看效果：

![](https://ws3.sinaimg.cn/large/006tNbRwgy1fxvyqdjsy0g308q07ctou.gif)



目前已经涵盖了`CAEmitterCell`提供的大部分内容，下面内容是关于❄️的一些细节。



### 雪花的细节
在`viewDidLoad()`中找到设置`emissionLongitude`并将其更改为以下内容的行：

```swift
emitterCell.emissionLongitude = -.pi
```

请记住，发射经度是粒子的起始角度。 这种变化会让雪花旋转一下，仿佛被风吹一下一样。
接下来，在找到声明`rect`的行并按如下方式修改它：

```swift
let rect = CGRect(x: 0.0, y: -70.0, width: view.bounds.width, height: 50.0)
```

这会将发射器移出屏幕，用户将无法看到粒子来自何处。之前让粒子发射在屏幕中，是为了展示说明。

最后，将以下位代码添加到`viewDidLoad()`以随机化雪花在屏幕上保留的时间长度：

```swift
emitterCell.lifetimeRange = 1.0
```

这会将每个雪花的生命周期设置为2.5到4.5秒之间的随机值。



虽然本章是一`CAEmitterLayer`为基础，说明了制作粒子效果的很多细节，但是每个概念都完全适用于其他粒子系统。无论是**SpriteKit**，**Unity**还是任何其他自定义粒子发射器，原理都基本上差不多。

本章目前效果：

![](https://ws3.sinaimg.cn/large/006tNbRwgy1fxvyxeh9d3g308q09ogyt.gif)





### 添加更多单元

这一部分只是为了学习更多粒子系统的知识，真实的雪景不是这样的，😏。



我又添加了三种不同❄️单元：

```swift
    //cell #2
    let cell2 = CAEmitterCell()
    cell2.contents = UIImage(named: "flake2.png")?.cgImage
    cell2.birthRate = 50
    cell2.lifetime = 2.5
    cell2.lifetimeRange = 1.0
    cell2.yAcceleration = 50
    cell2.xAcceleration = 50
    cell2.velocity = 80
    cell2.emissionLongitude = .pi
    cell2.velocityRange = 20
    cell2.emissionRange = .pi * 0.25
    cell2.scale = 0.8
    cell2.scaleRange = 0.2
    cell2.scaleSpeed = -0.1
    cell2.alphaRange = 0.35
    cell2.alphaSpeed = -0.15
    cell2.spin = .pi
    cell2.spinRange = .pi
    
    //cell #3
    let cell3 = CAEmitterCell()
    cell3.contents = UIImage(named: "flake3.png")?.cgImage
    cell3.birthRate = 20
    cell3.lifetime = 7.5
    cell3.lifetimeRange = 1.0
    cell3.yAcceleration = 20
    cell3.xAcceleration = 10
    cell3.velocity = 40
    cell3.emissionLongitude = .pi
    cell3.velocityRange = 50
    cell3.emissionRange = .pi * 0.25
    cell3.scale = 0.8
    cell3.scaleRange = 0.2
    cell3.scaleSpeed = -0.05
    cell3.alphaRange = 0.5
    cell3.alphaSpeed = -0.05
    
    //cell #4
    let cell4 = CAEmitterCell()
    cell4.contents = UIImage(named: "flake4.png")?.cgImage
    cell4.birthRate = 10
    cell4.lifetime = 5.5
    cell4.lifetimeRange = 1.0
    cell4.yAcceleration = 25
    cell4.xAcceleration = 30
    cell4.velocity = 20
    cell4.emissionLongitude = .pi
    cell4.velocityRange = 30
    cell4.emissionRange = .pi * 0.25
    cell4.scale = 0.8
    cell4.scaleRange = 0.2
    cell4.scaleSpeed = -0.05
    cell4.alphaRange = 0.5
    cell4.alphaSpeed = -0.05
    
    emitter.emitterCells = [emitterCell, cell2, cell3, cell4]
```



> 注：可能需要在真机才能看到流畅的效果

效果：

![](https://ws4.sinaimg.cn/large/006tNbRwgy1fxvzhofmleg30ku112b2a.gif)







## 27-使用UIImageView构建框架动画



现在是时候学习如何创建一种非常特殊的动画了。帧动画是你小时候喜欢的动画类型，今天可能仍然很喜欢;这就是迪斯尼的Duck Tales，Hanna-Barbera的Tom和Jerry以及Flintstones漫画的创作方式。

这也是您用来为游戏中的角色制作动画的动画。仅仅将静态游戏角色从一个位置转换为另一个位置是不够的。你需要移动角色的脚或旋转飞机的螺旋桨以给出逼真的运动感。

要创建角色移动的效果，可以将动画分解为帧，这些帧是表示动作阶段的静止图像。当您快速显示帧时，一个接一个地显示帧，看起来您的角色正在移动：

![image-20181205172245592](https://ws3.sinaimg.cn/large/006tNbRwgy1fxvzsuxv7yj30bt0370tb.jpg)

本章中的项目设置在南极，玩家可以控制企鹅企鹅。你将从一个静态的场景开始，通过这一章来让Pengui走路并在他的世界中滑行。



### 项目基础

打开本章的入门项目，然后选择Main.storyboard以查看最初的游戏场景：

企鹅和按钮都连接到ViewController.swift中的代码，但如果你点击它们，目前什么也没发生。打开ViewController.swift并查看代码的内容。
您将看到两个出口：一个用于企鹅图像视图（企鹅），另一个用于滑动按钮（slideButton）。您还有两个属性，walkFrames和slideFrames，它们分别包含步行和滑动动画的UIImage帧。
屏幕左侧的HUD按钮连接到actionLeft（_ :)和actionRight（_ :);你将为这两种方法添加一些动画代码，让企鹅走路。
屏幕右侧的HUD按钮连接到actionSlide（_ :)，您将在其中添加一些代码以使企鹅跳跃并在冰上滑动。

打开Images.xcassets并浏览帧图像以查看步行和滑动动画的各个帧，如下所示：





你需要走路才能跑步 - 在这个游戏中，你的企鹅需要走路才能滑行！你的第一个任务是当玩家点击HUD按钮时让企鹅走路。

### 设置帧动画

将以下代码添加到ViewController.swift中的loadWalkAnimation（）存根：

```swift
    penguin.animationImages = walkFrames
    penguin.animationDuration = animationDuration / 3
    penguin.animationRepeatCount = 3
```



此代码在UIImageView上设置了许多您可能以前从未见过的属性。以下是他们每个人依次做的事情：

animationImages：存储帧动画的所有帧图像。 walkFrames在代码中作为包含UIImage对象的数组在前面声明，所以在这里你只需要将它分配给penguin.animationImages来设置动画帧。

animationDuration：这告诉UIKit动画的一次迭代应该持续多长时间;因为您将重复动画三次（见下文），所以将其设置为总animationDuration长度的三分之一。

animationRepeatCount：它控制动画的重复次数;在这种情况下，动画将重复三次。



最后，您需要从视图控制器中的viewDidLoad（）调用loadWalkAnimation（），以便每当玩家点击左箭头按钮时图像视图就会准备就绪。
将以下代码添加到viewDidLoad（）的底部：

```swift
loadWalkAnimation()
```



建立并运行项目; 点击左箭头按钮将您的企鹅设置为动态：

哦 - 点击左箭头按钮时没有任何反应。 你做错了什么吗？ 没有; 您只为帧动画配置了图像视图，但您从未启动过动画。 如果不启动帧动画，图像视图将继续显示其图像属性的内容。
是时候让这只企鹅蹒跚了。
将以下代码添加到actionLeft（_ :)：

```swift

```

要跟踪企鹅面临的方式，你将分别在actionLeft（_ :)和actionRight（_ :)中将isLookingRight设置为false或true。
由于每次更改企鹅的方向时都需要更新企鹅的变换和按钮变换，因此需要向isLookingRight的didSet观察者添加一些代码。
在类定义顶部附近找到以下属性：



```swift
var isLookingRight: Bool = true {
    didSet {
        let xScale: CGFloat = isLookingRight ? 1 : -1
        penguin.transform = CGAffineTransform(scaleX: xScale, y: 1)
        slideButton.transform = penguin.transform
    }
}
```



此代码将企鹅和幻灯片按钮的x轴刻度设置为1或-1，具体取决于isLookingRight的值。 然后设置该变换将翻转视图，以便企鹅可以面向正确的方向：

![image-20181205174828259](https://ws2.sinaimg.cn/large/006tNbRwgy1fxw0jlkmdqj30bl04qaak.jpg)

现在你需要调用动画代码。 将以下内容添加到actionLeft（）的底部：

```swift
 penguin.startAnimating()
```

当您调用startAnimating（）时，图像视图会在您配置动画时播放动画：animationImages数组中的每个帧按顺序显示，总共超过1秒。
动画完成后，图像视图将再次显示其初始内容 - 图像属性。

建立并运行你的项目; 点击左箭头按钮，查看您的企鹅在行动：

![](https://ws2.sinaimg.cn/large/006tNbRwgy1fxw0ncwkelg30bq08r0th.gif)

你冷酷的朋友正在走路 - 但他无处可去！ 当步行动画播放时，您需要将企鹅移动到屏幕上。

### 翻译你的观点

将以下代码添加到actionLeft（_ :)：

```swift
UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseOut, animations: {
    self.penguin.center.x -= self.walkSize.width
}, completion: nil)
```



这是熟悉的代码，在本书的这一点上几乎无需解释; 您只需在屏幕上为视图设置动画即可。 您可以使用步行图像的宽度来确定企鹅在动画播放时间内移动的距离。

再次运行项目; 现在看起来怎么样？ 

![](https://ws4.sinaimg.cn/large/006tNbRwgy1fxw0r4e2uug30bq08r0tw.gif)



这还差不多！ 走向另一个方向的代码非常相似。
将以下代码添加到actionRight（_ :)：

```swift
isLookingRight = true
penguin.startAnimating()

UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseOut, animations: {
    self.penguin.center.x += self.walkSize.width
}, completion: nil)
```



它与以前的代码几乎相同：您可以更改角色方向，播放帧动画并将其移向屏幕的右边缘。

构建并运行您的项目并玩游戏。 你能想到角色可以执行的其他帧动画吗？

### 播放不同的帧动画

现在Pengui可以四处走动，是时候跳跃和滑行了。 您将在本节中面对一些新的帧动画问题，并学习如何以优雅的方式解决它们。

要使图像视图播放不同的帧动画，您需要更改animationImages属性的内容。方便的是，ViewController的slideFrames属性已经包含了滑动动画的图像。

将以下代码添加到loadSlideAnimation（）以加载新的帧序列：

```swift
    penguin.animationImages = slideFrames
    penguin.animationDuration = animationDuration
    penguin.animationRepeatCount = 1
```



在上面的代码中，将slideFrames数组指定给animationImages，然后将动画持续时间设置为预定义的1秒时间跨度。最后，将重复计数设置为1。
看起来您已经处理了上面所需的所有内容，因此您可以移动代码来加载和播放动画。
将以下代码添加到actionSlide（_ :)：

```swift
loadSlideAnimation()
penguin.startAnimating()
```




构建并运行您的项目;点击屏幕右侧的滑动按钮，你会看到Pengui跳到他的肚子上并反弹回他的脚。

嗯，这个动画中有一些奇怪的事情。随着动画的流逝，Pengui得到了真正的胖乎乎的;事实上，当他躺在地上时，他看起来完全是圆的！是什么赋予了？

好吧，首先检查最明显的事情：幻灯片图片是否正确？看看slide01和slide02，你会发现企鹅的形状和大小都是正确的。所以你的项目中的某些东西必须破坏Pengui的身材。无论是那个还是他最近都吃了太多的鱼。
滑动动画看起来很像，因为两个动画之间的帧图像不同：

![image-20181205180338215](https://ws3.sinaimg.cn/large/006tNbRwgy1fxw0ze1pouj308v047aap.jpg)

步行帧图像为108 x 96，而幻灯片图像为93 x 75.如果它们的大小相同，则每个图像中的空白空间最终会变大。想象一个具有五个，六个或更多帧动画的角色;你最终会得到巨大的图像尺寸，以适应所有可能的动画帧。

> 注意：此问题的一个简单解决方案是将图像视图的内容模式从其默认值“Aspect Fill”设置为“Center”或“Top Left”。但既然你是一个动画忍者，那么你将实现一个稍微不同且更灵活的解决方案。

在本章的这一部分中，您将手动调整图像视图的大小并重新定位，以创建漂亮流动的精美动画。



首先，您需要在播放任何动画之前设置所需的图像视图帧; 这可以确保框架在屏幕上可见时尺寸正确。
将以下代码添加到actionSlide（_ :)，就在您开始动画的位置之前：

```swift
penguin.frame = CGRect(x: penguin.frame.origin.x,
                       y: penguinY + (walkSize.height - slideSize.height),
                       width: slideSize.width,
                       height: slideSize.height)
```

此代码将企鹅图像视图向下移动一点以补偿幻灯片动画的较短帧，并调整图像视图的大小以匹配slideSize。
slideSize包含slide01.png的大小; viewDidLoad（）已包含获取图像的代码。

现在将以下代码添加到actionSlide（_ :)的底部：

```swift
UIView.animate(withDuration: animationDuration - 0.02, delay: 0.0, options: .curveEaseOut, animations: {
    self.penguin.center.x += self.isLookingRight ? self.slideSize.width : -self.slideSize.width
}, completion: { _ in

})
```



在上面的代码中，您将创建一个视图动画来移动企鹅图像视图并模拟跳转动作。 您还可以根据企鹅面对的方式添加或减去一个企鹅长度（这将是一个“penguimeter”？）。
你会注意到动画持续时间有一个很小的调整，你会缩短它。 你会在短时间内看到为什么这是必要的。
构建并运行您的项目; 你的动画在这一点上应该看起来很漂亮。

但可怜的Pengui被困在冰上; 进行幻灯片后，即使点击左右箭头按钮，所有动画也会成为幻灯片动画。
哎呀 - 你没有重置图像视图框并重新加载步行框架。 这很容易修复。
使用以下内容替换上面添加的代码段中的//动画是完整注释：

```swift
self.penguin.frame = CGRect(x: self.penguin.frame.origin.x,
                            y: self.penguinY,
                            width: self.walkSize.width,
                            height: self.walkSize.height)
self.loadWalkAnimation()
```



这会将图像视图帧重置为其初始大小，并加载步行帧序列。
从动画持续时间中减去的小时间间隔在这里发挥作用;没有它，框架动画和运动动画同时结束，这有时会导致企鹅在调整框架之前恢复站立的小故障。添加小偏移量可确保在上一个动画结束之前新帧已准备就绪。
最后一次构建并运行项目;你应该看到，一旦他完成滑动，Pengui现在会回到他的直立位置。

![](https://ws2.sinaimg.cn/large/006tNbRwgy1fxw1bdetvhg30fm08sn0q.gif)



### 从这往哪儿走

使用UIImageView的帧动画很简单，但它们是你已经令人印象深刻的动画技能的一个很好的补充。
您可能认为UIKit不适合游戏，但您会惊讶地发现情况并非如此！核心动画是一个比许多其他平台更强大的引擎，正如你在本书中看到的，它可以运行粒子，多个动画，淡入淡出等等。就好了:)

