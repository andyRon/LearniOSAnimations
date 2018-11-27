## [iOS Animations by Tutorials](https://store.raywenderlich.com/products/ios-animations-by-tutorials)

系统的学习iOS动画是很有必要的。RW网站的书 [iOS Animations by Tutorials](https://store.raywenderlich.com/products/ios-animations-by-tutorials) 非常全面介绍了iOS动画。《iOS Core Animation: Advanced Techniques》是iOS动画高级技巧。

系统学习iOS动画

## 介绍

动画制作很有趣，它们可以为用户界面注入活力，最重要的是，它们使您的界面变得愉悦。 当你打开菜单或向右滑动时，谁不喜欢有一点视觉刺激的应用程序？

如果使用得当，动画可以向用户传达信息，并将注意力吸引到界面的重要部分。

Xcode 10.1，Swift 4.2

本书的每一章都包含一个入门项目，并详细介绍了少量动画技术; 这使您可以按任何顺序完成本书中的章节。
但是，对于初学者，我们建议您按顺序完成各章，因为这些概念是相互依赖的。 另外，如果您按照教程并执行动手操作，请记住，您将充分利用本书。
对于高级开发人员，由于您可能还不熟悉这些熟悉的动画API的Swift语法，因此在前面的章节中仍然有价值，因为它涵盖了基础知识。 但是，如果您对此感到满意，请随时跳到您最感兴趣的主题。

### 笔记目录

## 关于代码

原书提供的代码，每章都会有*开始项目*和*最终完成项目*代码（这应该是RW网站的惯例了😀），有的章节还有有*挑战项目*。建议按顺序阅读，因为前后章节知识点有一定关联。

*开始项目*都是相对简单项目或者是前一个章节的项目，可以直接使用原书提供的，也可以自己从头创建一下（我自己就是这么干的🤓）。
我提供自己每一章节的完成项目[Github]()，代码中加了一些注释便于理解。

## 书结构

全书分为7个部分，27小章节。之所以把目录结构列出了，是我认为系统的学习很重要，每个知识点对应在系统点上，这样那边出问题也好及时发现，要不可能越学越乱，这方面我自己深有体会的😕🤔。

第一部分: View Animations
第二部分: Auto Layout
第三部分: Layer Animations
第四部分: View Controller Transitions(视图控制器转场)
第五部分: 3D Animations
第六部分: Animations with UIViewPropertyAnimator
第七部分: Further types of animations

## 书中项目对应章节

**BahamaAirLoginScreen**  1 2 3    8 9 10 11 12 

**Flight Info**           4 5

**Packing List**          6 7

**MultiplayerSearch**   13

**SlideToReveal**       14

**PullToRefresh**       15

**Lris**                16

**BeginnerCook**        17

**LogoReveal**          18 19

**LockSearch** 		20 21 22 23 

**OfficeBuddy** 	24

**ImageGallery** 	25

**SouthPoleFun**  	27

## 项目预览



## 关于英文

有的英文不怎么好翻译，为了不让我的翻译产生歧义，我尽量在使用专业词汇时，也把英文给出。

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



GIF很多都使用**Slow Animations(+T)**，所以看上去比较慢。





继续使用上一章完成的项目或使用原书对应章节的**开始项目**





## 动画类的结构



CAAnimation

​	CAPropertyAnimation

​	CABasicAnimation 

​		CASpringAnimation 	

​	CAKeyframeAnimation

​	CATransition

​	CAAnimationGroup

问题

----------

fillMode属性允许您在序列的开头和结尾控制动画的行为。
常量`kCAFillModeRemoved`是fillMode的默认值。 这将在定义的beginTime处启动动画 - 如果尚未设置beginTime，则立即启动动画 - 并在动画完成时删除动画期间所做的更改：

这是您在本章中使用的方法。 除了kCAFillModeRemoved之外，您还可以在动画中使用其他三个选项：

`kCAFillModeBackwards`
无论动画的实际开始时间如何，kCAFillModeBackwards都会立即在屏幕上显示动画的第一帧，并在以后启动动画：

`kCAFillModeForwards` 
kCAFillModeForwards像往常一样播放动画，但在屏幕上保留动画的最后一帧，直到您删除动画：

除了设置kCAFillModeForwards之外，你还需要对图层进行一些其他更改，以使最后一帧”坚持“。 您将在本章后面稍后了解这一点。


`kCAFillModeBoth`是kCAFillModeForwards和kCAFillModeBackwards的组合; 正如您所期望的那样，这会使动画的第一帧立即出现在屏幕上，并在动画结束时在屏幕上保留最终帧：

要解决之前发现的问题，你将使用kCAFillModeBoth。“



`CAMediaTimingFillMode.both`  与`kCAFillModeBoth`的区别

`kCAFillModeRemoved`  

`kCAFillModeBackwards`  

`kCAFillModeForwards`  

`kCAFillModeBoth`  



beginTime大于零的动画可以处于附加到图层但尚未开始动画的状态。同样，removeOnCompletion属性设置为NO的动画将在完成后保持附加到图层。这就提出了一个问题，即在动画开始之前和结束之后动画属性的价值是什么。
  www.it-ebooks.info
一种可能性是属性值可能与动画根本没有附加的相同，也就是说，值将是模型层中定义的值。 （有关图层模型与演示文稿的解释，请参阅第7章“隐式动画”。）
另一种选择是属性可以在开始之前采用动画的第一帧的值，并在结束之后保留最后一帧。这称为填充，因为动画的开始和结束值用于填充动画持续时间之前和之后的时间。
这种行为由开发人员决定;它可以使用CAMediaTiming的fillMode属性进行控制。 fillMode是一个NSString并接受以下常量值之一：
kCAFillModeForwards kCAFillModeBackwards kCAFillModeBoth kCAFillModeRemoved
默认值为kCAFillModeRemoved，它将属性值设置为图层模型在当前未播放动画时指定的任何值。其他三种模式向前，向后或两者填充动画，以便动画属性采用动画开始前指定的起始值和/或结束后的结束值。
这为必须手动更新图层属性以匹配动画结束值的问题提供了另一种解决方案，以避免动画结束时的快照（在第8章中提到）。但请记住，如果您打算将其用于此目的，则需要为动画将removeOnCompletion设置为NO。添加动画时，您还需要使用非零键，以便在不再需要时可以手动将其从图层中删除。



