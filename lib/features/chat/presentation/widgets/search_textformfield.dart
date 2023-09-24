import 'package:flutter/material.dart';

class SearchInputField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSearchPressed;

  const SearchInputField({
    Key? key, // Use Key? instead of super.key
    required this.controller,
    required this.onSearchPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(left: 2, top: 8, right: 2, bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25), // Apply BorderRadius here
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Search',
                contentPadding: EdgeInsets.all(5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    20.0,
                  ), // Adjust the radius as needed
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.check),
                  color: Colors.black,
                  onPressed: onSearchPressed,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
