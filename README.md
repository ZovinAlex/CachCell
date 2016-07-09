# CachCell
###在项目中经常需要做清除缓存的功能，但是很可能没有考虑全面，造成一些BUG，这里写了一个比较全面的清除缓存功能

1.具体功能

可以查询文件夹大小，也可以查询文件大小，当查询文件较大时，会有一个查询动画，当查询结束后，会变成可点击状态，点击清除缓存和清除完成时都有提示，计算和清除都是在子线程中进行，不会卡死主线程


2.如何使用？

将分类和特殊的缓存Cell拖入到你的工程中即可，其他请参考Demo

3.注意事项

这是单独做的一个Cell，复用的时候需要单独的标识符，不能当做常规Cell处理


![image](http://ww3.sinaimg.cn/large/006aAFlvgw1f5nmwwdyiog30b80kwq5b.gif)