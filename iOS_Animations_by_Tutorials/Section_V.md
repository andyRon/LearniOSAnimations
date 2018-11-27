## Section V: Animations with UIViewPropertyAnimator

`UIViewPropertyAnimator`  创建交互式，可中断的视图动画。

既然你在这本书中做到了这一点（巨大的恭喜），你已经知道如何利用Core Animation提供的大部分功能。由于UIKit中的所有API都包含了较低级别的功能，因此在查看`UIViewPropertyAnimator`时不会有太多惊喜。

但是，这个类确实使某些类型的视图动画更容易创建，因此绝对值得研究。
最值得注意的是，当您通过动画师运行动画时，您可以动态调整这些动画 - 您可以暂停，停止，反转和更改已经运行的动画的速度。

如上所述，您可以通过使用图层和视图动画的组合来完成上面提到的所有操作，但是UIViewPropertyAnimator可以在同一个类中方便地将多个API包装在一起，这样更容易使用。
此外，这个新类完全取代了UIView.animate（withDuration ...）API集和使用CAAnimation创建的动画，因此您仍然需要经常将这些与UIViewPropertyAnimator动画结合使用。

