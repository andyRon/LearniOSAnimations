# Section V: Animations with UIViewPropertyAnimator



`UIViewPropertyAnimator`是iOS10中引入的一个类，它可以帮助开发人员创建交互式，可中断的视图动画。
既然你在这本书中做到了这一点（巨大的恭喜），你已经知道如何利用**Core Animation**提供的大部分功能。由于UIKit中的所有API都包含了较低级别的功能，因此在查看UIViewPropertyAnimator时不会有太多惊喜。

但是，这个类确实使某些类型的视图动画更容易创建，因此绝对值得研究。

最值得注意的是，当您通过动画师运行动画时，您可以动态调整这些动画 - 您可以暂停，停止，反转和更改已经运行的动画的速度。

如上所述，你可以通过使用图层和视图动画的组合来完成上面提到的所有事情，但是`UIViewPropertyAnimator`可以在同一个类中方便地将许多API包装在一起，这样更容易使用。

此外，这个新类完全取代了`UIView.animate(withDuration...)`API集，也没有使用`CAAnimation`替换您创建的动画，因此您仍然需要经常将这些与`UIViewPropertyAnimator`动画结合使用。

在本书的这一部分中，您将开发一个具有大量不同视图动画的项目，您将使用`UIViewPropertyAnimator`实现这些动画。

第20章，UIViewPropertyAnimator入门 - 了解如何创建基本视图动画和关键帧动画。您将研究使用超出内置缓动曲线的自定义时序。

第21章，使用UIViewPropertyAnimator的中级动画 - 在本章中，您将学习如何使用具有自动布局的动画师。此外，您将学习如何反转动画或制作添加动画，以便在此过程中实现更平滑的变化。

第22章，使用UIViewPropertyAnimator进行交互式动画 - 了解如何根据用户的输入以交互方式驱动动画。为了获得额外的乐趣，您将了解基本和关键帧动画的交互性。

第23章，UIViewPropertyAnimator视图控制器转换 - 使用UIViewPropertyAnimator创建自定义视图控制器转换以驱动转换动画。您将创建静态和交互式过渡。

完成所有这些章节后，您肯定会在家中使用UIViewPropertyAnimator为您的应用程序中的所有类型的动画！



## Chapter20：UIViewPropertyAnimator入门



UIViewPropertyAnimator是在iOS10中引入的，它解决了能够创建易于交互，可中断和/或可逆的视图动画的需求。
在iOS10之前，创建基于视图的动画的唯一选择是UIView.animate（withDuration：...）一组API，它们没有为开发人员提供暂停或停止已经运行的动画的任何方法。此外，为了反转，加速或减慢动画，开发人员必须使用基于图层的CAAnimation动画。

UIViewPropertyAnimator使得创建上述所有内容变得更加容易，因为它是一个允许您保持运行动画的类，允许您调整当前运行的动画，并为您提供有关动画当前状态的详细信息。

UIViewPropertyAnimator距离iOS 10之前的“即发即忘”动画还有一大步。话虽这么说，UIView.animate（withDuration：...）API仍然在创建iOS动画方面发挥了重要作用;这些API简单易用，通常你只想开始一个简短的淡出或简单的移动，你真的不需要中断或反转它们。在这些情况下使用UIView.animate（withDuration：...）就好了。

此外，UIViewPropertyAnimator并未实现UIView.animate（withDuration：...）必须提供的所有内容，因此有时您仍需要依赖旧的API。
但足够关于哪个API更好或更新...让我们来看看UIViewPropertyAnimator的全部内容。

### 基础动画

打开并运行本章的[开始项目]() **LockSearch** 。 您应该会看到类似于iOS中的锁定屏幕的屏幕。 初始视图控制器在底部显示搜索栏，单个窗口小部件和编辑按钮：

![](https://ws1.sinaimg.cn/large/006tNbRwgy1fxukdn545vj31c00u0gy0.jpg)

已经为您实现了一些与动画无关的应用程序功能。 例如，如果点击“显示更多”，您将看到窗口小部件展开并显示更多项目。 如果点击编辑，您将看到另一个视图控制器，用于编辑窗口小部件列表。

当然，该应用程序只是模拟iOS中的锁定屏幕。 它实际上并不执行任何操作，并且专门为您设置了一些UIViewPropertyAnimator动画。 我们走吧！

首先，您将在应用程序最初打开时创建一个非常简单的动画。 打开LockScreenViewController.swift并向该视图控制器添加一个新的viewWillAppear（_ :)方法：

```swift
override func viewWillAppear(_ animated: Bool) {
    tableView.transform = CGAffineTransform(scaleX: 0.67, y: 0.67)
    tableView.alpha = 0
}
```

LockScreenViewController中的表视图在该屏幕上显示小部件，因此，为了创建简单的缩放和淡入淡出视图动画过渡，首先缩小整个表视图并使其透明。
如果您现在运行该项目，您将看到日期和下面的一些空白区域：

接下来，在视图控制器的视图出现在屏幕上时创建一个动画师。 将以下内容添加到LockScreenViewController：

```swift
override func viewDidAppear(_ animated: Bool) {
    let scale = UIViewPropertyAnimator.init(duration: 0.33, curve: .easeIn) {
    }
}
```



在这里，您使用UIViewPropertyAnimator的一个便利初始化器。 你将尝试所有这些，但你将从最简单的一个开始：UIViewPropertyAnimator（持续时间：，曲线:)。
此初始化程序创建动画实例并设置动画的总持续时间和时间曲线。 后一个参数的类型为UIViewAnimationCurve，这是一个带有以下基于曲线的选项的枚举：
easeInOut
easeIn
easeOut
线性

[前文]()

这些匹配您使用的时序选项与UIView.animate（withDuration：...）API，它们产生类似的结果。
既然你已经创建了一个动画师对象，那么让我们来看看你能用它做些什么。



### 添加动画



```swift
scale.addAnimations {
    self.tableView.alpha = 1.0
}
```

您使用`addAnimations`添加代码块，这些代码块执行所需的动画，就像使`UIView.animate(withDuration...)`一样。 使用动画师的不同之处在于您可以添加多个动画块。 例如，您可以包含逻辑以有条件地向同一个动画师添加更多或更少的动画。

除了能够有条件地构建复杂的动画外，您还可以添加具有不同延迟的动画。 有一个版本的addAnimations，它采用以下两个参数：
`animation`，这是一个有动画执行的块，
`delayFactor`，这是动画开始前的延迟。

请注意，后一个参数不称为延迟，具体为：delayFactor。 这是因为您不提供以秒为单位的绝对值，而是提供动画师剩余持续时间的因子（介于0.0和1.0之间）。

向同一个动画师添加第二个动画，但有一些延迟：

```swift
scale.addAnimations({
    self.tableView.transform = .identity
}, delayFactor: 0.33)
```

要确定以秒为单位的实际延迟，请使用delayFactor并将其乘以动画师的剩余持续时间。 由于您尚未启动动画，因此剩余持续时间等于总持续时间。
所以在上面的情况：

`delayFactor(0.33) * remainingDuration(=duration 0.33) = delay of 0.11 seconds`



为什么第二个参数不是一个简单的秒数值？
好吧，想象你的动画师已经在运行了，你决定在中途添加一些新的动画。 在这种情况下，剩余持续时间不会等于总持续时间，因为自启动动画以来已经过了一段时间。

![image-20181204120317868](https://ws4.sinaimg.cn/large/006tNbRwgy1fxuky4tem3j30e2055q37.jpg)

在这种情况下，delayFactor将允许您根据剩余可用时间安排延迟动画。 此外，这可确保您不能将延迟设置为长于剩余运行时间。

![image-20181204120335113](https://ws4.sinaimg.cn/large/006tNbRwgy1fxukyfk6x4j30co054glu.jpg)

### Adding completions



```swift
scale.addCompletion { (_) in
    print("ready")
}
```



在这个简单的例子中，你只是打印到控制台，但你可以做任何你想要的事情; 清理一些临时视图，重置移动的视觉元素的位置，等等。

与addAnimations（_ :)一样，您可以多次调用addCompletion（_ :)来添加更多完成处理程序。 这些将一个接一个地执行，并按照您将它们添加到动画师的顺序执行。
最后但并非最不重要的，你需要启动动画师。
在调用startAnimations（）之前，屏幕上不会发生任何事情，因此在习惯使用UIViewPropertyAnimator时请记住，如果您在屏幕上看不到动画，则可能忘记启动它们。

在viewWillAppear（_ :)的末尾添加：

```swift
scale.startAnimation()
```



### Abstracting animations away

你可能已经注意到，就像图层动画一样，使用UIViewPropertyAnimator的动画添加了相当多的代码。

使用非“即发即忘”的对象可以很容易地将一些动画代码提取到一个单独的类中。 由于您将在本书的这一部分为项目创建大量动画，因此您将在单独的文件中提取大部分动画。

创建一个名为AnimatorFactory.swift的新文件，并将其默认内容替换为：

```swift
import UIKit

class AnimatorFactory {
  
}
```

然后添加一个方法，其中包含您刚刚编写的动画代码，但默认情况下不运行动画，而是返回动画师作为结果：

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

该方法将视图作为参数，并在该视图上创建所有动画。 最后它返回准备好的动画师。
切换到LockScreenViewController.swift并将viewDidAppear（_ :)替换为：

```swift
override func viewDidAppear(_ animated: Bool) {
    AnimatorFactory.scaleUp(view: tableView).startAnimation()
}
```



那更好，更短，更清洁！
到本节结束时，您将非常欣赏AnimatorFactory，因为它将从您的视图控制器中删除大量代码。

> 注意：在您自己的项目中，您可能希望使用枚举或结构来访问抽象动画师。 在本书中，您将使用静态类方法。



### Running animators

此时你可能会问自己”如果动画对象的唯一目的是立即开始，那么创建动画对象有什么意义呢？
这是个好问题！

如果您需要运行单个动画块并且不再需要更改，请继续使用UIView.animate（withDuration：...）。您决定使用哪个API的转折点取决于您是想简单地运行动画 - 还是运行动画并最终与之交互。

如果你想使用UIViewPropertyAnimator但你仍然只有一个动画和完成块，并想立即运行它会怎么样？是不是有更简化的方式来创建这样的动画？
为什么，是的，有！你问我很高兴。这就是本章的这一部分被称为运行动画师的原因。在UIViewPropertyAnimator上有一个类方法，它创建一个动画师并立即为你启动它。
接下来，当用户使用搜索栏时，您将淡入模糊图层（blurView），并在用户完成搜索时将其淡出。

打开LockScreenViewController.swift并向LockScreenViewController类添加一个新方法：

```swift
func toggleBlur(_ blurred: Bool) {
    UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0.1, options: .curveEaseOut, animations: {
        self.blurView.alpha = blurred ? 1 : 0
    }, completion: nil)
}
```

你当然注意到了`UIViewPropertyAnimator.runningPropertyAnimator(withDuration:...)`使用与UIView.animate（withDuration：...）完全相同的参数，以便您更轻松地使用此新API。

虽然看起来这可能是一种“即发即忘”的API，但请注意它确实会返回一个动画实例。 因此，您可以添加更多动画，更多完成块，并且通常与当前正在运行的动画进行交互。

现在让我们看看淡入淡出动画的样子。 LockScreenViewController已设置为搜索栏的委托，因此您只需实现所需的方法即可在正确的时间触发动画。

添加一个新的LockScreenViewController扩展：

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

当用户点击搜索字段时，您会淡化模糊，并在用户使用完搜索栏时将其淡出。 要为用户提供更多取消搜索的方法，还要添加以下两种方法：

```swift

```



这将允许用户通过点击右侧按钮或删除其搜索查询来解除搜索。 立即运行该应用，然后点按搜索栏文本字段。

你会看到小部件在模糊效果视图下消失。 当您点击搜索栏右侧的按钮时，模糊视图会淡出。

![](https://ws1.sinaimg.cn/large/006tNbRwgy1fxulof5jzqg308q09lwov.gif)

### Basic keyframe animations

之前您学习了如何向同一个动画师添加更多动画块，并让它们以给定的延迟因子开始。 这很方便，但它与您习惯使用视图关键帧动画的功能并不完全相同。

UIView.animateKeyframes API非常强大，因为它允许您以任何方式对动画进行分组，具有任何延迟和持续时间。
准备一些好消息！
实际上，您可以在UIViewPropertyAnimator动画块中使用UIView.animate和UIView.animateKeyframes。

因此，如果你想创建一个复杂的关键帧动画，但仍然意识到创建动画师的好处，比如能够暂停或反转，你可以！
在本章的这一部分中，您将创建一个简单的抖动关键帧动画。 您将在用户点击的任何图标上播放该动画，为他们提供一些视觉点击反馈：



在`AnimatorFactory`中添加方法：

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



查看 [关键帧动画]()

第一个关键帧将给定视图向左旋转，第二个关键帧将其向右旋转，最后第三个关键帧将其带回原点 - 呃，我的意思是重置它的变换。
要确保图标保持在其初始位置，即使动画被中断，请在完成块中添加：

```swift
view.transform = .identity
```



没有明显的方法可以中断动画，但由于您使用的是动画师，因此总是可以添加代码以暂停或停止该特定动画师。
现在，与UIView.animate（withDuration：...）系列API相比，您对动画的看法有很大差异。使用动画师时，您的动画总是可以成功完成或在中途停止，或者甚至不是在最终状态完成，而是在执行期间反转时处于启动状态。

接下来，由于动画已完成，您可以使用jiggle（view :)方法获取关键帧动画师并在某些视图上运行它。

打开IconCell.swift（该文件位于Widget子文件夹中）。这是自定义集合单元类，它在窗口小部件视图中显示每个图标：



每当选择其中一个单元格时，您将在其图像上运行微动画动画，为用户提供一些触摸反馈。
在单元格上添加一个新的便捷方法，以在其图像上启动动画师：

```swift
func iconJiggle() {
    AnimatorFactory.jiggle(view: icon)
}
```

现在Xcode抱怨你的AnimatorFactory.jiggle方法返回一个结果，但你不以任何方式使用它。 幸运的是，这是一个容易解决的问题。

![image-20181204124154609](https://ws1.sinaimg.cn/large/006tNbRwgy1fxum2bblu4j31gy032t98.jpg)

切换到AnimatorFactory.swift并将以下内容添加到静态func jiggle之前的行（view：UIView） - > UIViewPropertyAnimator一个@discardableResult属性，以便Xcode知道您可以选择忽略该方法的结果：

```swift
  @discardableResult
  static func jiggle(view: UIView) -> UIViewPropertyAnimator {
```

不要完全删除返回类型 - 稍后您将使用该方法的结果。
要最终运行动画，请打开WidgetView.swift并找到collectionView（collectionView：didSelectItemAt :)。 这是当用户点击集合视图单元格时调用的集合视图委托方法。 附加以下内容：

```swift
if let cell = collectionView.cellForItem(at: indexPath) as? IconCell {
    cell.iconJiggle()
}
```

![](https://ws3.sinaimg.cn/large/006tNbRwgy1fxumdsesopg308q06075c.gif)



>注意：如果您碰巧想知道，目前还没有一种简化的动画制作动画重复方式。如果你想要一个重复的动画，你将需要观察动画师的运行属性，一旦动画完成，将动画师的进度重置为0％并重新开始。或者只使用UIView.animate（withDuration：animations）方法。
通过这个动画，你已经完成了基础之旅。希望您已经了解了使用UIViewPropertyAnimator而不是旧API的一些好处。

然而，你所涵盖的只是UIViewPropertyAnimator可以做的一小部分。在接下来的章节中，您将研究更有趣的方法来设置动画的时序，交互性和电源视图控制器转换。

挑战
您已经了解了有关使用UIViewPropertyAnimator的一些基础知识，但在接下来的三章中还有很多内容需要学习。在本章的挑战部分，花点时间思考一下你所学到的知识，并体验你第一次遇到属性动画师的状态。“



### 把blur动画放入工厂🏭

要再次练习抽象动画，请将toggleBlur（_ :)中的模糊动画提取到AnimatorFactory上的静态方法中。
这次，静态工厂方法应该采用两个参数：动画视图以及是否动画为完全透明或完全不透明状态。

```swift
@discardableResult
static func fade(view: UIView, visible: Bool) -> UIViewPropertyAnimator {
    return UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0.1, options: .curveEaseOut, animations: {
        view.alpha = visible ? 1.0 : 0.0
    }, completion: nil)
}
```





最后，您应该能够通过使用这个单行程序轻松切换blurView的可见性：

```swift
func toggleBlur(_ blurred: Bool) {
    AnimatorFactory.fade(view: blurView, visible: blurred)
}
```




您是否意识到使用UIViewPropertyAnimator抽象和重复使用动画是多么容易？ 我知道我当然会这样做！“

### Prevent

在这个挑战中，您将学习如何检查动画师当前是否正在执行其动画。

如果您在同一个图标上重复点击，您会看到它在每次点击时跳回到其初始状态，并且动画看起来不稳定。

![](https://ws2.sinaimg.cn/large/006tNbRwgy1fxumve35v2g308k06076o.gif)

现在，你只是忽略了AnimatorFactory.jiggle的结果 - 但如果你没有呢？如果您实际掌握了动画对象并使用它来检查当前是否有活动的抖动动画，则可以防止在同一个图标上进一步点击。

首先，将一个名为animator的可选属性添加到IconCell类中。

接下来，不是丢弃AnimatorFactory.jiggle的结果，而是将其存储在动画师中。现在，每次用户点击图标时，您都可以检查图标上是否已有动画。
在iconJiggle（）的开头检查是否设置了animator，如果是，请检查其isRunning属性是否为true。 isRunning告诉你动画师当前是否正在运行它的动画 - 即它已经启动但尚未完成。

如果有一个正在运行的动画师，剩下要做的就是退出iconJiggle（）而不创建新的动画。 这将解决您的问题，用户可以根据需要在图标上点击多次。

```swift
  var animator: UIViewPropertyAnimator?

  func iconJiggle() {
    if let animator = animator, animator.isRunning {
      return
    }

    animator = AnimatorFactory.jiggle(view: icon)
  }
```

![](https://ws1.sinaimg.cn/large/006tNbRwgy1fxumwxwqd0g308k0600uv.gif)



接下来 - 使用UIViewPropertyAnimator制作更复杂的动画！



## Chapter21：使用UIViewPropertyAnimator的中级动画 

您已经使用UIViewPropertyAnimator尝试了一些动画，并且已经开始通过向界面添加令人愉快的动画来改进Widgets项目用户体验。 您还研究了创建基本和关键帧动画，并发现使用UIViewPropertyAnimator类并不困难！

更重要的是，当使用UIView.animate（withDuration：...）API集时，你已经解决了一些不那么简单的问题 - 例如，检查动画当前是否正在运行，有条件地添加动画和完成，以及抽象 动画到独立类。
如果您成功完成了上一章中的挑战，只需重新打开项目并继续处理。 否则，您可以使用本章提供的入门项目：



让我们看看如何使用自定义时序为您的动画添加额外的东西！



### Custom animation timing



在本书中，您一直在使用四条内置曲线：线性，轻松，轻松，轻松。 到目前为止，对于那些尚未说过的内容没什么可说的，所以通过本章的大部分内容，您将专注于自定义曲线。 如果有任何机会，您跳过前面解释内置曲线的章节，请快速阅读第1章“视图动画入门”并搜索动画缓动部分。

假设你已经掌握了四条内置曲线的内容，那么让我们看一下动画中的曲线。

#### 内置定时曲线

目前，当您激活搜索栏时，您会在窗口小部件顶部的模糊视图中淡入淡出。 在此示例中，您将删除该淡入淡出动画并为模糊效果本身设置动画。
打开`LockScreenViewController.swift`并向该类添加一个新方法：

```swift
func blurAnimations(_ blured: Bool) -> () -> Void {
    return {    }
}
```

这是一种方法，它将返回准备好的动画块，您可以在以后添加到动画师中。 根据参数值，块中的动画将在blurView中删除或创建模糊效果。
首先让我们添加代码来创建动画。 插入支架之间：

```swift
self.blurView.effect = blured ? UIBlurEffect(style: .dark) : nil
self.tableView.transform = blured ? CGAffineTransform(scaleX: 0.75, y: 0.75) : .identity
self.tableView.alpha = blured ? 0.33 : 1.0
```

将blurView上的效果属性设置为nil或模糊效果将生成动画。 此外，您还可以调整包含窗口小部件的表视图的可见性和变换。

删除`viewDidLoad()`中的两行：

```swift
    blurView.effect = UIBlurEffect(style: .dark)
    blurView.alpha = 0
```



替代`toggleBlur(_:)`内容：

```swift
func toggleBlur(_ blurred: Bool) {
    UIViewPropertyAnimator(duration: 0.55, curve: .easeOut, animations: blurAnimations(blurred)).startAnimation()
}
```

![](https://ws4.sinaimg.cn/large/006tNbRwgy1fxur7gcxngg308k09u11x.gif)



请注意模糊不仅仅是淡入或淡出，但实际上它会在效果视图中插入模糊量。
现在，您可以尝试不同的时序曲线，如.easeIn或.linear，以查看它们如何改变动画。

> 注意：模拟器中的模糊动画可能会有点生涩，要享受iOS动画的强大功能，请始终在设备上享受最终效果。



#### 定制贝塞尔曲线

有时当你想要对动画的时间非常具体时，使用这些曲线简单地“开始减速”或“慢慢结束”是不够的。
在本书的前面，您了解到可以创建自定义CAMediaTimingFunction并为您的图层动画定制自定义时序。但是，在说明中简要提到了这一点，你没有机会更多地了解它。

在本节中，您将了解Bézier曲线是什么以及如何使用它们来设计您自己的自定义动画时序。好消息是，由于UIViewPropertyAnimator在幕后使用图层动画，您可以返回并将本章中掌握的内容应用到图层动画中。

首先 —— **贝塞尔曲线是什么？**

让我们从简单的事情开始 —— 一条线。它非常简洁，需要在屏幕上画一条线，只需要定义它的两个点的坐标，开始 *(A)* 和结束 *(B)*：

![image-20181204154619268](https://ws3.sinaimg.cn/large/006tNbRwgy1fxure6zmgcj309q036aa0.jpg)



能够如此精确地描述屏幕上的形状的方便之处在于，您还可以对其应用 transform：可以缩放线条，移动它，也可以旋转它。一切都归功于坐标系中的这两点。此外，您可以将行保留到磁盘并加载回来，因为您可以使用数字来描述它们，并且您知道如何保留它们！

现在让我们来看看曲线。曲线比线条更有趣，因为它们可以在屏幕上绘制任何东西。例如：

![image-20181204154744302](https://ws1.sinaimg.cn/large/006tNbRwgy1fxurfnsi7zj30c706cq37.jpg)

你在上面看到的是四条曲线放在一起;他们的两端在你看到小白方块的地方相遇。图中有趣的是小绿圈。看了一会儿之后，你会注意到每个曲线弯曲的圆圈“kind of define”。

所以曲线不是随机的。它们也有一些细节，就像线条一样，可以帮助你通过坐标定义它们。然后，您可以获得坐标的所有好处，例如持久化，转换它们等。

您可以通过向线条添加控制点来定义曲线。 让我们在之前的行中添加一个控制点：

![image-20181204154909038](https://ws1.sinaimg.cn/large/006tNbRwgy1fxurh4vhhdj30aw052gly.jpg)

您可以想象由连接到线的铅笔绘制的曲线，其起点沿着线AC移动，其终点沿着线CB移动：

![image-20181204154949279](https://ws4.sinaimg.cn/large/006tNbRwgy1fxurhti255j30fu03ljrn.jpg)

具有一个控制点的Bézier曲线称为二次曲线。 但是，你对立方Bézier曲线更感兴趣 - 那些有两个控制点。
您还可以使用三次曲线来描述动画计时。 实际上，您使用的内置曲线也是为您预定义的三次曲线。

Core Animation使用始终以坐标（0,0）开始的三次曲线，它表示动画持续时间的开始。 当然，这些时序曲线的终点始终是（1,1） - 动画的持续时间和进度的结束。
让我们来看看轻松曲线：

![image-20181204155458179](https://ws4.sinaimg.cn/large/006tNbRwgy1fxurn6i2vqj309107kdg7.jpg)

随着时间的推移（在坐标空间中从左向右水平移动），曲线在垂直轴上的进展非常小，然后大约在动画持续时间的一半时间内，进度加快并随着时间的推移而赶上，因此它们都达到了 （1,1）在动画结束时。

这一切都有意义，对吧？

你能猜出下面的哪一个是缓出的，哪一个是一个轻松的曲线？

![image-20181204155513973](https://ws4.sinaimg.cn/large/006tNbRwgy1fxurngb6dwj30f306tt9l.jpg)



现在您已了解Bézier曲线的工作原理，唯一剩下的问题是如何在视觉上设计一些曲线并获得控制点的坐标，以便您可以将它们用于iOS动画。

> 注意：打开Web浏览器并访问http://cubic-bezier.com。 这是计算机科学研究员和演讲者Lea Verou的便利网站。 它允许您拖动立方Bézier的两个控制点并查看即时动画预览。

![image-20181204155438660](https://ws4.sinaimg.cn/large/006tNbRwgy1fxurmuxor9j31br0i5n0t.jpg)

我鼓励你一起玩，直到你知道不同的时序曲线如何影响动画时序。
接下来，您将继续向Widgets项目添加自定义计时动画。



打开LockScreenViewController.swift并将toggleBlur（）中的现有动画替换为：

```swift
func toggleBlur(_ blurred: Bool) {
    UIViewPropertyAnimator(duration: 0.55, controlPoint1: CGPoint(x: 0.57, y: -0.4), controlPoint2: CGPoint(x: 0.96, y: 0.87), animations: blurAnimations(blurred)).startAnimation()
}
```



这是UIViewPropertyAnimator类的第二个便利初始值设定项。除了持续时间和动画块之外，还需要两个控制点作为参数。这些可以帮助您定义自定义三次曲线。
等一等！上面的一点有一个负坐标！
确实！既然你无论如何做自定义时序曲线，为什么不做异国情调呢？
您可以拖动控制点，以便将曲线拉入定义进度轴负值的空间。效果相当有趣：如果你正在从A点向B点的正确方向移动视图，它将首先向左“退一步”，然后继续朝向B点的正确方向。
在模糊和缩放动画的情况下，表格视图实际上会在缩小之前首先缩放一点。这样做会为动画添加一点“弹性”。
但请注意：如果你过度使用它，这将对你的动画产生一种相当滑稽的效果。



#### Spring Animations

还有另一个便利初始化器-- `UIViewPropertyAnimator(duration:dampingRatio:animations :)`  - 用于定义弹簧驱动的动画。

这将产生与UIView的动画相同的动画（withDuration：delay：usingSpringWithDamping：initialSpringVelocity：options：animations：completion :)，初始速度为0。

与UIView方法一样，此API会向后创建弹簧动画，如第11章所述。您可以提供动画的持续时间，UIKit会计算弹簧的所有方面，以便为您提供持续时间。 你知道，弹簧效果不如正确计算。 幸运的是，有一种更好的方法可以使用UIViewPropertyAnimator创建弹簧动画，接下来会出现。



#### Custom timing providers

满足你将要在这里介绍的第四个也是最后一个初始化程序：`UIViewPropertyAnimator(duration:timingParameters:)`。

这一次，您可以创建一个可以为动画提供任何计时数据的全新对象！ 您可以使用其中一个UIKit对象来定义自定义立方体或基于弹簧的计时，但您也可以自行推出。

您将看到如何创建自定义弹簧动画，然后再转到本章的下一部分，您将在实践中创建一些弹簧动画。
名为timingParameters的第二个参数是UITimingCurveProvider类型 - 由UIKit定义的协议。 UIKit中有两个符合该协议的类：UICubicTimingParameters和UISpringTimingParameters。
我们来看看UISpringTimingParameters。

#### 提供阻尼和速度

即使您使用自定义计时提供程序，您仍然可以选择简单的方法，并提供阻尼比和初始速度，就像使用便捷初始化程序时一样。 代码如下所示：

```swift
let spring = UISpringTimingParameters(dampingRatio:0.5, initialVelocity: CGVector(dx: 1.0, dy: 0.2))

let animator = UIViewPropertyAnimator(duration: 1.0, timingParameters: spring)
```



spring参数表示弹簧的配置，并将其提供给动画对象以用于动画的计时。 如前所述，这仍将计算弹簧“向后”。

注意初始速度是矢量类型。 如果您要为任何视图的位置或大小设置动画，UIKit将在开始时应用二维初始速度。 如果您要为视图的位置设置alpha或单个轴的动画，UIKit将仅考虑初始速度矢量的dx属性。

initialVelocity也是一个可选参数，因此如果您根本不需要设置速度，只需提供阻尼比即可。

#### Custom springs

如果你想对你的弹簧更加具体，你可以在UISpringTimingParameters上使用不同的初始化器，让你指定弹簧的质量，刚度和阻尼，就像你在本书前面对你的层动画所做的那样。
因此，配置自定义弹簧的代码如下：

```swift
let spring = UISpringTimingParameters(mass: 10.0, stiffness: 5.0, damping: 30, initialVelocity: CGVector(dx: 1.0, dy: 0.2))

let animator = UIViewPropertyAnimator(duration: 1.0, timingParameters: spring) 
```



如果您需要快速了解所有这些参数的工作原理，请快速阅读[第11章“图层弹簧”]()。
在下一节中，您将尝试一些自定义时序动画。



### Auto Layout animations

咻！ 这是本章的一个相当冗长的理论部分，所以我很有兴趣编写一些代码并尝试一些动画。

您已经在[第7章“动画约束”]()中熟练掌握了自动布局动画，因此在下一部分中您将要制作一些约束动画并不会让您感到意外。
使用UIViewPropertyAnimator的布局约束动画与使用UIView.animate（withDuration：...）创建它们的方式非常相似。 诀窍是更新约束，然后从动画块中调用layoutIfNeeded（）。
让我们尝试使用UIViewPropertyAnimator。
打开AnimatorFactory.swift并添加一个新的工厂方法：

```swift
@discardableResult
static func animateConstraint(view: UIView, constraint: NSLayoutConstraint, by: CGFloat) -> UIViewPropertyAnimator {
    let spring = UISpringTimingParameters(dampingRatio: 0.2)
    let animator = UIViewPropertyAnimator(duration: 2.0, timingParameters: spring)

    animator.addAnimations {
        constraint.constant += by
        view.layoutIfNeeded()
    }
    return animator
}
```

在此方法中，您将动画更改为约束的常量，然后在提供的视图上调用layoutIfNeeded（）。

这个动画看起来像什么？ 不知道！ 这实际上取决于您为方法提供的约束类型。 如果给它一个尾随空格约束，它将水平移动视图; 如果为其提供高度约束，则视图将向上或向下缩放。

在`LockScreenViewController`中`viewWillAppear`里添加：

```swift
dateTopConstraint.constant -= 100
view.layoutIfNeeded()
```

`viewDidAppear`：

```swift
AnimatorFactory.animateConstraint(view: view, constraint: dateTopConstraint, by: 100).startAnimation()
```



切换回AnimatorFactory.swift并更改弹簧动画的参数。 将dampingRatio设置为0.55，持续时间设置为1.0。 这应该使动画更微妙但仍然有趣。
接下来，当您为约束设置动画时，您将探索不同的情况。 目前，当您点击“显示更多”时，窗口小部件会更改其高度约束并重新加载顶部表视图内容以调整窗口小部件的大小。
在下一个动画中，您将为单元格高度变化设置动画。



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

在这段代码中，你执行了一个小技巧。 首先，您照常更改约束，但之后在表视图上调用beginUpdates（）和endUpdates（）。 这样做会询问所有细胞的高度，并根据需要调整布局。 如果您的任何单元格表示它想要更高或更短，UIKit将相应地调整其框架。在块结束时，您调用layoutIfNeeded（）以确保布局更改将在动画块内发生。

该视图已经具有一个名为toggleHeightAnimator的属性，因此您只需创建一个弹簧配置并将新的动画制作工具存储在该属性中。 请注意，在这种情况下，您可以定义所有弹簧属性，因此将忽略传递给属性动画制作工具的持续时间。 弹簧本身决定了动画运行的时间。

在方法的底部，添加以下代码以重新加载窗口小部件中的图标：

```swift
widgetView.expanded = showsMore
widgetView.reload()
```

![](https://ws4.sinaimg.cn/large/006tNbRwgy1fxuvd8a3hwg308k08cqhn.gif)



### Built-in view transitions

要完成此动画，您将看到使用UIViewPropertyAnimator的内置视图过渡。

在[第3章“过渡”]()中，您了解了可以在iOS中使用的内置视图过渡。 现在，您将使用交叉淡入淡出将窗口小部件按钮的标题从"显示更多"更改为"显示更少"，反之亦然。
在你定义动画块之后（但在定义你的动画师之前），在toggleShowMore（_ :)里面添加这段代码：

```swift
let textTransition = {
    UIView.transition(with: sender, duration: 0.25, options: .transitionCrossDissolve, animations: {
        sender.setTitle(self.showsMore ? "Show Less" : "Show More", for: .normal)
    }, completion: nil)
}
```



您定义了一个视图过渡，并在其动画块中，根据当前是否展开了窗口小部件来更改按钮标题。
那么如何将这种过渡添加到动画师？ 就像你对任何其他动画一样阻止！

找到向动画师添加动画的位置，并添加textTransition以及0.5延迟因子。 最终的代码应如下所示：

```swift
toggleHeightAnimator?.addAnimations(textTransition, delayFactor: 0.5)
```





这将改变按钮标题，具有很好的交叉渐变效果：

![](https://ws1.sinaimg.cn/large/006tNbRwgy1fxuvtnlvmbg303m03s772.gif)

如果您想尝试其他转换，请使用.transitionFlipFromTop替换.transitionCrossDissolve  - 这是我个人的最爱。 这种转换使得更新按钮标题看起来更加花哨。

你开始将UIViewPropertyAnimator推向极限了！ 在进入下一章和交互式动画之前，请务必查看本章的挑战，该挑战将向您介绍使用UIViewPropertyAnimator的创意添加动画。



### Additive animations

当使用UIView.animate（withDuration：...）时，将动画添加到相同的视图属性会发生。
例如，如果您要在屏幕上从A点移动到B点，并在终点中途改变主意并决定将视图发送到C点，那么它不会在 当前点并直接向新的终点移动。



UIKit比这更聪明，所以默认情况下它会试图将你的观点“放松”到新的轨迹中。 实际的动作看起来像这样：



添加更改时动画不会被替换，但会合并以便更改发生变化。

UIViewPropertyAnimator也可以处理这些情况（不同的时序提供商会有不同的成功）。
对于此挑战，如果在上一个动画完成之前在toggleShowMore（_ :)中再次切换菜单状态，则应该将“动画”添加到现有的toggleHeightAnimator，而不是创建新的动画制作者。

检查toggleHeightAnimator当前是否正在使用isRunning运行。
如果已经创建了动画师，请暂停它，添加新的动画块，然后继续动画！

当您完成此挑战后，请转到下一章，了解如何为您的属性动画动画添加交互性。




## 第22章，使用UIViewPropertyAnimator进行交互式动画



你已经介绍了许多UIViewPropertyAnimator API，例如基本动画，自定义时序和弹簧，以及动画的抽象。但是，与旧式的“即发即忘”API相比，你尚未研究使这个类真正有趣的原因。

UIView.animate（withDuration：...）提供了一种在屏幕上为视图设置动画的方法，但是一旦定义了所需的结束状态，就会发送动画以进行渲染，并且控制权无法控制。

但是如果你想与动画互动怎么办？或者创建动画，这些动画不是静态的，而是由用户手势或麦克风输入驱动的，就像你在书中涉及图层动画的那部分一样？

这是UIViewPropertyAnimator在动画视图方面真正实现的地方。使用此类创建的动画是完全交互式的：您可以启动，暂停它们并改变它们的速度。最后，您可以通过直接设置当前进度来简单地“擦除”动画。

由于UIViewPropertyAnimator可以同时驱动预设动画和交互式动画，因此在讲述动画师目前的状态时，事情会变得有点复杂。本章的下一部分将教你如何处理动画师状态。



如果您已完成上一章中的挑战，请继续处理您的Xcode项目;如果您跳过挑战，请打开本章提供的入门项目。
您应该让项目具有不同的动画，当您在搜索栏中输入文本，点击图标或展开小部件视图时，这些动画会启动。

### 动画状态机

除了处理您的动画外，UIViewPropertyAnimator还展示了状态机的行为，并且可以为您提供有关动画当前状态的许多不同方面的信息。
您可以检查动画是否已启动，是否已暂停或完全停止，或动画是否已反转。最后，您可以检查动画“完成”的位置，例如从所需的最终状态开始，或者介于两者之间的某个位置。

UIViewPropertyAnimator有三个属性可帮助您找出当前状态：

![image-20181204183027143](https://ws4.sinaimg.cn/large/006tNbRwgy1fxuw4ytvcqj30et02eaa7.jpg)



isRunning属性（只读）告诉您动画师的动画当前是否处于运动状态。 默认情况下该属性为false，并在调用startAnimation（）时变为true。 如果您暂停或停止动画，或者您的动画自然完成，它将再次变为false。

isReversed属性默认为false，因为您总是以向前方向开始动画，即动画从其开始状态播放到结束状态。 如果将此属性更改为true，则动画将反转方向并回放到其初始状态。



状态属性（只读）确定动画师是否处于活动状态并且当前是动画还是处于某种其他被动状态。

默认情况下，状态为非活动状态这通常意味着你刚刚创建了动画师，并且还没有调用任何方法。请注意，这与将isRunning设置为false不同：isRunning实际上只关注正在播放的动画，而当状态处于非活动状态时，这实际上意味着动画师还没有做任何事情。

当你要么：状态变得活跃：
调用startAnimation（）来启动动画

在没有开始动画的情况下调用pauseAnimation（），

设置fractionComplete属性以将动画“倒回”到某个位置。



动画自然完成后，状态切换回非活动状态。

如果在动画师上调用stopAnimation（），它会将其state属性设置为停止。在这种状态下，你唯一能做的就是完全放弃动画师或者调用finishAnimation（at :)来完成动画并让动画师回到无效状态。



正如你可能想到的那样，UIViewPropertyAnimator只能按特定顺序在状态之间切换。 它不能直接从非活动状态到停止状态，也不能从停止状态直接转为活动状

在您的控制下还有一个选项：如果您设置了名为pausesOnCompletion的属性，一旦动画师完成了动画的运行而不是自动停止，它将暂停。 这将使您有机会在暂停状态下继续使用它。

如果您有疑问，可以随时回到本章的这一部分，并参考下面的状态流程图：

![image-20181204183357332](https://ws4.sinaimg.cn/large/006tNbRwgy1fxuw8m1813j30fj05iwf8.jpg)

如果使用UIViewPropertyAnimator管理状态起初听起来有点复杂，请不要担心。 如果你打电话给一个你不允许在当前状态下打电话的方法，你的应用程序会立即崩溃，这样你就有机会找出出错的地方。

### Interactive 3D touch animation

??





## 第23章，UIViewPropertyAnimator视图控制器转换



在完成第17章到第19章的过程中，您学习了如何创建自定义视图控制器转换。 你看到了它们的灵活性和强大性，所以你可能很想知道如何使用UIViewPropertyAnimator来创建它们。

好消息 - 使用动画师进行过渡很容易，而且几乎没有惊喜。

在本章中，您将查看构建自定义过渡动画并为Widgets项目创建静态和交互式过渡。

完成本章后，您的用户将能够通过下拉窗口小部件表来显示设置视图控制器。

如果您参与了上一章的挑战，请继续研究同一个项目; 如果您跳过了挑战，请打开本章提供的入门项目。