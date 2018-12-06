# Section VI: 3D Animations



到目前为止，之前的文章只使用了二维动画——这是在平面设备屏幕上动画元素的最自然方式。 毕竟，从iOS 7扁平化后的世界中的按钮，文本字段，开关和图像没有第三维; 这些元素存在于由X和Y轴定义的平面中：

![](https://ws2.sinaimg.cn/large/006tNbRwgy1fx962j0d7jj309a03g0sj.jpg)

**核心动画**可以帮助我们摆脱这个二维世界; 虽然它不是真正的3D框架，但**核心动画**有很多智能可以帮助您在3D空间中定位二维对象。

换句话说，您的图层和动画仍然以二维方式进行，但您可以在3D空间中旋转和定位每个元素的2D平面，如下所示：

![](https://ws4.sinaimg.cn/large/006tNbRwgy1fx9630g50tj30ab04jdfv.jpg)

上面显示的是在3D空间中旋转的两个2D图像。 透视变形使您可以从渲染器的角度了解它们的位置。

本书的这一部分将向您展示如何在3D空间中定位和旋转图层。 您将使用CATransform3D的特殊属性：即，应用于图层的转换类。 CATransform3D类似于CGAffineTransform，但除了让你在x和y方向上缩放，倾斜和平移之外，它还带来了第三维：z。 z轴直接从设备屏幕朝向您的眼睛。

CATransform3D允许您确定渲染摄像机与设备屏幕相对应的位置; 这会影响Core Animation应用于视图的透视变形量。

请考虑以下几个示例，以更好地了解透视的工作原理。 如果你非常非常接近物体，例如在摩天大楼前面，物体会占据你的大部分视野，当摩天大楼的线条向远处消失时，你会看到很多视角。

以类似的方式，将相机设置得非常靠近屏幕会相应地扭曲图层的视角：

![image-20181204230708868](https://ws1.sinaimg.cn/large/006tNbRwgy1fxv44v769fj30b60a4jsk.jpg)

如果将相机从物体上移回，则应用的透视失真较少，就像从几个街区外观看摩天大楼时看不到的透视失真一样。

![image-20181204230723724](https://ws2.sinaimg.cn/large/006tNbRwgy1fxv45b8kb6j309s0anwfo.jpg)

最后，如果你在相机和屏幕之间设置了很大的距离，那么就不会有任何明显的视角 - 正如你不会注意到你从整个城市观看的摩天大楼上的任何透视扭曲：

![image-20181204230830029](https://ws2.sinaimg.cn/large/006tNbRwgy1fxv469w6efj309508kq3v.jpg)

图像仍然失真，但请注意图像框架的顶部和底部线条几乎是平行的。你仍然在某个角度看它，但透视失真很小。
在接下来的两章中，您将学习如何在3D空间中设置图层，如何选择从相机到图层的距离以及如何在3D场景中创建动画。有了一些关于视角的知识，本章的其余部分应该是在三维公园散步！ ：]

第24章，“简单的3D动画” - 尝试新发现的有关相机距离和视角的知识。设置图层的透视图，处理图层的变换以旋转，平移和缩放三维图层。

第25章，“中级3D动画” - 在前一章的基础上，既然你知道了m34和相机距离的秘密，你就可以创建具有多个视图的各种3D动画。



## 24简单3D动画



在本章中，您将尝试新发现的有关相机距离和视角的知识。
设置图层的透视图后，您可以像往常一样处理图层的变换; 但现在您可以三维旋转，平移和缩放图层。

本章的项目具有折叠拉出菜单，在许多应用程序中普及，如Taasky：

Office Buddy是一个办公室帮助应用程序，供员工访问有关日常公司生活的分类信息。

初始项目已经具有使菜单起作用的所有代码，但它仅适用于2D。 您的任务是将菜单带入第三维度并赋予其生命！

![](https://ws1.sinaimg.cn/large/006tNbRwgy1fxv4fvitbsg308q0fntd3.gif)



### 创造3Dtransformations



打开ContainerViewController.swift; 此控制器在屏幕上显示菜单视图控制器和内容视图控制器。 它还处理平移手势，以便用户可以打开和关闭菜单。
您的第一个任务是构建一个类方法，该方法为侧面菜单的给定百分比“开放性”创建相应的3D变换。
将以下方法声明添加到ContainerViewController.swift：

```swift
  func menuTransform(percent: CGFloat) -> CATransform3D {
    
  }
```



上述方法接受菜单当前进度的单个参数，该参数由handleGesture（_ :)中的代码计算，并返回CATransform3D的实例。 您将直接将此方法的结果分配给菜单图层的transform属性。
将以下代码添加到新方法中：

```swift
var identity = CATransform3DIdentity
identity.m34 = -1.0/1000
```

这段代码可能看起来有点令人惊讶; 到目前为止，您只使用函数来创建或修改变换。 但是，这一次，您正在修改其中一个类的属性。

>  注意：为什么这个属性叫做m34？ 视图和图层变换表示为二维数学矩阵。 对于图层变换矩阵，第4列第3行中的元素设置z轴透视图。 您可以直接设置此元素以应用所需的透视变换。



因此，您创建一个新的CATransform3D结构，并将其m34属性设置为-1.0 / 1000 ...为什么要选择该值？
好的，我会稍微备份一下。 要在图层上启用3D变换，您需要将m34设置为-1.0 / [摄像机距离]。 由于您仔细阅读了本节的介绍（您确实阅读了它，对吗？），您可以了解相机距离如何影响场景透视。

但你为什么要用相机距离1000？ 距离以相机和场景前方之间的点表示。 至于使用什么价值，事实是你需要尝试不同的值，看看什么看起来对你的特定动画有好处。



### Working with camera distance

对于普通应用程序中的UI元素，您可以参考以下参考资料，了解有关适当摄像机距离的一些指导原则：
0.1 ... 500：非常接近，很多透视失真。
750 ... 2,000：视角不错，内容清晰可见。
2000及以上：几乎没有透视失真。

对于Office Buddy应用程序，1000点的距离将为菜单提供一个非常微妙的视角。 完成当前方法后，您可以看到它的运行情况。

将以下代码添加到menuTransform（百分比:)的底部：

```swift
let remainingPercent = 1.0 - percent
let angle = remainingPercent * .pi * -0.5
```

在上面的代码中，您可以根据”开放性“值计算菜单的当前角度。
现在将以下代码添加到menuTransform（percent :)的底部：

```swift
let rotationTransform = CATransform3DRotate(identity, angle, 0.0, 1.0, 0.0)
let translationTransform = CATransform3DMakeTranslation(menuWidth * percent, 0, 0)
return CATransform3DConcat(rotationTransform, translationTransform)
```

在这里，您可以使用rotationTransform将图层绕y轴旋转。 菜单从左侧移动，因此您还可以创建平移变换以沿x轴移动它，最终将菜单宽度设置为100％。 最后，连接两个转换并返回结果。
现在，您可以使用menuTransform（percent :)来更新菜单转换，因为用户可以向右或向左平移。
从setMenu（toPercent :)中删除修改菜单原点的以下行：

```swift
menuViewController.view.frame.origin.x = menuWidth * CGFloat(percent) - menuWidth
```

你不再需要上面的那一行，因为你将通过它的变换移动菜单。 将以下代码添加到setMenu（toPercent :)：

```swift
menuViewController.view.layer.transform = menuTransform(percent: percent)
```

建立并运行你的项目; 向右平移以查看菜单如何围绕其y轴旋转：

![](https://ws4.sinaimg.cn/large/006tNbRwgy1fxvodwgodgg306y08edhk.gif)

菜单以3D形式旋转，但它围绕其水平中心旋转，从而将菜单与内容视图控制器分开。



### 移动图层的锚点

默认情况下，图层的锚点的x坐标为0.5，表示它位于中心。 您需要将锚点的x设置为1.0，以使菜单像铰链一样围绕其右边缘旋转，如下所示：
![image-20181205104831488](https://ws1.sinaimg.cn/large/006tNbRwgy1fxvoenmznij30a207xq3b.jpg)



所有变换都是围绕图层的锚点计算的。 设置图层的位置时，还可以使用锚点作为参考点。 这意味着在屏幕上设置其位置之前最好更改图层的anchorPoint。
在viewDidLoad（）中找到以下行，您可以在其中设置菜单框：

```swift
menuViewController.view.frame = CGRect(x: -menuWidth, y: 0, width: menuWidth, height: view.frame.height)
```

现在在该行上方插入以下代码（在设置视图帧之前插入行非常重要，因为否则设置锚点将偏移视图 - 如果您想要看到不同的两种方法一试）：

```swift
menuViewController.view.layer.anchorPoint.x = 1.0
```



这会使菜单围绕其右边缘旋转。
再次构建并运行项目，然后在视图中水平平移并观察效果如何变化：

![](https://ws1.sinaimg.cn/large/006tNbRwgy1fxvokxjjzcg306y08e764.gif)

那看起来好多了！
你差不多完成了 - 只需要几点就可以了。



### 通过阴影创建视角

阴影为3D动画带来了很多真实感; 为此，您将从内容视图控制器左侧的“阴影”中旋转菜单。

你在这里没有使用任何先进的着色技术; 相反，您可以通过在旋转时更改菜单的alpha来模拟这一点。
将以下代码添加到setMenu（toPercent :)：

```swift
menuViewController.view.alpha = CGFloat(max(0.2, percent))
```



在上面的代码中，您将百分比值直接指定给图层的alpha，但是将其限制为0.2以确保菜单在用户边缘时仍然可见，并且不会完全消失。

由于此应用程序的背景为黑色，因此降低菜单视图的alpha值会使菜单中显示黑色并模拟阴影效果。

构建并运行您的项目并观察效果：

![](https://ws2.sinaimg.cn/large/006tNbRwgy1fxvoq48apag306y08edhu.gif)



这是一个小细节，但它真的让你的3D动画”流行“！
您可能已经注意到，当您第一次点击菜单按钮时，动画不会以3D模式播放。 该效果仅对第二个及后续动画产生影响。
那是因为在第一次切换菜单之前，您没有设置3D动画参数和图层变换。 这很容易修复：菜单视图控制器加载后，将菜单进度设置为0.0以设置正确的菜单层转换。
将以下内容添加到viewDidLoad（）的底部：

```swift
setMenu(toPercent: 0.0)
```

这将从一开始就获得起始帧和层变换。再次构建并运行您的项目;点击菜单按钮，您将看到动画第一次正常工作。



### 光栅化效率

最后一项任务是让你的动画“完美”。如果你在来回平移时盯着菜单足够长，你会注意到菜单项的边框看起来像素化，如下所示：

![image-20181205110350367](https://ws3.sinaimg.cn/large/006tNbRwgy1fxvoukq8jyj30b706tmxa.jpg)

核心动画不断重绘菜单视图控制器的所有内容，并在所有元素移动时重新计算所有元素的透视失真，这不是非常有效 - 因此是锯齿状边缘。

最好让Core Animation知道您不会在动画期间更改菜单内容，以便它可以渲染菜单一次并简单地旋转渲染和缓存的图像。
这听起来很复杂，但你会发现它很容易实现。滚动到handleGesture（）并找到.began案例块;此代码在用户启动平移操作时执行。您可以在此指示Core Animation缓存菜单。

将以下代码添加到.began案例块的末尾：

```swift
menuViewController.view.layer.shouldRasterize = true
menuViewController.view.layer.rasterizationScale = UIScreen.main.scale
```

shouldRasterize指示Core Animation将图层内容缓存为图像。 然后设置rasterizationScale以匹配当前的屏幕比例，你就是金色的！
再次构建和运行项目，看看你的图形是如何改进的：

![image-20181205110814153](https://ws2.sinaimg.cn/large/006tNbRwgy1fxvoz544nmj308203uwed.jpg)

在这种情况下，核心动画真的很棒。使用2D图像是这个框架真正做得很好的事情之一！

为避免在使用应用程序时进行任何不必要的缓存，您应该在动画完成后立即关闭光栅化。
在.failed案例中找到空动画完成闭包并添加以下代码：

```swift
self.menuViewController.view.layer.shouldRasterize = false
```

现在，您只在动画期间激活光栅化。你的效率如何！
只需几页，您就可以了解相机距离，透视以及如何设置3D场景并对其应用动画。
本节还有一章，其中包含更多3D乐趣 - 但在您开始之前，先看一下本章的挑战。



### 创建自己的3D动画

对于此挑战，您将为菜单按钮创建3D旋转动画。当用户平移按钮时，按钮将在菜单视图控制器旁边旋转。
具体来说，您将围绕x轴和y轴创建旋转，以使菜单按钮在其对角线上翻转。

在`ContainerViewController`的`setMenu(toPercent:)`中添加：

```swift
let centerVC = centerViewController.viewControllers.first as? CenterViewController
if let menuButton = centerVC?.menuButton {
    menuButton.imageView.layer.transform = buttonTransform(percent: percent)
}
```

`buttonTransform`函数为：

```swift
func buttonTransform(percent: CGFloat) -> CATransform3D {
    var identity = CATransform3DIdentity
    identity.m34 = -1.0/1000

    let angle = percent * .pi
    let rotationTransform = CATransform3DRotate(identity, angle, 1.0, 1.0, 0.0)

    return rotationTransform
}
```



这将获取当前内容视图控制器，以便您可以使用它。
菜单按钮可通过CenterViewController的menuButton属性访问。对于此挑战，请调整按钮imageView的3D变换。
如果直接旋转按钮而不是使用3D变换，它将与下面的导航栏视图发生冲突，并可能被导航栏部分遮挡。
相比之下，按钮自己的2D空间在旋转之前已经位于所有导航栏视图的顶部 - 因此，如果旋转menuButton.imageView，它将在按钮自己的平面内旋转，该平面始终位于导航栏的顶部。

另一个问题是，第一次运行menuButton的代码将是nil，所以你应该像对待它一样对待它，即使它是隐式解包的。

对于旋转，创建一个变换就像您在本章前面所做的那样，但这次围绕x轴和y轴旋转视图。如有必要，请查看CATransform3DRotate（）的文档。

这次你不需要计算剩余的百分比;要获得旋转角度，只需将进度乘以.pi即可。

当您完成解决方案时，按钮图像应在您平移屏幕时翻转，如下所示：

![](https://ws3.sinaimg.cn/large/006tNbRwgy1fxvpgah492g306y067799.gif)

而已！进入下一章，了解3D中更棒的动画！







## 25中级3D动画

在上一章中，您了解到将透视应用于单个视图并不是一项复杂的任务; 事实上，一旦你知道m34和相机距离的秘密，你就可以创建各种3D动画。

本章以您已经学习的内容为基础，向您展示如何使用多个视图创建令人信服的3D动画。

本章的入门项目是一个简单的飓风图库。 到本章结束时，您将获得3D效果以获得图库中图像的整体视图：



你可以点击一张照片将其全屏显示，然后点击右上角的按钮将所有图像再次打开 - 当然，还有一个很酷的动画带你进入这两个状态！

准备开始了吗？ 坚持你的帽子，准备好被这个“暴风雨”的项目所震撼！



### 探索入门项目
从本章的Resources文件夹中打开starter项目; 构建并运行它以查看您必须开始的内容：



你所拥有的只是一个空白屏幕，顶部有两个条形按钮：左边一个显示NASA图像信用，右边一个调用显示或隐藏图库的方法。
首先，您需要在屏幕上显示所有图像并进行设置，以便为“粉丝”动画做好准备。

打开ViewController.swift并检查类代码。 你会看到一个名为images的数组; 此数组包含一些略微自定义的图像视图。 ImageViewCard类继承自UIImageView并添加一个字符串属性标题来保存飓风标题，并添加一个名为didSelect的属性，以便您可以轻松地在图像上设置点击处理程序。

您的第一个任务是将所有图像添加到视图控制器的视图中。 将以下代码添加到viewDidAppear（_ :)的末尾：

```swift
for image in images {
    image.layer.anchorPoint.y = 0.0
    image.frame = view.bounds

    view.addSubview(image)
}
```



在上面的代码中，您循环遍历所有图像，在y轴上将每个图像的锚点设置为0.0，并调整每个图像的大小，使其占据整个屏幕。 完成后，您可以添加每个图像进行查看。

设置锚点可让图像围绕其上边缘而不是中心的默认值旋转，如下图所示：

![image-20181205113638430](https://ws1.sinaimg.cn/large/006tNbRwgy1fxvpsq3ekwj30d7068417.jpg)

这将使在3D空间中散布图像变得更加容易。
构建并运行您的项目，看看到目前为止您取得了哪些成就：



嗯 - 你只能看到你添加的最后一张图片。那是因为所有图像都有相同的帧，所以你只能看到你添加的最后一张图片：Hurricane Irene。

为了更明显地显示哪个飓风图像，请在viewDidAppear（_ :)的末尾添加以下行：

```swift
navigationItem.title = images.last?.title
```

此代码采用集合中最后一个飓风图像的名称，并将其设置为视图控制器的导航标题，如此。
建立并再次运行以熟悉艾琳：



请注意，您没有在图像上设置任何透视变换;您将直接在视图控制器的视图上设置透视图。
在上一章中，您在单个视图上调整了transform属性，然后在3D空间中旋转它。但是，由于您当前的项目有更多的个人视图，您需要在3D中操作，您可以设置其父视图的透视图，而不是为自己节省大量工作。
将以下代码添加到viewDidAppear（_ :)：

```swift
var perspective = CATransform3DIdentity
perspective.m34 = -1.0/250.0
view.layer.sublayerTransform = perspective
```

“在这里，您可以使用图层属性sublayerTransform来设置视图控制器图层的所有子图层的透视图。 然后将子层变换与每个单独层的自身变换组合。
这使您可以专注于管理子视图的旋转或平移，而无需担心透视。 您将在下一节中更详细地了解它的工作原理。

### 改变画廊

toggleGallery（_ :)连接到右侧的“浏览”栏按钮，您可以将3D变换应用于四个图像。
将以下变量添加到toggleGallery（_ :)：

```swift
var imageYOffset: CGFloat = 50.0

for subview in view.subviews {
    guard let image = subview as? ImageViewCard else {
        continue
    }
}
```

由于您不只是将所有图像旋转到原位而只是移动它们以产生”扇形“动画，因此您可以使用imageYOffset来设置每个图像的偏移。
接下来，您需要遍历所有图像并运行其各自的动画。

在这里，您循环浏览视图控制器视图的所有子视图，并仅对作为ImageViewCard实例的子视图执行操作。
在上面添加的`guard`块之后添加以下代码，以替换此处的更多代码注释：

```swift
var imageTransform = CATransform3DIdentity
// 1
imageTransform = CATransform3DTranslate(imageTransform, 0.0, imageYOffset, 0.0)
// 2
imageTransform = CATransform3DScale(imageTransform, 0.95, 0.6, 1.0)
// 3
imageTransform = CATransform3DRotate(imageTransform, .pi/8, -1.0, 0.0, 0.0)
```

首先将标识转换分配给imageTransform，然后对其添加一系列调整。 这是每个单独的调整对图像的作用：

1 使用CATransform3DTranslate在y轴上移动图像; 这会使图像偏离其默认的0.0 y坐标，如下所示：



之后，您将分别计算每个图像的imageYOffset; 现在所有图像移动的数量都相同，所以你现在仍然只能看到最顶层的图像。

2 通过使用CATransform3DScale调整变换的比例分量来缩放图像。 您可以在x轴上稍微缩小图像，但是在y轴上将其缩小到60％以丰富旋转3D效果：



3 最后，使用CATransform3DRotate将图像旋转22.5度，使其具有一些透视变形，如下所示：



请记住，您已经设置了锚点，因此图像围绕其顶部边缘旋转。

现在你看到通过view.layer.sublayerTransform设置上面的m34值的值; 您的旋转变换只需重新使用子层变换中的m34值，而无需在此处应用它。 那很方便！

现在剩下的就是将变换应用于每个图像。 添加以下行（仍在for body中）：

```swift
image.layer.transform = imageTransform
```



构建并运行您的项目; 点击“浏览”按钮查看转换结果：



同样，您只能看到顶部图像，因为它后面的所有其他图像都应用了相同的变换。 现在是为每个图像定制变换的绝佳机会。
将以下行添加到for块的末尾：

```swift
imageYOffset += view.frame.height / CGFloat(images.count)
```



这会调整每个图像的y偏移量，具体取决于它在堆栈中的位置。 您将屏幕高度除以图像数量，以便它们在屏幕上均匀分布。
构建并运行您的项目以查看您的视图：

![image-20181205115546758](https://ws2.sinaimg.cn/large/006tNbRwgy1fxvqcmw3j4j308w0fu0ym.jpg)

甜蜜 - 画廊看起来就像你想要的那样！ 但是因为这是一本关于动画的书，如果你没有动画过渡到扇形视图，那将是一种耻辱，不是吗？

### 动画画廊

在`image.layer.transform = imageTransform`的前面添加：

```swift
let animation = CABasicAnimation(keyPath: "transform")
animation.fromValue = NSValue(caTransform3D: image.layer.transform)
animation.toValue = NSValue(caTransform3D: imageTransform)
animation.duration = 0.33
image.layer.add(animation, forKey: nil)
```

这段代码非常熟悉：您可以在transform属性上创建一个图层动画，并将其从当前值设置为您之前设计的imageTransform。
再次构建和运行您的项目; 点击“浏览”按钮，欣赏完成的动画：

![](https://ws2.sinaimg.cn/large/006tNbRwgy1fxvqjb5gwig308q0fo49f.gif)

你现在已经完成了画廊; 当您在用户点击“浏览”按钮时添加关闭风扇的功能时，您将在“挑战”部分重新访问它。

### 将图像带到前面

在最后一节中，您将为图像库添加一些交互性：点击图像将使其在其他图像前跳转，以便用户可以更好地查看它。

ImageViewCard已经具有名为didSelect的闭包表达式属性; 当用户点击图像并将点击的图像视图作为输入参数接收时，它会触发。

要添加此功能，您将向ViewController添加一个方法，并将其分配给所有图像视图上的didSelect。
首先将以下代码添加到for循环体内的viewDidAppear（）：

```swift
image.didSelect = selectImage
```



Xcode会抱怨selectImage不存在，但你会在下一步中解决这个问题。
将以下方法添加到ViewController：

```swift
func selectImage(selectedImage: ImageViewCard) {

    for subview in view.subviews {
        guard let image = subview as? ImageViewCard else {
            continue
        }
        if image === selectedImage {

        } else {

        }
    }
}
```

这是selectImage（selectedImage :)的骨架; 当用户点击其中一个图像时，您可以遍历所有子视图并像以前一样获取ImageViewCard实例。 然后检查每个ImageViewCard以查看它是否是所选图像。

现在您还需要两个动画：一个用于为所选图像设置动画，另一个用于为图库中的所有其他图像设置动画。
你将反过来解决这个问题并首先淡出未选择的图像。

使用以下代码替换selectImage（selectedImage :)中的//任何其他图像注释：

```swift
UIView.animate(withDuration: 0.33, delay: 0.0, options: .curveEaseIn, animations: {
    image.alpha = 0.0
}, completion: { (_) in
    image.alpha = 1.0
    image.layer.transform = CATransform3DIdentity
})
```



这是一个淡出每个图像的简单动画。 在完成块中，将其变换重置为标识变换，将alpha重置为完全不透明。 到上述动画完成时，所选图像将位于所有其他图像的前面 - 如此透明或不透明，您将看不到任何未选择的图像。 在此处重置alpha可以避免在想要再次查看图像时重置它。

构建并运行您的项目; 打开画廊并点击图像，查看所有其他未选择的图像从视图中淡出。



当该动画完成后，视图会变回以全屏显示顶部图像 - 因为您没有对所选图像做任何事情！ 你现在就解决这个问题。
您可以将所选图像的变换设置为身份变换的动画，并在动画完成时将图像拉到前面。
使用以下代码替换selectImage（selectedImage :)中的//选定图像注释：

```swift
UIView.animate(withDuration: 0.33, delay: 0.0, options: .curveEaseIn, animations: {
    image.layer.transform = CATransform3DIdentity
}, completion: {_ in
    self.view.bringSubview(toFront: image)
})
```

在这里，你没有对动画进行3D变换，然后确保图像位于视图堆栈的顶部，以便它可见。
最后，将以下代码添加到selectImage（selectedImage :)的末尾：

```swift
self.navigationItem.title = selectedImage.title
```



这将使用当前选定的图像标题更新导航栏。
构建并运行您的项目; 点击各种图像以查看它们如何缩放到全屏。 它看起来怎么样？
我以为你会喜欢这个优雅的小动画！ 这是一个包装; 在下面的挑战部分中有一小部分功能可以清理，但除此之外，您还可以轻松获得令人惊叹的动画效果。 我怀疑你可以想到很多方法在你自己的项目中使用它！





### 使用”浏览“按钮切换图库

现在，用户打开图像后必须从图库中选择图像。 在此挑战中，您将使“浏览”按钮像切换一样工作以关闭图库视图。

向ViewController添加一个名为isGalleryOpen的新属性，并将其初始值设置为false。 您需要在代码中的几个位置更新此属性的值：

在toggleGallery（_ :)结束时将其设置为true
在selectImage（selectedImage :)结束时将其设置为false



在toggleGallery（）的顶部，添加一个检查以查看图库是否已打开。 如果是这样，则遍历所有图像并将其变换设置为原始值。 不要忘记重置isGalleryOpen并返回，因此其余的方法代码也不会执行。

```swift
if isGalleryOpen {
    for subview in view.subviews {
        guard let image = subview as? ImageViewCard else {
            continue
        }

        let animation = CABasicAnimation(keyPath: "transform")
        animation.fromValue = NSValue(caTransform3D: image.layer.transform)
        animation.toValue = NSValue(caTransform3D: CATransform3DIdentity)
        animation.duration = 0.33

        image.layer.add(animation, forKey: nil)
        image.layer.transform = CATransform3DIdentity

    }

    isGalleryOpen = false
    return
}
```



就是这样 - 如果你愿意，可以在这个项目中使用动画，看看你可以自己添加哪些其他华丽的元素！

本章的最后效果：

![](https://ws3.sinaimg.cn/large/006tNbRwgy1fxvr9roxswg308q0fo7wh.gif)