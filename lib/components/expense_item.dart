import 'package:expense_tracker/constants/dimens.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';

class ExpenseItem extends StatelessWidget {
  const ExpenseItem({super.key, required this.expense});

  final Expense expense;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Dimens.padding),
        child: Column(children: [
          Text(expense.title),
          const SizedBox(height: Dimens.space),
          Row(
            children: [
              Text('\$${expense.amount.toStringAsFixed(2)}'),
              const Spacer(),
              Row(
                children: [
                  Icon(categoryIcons[expense.category]),
                  const SizedBox(width: Dimens.space),
                  Text(expense.formatedDate)
                ],
              )
            ],
          )
        ]),
      ),
    );
  }
}
