# 系统学习iOS动画之二：自动布局

**自动布局(Auto Layout)** 在iOS 6中首次推出，已经存在了一段时间，每次发布新版本的iOS和Xcode都经历了一系列成功的迭代。

**自动布局**背后的核心理念非常简单：它允许您根据布局中的每个元素之间创建的关系来定义应用程序的UI元素的布局。

我们平常开发时已将自动布局用于静态的布局，在本文中将学习使用约束来设置动画。



## 6-自动布局的介绍

本章节是用自动布局完成下一章节需要使用的项目**Packing List** 。关于自动布局，可参考我之前的文章[开始用Swift开发iOS 10 - 3 介绍Auto Layout](http://andyron.com/2017/beginning-ios-swift-3.html)，这里就不重复了。



## 7-约束动画

**约束动画(Animating Constraints)**并不比属性动画困难; 它只是有点不同。 通常，只需使用新约束替换现有约束，然后让**Auto Layout**为两个状态之间的UI设置动画就可以了。



### 设置约束动画

[开始项目](README.md#关于代码)**Packing List**大概如下：

![](https://ws3.sinaimg.cn/large/006tNbRwgy1fxcjf2es69j30et07nglp.jpg)



#### 导航栏高度变化

在`ViewController`中添加约束接口：

```swift
@IBOutlet weak var menuHeightConstraint: NSLayoutConstraint!
```

并让它与导航栏视图的高度约束关联：

![](https://ws2.sinaimg.cn/large/006tNbRwgy1fxcjoqulgej31ak0tsq4n.jpg)



在右上角加号按钮的Action方法`actionToggleMenu()`中添加：

```swift
isMenuOpen = !isMenuOpen
menuHeightConstraint.constant = isMenuOpen ? 200.0 : 60.0
titleLabel.text = isMenuOpen ? "Select Item" : "Packing List”
```

点击加号按钮后导航栏高度变大，并且title变化。

#### 布局变化的动画

继续在`actionToggleMenu()`添加布局变化的弹簧动画：

```swift
UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 10.0, options: .curveEaseIn, animations: {
    // 强制更新布局
    self.view.layoutIfNeeded()
}, completion: nil)
```

 在`menuHeightConstraint.constant = isMenuOpen ? 200.0 : 60.0`已经更新了约束值，但iOS还没有机会更新布局。通过从动画闭包中调用`layoutIfNeeded()`强制更新布局，可以设置布局中涉及的每个视图的中心和边界。比如table view也随着Menu的收缩或增大而收缩或增大，这就是约束的效果，现在相当于一次设置两个动画😊。

效果：

![](https://ws3.sinaimg.cn/large/006tNbRwgy1fxck453c9tg308m06lgon.gif)


#### 旋转

让`+`旋转45°变成`x`在上面的动画闭包中添加：

```swift
let angle: CGFloat = self.isMenuOpen ? .pi/4 : 0.0
self.buttonMenu.transform = CGAffineTransform(rotationAngle: angle)
```



### 查看约束

直接用可视化的方式为视图约束添加代码接口（outlet）是相对简单的方式。有的时候不方便在Interfa Builder使用**Control-drag**方式添加接口或者不方便添加有太多outlet，这时可以利用`UIView`提供的`constraints`属性，它是当前视图所有约束的数组。

比如下面代码：

```swift
titleLabel.superview?.constraints.forEach { constraint in
    print("-> \(constraint.description)\n")
}
```

打印结果：

```swift
-> <NSLayoutConstraint:0x600002d04320 UIView:0x7ff7df530c00.height == 200   (active)>

-> <NSLayoutConstraint:0x600002d02210 UILabel:0x7ff7df525350'Select Item'.centerX == UIView:0x7ff7df530c00.centerX   (active)>

-> <NSLayoutConstraint:0x600002d02a30 UILabel:0x7ff7df525350'Select Item'.centerY == UIView:0x7ff7df530c00.centerY + 5   (active)>

-> <NSLayoutConstraint:0x600002d02d00 H:[UIButton:0x7ff7df715d20'+']-(8)-|   (active, names: '|':UIView:0x7ff7df530c00 )>

-> <NSLayoutConstraint:0x600002d030c0 UIButton:0x7ff7df715d20'+'.centerY == UILabel:0x7ff7df525350'Select Item'.centerY   (active)>
```

看上去有点乱，不过仔细看还是能看出有五个约束分别对应于：

![](https://ws3.sinaimg.cn/large/006tNbRwgy1fw8o6ki0mtj30lm0g6q37.jpg)



### 设置UILabel的约束动画

在 `actionToggleMenu()`的`isMenuOpen = !isMenuOpen`下添加：

```swift
titleLabel.superview?.constraints.forEach { constraint in
	if constraint.firstItem === titleLabel && constraint.firstAttribute == .centerX {
    	constraint.constant = isMenuOpen ? -100.0 : 0.0
        return
    }
}                              
```

约束表达式的通用形式如下：

```
firstItem.firstItemAttribute == secondItem.secondItemAttribute * multiplier + constant
```

对应于 `NSLayoutConstraint`的各种属性，名字看着很明显，其中`==`对应于属性`relation`，当然也可以是`<=`、`>=`等。

![](https://ws1.sinaimg.cn/large/006tNbRwgy1fxd5otisznj30ws0jgjwi.jpg)

实际例子：

```swift
Superview.CenterX = 1.0 * UILabel.CenterX + 0.0
```

这边的效果：



![](https://ws4.sinaimg.cn/large/006tNbRwgy1fw8ok05sq2g308q0frafs.gif)



### 替代约束 

每个约束可以添加 `Identifier`属性，在代码中就可以通过 `Identifier`获取这个约束。



![image-20181015101142175](https://ws2.sinaimg.cn/large/006tNbRwgy1fxd8wuzg5tj31jk0scdkm.jpg)

继续在上面的约束后添加：

```swift
if constraint.identifier == "TitleCenterY" {
    constraint.isActive = false
    let newConstraint = NSLayoutConstraint(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: titleLabel.superview!, attribute: .centerY, multiplier: isMenuOpen ? 0.67 : 1.0, constant: 5.0)
    newConstraint.identifier = "TitleCenterY"
    newConstraint.isActive = true
    return
}
```



新加的约束可以表示为`Title.CenterY = Menu.CenterY * 0.67 + 0.0`，图示：

![image-20181015101900852](https://ws4.sinaimg.cn/large/006tNbRwgy1fxd8x38aexj30a405fq30.jpg)

运行后效果：

![](https://ws4.sinaimg.cn/large/006tNbRwgy1fw8p3arxskg308s0fntcl.gif)



### 添加导航栏内容

在 `actionToggleMenu()`中添加：

```swift
if isMenuOpen {
    slider = HorizontalItemList(inView: view)
    slider.didSelectItem = { index in
                            print("add \(index)")
                            self.items.append(index)
                            self.tableView.reloadData()
                            self.actionToggleMenu(self)
                           }
    self.titleLabel.superview!.addSubview(slider)
} else {
    slider.removeFromSuperview()
}
```



`HorizontalItemList`是自定义的一个`UIScrollView`子类，用于menu中左右滚动的视图，



![](https://ws4.sinaimg.cn/large/006tNbRwgy1fw8pe0psf2g308s0fn4lk.gif)

### 动态创建视图

当点击TableView的cell时，会调用`showItem(_:)`，在这个方法中添加：

```swift
// 点击后创造图片
let imageView = UIImageView(image: UIImage(named: "summericons_100px_0\(index).png"))
imageView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
imageView.layer.cornerRadius = 5.0
imageView.layer.masksToBounds = true
imageView.translatesAutoresizingMaskIntoConstraints = false
view.addSubview(imageView)
```

添加约束代码：

```swift
let conx = imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
```

此方法使用新的`NSLayoutAnchor`类，这使得创建常见约束非常容易。 在这里，您将在图像视图的中心x锚点和视图控制器的视图之间创建约束。

添加图片底部约束：

```swift
let conBottom = imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: imageView.frame.height)
```

此约束设置图像视图的底部以匹配视图控制器视图的底部，加上图像高度; 这会将图像定位在屏幕底部边缘之外，这将作为动画的起点。

添加图片宽度约束：

```swift
let conWidth = imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.33, constant: -50.0)
```

这将图像宽度设置为屏幕宽度的1/3减去50磅。 目标尺寸是屏幕的1/3; 你将动画50磅的差异，使图像“成长”到位。

最后，添加高度和宽度相等约束，并激活上面所有约束：

```swift
let conHeight = imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
NSLayoutConstraint.activate([conx, conBottom, conWidth, conHeight])
```


此时点击TableView的Cell，只能看到下面：

![](https://ws4.sinaimg.cn/large/006tNbRwgy1fxd80nixp6j308g03o0sj.jpg)



### 为动态创建的视图创建动画

在`showItem(_:)`添加：

```swift
UIView.animate(withDuration: 0.8, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.0, animations: {
    conBottom.constant = -imageView.frame.size.height/2
    conWidth.constant = 0.0
    self.view.layoutIfNeeded()
}, completion: nil)
```

但是此时的效果是：

![](https://ws3.sinaimg.cn/large/006tNbRwgy1fw8pwyg73og308s0fnjw3.gif)



**想一想：**添加了一个视图，设置了一些约束，然后改变了这些约束并设置了布局变化的动画。 但是，视图从未有机会执行其初始布局，因此图像从其左上角的`(0, 0)`的默认位置开始🙄。

要解决此问题，只要在动画开始之前进行初始布局，在动画前添加：

```swift
view.layoutIfNeeded()
```

效果变成从下面上来：

![](https://ws1.sinaimg.cn/large/006tNbRwgy1fw8q0dbfjcg308s0fndid.gif)



### 移出已经出现的图片

上面的弹出图片会重叠在一起，下个图片出来之前，需要把上一个图片移出。

在之前的代码下添加：

```swift
UIView.animate(withDuration: 0.8, delay: 1.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.0, animations: {
            conBottom.constant = imageView.frame.size.height
            conWidth.constant = -50.0
            self.view.layoutIfNeeded()
        }) { (_) in
            imageView.removeFromSuperview()
        }
```

效果为：😝

![](../images/LearniOSAnimations-004.gif)

