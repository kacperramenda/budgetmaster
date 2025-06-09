import 'package:budgetmaster/presentation/categories/view/edit/category_edit_view.dart';
import 'package:flutter/material.dart';
import 'package:budgetmaster/domain/models/category.dart';
import 'package:budgetmaster/core/constants/app_colors.dart';
import 'package:budgetmaster/core/theme/app_typography.dart';
import 'package:budgetmaster/presentation/common/page_header.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:budgetmaster/presentation/categories/cubit/category_cubit.dart';

class CategoryDetailsView extends StatefulWidget {
  final String categoryId;

  const CategoryDetailsView({super.key, required this.categoryId});

  @override
  State<CategoryDetailsView> createState() => _CategoryDetailsViewState();
}

class _CategoryDetailsViewState extends State<CategoryDetailsView> {
  Category? currentCategory;

  @override
  void initState() {
    super.initState();
    _loadCategory();
  }

  void _loadCategory() {
    final cubit = context.read<CategoryCubit>();
    Category? category;
    final state = cubit.state;
    if (state is CategoryLoaded) {
      category = state.categories.firstWhere(
        (c) => c.id == widget.categoryId,
        orElse: () => Category(
          id: widget.categoryId,
          name: '',
          startAmount: 0.0,
          currentAmount: 0.0,
          month: '',
          year: '',
          color: null,
        ),
      );
    }

    if (category != null) {
      setState(() {
        currentCategory = category;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral6,
      body: BlocListener<CategoryCubit, CategoryState>(
        listener: (context, state) {
          if (state is CategoryError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
          if (state is CategoryLoaded) {
            _loadCategory(); // odśwież lokalnie
          }
        },
        child: currentCategory == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  PageHeader(
                    route: '/budget-categories',
                    title: 'Szczegóły kategorii',
                    showEditButton: true,
                    onEditPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CategoryEditView(
                                categoryId: currentCategory!.id,
                                category: currentCategory!,
                              ),
                        ),
                      );

                      if (result == true && context.mounted) {
                        context.read<CategoryCubit>().loadCategories();
                      }
                    },
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildRow("Nazwa", currentCategory!.name),
                          _buildRow("Budżet początkowy",
                              "${currentCategory!.startAmount.toStringAsFixed(2)} zł"),
                          _buildRow("Budżet aktualny",
                              "${currentCategory!.currentAmount.toStringAsFixed(2)} zł"),
                          _buildRow("Miesiąc", currentCategory!.month),
                          _buildRow("Rok", currentCategory!.year),
                          Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                    color: AppColors.neutral5, width: 1),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Kolor",
                                    style: AppTypography.body1
                                        .copyWith(color: AppColors.neutral2)),
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: currentCategory!.color != null
                                        ? Color(
                                            int.parse(currentCategory!.color!))
                                        : AppColors.primary1,
                                    shape: BoxShape.circle,
                                    border:
                                        Border.all(color: AppColors.neutral4),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          _buildDeleteButton(context),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildDeleteButton(BuildContext context) {
    return InkWell(
      onTap: () async {
        final confirm = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            backgroundColor: AppColors.neutral6,
            title: Text("Potwierdzenie", style: AppTypography.title2),
            content: Text("Czy na pewno chcesz usunąć tę kategorię?",
                style: AppTypography.body3.copyWith(color: AppColors.neutral1)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text("Anuluj",
                    style:
                        AppTypography.body1.copyWith(color: AppColors.primary1)),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text("Usuń",
                    style: AppTypography.body1
                        .copyWith(color: AppColors.semanticRed)),
              ),
            ],
          ),
        );

        if (confirm == true) {
          try {
            await context
                .read<CategoryCubit>()
                .deleteCategory(currentCategory!.id);
            if (!context.mounted) return;
            Navigator.pop(context, true);
          } catch (_) {
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content:
                    Text('Nie można usunąć kategorii z dodanymi wydatkami'),
                backgroundColor: AppColors.semanticRed,
              ),
            );
          }
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 48),
        child: Center(
          child: Text(
            "Usuń kategorię",
            style: AppTypography.body1.copyWith(color: AppColors.semanticRed),
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.neutral5, width: 1),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.body1.copyWith(color: AppColors.neutral2)),
          Text(value, style: AppTypography.title3.copyWith(color: AppColors.primary1)),
        ],
      ),
    );
  }
}
