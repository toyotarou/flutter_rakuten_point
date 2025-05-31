

class Utility {
  // ///
  // Color getYoubiColor({required String date, required String youbiStr, required Map<String, String> holidayMap}) {
  //   Color color = Colors.black.withOpacity(0.2);
  //
  //   switch (youbiStr) {
  //     case 'Sunday':
  //       color = Colors.redAccent.withOpacity(0.2);
  //
  //     case 'Saturday':
  //       color = Colors.blueAccent.withOpacity(0.2);
  //
  //     default:
  //       color = Colors.black.withOpacity(0.2);
  //   }
  //
  //   if (holidayMap[date] != null) {
  //     color = Colors.greenAccent.withOpacity(0.2);
  //   }
  //
  //   return color;
  // }
  //
  // ///
  // List<LineTooltipItem> getGraphToolTip(List<LineBarSpot> touchedSpots) {
  //   final List<LineTooltipItem> list = <LineTooltipItem>[];
  //
  //   for (final LineBarSpot element in touchedSpots) {
  //     final TextStyle textStyle = TextStyle(
  //       color: element.bar.gradient?.colors.first ?? element.bar.color ?? Colors.blueGrey,
  //       fontWeight: FontWeight.bold,
  //       fontSize: 12,
  //     );
  //
  //     final String price = element.y.round().toString().split('.')[0].toCurrency();
  //
  //     list.add(LineTooltipItem(price, textStyle, textAlign: TextAlign.end));
  //   }
  //
  //   return list;
  // }
  //
  // ///
  // FlGridData getFlGridData() {
  //   const FlLine flline = FlLine(color: Colors.white30, strokeWidth: 1);
  //
  //   return FlGridData(
  //     verticalInterval: 1,
  //
  //     //横線
  //     getDrawingHorizontalLine: (double value) => flline,
  //
  //     //縦線
  //     getDrawingVerticalLine: (double value) => flline,
  //   );
  // }
}
