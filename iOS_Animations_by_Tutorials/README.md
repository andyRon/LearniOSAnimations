系统学习iOS动画之零：说明和目录
---------

动画制作很有趣，可以为用户界面注入活力。 如果使用得当，动画可以向用户传达信息，并将用户注意力吸引到界面的重要部分。

之前也做过一些iOS动画，但一直没有系统学习过，这次我用[RW网站](https://www.raywenderlich.com)的书 [《iOS Animations by Tutorials》](https://store.raywenderlich.com/products/ios-animations-by-tutorials) 来系统地学习iOS动画。这本书的内容和项目不复杂但很全，基本上iOS动画的各个方面都介绍了。

 [《iOS Animations by Tutorials》](https://store.raywenderlich.com/products/ios-animations-by-tutorials) 全书分为7个部分，27小章节，内容非常丰富，我对应7个部分分别总结为7篇文章，有几篇文章可能比较长，特别是动图比较多，用手机看的小伙伴请慎重，对自己温柔一点🥴。

开发环境：**Xcode 10.1, Swift 4.2, macOS Mojave 10.14.1**



## 目录

目录可以很好看清整体脉络，每一篇文章的开始我也列出了小章节的题目，这样可以系统的学习iOS动画，那边有问题也好及时发先并对应到系统点上。要不可能越学越乱，这方面我自己深有体会的😕🤔。

[系统学习iOS动画之一：视图动画](Section_I.md)
[系统学习iOS动画之二：自动布局动画](Section_II.md)
[系统学习iOS动画之三：图层动画](Section_III.md)
[系统学习iOS动画之四：视图控制器的转场动画](Section_IV.md)
[系统学习iOS动画之五：使用UIViewPropertyAnimator](Section_V.md)
[系统学习iOS动画之六：3D动画](Section_VI.md)
[系统学习iOS动画之七：其它类型的动画](Section_VII.md)





## 关于代码

我完成每一章节代码放在GitHub上 [andyRon/LearniOSAnimations](https://github.com/andyRon/LearniOSAnimations)，代码中加一些中文注释便于理解。



原书提供的代码，每章都会有**开始项目**和**最终完成项目**代码（这应该是RW网站的惯例了😀），有的章节还有有**挑战项目**。建议按顺序阅读，因为前后章节知识点有一定关联。

**开始项目**都是相对简单项目或者是前一个章节的项目，可以直接使用原书提供的，也可以自己从头创建一下（我自己就是这么干的🤓🤓）。

> 悄悄地说，如果小伙伴暂时手头没有多余💰购买正版，可以私信我获取电子书+代码。





## 项目预览和对应章节




- **BahamaAirLoginScreen**  1 2 3    8 9 10 11 12 

![](https://ws1.sinaimg.cn/large/006tNbRwgy1fx69ltw09dg308s0avwtn.gif)

- **Flight Info**           4 5

![](https://ws1.sinaimg.cn/large/006tNbRwgy1fxcajmwugeg308m0fndxy.gif)

- **Packing List**          6 7

![](https://ws1.sinaimg.cn/large/006tNbRwgy1fw8qbtmmeag308s0fnafk.gif)

- **MultiplayerSearch**   13

![](https://ws2.sinaimg.cn/large/006tNbRwgy1fxmnjaf154g308m0fn1gb.gif)

- **SlideToReveal**       14

![](https://ws2.sinaimg.cn/large/006tNbRwgy1fy6f1w4io8g308o0fpjw8.gif)

- **PullToRefresh**       15

![](https://ws4.sinaimg.cn/large/006tNbRwgy1fx7j42np9ig308q08r0w0.gif)

- **Lris**                16



![](https://ws4.sinaimg.cn/large/006tNbRwgy1fy7mgff62bg308o0811bi.gif)

- **BeginnerCook**        17

![](https://ws3.sinaimg.cn/large/006tNbRwgy1fxtgx7q5s5g308s0fqqv5.gif)

- **LogoReveal**          18 19

![](https://ws1.sinaimg.cn/large/006tNbRwgy1fy9krwbad6g308q0fogzr.gif)

- **LockSearch** 		20 21 22 23 



- **OfficeBuddy** 	24

![](https://ws3.sinaimg.cn/large/006tNbRwgy1fxvpgah492g306y067799.gif)

- **ImageGallery** 	25

![](https://ws3.sinaimg.cn/large/006tNbRwgy1fxvr9roxswg308q0fo7wh.gif)

- **Snow Scene**26

![](https://ws4.sinaimg.cn/large/006tNbRwgy1fxvzhofmleg30ku112b2a.gif)

- **SouthPoleFun**  	27

![](https://ws2.sinaimg.cn/large/006tNbRwgy1fxw1bdetvhg30fm08sn0q.gif)








## 关于英文

有的英文不怎么好翻译，为了不让我的翻译产生歧义，我尽量在使用专业词汇时，也把英文给出。

英语水平有限，勉强能看懂和理解书籍，但有的部分翻译成中文，就有点尴尬了，所以遇到一些不好翻译的词时，我就把英文原文也列出来。

另外加一个学到英语词汇😊
wrangle  	争吵，口角
thrill		(使)兴奋
convey	  表达，运输
subtle
elaborate
stiff
mimic
keen
acceleration
deceleration
oscillation
snappy



## 动画相关的类总结

UIKit

​	.animate(withDuration:delay:usingSpringWithDamping:initialSpringVelocity:options:animations:completion:)

​	.transition(...)

​	

QuartzCore

CAAnimation

​	CAPropertyAnimation

​	CABasicAnimation 

​		CASpringAnimation 	

​	CAKeyframeAnimation

​	CATransition

​	CAAnimationGroup



CATransform3D

CGAffineTransform

CATransform3DRotate

CALayer  CAEmitterLayer















