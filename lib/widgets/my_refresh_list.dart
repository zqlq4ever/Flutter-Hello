import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hello_flutter/res/gaps.dart';
import 'package:hello_flutter/res/styles.dart';
import 'package:hello_flutter/util/theme_util.dart';

/// 封装下拉刷新与加载更多
class RefreshListView extends StatefulWidget {
  const RefreshListView({
    Key? key,
    required this.itemCount,
    required this.itemBuilder,
    required this.onRefresh,
    this.loadMore,
    this.hasMore = false,
    this.pageSize = 10,
    this.padding,
    this.itemExtent,
  }) : super(key: key);

  final RefreshCallback onRefresh;
  final LoadMoreCallback? loadMore;
  final int itemCount;
  final bool hasMore;
  final IndexedWidgetBuilder itemBuilder;

  /// 一页的数量，默认为 10
  final int pageSize;

  /// padding 属性使用时注意会破坏原有的 SafeArea，需要自行计算 bottom 大小
  final EdgeInsetsGeometry? padding;
  final double? itemExtent;

  @override
  _RefreshListViewState createState() => _RefreshListViewState();
}

typedef RefreshCallback = Future<void> Function();
typedef LoadMoreCallback = Future<void> Function();

class _RefreshListViewState extends State<RefreshListView> {
  /// 是否正在加载数据
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final Widget child = RefreshIndicator(
      onRefresh: widget.onRefresh,
      child: widget.itemCount == 0
          ? Text('页面不存在')
          : ListView.builder(
              itemCount: widget.loadMore == null ? widget.itemCount : widget.itemCount + 1,
              padding: widget.padding,
              itemExtent: widget.itemExtent,
              itemBuilder: (BuildContext context, int index) {
                /// 不需要加载更多则不需要添加 FootView
                if (widget.loadMore == null) {
                  return widget.itemBuilder(context, index);
                } else {
                  return index < widget.itemCount
                      ? widget.itemBuilder(context, index)
                      : MoreWidget(widget.itemCount, widget.hasMore, widget.pageSize);
                }
              },
            ),
    );
    return SafeArea(
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification note) {
          /// 确保是垂直方向滚动，且滑动至底部
          if (note.metrics.pixels == note.metrics.maxScrollExtent &&
              note.metrics.axis == Axis.vertical) {
            _loadMore();
          }
          return true;
        },
        child: child,
      ),
    );
  }

  Future<void> _loadMore() async {
    if (widget.loadMore == null) {
      return;
    }
    if (_isLoading) {
      return;
    }
    if (!widget.hasMore) {
      return;
    }
    _isLoading = true;
    await widget.loadMore?.call();
    _isLoading = false;
  }
}

class MoreWidget extends StatelessWidget {
  const MoreWidget(this.itemCount, this.hasMore, this.pageSize, {Key? key}) : super(key: key);

  final int itemCount;
  final bool hasMore;
  final int pageSize;

  @override
  Widget build(BuildContext context) {
    final TextStyle style =
        context.isDark ? TextStyles.textGray14 : const TextStyle(color: Color(0x8A000000));
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          if (hasMore) const CupertinoActivityIndicator(),
          if (hasMore) Gaps.hGap5,

          /// 只有一页的时候，就不显示 FooterView 了
          Text(hasMore ? '正在加载中...' : (itemCount < pageSize ? '' : '没有了哦~'), style: style),
        ],
      ),
    );
  }
}
