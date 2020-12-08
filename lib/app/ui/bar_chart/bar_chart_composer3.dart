import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:wifiscan/app/models/station.dart';

class BarChartComposer3 extends StatelessWidget {
  final Station station;
  static const double barWidth = 2.6;

  BarChartComposer3({this.station});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        //color: const Color(0xff2c4260),
        color: const Color(0xff4fc3f7).withOpacity(0.1),
        child: station.listRSSI.isEmpty
            ? Container()
            : Container(
                margin: EdgeInsets.only(top: 1, right: 2),
                padding: EdgeInsets.all(0),
                width: double.infinity,
                height: 82,
                child: BarChart(
                  _mainData(),
                  swapAnimationDuration: const Duration(milliseconds: 800),
                )),
      ),
    );
  }

  BarChartData _mainData() {
    return BarChartData(
      alignment: BarChartAlignment.spaceBetween,

      //TITULOS
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
            showTitles: true,
            //MARGEM INFERIOR
            reservedSize: 10,
            getTextStyles: (value) => const TextStyle(
                color: Color(
                  0xff7589a2,
                ),
                fontSize: 8),
            margin: 0,
            interval: 10,
            // ignore: missing_return
            getTitles: (value) {
              if (value % 5 == 0) {
                return (value.toInt()).toString();
              }
            }),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
              color: Color(
                0xff7589a2,
              ),
              fontSize: 8),
          margin: 2,
          //interval: 10,
          //checkToShowTitle: (minValue, maxValue, sideTitles, appliedInterval, value) => ,
          // ignore: missing_return
          getTitles: (double value) {
            return '${value.toInt()}';
            /*if (value % 10 == 0) {
               return (value.toInt()).toString();
            }*/
          },
        ),
      ),

      axisTitleData: FlAxisTitleData(
        leftTitle: AxisTitle(showTitle: true, margin: -15),
      ),

      gridData: FlGridData(
        show: true,
        checkToShowHorizontalLine: (value) => value % 100 == 0,
        checkToShowVerticalLine: (value) => value % 10 == 0,
        getDrawingHorizontalLine: (value) => FlLine(
          color: const Color(0xffe1f5fe),
          strokeWidth: 1,
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
    );
  }

  List<BarChartGroupData> showingGroups() {
    List<BarChartGroupData> grupoDados = [];
    for (int i = 1; i > -100; i--) {
      grupoDados.add(
        BarChartGroupData(
          x: i,
          barRods: BastoesRodData(i.toInt()),
          //barsSpace: 1,
          //showingTooltipIndicators: [0],
        ),
      );
    }
    return grupoDados;
  }

  List<BarChartRodData> BastoesRodData(int element) {
    List<BarChartRodData> bastaoDado = [];
    bastaoDado.add(
      BarChartRodData(
          //y: Random().nextInt(6000).toDouble() + 0,
          y: station.listHistograma100[element.abs().toInt()],
          width: barWidth,
          colors: [
            const Color(0xff02d39a),
            const Color(0xff4fc3f7),
            const Color(0xff23b6e6),
            const Color(0xFF0087FF),
          ]),
    );
    return bastaoDado;
  }
}
