import 'package:flutter/material.dart';

class DueDateField extends StatelessWidget{
  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;

  const DueDateField({
    super.key,
    required this.value,
    required this.onChanged,
  });

  Future<void> _pickDate(BuildContext context) async{
    final picked = await showDatePicker(
      context: context,
      initialDate: value ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if(picked != null) onChanged(picked);
  }

  @override
  Widget build(BuildContext context){
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.calendar_today),
      title:Text(
        value == null 
        ? 'Pick a due date'
        : '${value!.year}-${value!.month.toString().padLeft(2, '0')}-${value!.day.toString().padLeft(2, '0')}',
      ),
      trailing: value != null
      ? IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => onChanged(null),
      )
      : null,
      onTap: () => _pickDate(context),
    );
  }
}