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
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: "Search...",
                hintStyle: TextStyle(color: Colors.grey.shade600),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey.shade600,
                  size: 20,
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.all(8),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.check),
                  color: Colors.black,
                  onPressed: onSearchPressed,
                ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.grey.shade100)),
              ),
            ),
            // child: TextFormField(
            //   controller: controller,
            //   decoration: InputDecoration(
            //     filled: true,
            //     fillColor: Colors.white,
            //     hintText: 'Search',
            //     contentPadding: EdgeInsets.all(5),
            //     border: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(
            //         20.0,
            //       ), // Adjust the radius as needed
            //     ),
            //     suffixIcon: IconButton(
            //       icon: const Icon(Icons.check),
            //       color: Colors.black,
            //       onPressed: onSearchPressed,
            //     ),
            //   ),
            // ),
          ),
        ],
      ),
    );
  }
}

class SearchTextField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSearchPressed;

  const SearchTextField({
    super.key,
    required this.controller,
    required this.onSearchPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: "Search...",
        hintStyle: TextStyle(color: Colors.grey.shade600),
        prefixIcon: Icon(
          Icons.search,
          color: Colors.grey.shade600,
          size: 20,
        ),
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: const EdgeInsets.all(8),
        suffixIcon: IconButton(
          icon: const Icon(Icons.check),
          color: Colors.black,
          onPressed: onSearchPressed,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.grey.shade100),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
      ),
    );
  }
}
