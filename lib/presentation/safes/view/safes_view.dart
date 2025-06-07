import 'package:budgetmaster/presentation/common/page_header.dart';
import 'package:budgetmaster/presentation/common/safe_fullfiled_scroll_list.dart';
import 'package:budgetmaster/presentation/safes/cubit/safe_cubit.dart';
import 'package:budgetmaster/presentation/safes/widget/safe_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SafesView extends StatefulWidget {
  const SafesView({super.key});

  @override
  State<SafesView> createState() => _SafesViewState();
}

class _SafesViewState extends State<SafesView> {
  int selectedState = 0; // 0 - All, 1 - Fullfiled, 2 - Unfullfiled

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<SafeCubit, SafeState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PageHeader(
                title: 'Sejfy',
                showAddButton: true,
                onAddPressed: () async {
                  final result = await Navigator.pushNamed(context, '/add-safe');
                  if (result == true) {
                    // ignore: use_build_context_synchronously
                    context.read<SafeCubit>().loadSafes();
                  }
                },
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                child: SafeFullfiledScrollList(
                  selectedState: selectedState,
                  states: [
                    'Wszystkie',
                    'Wypełnione',
                    'Niewypełnione',
                  ],
                  onStateSelected: (selected) {
                    print('###############Selected state: $selected');
                    context.read<SafeCubit>().getSafesByState(selected);
                    setState(() {
                      selectedState = selected;
                    });
                  },
                ),
              ),

              Expanded(
                child: state.safes.isEmpty
                    ? const Center(child: Text('Brak sejfów'))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        itemCount: state.safes.length,
                        itemBuilder: (context, index) {
                          final safe = state.safes[index];
                          return SafeListItem(
                            safe: safe,
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}