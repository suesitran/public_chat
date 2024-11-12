import 'package:flutter/cupertino.dart';

class MySwitchButton extends StatefulWidget {
  const MySwitchButton({super.key, this.onChange, this.toggle = false});
  final bool toggle;
  final Function(bool value)? onChange;

  @override
  State<MySwitchButton> createState() => _MySwitchButtonState();
}

class _MySwitchButtonState extends State<MySwitchButton> {
  // bool _toggle = false;
  // @override
  // void initState() {
  //   super.initState();
  //   _toggle = widget.init;
  //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
  //     setState(() {});
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    bool _toggle = widget.toggle;
    return CupertinoSwitch(
      // overrides the default green color of the track
      // activeColor: Colors.pink.shade200,
      // color of the round icon, which moves from right to left
      // thumbColor: Colors.green.shade900,
      // when the switch is off
      // trackColor: Colors.black12,
      // boolean variable value
      value: _toggle, //only do when not null
      // changes the state of the switch
      onChanged: (value) {
        setState(() {
          _toggle = value;
          print(_toggle);
        });
        widget.onChange?.call(value);
      },
    );
  }
}
