import 'package:flutter/material.dart';

class ButtonWithPopup<T> extends StatefulWidget {
  const ButtonWithPopup(
      {
      // required this.onChanged,
      required this.items,
      this.onTap,
      required this.child});
  // final Function(T) onChanged;
  final List<DropdownMenuItem<T>> items;
  final Widget child;
  final Function()? onTap;
  @override
  _ButtonWithPopupState<T> createState() => _ButtonWithPopupState<T>();
}

class _ButtonWithPopupState<T> extends State<ButtonWithPopup<T>> {
  String? selectedItem;
  final LayerLink _layerLink = LayerLink();

  void _onDropdownTap() async {
    print('onDropdownTap');
    // Khi đã có dữ liệu, hiển thị dropdown items
    if (widget.items.isNotEmpty) {
      print('items không rỗng');
      _showOverlay(); //ko do day
    } else {
      print('items rỗng');
      // MsgDialog.showError(msg: 'Không tải được dữ liệu!');
    }
  }

  final GlobalKey _key = GlobalKey();
  OverlayEntry? _overlayEntry;
  void _showOverlay() {
    print('show overlay');
//null check
    final renderBox = _key.currentContext!.findRenderObject() as RenderBox;
    final size = renderBox.size;
    print('size (dropdownNoFetchItems): $size');
    final position = renderBox.localToGlobal(Offset.zero);

    // Tính chiều cao của popup dựa trên số lượng items
    double popupHeight = widget.items.length * 50.0; // Giả sử mỗi item cao 58px
    // final offset = renderBox.localToGlobal(Offset.zero);
    // Lấy chiều cao màn hình
    // Tính khoảng cách từ vị trí widget đến mép trên
    double distanceToTop = position.dy;

    // Tính khoảng cách offset để giữ popup cách mép trên 100 pixels nếu cần thiết
    double offsetY = -popupHeight;
    if (distanceToTop - popupHeight < 20) {
      //cach mep tren man hinh 20
      offsetY = -distanceToTop + 20;
    }
    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          GestureDetector(
            onTap: () {
              _removeOverlay(); // Call this when tapping outside
            },
            child: Container(
              color: Colors.transparent, // Transparent barrier
            ),
          ),
          Positioned(
            // left: offset.dx,
            // top: offset.dy + size.height,
            width: size.width,
            //        width: _key.currentContext!.size!.width,
            child: CompositedTransformFollower(
              //để popup luôn di chuyển theo field khi cuộn
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(0, offsetY),
              // offset: Offset(0, -popupHeight),
              // offset: Offset(0, _key.currentContext!.size!.height),
              child: Material(
                elevation: 2.0,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: popupHeight, // Đặt chiều cao tối đa của popup
                  ),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    children: widget.items.map((item) {
                      return SizedBox(
                        height: 50,
                        child: ListTile(
                          title: item.child,
                          onTap: () {
                            item.onTap?.call();
                            // setState(() {
                            //   selectedItem = (item.child as Text).data;
                            // });
                            // if (item.value != null) {
                            //   widget.onChanged(item.value!);
                            // }
                            _removeOverlay();
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    // const lightgrey = const Color.fromRGBO(237, 237, 237, 1);
    // const darkgrey = const Color.fromRGBO(104, 102, 102, 1);
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
          key: _key,
          onTap: widget.onTap,
          onLongPress: _onDropdownTap,
          behavior: HitTestBehavior.opaque,
          onTapDown: (details) {
            if (_overlayEntry != null) {
              _removeOverlay();
            }
          }, // Điều khiển khi tap vào dropdown
          child: Material(
            child: widget.child,
          )),
    );
  }
}
