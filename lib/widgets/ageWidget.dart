
import 'package:flutter/material.dart';

class AgeWidget extends StatefulWidget {
  final DateTime date;
  final TextStyle textStyle;
  final String suffix;

  AgeWidget({Key key, @required this.date, this.textStyle, this.suffix = ''}) : super(key: key);

  _AgeWidgetState createState() => _AgeWidgetState();
}

class _AgeWidgetState extends State<AgeWidget> {
  String _ageString = '';

  @override
  void initState() {

    _ageString = _getAgeString();
    super.initState();
  }

  String _getAgeString() {
    Duration diff = DateTime.now().difference(widget.date);

    if(diff.inHours > 8766) {
      if((diff.inDays / 365).round() == 1) return 'One year';
      return (diff.inDays / 365).round().toString() + ' years';
    }
    if(diff.inHours > 24) {
      if(diff.inDays == 1) return 'One day';
      return diff.inDays.toString() + ' days';
    }
    if(diff.inMinutes > 60) {
      if(diff.inHours == 1) return 'One hour';
      return diff.inHours.toString() + ' hours';
    }
    if(diff.inMinutes == 1) return 'One minute';
    return diff.inMinutes.toString() + ' minutes';
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _ageString + widget.suffix,
      style: widget.textStyle ?? TextStyle()
    );
  }
}
