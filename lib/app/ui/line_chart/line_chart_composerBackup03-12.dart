//Com gradiente
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:wifiscan/app/models/station.dart';

class LineChartComposer extends StatelessWidget {
  final Station station;

  LineChartComposer({this.station});

  @override
  Widget build(BuildContext context) {
    //avgChart
    //https://velog.io/@adbr/flutter-line-chart%EA%BA%BD%EC%9D%80%EC%84%A0-%EA%B7%B8%EB%9E%98%ED%94%84-%EA%B5%AC%ED%98%84%ED%95%98%EA%B8%B02-flutter-flchart-example

    return Container(
        child: station.listRSSI.isEmpty
            ? Container()
            : Container(
                width: double.infinity,
                height: 83,
                child: LineChart(
                  _mainData(),
                  swapAnimationDuration: const Duration(milliseconds: 200),
                ),
              ));
  }

  final List<Color> gradientColors = [
    const Color(0xffe1f5fe),
    const Color(0xff02d39a),
    const Color(0xff23b6e6),
    const Color(0xff4fc3f7),
  ];

  final List<Color> gradientColorsBar = [
    const Color(0xff02d39a),
    const Color(0xff02d39a),
    const Color(0xff23b6e6),
    const Color(0xff4fc3f7),
  ];

  static const dateTextStyle = TextStyle(
      fontSize: 10, color: Colors.blueGrey, fontWeight: FontWeight.bold);

  LineChartData _mainData() {
    return LineChartData(
      lineTouchData: LineTouchData(enabled: false),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xffecf1fe), width: 1)),
      lineBarsData: [
        LineChartBarData(
          // PONTOS DO GRÁFICO
          spots: assignSpots(),
          /*spots: [
            FlSpot(0, -73),
            FlSpot(1, -57),
            FlSpot(2, -55),
          ],*/

          isCurved: true,
          isStepLineChart: true,
          preventCurveOverShooting: true,
          barWidth: 1.5,
          colors: gradientColorsBar
              .map((color) => color.withOpacity(0.99))
              .toList(),
          belowBarData: BarAreaData(
            show: true,
            //colors: [Colors.orange.withOpacity(0.4)],
            colors:
                gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
          aboveBarData: BarAreaData(
            show: true,
            //colors: [Colors.white.withOpacity(0.4)],
            colors:
                gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
          dotData: FlDotData(
            show: false,
            getDotPainter: (spot, percent, barData, index) =>
                FlDotCirclePainter(
                    radius: 2,
                    color: Color(0xff23b6e6).withOpacity(0.9),
                    strokeWidth: 0,
                    strokeColor: Colors.white),
          ),
        ),
      ],
      minY: -100,
      maxY: -30,
      minX: 0,
      maxX: 99,
      // gráfico de 5 min
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
            showTitles: false,
            reservedSize: 0,
            getTextStyles: (value) => dateTextStyle,
            getTitles: (value) {}),
        leftTitles: SideTitles(
          interval: 20,
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
              color: Color(
                0xff7589a2,
              ),
              fontSize: 8),
          margin: 2,
          getTitles: (double value) {
            if (value % 10 == 0)
              return '${value.toInt()}';
          },
        ),
      ),
      axisTitleData: FlAxisTitleData(
        leftTitle: AxisTitle(
            showTitle: true,
            titleText: 'dBm',
            textStyle: dateTextStyle,
            textAlign: TextAlign.center,
            margin: -10),
      ),
      /*rangeAnnotations: RangeAnnotations(
        horizontalRangeAnnotations: [
          HorizontalRangeAnnotation(
            y1: -30,
            y2: -65,
            color: const Color(0xffEEF3FE),
          ),
        ],
      ),*/
      // grade
      gridData: FlGridData(
        show: true,
        checkToShowHorizontalLine: (double value) {
          return value == -40 || value == -60 || value == -80 || value == -100;
        },
      ),
    );
  }

  List<FlSpot> assignSpots() {
    List<FlSpot> mySpots = [];
    //print("station.listRSSI = ${station.listRSSI.toString()}");

    if (station.listRSSI.isNotEmpty) {
      for (int i = 0; i < station.listRSSI.length; i++) {
        mySpots.add(FlSpot((i * 1.0), ((station.listRSSI[i]))));
      }
    }
    return mySpots;
  }
}
