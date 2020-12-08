import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:wifiscan/app/models/station.dart';

class BarChartComposer extends StatelessWidget {
  final Station station;
  static const double barWidth = 4;
  final Color barBackgroundColor = const Color(0xFFE1F5FE);

  int touchedIndex;

  BarChartComposer({this.station});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        //color: const Color(0xff2c4260).withOpacity(1),
          color: const Color(0xff4fc3f7).withOpacity(0.2),

          child: station.listRSSI.isEmpty
              ? Container()
              : Container(
            width: double.infinity,
            height: 83,
            child: BarChart(
              _mainData(),
              swapAnimationDuration: const Duration(milliseconds: 200),
            ),
          )),
    );
  }

  final List<Color> gradientColorsBar = [
    const Color(0xff02d39a),
    const Color(0xff02d39a),
    const Color(0xff4fc3f7),
    const Color(0xff23b6e6),
    const Color(0xFF0087FF),
  ];

  BarChartData _mainData() {
    return BarChartData(
      //backgroundColor: Colors.amber,
      alignment: BarChartAlignment.spaceAround, //center
      //maxY: 80,
      //minY: 0,
      groupsSpace: 12,
      barTouchData: BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.transparent,
          tooltipPadding: const EdgeInsets.all(-8), // -15
          tooltipBottomMargin: 0,
          getTooltipItem: (
              BarChartGroupData group,
              int groupIndex,
              BarChartRodData rod,
              int rodIndex,
              ) {
            return BarTooltipItem(
              rod.y.round().toString(),
              TextStyle(
                color: const Color(0xff2c4260).withOpacity(1),
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            );
          },
        ),
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            //backgroundColor: Colors.white,
              color: Color(0xff7589a2),
              fontWeight: FontWeight.bold,
              fontSize: 9),
          margin: -4, //-20
          getTitles: (double value) {
            switch (value.toInt()) {
              case 0:
                return '[-10   ...   -50]';
              case 1:
                return '[-51   ...   -60]';
              case 2:
                return '[-61   ...   -70]';
              case 3:
                return '  {-71   ...   -100]';
              default:
                return '';
            }
          },
        ),
        leftTitles: SideTitles(showTitles: false),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
    );
  }

  List<BarChartGroupData> showingGroups() => List.generate(4, (i) {

    switch (i) {
      case 0:
        return makeGroupData(0, station.listHistograma[0]);
      case 1:
        return makeGroupData(1, station.listHistograma[1]);
      case 2:
        return makeGroupData(2, station.listHistograma[2]);
      case 3:
        return makeGroupData(3, station.listHistograma[3]);
      default:
        return null;
    }
  });

  BarChartGroupData makeGroupData(
      int x,
      double y, {
        bool isTouched = false,
        Color barColor = Colors.orange,
        double width = barWidth,
        List<int> showTooltips = const [],
      }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: isTouched ? y + 1 : y,
          //colors: isTouched ? [Colors.yellow] : [barColor],
          //colors: [Colors.redAccent, Colors.red[800]],
          colors: gradientColorsBar.map((color) => color.withOpacity(0.99)).toList(),
          width: barWidth,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            y: y+20,
            colors: [barBackgroundColor],
          ),
        ),
      ],
      showingTooltipIndicators: [0],
    );
  }

}
