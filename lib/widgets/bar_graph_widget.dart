import 'package:customizable_fitness_tracker/const/constant.dart';
import 'package:customizable_fitness_tracker/model/bar_graph_model.dart';
import 'package:customizable_fitness_tracker/model/graph_model.dart';
import 'package:customizable_fitness_tracker/data/bar_graph_data.dart';
import 'package:flutter/material.dart';

class BarGraphCard extends StatelessWidget {
  const BarGraphCard({super.key});

  @override
  Widget build(BuildContext context) {
    final barData = BarGraphData();

    return
        Row(
          children: barData.data.map((barGraphModel) {
            return Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: cardBackgroundColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      barGraphModel.label,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 140,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: barGraphModel.graph.map((graph) {
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 1.5),
                              child: Container(
                                height: graph.y * 10.0,
                                decoration: BoxDecoration(
                                  color: barGraphModel.color,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: barData.label
                          .map((label) => Text(
                        label,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ))
                          .toList(),
                    )
                  ],
                ),
              ),
            );
          }).toList(),
    );
  }
}
