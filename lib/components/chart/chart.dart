import 'package:expense_tracker/components/chart/chart_bar.dart';
import 'package:expense_tracker/constants/dimens.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/models/expense_bucket.dart';
import 'package:flutter/material.dart';

class Chart extends StatelessWidget {
  const Chart({super.key, required this.expenses});

  final List<Expense> expenses;

  List<ExpenseBucket> get buckets {
    return [
      ExpenseBucket.forCategory(expenses, Category.food),
      ExpenseBucket.forCategory(expenses, Category.leisure),
      ExpenseBucket.forCategory(expenses, Category.travel),
      ExpenseBucket.forCategory(expenses, Category.work),
    ];
  }

  double get maximunExpense {
    var maximunValue = buckets
        .reduce((a, b) => a.totalExpenses > b.totalExpenses ? a : b)
        .totalExpenses;
    //to prevent divide by zero (occurs when there is no expenses)
    if (maximunValue == 0) maximunValue = 1;
    return maximunValue;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimens.padding),
      child: SizedBox(
        height: Dimens.chartHeight,
        child: Column(
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ...buckets.map((bucket) => ChartBar(
                      proportion: bucket.totalExpenses / maximunExpense))
                ],
              ),
            ),
            const SizedBox(height: Dimens.space),
            Row(
              children: [
                ...buckets.map(
                  (bucket) => Expanded(
                    child: Icon(
                      categoryIcons[bucket.category],
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.75),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
