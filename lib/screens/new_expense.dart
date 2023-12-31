import 'package:expense_tracker/constants/dimens.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/utils/utils.dart';
import 'package:flutter/material.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _seletedCategory = Category.leisure;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: firstDate,
        lastDate: now);

    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _submitExpenseData() {
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;
    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null) {
      showSimpleDialog(
          context: context,
          title: 'Invalid input',
          content:
              'Please make sure a valid title, amount, date and category was entered.');
      return;
    }

    widget.onAddExpense(Expense(
        title: _titleController.text,
        amount: enteredAmount,
        date: _selectedDate!,
        category: _seletedCategory));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    final titleInputWidget = TextField(
      maxLength: 50,
      keyboardType: TextInputType.text,
      decoration: const InputDecoration(label: Text('Title')),
      autocorrect: true,
      textCapitalization: TextCapitalization.sentences,
      controller: _titleController,
    );

    final amountInputWidget = TextField(
      maxLength: 15,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: const InputDecoration(
        label: Text('Amount'),
        prefix: Text('\$'),
      ),
      controller: _amountController,
    );

    final dateInputWidget = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(_selectedDate == null
            ? 'No date selected'
            : formatter.format(_selectedDate!)),
        IconButton(
            onPressed: _presentDatePicker,
            icon: const Icon(Icons.calendar_month))
      ],
    );

    final categoryInputWidget = DropdownButton(
        value: _seletedCategory,
        items: Category.values
            .map((category) => DropdownMenuItem(
                  value: category,
                  child: Text(category.name.toUpperCase()),
                ))
            .toList(),
        onChanged: (value) {
          setState(() {
            if (value == null) return;
            _seletedCategory = value;
          });
        });

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        return SizedBox(
          height: screenHeight,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                Dimens.padding,
                Dimens.padding,
                Dimens.padding,
                Dimens.padding + keyboardSpace,
              ),
              child: Column(
                children: [
                  if (width > Dimens.maxPortraitWidth)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: titleInputWidget),
                        const SizedBox(width: Dimens.padding),
                        Expanded(child: amountInputWidget)
                      ],
                    )
                  else
                    titleInputWidget,
                  if (width > Dimens.maxPortraitWidth)
                    Row(
                      children: [
                        Expanded(child: categoryInputWidget),
                        const SizedBox(width: Dimens.padding),
                        dateInputWidget
                      ],
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          child: amountInputWidget,
                        ),
                        Expanded(
                          child: dateInputWidget,
                        ),
                      ],
                    ),
                  const SizedBox(height: Dimens.padding),
                  Row(
                    children: [
                      if (width <= Dimens.maxPortraitWidth) categoryInputWidget,
                      const Spacer(),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel')),
                      ElevatedButton(
                          onPressed: _submitExpenseData,
                          child: const Text('Save Expense'))
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
