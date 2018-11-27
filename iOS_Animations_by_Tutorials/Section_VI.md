## Section VI: 3D Animations

到目前为止，你只使用了二维动画，并且有充分的理由 - 这是在平面设备屏幕上动画元素的最自然方式。 毕竟，平板后iOS 7世界中的按钮，文本字段，开关和图像没有第三维; 这些元素存在于由X和Y轴定义的平面中：

![](https://ws2.sinaimg.cn/large/006tNbRwgy1fx962j0d7jj309a03g0sj.jpg)

核心动画可以帮助您摆脱这个二维世界; 虽然它不是真正的3D框架，但Core Animation有很多智能可以帮助您在3D空间中定位二维对象。

换句话说，您的图层和动画仍然以二维方式进行，但您可以在3D空间中旋转和定位每个元素的2D平面，如下所示：

![](https://ws4.sinaimg.cn/large/006tNbRwgy1fx9630g50tj30ab04jdfv.jpg)

上面显示的是在3D空间中旋转的两个2D图像。 透视变形使您可以从渲染器的角度了解它们的位置。
本书的这一部分将向您展示如何在3D空间中定位和旋转图层。 您将使用CATransform3D的特殊属性：即，应用于图层的转换类。 CATransform3D类似于CGAffineTransform，但除了让你在x和y方向上缩放，倾斜和平移之外，它还带来了第三维：z。 z轴直接从设备屏幕朝向您的眼睛。
CATransform3D允许您确定渲染摄像机与设备屏幕相对应的位置; 这会影响Core Animation应用于视图的透视变形量。