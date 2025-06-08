import 'package:budgetmaster/domain/models/safe.dart';
import 'package:budgetmaster/presentation/common/page_header.dart';
import 'package:budgetmaster/presentation/safes/cubit/safe_cubit.dart';
import 'package:budgetmaster/presentation/savings/cubit/savings_cubit.dart';
import 'package:budgetmaster/presentation/savings/widgets/safes_scroll_list.dart';
import 'package:budgetmaster/presentation/savings/widgets/savings_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SavingsView extends StatefulWidget {
  const SavingsView({super.key});

  @override
  State<SavingsView> createState() => _SavingsViewState();
}

class _SavingsViewState extends State<SavingsView> {
  String selectedSafeId = '0';

  @override
  void initState() {
    super.initState();
    context.read<SavingsCubit>().loadSavings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<SavingsCubit, SavingsState>(
        builder: (context, savingsState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PageHeader(
                title: 'Oszczędności',
                showAddButton: true,
                onAddPressed: () async {
                  final result = await Navigator.pushNamed(context, '/add-saving');
                  if (!mounted) return;
                  if (result == true) {
                    context.read<SavingsCubit>().loadSavings();
                  }
                },
              ),

              // 🟡 Sejfy wyświetlane z SafeCubit
              BlocBuilder<SafeCubit, SafeState>(
                builder: (context, safeState) {
                  final allSafes = [
                    Safe(id: '0', name: 'Wszystkie', goalAmount: 0.0, isFullfiled: false),
                    ...safeState.safes,
                  ];

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    child: SafesScrollList(
                      safes: allSafes,
                      selectedSafe: selectedSafeId,
                      onSafeSelected: (newSelectedId) async {
                        setState(() {
                          selectedSafeId = newSelectedId;
                        });

                        if (newSelectedId == '0') {
                          context.read<SavingsCubit>().loadSavings();
                        } else {
                          final filtered = await context.read<SavingsCubit>().getSavingsBySafeId(newSelectedId);
                          context.read<SavingsCubit>().emit(
                            SavingsState(
                              savings: filtered,
                              safes: savingsState.safes,
                              selectedSafe: newSelectedId,
                            ),
                          );
                        }
                      },
                    ),
                  );
                },
              ),

              // 📋 Lista oszczędności
              Expanded(
                child: savingsState.savings.isEmpty
                    ? const Center(child: Text('Brak dodanych oszczędności'))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        itemCount: savingsState.savings.length,
                        itemBuilder: (context, index) {
                          final saving = savingsState.savings[index];
                          return FutureBuilder<String>(
                            future: context.read<SafeCubit>().getSafeNameById(saving.safeId),
                            builder: (context, snapshot) {
                              final safeName = snapshot.data ?? '';
                              return SavingsListItem(
                                saving: saving,
                                safeName: safeName,
                                onTap: () async {
                                  final result = await Navigator.pushNamed(
                                    context,
                                    '/saving-details',
                                    arguments: saving,
                                  );

                                  if (!mounted) return;
                                  if (result == true) {
                                    context.read<SavingsCubit>().loadSavings();
                                  }
                                },
                              );
                            },
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
