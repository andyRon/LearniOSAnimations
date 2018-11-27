# Sction II: 自动布局(Auto Layout)

**Auto Layout(自动布局)**已经存在了一段时间 - 它首次在iOS 6中推出，并且每次发布iOS和Xcode都经历了一系列成功的迭代。
**Auto Layout**背后的核心理念非常简单：它允许您根据您在布局中的每个元素之间创建的关系来定义应用程序的UI元素的布局。

虽然您可能已将自动布局用于静态布局，但您将超越本节中的内容并使用代码中的约束来设置它们的动画！
您需要比一般的iOS开发人员更好地理解自动布局范例，以便使您的动画与自动布局很好地配合。
幸运的是，您会发现在代码中使用Auto Layout约束并不像最初听起来那么难，并且在您完成一些示例后，这是一个相当简单的过程。



**Packing List**



## Chapter 6: Intorduction to Auto Layout(自动布局的介绍) 



Once you place your app in the hands of Auto Layout, you no longer set the bounds, frame or center properties of a view. If you were to try, UIKit will force a layout pass on your UI using Auto Layout, which will set everything back to the positions and sizes determined by your constraints.

将应用程序置于自动布局之后，您将不再设置视图的边界，框架或中心属性。 如果你要尝试，UIKit将使用自动布局强制在UI上进行布局传递，这将把所有内容都设置回由约束决定的位置和大小。

使用原书对应章节的开始项目

### 创建项目Packing List

- 添加一个UIView当作navigation bar，高度为60，背景色选择**Group Table View Background Color **；添加一个UILabel作为title，添加一个UIButton。
- 添加一个UITableView和一个UITableViewCell
- 



Resoling Auto Layout issues

Aligning views with Auto Layout



## Chapter 7: 约束动画(Animating Constraints)

约束动画并不比属性动画困难; 它只是有点不同。 通常，您只需使用新约束替换现有约束，然后让**Auto Layout**为两个状态之间的UI设置动画。





上一章的成果：

![](https://ws3.sinaimg.cn/large/006tNbRwgy1fxcjf2es69j30et07nglp.jpg)





`NSLayoutConstraint` 类代表IB各种约束。



添加约束接口：

`@IBOutlet weak var menuHeightConstraint: NSLayoutConstraint!`

让它与导航栏视图的高度约束关联。

![](https://ws2.sinaimg.cn/large/006tNbRwgy1fxcjoqulgej31ak0tsq4n.jpg)



- 在`actionToggleMenu()`添加：

  ```swift
  isMenuOpen = !isMenuOpen
  menuHeightConstraint.constant = isMenuOpen ? 200.0 : 60.0
  titleLabel.text = isMenuOpen ? "Select Item" : "Packing List”
  ```


### Animating layout changes

 By calling `layoutIfNeeded()` from within the animation closure, you set the center and bounds of every view involved in the layout. 

- 继续在`actionToggleMenu()`添加布局变化的弹簧动画：

  ```swift
          isMenuOpen = !isMenuOpen
          menuHeightConstraint.constant = isMenuOpen ? 200.0 : 60.0
          titleLabel.text = isMenuOpen ? "Select Item" : "Packing List"
          
          UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 10.0, options: .curveEaseIn, animations: {
              // 强制更新布局
              self.view.layoutIfNeeded()
          }, completion: nil)
  ```

  在`menuHeightConstraint.constant = isMenuOpen ? 200.0 : 60.0`已经更新了约束值，但iOS还没有机会更新布局。通过从动画闭包中调用`layoutIfNeeded()`强制更新布局，可以设置布局中涉及的每个视图的中心和边界。比如table view也随着Menu的收缩或增大而收缩或增大，这就是约束的效果，现在相当于一次设置两个动画😊。

  效果：

  ![](https://ws3.sinaimg.cn/large/006tNbRwgy1fxck453c9tg308m06lgon.gif)


### Rotating view animations

让`+`旋转45°变成`x`在动画闭包中继续添加：

```swift
let angle: CGFloat = self.isMenuOpen ? .pi/4 : 0.0
self.buttonMenu.transform = CGAffineTransform(rotationAngle: angle)
```



### Insecting and animating constraints

以视觉方式使用插座是连接插座的一种相对简单的方法，但有时您无法使用Interface Builder将UI的所有部分连接到插座。 您可以从代码中添加约束，或者您可能只是不想按住Control并拖动并创建大量的插座！
在这些情况下，您需要在运行时检查现有约束，并在代码中修改要设置动画的约束。
幸运的是，UIView类有一个名为constraints的属性，它为您提供了影响给定视图的所有约束的列表。 这有多方便？

有时不能通过IB来实现outlets之间的约束，不想使用**Control-drag**方式添加大量的约束outlets。

直接用可视化的方式为视图约束添加代码接口（outlet）是相对简单的方式。有的时候不方便在Interfa Builder使用**Control-drag**方式添加接口，这时可以利用`UIView`提供的`constraints`属性，它是当前视图所有约束的数组。

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

看上去有点乱，不过仔细看还是能看出五个约束对应于：

![](https://ws3.sinaimg.cn/large/006tNbRwgy1fw8o6ki0mtj30lm0g6q37.jpg)



### Animating UILabel constraints

在 `actionToggleMenu()`的`isMenuOpen = !isMenuOpen`下添加：

```swift
        titleLabel.superview?.constraints.forEach { constraint in
            if constraint.firstItem === titleLabel &&
                constraint.firstAttribute == .centerX {
                constraint.constant = isMenuOpen ? -100.0 : 0.0
                return
            }
        }                              
```

约束表达式的通用形式如下：

```
firstItem.firstItemAttribute == secondItem.secondItemAttribute * multiplier + constant
```

对赢于 `NSLayoutConstraint`的各种属性，其中`==`对应于属性`relation`，当然也可以是`<=`、`>=`等。

![](https://ws1.sinaimg.cn/large/006tNbRwgy1fxd5otisznj30ws0jgjwi.jpg)

实际例子：

```swift
Superview.CenterX = 1.0 * UILabel.CenterX + 0.0
```

这边的效果：



![](https://ws4.sinaimg.cn/large/006tNbRwgy1fw8ok05sq2g308q0frafs.gif)



### 替代约束 

每个约束可以添加 `Identifier`，在代码中就可以通过这个 `Identifier`获取约束。



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



### Adding menu content

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

### Animating dynamically created views(动态创建视图)

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

- 添加约束代码：

  ```swift
  let conx = imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
  ```

  此方法使用新的`NSLayoutAnchor`类，这使得创建常见约束非常容易。 在这里，您将在图像视图的中心x锚点和视图控制器的视图之间创建约束。

- 添加图片底部约束：

  ```swift
  let conBottom = imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: imageView.frame.height)
  ```

  此约束设置图像视图的底部以匹配视图控制器视图的底部，加上图像高度; 这会将图像定位在屏幕底部边缘之外，这将作为动画的起点。

- 添加图片宽度约束：

  ```swift
  let conWidth = imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.33, constant: -50.0)
  ```

  这将图像宽度设置为屏幕宽度的1/3减去50磅。 目标尺寸是屏幕的1/3; 你将动画50磅的差异，使图像“成长”到位。

- 最后，添加高度和宽度相等约束，并激活上面所有约束：

  ```swift
  let conHeight = imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
  NSLayoutConstraint.activate([conx, conBottom, conWidth, conHeight])
  ```


此时点击TableView的Cell，还只能看到下面：

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



**想一想：**你添加了一个视图，设置了一些约束，然后改变了这些约束并设置了布局变化的动画。 但是，视图从未有机会执行其初始布局，因此您的图像从其左上角的`(0, 0)`的默认位置开始。

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

![](https://ws1.sinaimg.cn/large/006tNbRwgy1fw8qbtmmeag308s0fnafk.gif)

