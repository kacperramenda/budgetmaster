import 'dart:io';
import 'package:budgetmaster/core/constants/app_colors.dart';
import 'package:budgetmaster/core/theme/app_typography.dart';
import 'package:budgetmaster/domain/models/category.dart';
import 'package:budgetmaster/domain/models/expense.dart';
import 'package:budgetmaster/presentation/common/button_primary.dart';
import 'package:budgetmaster/presentation/expenses/cubit/expense_cubit.dart';
import 'package:budgetmaster/presentation/expenses/widgets/add/expense_category_add_tile.dart';
import 'package:budgetmaster/presentation/expenses/widgets/add/expense_category_tile.dart';
import 'package:flutter/material.dart';
import 'package:budgetmaster/presentation/common/input_field.dart';
import 'package:budgetmaster/presentation/common/page_header.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:budgetmaster/domain/repository/category_repo.dart';
import 'package:image_picker/image_picker.dart';

class ExpenseEditView extends StatefulWidget {
  final Expense expense;

  const ExpenseEditView({super.key, required this.expense});

  @override
  State<ExpenseEditView> createState() => _ExpenseEditViewState();
}

class _ExpenseEditViewState extends State<ExpenseEditView> {
  late String expenseDate;
  late String expenseCategory;
  late String expenseAmount;
  late String expenseDescription;
  Category? selectedCategory;
  Future<List<Category>>? _categoriesFuture;
  File? _receiptImage;
  String? _existingImagePath;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.expense.name;
    _amountController.text = widget.expense.amount.toString();
    _descriptionController.text = widget.expense.description ?? '';
    
    final date = widget.expense.date;
    _dateController.text = '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    
    expenseDate = _dateController.text;
    expenseCategory = widget.expense.categoryId;
    expenseAmount = _amountController.text;
    expenseDescription = _descriptionController.text;
    _existingImagePath = widget.expense.receiptImagePath;

    _loadCategoriesForExpenseDate();
  }

  void _loadCategoriesForExpenseDate() {
    final parsed = _extractMonthAndYear(expenseDate);
    if (parsed != null) {
      setState(() {
        _categoriesFuture = Provider.of<CategoryRepository>(
          context,
          listen: false,
        ).getCategoriesForSelectedMonth(parsed['month']!, parsed['year']!).then(
          (list) => list.whereType<Category>().toList(),
        );
      });
    }
  }

  void _onDateChanged(String newDate) {
    setState(() {
      expenseDate = newDate;
      _loadCategoriesForExpenseDate();
    });
  }

  Future<void> _pickImage() async {
    try {
      final status = await Permission.photos.request();
      if (!status.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Brak uprawnień do galerii')),
        );
        return;
      }

      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      ).timeout(const Duration(seconds: 10), onTimeout: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Przekroczono czas oczekiwania')),
        );
        return null;
      });

      if (image != null) {
        final File compressedImage = await _compressImage(File(image.path));
        setState(() {
          _receiptImage = compressedImage;
          _existingImagePath = null; // Reset existing path when new image is selected
        });
      }
    } on PlatformException catch (e) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   // SnackBar(content: Text('Błąd platformy: ${e.message}')),
      // );
    } catch (e) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   // SnackBar(content: Text('Wystąpił błąd: ${e.toString()}')),
      // );
    }
  }

  void _removeImage() {
    setState(() {
      _receiptImage = null;
      _existingImagePath = null;
    });
  }

  Future<File> _compressImage(File file) async {
    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      '${file.path}_compressed.jpg',
      quality: 70,
    );
    return result != null ? File(result.path) : file;
  }

  Map<String, String>? _extractMonthAndYear(String dateStr) {
    try {
      final parts = dateStr.split('/');
      final month = int.parse(parts[1]).toString();
      final year = parts[2];
      return {'month': month, 'year': year};
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral6,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PageHeader(
              title: "Edytuj wydatek",
              showAddButton: false,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: InputField(
                      label: 'Data',
                      placeholder: 'Wybierz datę',
                      type: InputType.date,
                      controller: _dateController,
                      onChanged: _onDateChanged,
                    ),
                  ),
                  if (expenseDate.isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text(
                        'Wybierz datę, aby wyświetlić kategorie',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: FutureBuilder<List<Category>>(
                        future: _categoriesFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }
                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return Column(
                              children: [
                                const Text(
                                  'Brak kategorii dla wybranej daty',
                                  style: TextStyle(color: AppColors.neutral3),
                                ),
                                Center(
                                  child: InkWell(
                                    onTap: () async {
                                      final result = await Navigator.pushNamed(context, '/add-budget-category');
        
                                      if (result == true && expenseDate.isNotEmpty) {
                                        _loadCategoriesForExpenseDate();
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 6),
                                      child: Text(
                                        'Dodaj kategorię',
                                        style: TextStyle(color: AppColors.primary1),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                          final categories = snapshot.data!;
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            clipBehavior: Clip.none,
                            child: IntrinsicHeight(
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: ExpenseCategoryAddTile(
                                      onTap: () {
                                        Navigator.pushNamed(context, '/add-budget-category').then((result) {
                                          if (result == true && expenseDate.isNotEmpty) {
                                            _loadCategoriesForExpenseDate();
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                  ...categories.map((category) {
                                    final isSelected = selectedCategory?.id == category.id || 
                                        (selectedCategory == null && category.id == widget.expense.categoryId);
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: isSelected
                                              ? Border.all(color: AppColors.primary1, width: 2)
                                              : null,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: ExpenseCategoryTile(
                                          label: category.name,
                                          backgroundColor: category.color != null
                                              ? Color(int.parse(category.color!))
                                              : AppColors.primary1,
                                          onTap: () {
                                            setState(() {
                                              expenseCategory = category.id;
                                              selectedCategory = category;
                                            });
                                          },
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: InputField(
                      label: 'Nazwa',
                      placeholder: 'Nazwa wydatku',
                      controller: _nameController,
                      type: InputType.text,
                      onChanged: (value) {
                        setState(() {
                          expenseCategory = value;
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: InputField(
                      label: 'Kwota',
                      placeholder: 'Kwota wydatku',
                      controller: _amountController,
                      type: InputType.number,
                      onChanged: (value) {
                        setState(() {
                          expenseAmount = value;
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: InputField(
                      label: 'Opis',
                      placeholder: 'Opis wydatku',
                      controller: _descriptionController,
                      type: InputType.text,
                      onChanged: (value) {
                        setState(() {
                          expenseDescription = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: _pickImage,
                        child: Text(
                          _receiptImage != null || _existingImagePath != null 
                              ? "Zmień zdjęcie" 
                              : "Dodaj zdjęcie paragonu",
                          style: TextStyle(color: AppColors.primary1),
                        ),
                      ),
                      if (_receiptImage != null || _existingImagePath != null)
                        TextButton(
                          onPressed: _removeImage,
                          child: Text(
                            "Usuń zdjęcie",
                            style: TextStyle(color: AppColors.semanticRed),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (_receiptImage != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        _receiptImage!,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    )
                  else if (_existingImagePath != null && File(_existingImagePath!).existsSync())
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        File(_existingImagePath!),
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  const SizedBox(height: 24),
                  ButtonPrimary(
                    label: 'Zapisz zmiany',
                    onPressed: () async {
                      final name = _nameController.text.trim();
                      final amount = _amountController.text.trim();
                      final desc = _descriptionController.text.trim();
                      final date = _dateController.text.trim();
        
                      if (date.isEmpty || expenseCategory.isEmpty || name.isEmpty || amount.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Proszę wypełnić wszystkie pola')),
                        );
                        return;
                      }
        
                      DateTime? parsedDate;
                      try {
                        final parts = date.split('/');
                        parsedDate = DateTime(
                          int.parse(parts[2]),
                          int.parse(parts[1]),
                          int.parse(parts[0]),
                        );
                      } catch (_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Nieprawidłowy format daty')),
                        );
                        return;
                      }
        
                      final imagePath = _receiptImage?.path ?? _existingImagePath;
        
                      final updatedExpense = widget.expense.copyWith(
                        name: name,
                        amount: double.tryParse(amount) ?? 0.0,
                        categoryId: expenseCategory,
                        description: desc.isNotEmpty ? desc : null,
                        date: parsedDate,
                        receiptImagePath: imagePath,
                      );
        
                      await context.read<ExpenseCubit>().updateExpense(
                        updatedExpense.id,
                        updatedExpense.name,
                        updatedExpense.amount,
                        updatedExpense.categoryId,
                        updatedExpense.description ?? '',
                        date: updatedExpense.date,
                        receiptImagePath: imagePath,
                      );
        
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Zmiany w wydatku zostały zapisane')),
                      );
                      
                      if (mounted) {
                        Navigator.pop(context, true);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    super.dispose();
  }
}