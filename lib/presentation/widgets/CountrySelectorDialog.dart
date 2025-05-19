import 'package:flutter/material.dart';
import 'package:my_demo_app/const/colors.dart';

class CountrySelectorDialog extends StatefulWidget {
  final List<String> countries;
  final String? initial;
  final ValueChanged<String> onSelected;

  const CountrySelectorDialog({
    super.key,
    required this.countries,
    this.initial,
    required this.onSelected,
  });

  @override
  State<CountrySelectorDialog> createState() => _CountrySelectorDialogState();
}

class _CountrySelectorDialogState extends State<CountrySelectorDialog> {
  late List<String> filtered;
  String query = '';

  @override
  void initState() {
    super.initState();
    filtered = widget.countries;
  }

  void filterCountries(String input) {
    setState(() {
      query = input;
      filtered =
          widget.countries
              .where((c) => c.toLowerCase().contains(input.toLowerCase()))
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.background,
      title: Text(
        'Select Country',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Search...',
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 2,
                ),
              ),
            ),

            onChanged: filterCountries,
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 300,
            width: double.maxFinite,
            child:
                filtered.isEmpty
                    ? const Center(child: Text('No matches'))
                    : ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(filtered[index]),
                          onTap: () {
                            widget.onSelected(filtered[index]);
                            Navigator.of(context).pop();
                          },
                        );
                      },
                    ),
          ),
        ],
      ),
      actions: [
        ElevatedButton.icon(
          onPressed: () => Navigator.pop(context),
          label: const Text('Cancel'),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: AppColors.primaryDark,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
      ],
    );
  }
}
