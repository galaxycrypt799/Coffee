import 'dart:typed_data';

import 'package:coffee_admin/src/modules/operations/blocs/create_coffee_bloc/create_coffee_bloc.dart';
import 'package:coffee_admin/src/modules/operations/blocs/upload_picture_bloc/upload_picture_bloc.dart';
import 'package:coffee_admin/src/utils/price_formatter.dart';
import 'package:coffee_repository/coffee_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class CreateCoffeeScreen extends StatefulWidget {
  const CreateCoffeeScreen({super.key});

  @override
  State<CreateCoffeeScreen> createState() => _CreateCoffeeScreenState();
}

class _CreateCoffeeScreenState extends State<CreateCoffeeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _taglineController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  final _priceController = TextEditingController();
  final _discountController = TextEditingController();
  final _originController = TextEditingController();
  final _caffeineLevelController = TextEditingController();
  final _intensityController = TextEditingController();
  final _brewMinutesController = TextEditingController();
  final _volumeController = TextEditingController();
  final _ratingController = TextEditingController();
  final _tastingNotesController = TextEditingController();
  final _pictureUrlController = TextEditingController();
  final _sortOrderController = TextEditingController();
  final _calorieController = TextEditingController();
  final _proteinController = TextEditingController();
  final _fatController = TextEditingController();
  final _carbsController = TextEditingController();

  late Future<List<Coffee>> _coffeesFuture;
  var _didLoad = false;
  var _isSubmitting = false;
  var _showEditor = false;
  var _query = '';
  var _categoryFilter = _allCategories;
  Coffee? _editingCoffee;
  Uint8List? _pickedImageBytes;

  static const _allCategories = 'Tất cả';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didLoad) return;
    _coffeesFuture = context.read<CoffeeRepo>().getCoffees();
    _didLoad = true;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CreateCoffeeBloc, CreateCoffeeState>(
          listener: (context, state) {
            setState(() => _isSubmitting = state is CreateCoffeeLoading);

            if (state is CreateCoffeeSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.message.isEmpty ? 'Đã lưu sản phẩm' : state.message,
                  ),
                ),
              );
              _resetForm(closeEditor: true);
              _refreshProducts();
            }

            if (state is CreateCoffeeFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.message.isEmpty
                        ? 'Không thể lưu sản phẩm. Kiểm tra Firestore rules.'
                        : state.message,
                  ),
                ),
              );
            }
          },
        ),
        BlocListener<UploadPictureBloc, UploadPictureState>(
          listener: (context, state) {
            if (state is UploadPictureSuccess) {
              setState(() => _pictureUrlController.text = state.url);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã upload ảnh sản phẩm')),
              );
            }

            if (state is UploadPictureFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.message.isEmpty
                        ? 'Không thể upload ảnh. Kiểm tra Storage rules.'
                        : state.message,
                  ),
                ),
              );
            }
          },
        ),
      ],
      child: ColoredBox(
        color: Theme.of(context).colorScheme.surface,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: FutureBuilder<List<Coffee>>(
            future: _coffeesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(48),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              final coffees = snapshot.data ?? const <Coffee>[];
              final categories = _categoriesFor(coffees);
              final effectiveCategory = categories.contains(_categoryFilter)
                  ? _categoryFilter
                  : _allCategories;
              final filteredCoffees =
                  _filterCoffees(coffees, effectiveCategory);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 20),
                  _buildProductStats(context, coffees),
                  if (_showEditor) ...[
                    const SizedBox(height: 20),
                    _buildEditor(context),
                  ],
                  const SizedBox(height: 20),
                  _buildFilters(context, categories, effectiveCategory),
                  const SizedBox(height: 16),
                  if (snapshot.hasError)
                    _buildEmptyState(
                      icon: CupertinoIcons.exclamationmark_triangle,
                      title: 'Không thể tải sản phẩm',
                      message: snapshot.error.toString(),
                    )
                  else if (filteredCoffees.isEmpty)
                    _buildEmptyState(
                      icon: CupertinoIcons.cube_box,
                      title: 'Chưa có món phù hợp',
                      message: 'Thêm món mới hoặc đổi bộ lọc đang chọn.',
                    )
                  else
                    _buildProductGrid(context, filteredCoffees),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      runSpacing: 12,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quản lý sản phẩm',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              'Menu đồ uống dùng chung với Coffee App',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton.filledTonal(
              onPressed: _refreshProducts,
              tooltip: 'Tải lại',
              icon: const Icon(CupertinoIcons.refresh),
            ),
            const SizedBox(width: 10),
            FilledButton.icon(
              onPressed: _isSubmitting ? null : () => _startCreate(),
              icon: const Icon(CupertinoIcons.plus),
              label: const Text('Thêm món'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProductStats(BuildContext context, List<Coffee> coffees) {
    final promoted = coffees.where((coffee) => coffee.discount > 0).length;
    final averagePrice = coffees.isEmpty
        ? 0
        : coffees.fold<double>(0, (sum, coffee) => sum + coffee.price) /
            coffees.length;
    final categories = coffees.map((coffee) => coffee.category).toSet().length;

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 960
            ? 4
            : constraints.maxWidth >= 640
                ? 2
                : 1;
        const gap = 12.0;
        final width = (constraints.maxWidth - gap * (columns - 1)) / columns;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            _statTile(
              context,
              width: width,
              icon: CupertinoIcons.cube_box_fill,
              label: 'Tổng món',
              value: coffees.length.toString(),
              color: Colors.indigo,
            ),
            _statTile(
              context,
              width: width,
              icon: CupertinoIcons.tag_fill,
              label: 'Đang khuyến mãi',
              value: promoted.toString(),
              color: Colors.orange,
            ),
            _statTile(
              context,
              width: width,
              icon: CupertinoIcons.money_dollar_circle_fill,
              label: 'Giá trung bình',
              value: formatVnd(averagePrice),
              color: Colors.green,
            ),
            _statTile(
              context,
              width: width,
              icon: CupertinoIcons.square_grid_2x2_fill,
              label: 'Nhóm món',
              value: categories.toString(),
              color: Colors.deepPurple,
            ),
          ],
        );
      },
    );
  }

  Widget _statTile(
    BuildContext context, {
    required double width,
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return SizedBox(
      width: width,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withValues(alpha: 0.12),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditor(BuildContext context) {
    final isEditing = _editingCoffee != null;

    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F3EE),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE5D8CB)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    isEditing ? 'Sửa món' : 'Thêm món mới',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                ),
                IconButton(
                  onPressed: _isSubmitting
                      ? null
                      : () => _resetForm(closeEditor: true),
                  tooltip: 'Đóng',
                  icon: const Icon(CupertinoIcons.xmark),
                ),
              ],
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 900;
                if (!isWide) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildImagePicker(context),
                      const SizedBox(height: 18),
                      _buildFormFields(context),
                    ],
                  );
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 300,
                      child: _buildImagePicker(context),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: _buildFormFields(context),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 18),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: _isSubmitting
                      ? null
                      : () => _resetForm(closeEditor: true),
                  child: const Text('Huỷ'),
                ),
                FilledButton.icon(
                  onPressed: _isSubmitting ? null : _submit,
                  icon: _isSubmitting
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Icon(isEditing
                          ? CupertinoIcons.checkmark_alt
                          : CupertinoIcons.plus),
                  label: Text(isEditing ? 'Lưu thay đổi' : 'Thêm vào menu'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePicker(BuildContext context) {
    return BlocBuilder<UploadPictureBloc, UploadPictureState>(
      builder: (context, state) {
        final isUploading = state is UploadPictureLoading;
        final imageUrl = _pictureUrlController.text.trim();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: isUploading ? null : _pickImage,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: double.infinity,
                height: 260,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE1D8CF)),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _imagePreview(imageUrl, memoryBytes: _pickedImageBytes),
                    if (isUploading)
                      Container(
                        color: Colors.black.withValues(alpha: 0.28),
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(),
                      ),
                    Positioned(
                      right: 12,
                      bottom: 12,
                      child: FilledButton.tonalIcon(
                        onPressed: isUploading ? null : _pickImage,
                        icon: const Icon(CupertinoIcons.photo),
                        label: Text(imageUrl.isEmpty ? 'Chọn ảnh' : 'Đổi ảnh'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            _textField(
              controller: _pictureUrlController,
              label: 'URL ảnh',
              validator: (value) => _required(value, 'URL ảnh'),
              onChanged: (_) => setState(() => _pickedImageBytes = null),
            ),
          ],
        );
      },
    );
  }

  Widget _imagePreview(String imageUrl, {Uint8List? memoryBytes}) {
    final fallback = Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(CupertinoIcons.photo, size: 44, color: Colors.grey.shade500),
          const SizedBox(height: 8),
          Text(
            'Ảnh sản phẩm',
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      ),
    );

    if (memoryBytes != null && memoryBytes.isNotEmpty) {
      return Image.memory(
        memoryBytes,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => fallback,
      );
    }

    if (imageUrl.isEmpty) {
      return fallback;
    }

    if (_isRemoteImage(imageUrl)) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        webHtmlElementStrategy: WebHtmlElementStrategy.fallback,
        errorBuilder: (_, __, ___) => fallback,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Container(
            color: Colors.white,
            alignment: Alignment.center,
            child: const CircularProgressIndicator(strokeWidth: 2),
          );
        },
      );
    }

    return Image.asset(
      imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => fallback,
    );
  }

  Widget _buildFormFields(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 760 ? 2 : 1;
        const gap = 12.0;
        final width = (constraints.maxWidth - gap * (columns - 1)) / columns;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            SizedBox(
              width: width,
              child: _textField(
                controller: _nameController,
                label: 'Tên món',
                validator: (value) => _required(value, 'Tên món'),
              ),
            ),
            SizedBox(
              width: width,
              child: _textField(
                controller: _categoryController,
                label: 'Nhóm món',
                validator: (value) => _required(value, 'Nhóm món'),
              ),
            ),
            SizedBox(
              width: constraints.maxWidth,
              child: _textField(
                controller: _taglineController,
                label: 'Tagline ngắn',
                validator: (value) => _required(value, 'Tagline'),
              ),
            ),
            SizedBox(
              width: constraints.maxWidth,
              child: _textField(
                controller: _descriptionController,
                label: 'Mô tả chi tiết',
                maxLines: 3,
                validator: (value) => _required(value, 'Mô tả'),
              ),
            ),
            SizedBox(
              width: width,
              child: _textField(
                controller: _priceController,
                label: 'Giá bán',
                keyboardType: TextInputType.number,
                validator: (value) => _requiredNumber(value, 'Giá bán'),
              ),
            ),
            SizedBox(
              width: width,
              child: _textField(
                controller: _discountController,
                label: 'Giảm giá (%)',
                keyboardType: TextInputType.number,
                validator: (value) => _optionalNumber(
                  value,
                  'Giảm giá',
                  min: 0,
                  max: 100,
                ),
              ),
            ),
            SizedBox(
              width: width,
              child: _textField(
                controller: _originController,
                label: 'Nguồn gốc hạt',
              ),
            ),
            SizedBox(
              width: width,
              child: _textField(
                controller: _caffeineLevelController,
                label: 'Hàm lượng caffeine',
                validator: (value) => _required(value, 'Hàm lượng caffeine'),
              ),
            ),
            SizedBox(
              width: width,
              child: _textField(
                controller: _intensityController,
                label: 'Độ đậm (1-5)',
                keyboardType: TextInputType.number,
                validator: (value) => _requiredNumber(
                  value,
                  'Độ đậm',
                  min: 1,
                  max: 5,
                ),
              ),
            ),
            SizedBox(
              width: width,
              child: _textField(
                controller: _brewMinutesController,
                label: 'Thời gian pha (phút)',
                keyboardType: TextInputType.number,
                validator: (value) => _requiredNumber(
                  value,
                  'Thời gian pha',
                  min: 1,
                ),
              ),
            ),
            SizedBox(
              width: width,
              child: _textField(
                controller: _volumeController,
                label: 'Dung tích (ml)',
                keyboardType: TextInputType.number,
                validator: (value) => _requiredNumber(
                  value,
                  'Dung tích',
                  min: 1,
                ),
              ),
            ),
            SizedBox(
              width: width,
              child: _textField(
                controller: _ratingController,
                label: 'Đánh giá (0-5)',
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (value) => _requiredNumber(
                  value,
                  'Đánh giá',
                  min: 0,
                  max: 5,
                ),
              ),
            ),
            SizedBox(
              width: constraints.maxWidth,
              child: _textField(
                controller: _tastingNotesController,
                label: 'Tasting notes, cách nhau bằng dấu phẩy',
              ),
            ),
            SizedBox(
              width: width,
              child: _textField(
                controller: _calorieController,
                label: 'Calories',
                keyboardType: TextInputType.number,
                validator: (value) => _optionalNumber(value, 'Calories'),
              ),
            ),
            SizedBox(
              width: width,
              child: _textField(
                controller: _proteinController,
                label: 'Protein',
                keyboardType: TextInputType.number,
                validator: (value) => _optionalNumber(value, 'Protein'),
              ),
            ),
            SizedBox(
              width: width,
              child: _textField(
                controller: _fatController,
                label: 'Fat',
                keyboardType: TextInputType.number,
                validator: (value) => _optionalNumber(value, 'Fat'),
              ),
            ),
            SizedBox(
              width: width,
              child: _textField(
                controller: _carbsController,
                label: 'Carbs',
                keyboardType: TextInputType.number,
                validator: (value) => _optionalNumber(value, 'Carbs'),
              ),
            ),
            SizedBox(
              width: constraints.maxWidth,
              child: _textField(
                controller: _sortOrderController,
                label: 'Thứ tự hiển thị',
                keyboardType: TextInputType.number,
                validator: (value) => _optionalNumber(value, 'Thứ tự'),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    ValueChanged<String>? onChanged,
    int maxLines = 1,
  }) {
    final effectiveKeyboardType =
        maxLines > 1 && keyboardType == TextInputType.text
            ? TextInputType.multiline
            : keyboardType;

    return TextFormField(
      controller: controller,
      keyboardType: effectiveKeyboardType,
      validator: validator,
      onChanged: onChanged,
      maxLines: maxLines,
      textInputAction:
          maxLines > 1 ? TextInputAction.newline : TextInputAction.next,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE2D8CE)),
        ),
      ),
    );
  }

  Widget _buildFilters(
    BuildContext context,
    List<String> categories,
    String effectiveCategory,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 720;
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SizedBox(
              width: isWide ? 420 : constraints.maxWidth,
              child: TextField(
                onChanged: (value) => setState(() => _query = value),
                decoration: InputDecoration(
                  prefixIcon: const Icon(CupertinoIcons.search),
                  hintText: 'Tìm theo tên, nhóm món, nguồn gốc',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: isWide ? 220 : constraints.maxWidth,
              child: DropdownButtonFormField<String>(
                initialValue: effectiveCategory,
                items: categories
                    .map(
                      (category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      ),
                    )
                    .toList(growable: false),
                onChanged: (value) {
                  if (value == null) return;
                  setState(() => _categoryFilter = value);
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildProductGrid(BuildContext context, List<Coffee> coffees) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 1100
            ? 3
            : constraints.maxWidth >= 720
                ? 2
                : 1;
        const gap = 14.0;
        final width = (constraints.maxWidth - gap * (columns - 1)) / columns;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: coffees
              .map((coffee) => SizedBox(
                    width: width,
                    child: _productCard(context, coffee),
                  ))
              .toList(growable: false),
        );
      },
    );
  }

  Widget _productCard(BuildContext context, Coffee coffee) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 170, child: _imagePreview(coffee.picture)),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        coffee.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                      ),
                    ),
                    if (coffee.discount > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.orange.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          '-${coffee.discount}%',
                          style: const TextStyle(
                            color: Colors.deepOrange,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  coffee.tagline,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _miniChip(coffee.category),
                    _miniChip(coffee.roastLevel),
                    _miniChip('${coffee.volumeMl}ml'),
                    _miniChip('${coffee.brewMinutes} phút'),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            formatVnd(coffee.discountedPrice),
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                          if (coffee.discount > 0)
                            Text(
                              formatVnd(coffee.price),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    decoration: TextDecoration.lineThrough,
                                    color: Colors.grey,
                                  ),
                            ),
                        ],
                      ),
                    ),
                    IconButton.filledTonal(
                      onPressed:
                          _isSubmitting ? null : () => _startEdit(coffee),
                      tooltip: 'Sửa',
                      icon: const Icon(CupertinoIcons.pencil),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filledTonal(
                      onPressed:
                          _isSubmitting ? null : () => _confirmDelete(coffee),
                      tooltip: 'Xoá',
                      icon: const Icon(CupertinoIcons.trash),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFF3EEE9),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String message,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(36),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Icon(icon, size: 44, color: Colors.grey.shade500),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Text(message, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  List<String> _categoriesFor(List<Coffee> coffees) {
    final categories = coffees
        .map((coffee) => coffee.category.trim())
        .where((category) => category.isNotEmpty)
        .toSet()
        .toList()
      ..sort();
    return <String>[_allCategories, ...categories];
  }

  List<Coffee> _filterCoffees(List<Coffee> coffees, String category) {
    final query = _query.trim().toLowerCase();
    return coffees.where((coffee) {
      final matchesCategory =
          category == _allCategories || coffee.category == category;
      final haystack =
          '${coffee.name} ${coffee.category} ${coffee.origin} ${coffee.tagline}'
              .toLowerCase();
      return matchesCategory && (query.isEmpty || haystack.contains(query));
    }).toList(growable: false);
  }

  void _refreshProducts() {
    setState(() {
      _coffeesFuture = context.read<CoffeeRepo>().getCoffees();
    });
  }

  void _startCreate() {
    setState(() {
      _editingCoffee = null;
      _showEditor = true;
      _nameController.clear();
      _taglineController.clear();
      _descriptionController.clear();
      _categoryController.text = 'Phin Việt';
      _priceController.clear();
      _discountController.text = '0';
      _originController.clear();
      _caffeineLevelController.text = 'Vừa';
      _intensityController.text = '3';
      _brewMinutesController.text = '4';
      _volumeController.text = '320';
      _ratingController.text = '4.8';
      _tastingNotesController.clear();
      _pictureUrlController.clear();
      _pickedImageBytes = null;
      _sortOrderController.clear();
      _calorieController.text = '0';
      _proteinController.text = '0';
      _fatController.text = '0';
      _carbsController.text = '0';
    });
  }

  void _startEdit(Coffee coffee) {
    setState(() {
      _editingCoffee = coffee;
      _showEditor = true;
      _nameController.text = coffee.name;
      _taglineController.text = coffee.tagline;
      _descriptionController.text = coffee.description;
      _categoryController.text = coffee.category;
      _priceController.text = coffee.price.round().toString();
      _discountController.text = coffee.discount.toString();
      _originController.text = coffee.origin;
      _caffeineLevelController.text = coffee.roastLevel;
      _intensityController.text = coffee.intensity.toString();
      _brewMinutesController.text = coffee.brewMinutes.toString();
      _volumeController.text = coffee.volumeMl.toString();
      _ratingController.text = coffee.rating.toString();
      _tastingNotesController.text = coffee.tastingNotes.join(', ');
      _pictureUrlController.text = coffee.picture;
      _pickedImageBytes = null;
      _sortOrderController.text = coffee.sortOrder.toString();
      _calorieController.text = coffee.macros.calories.toString();
      _proteinController.text = coffee.macros.proteins.toString();
      _fatController.text = coffee.macros.fat.toString();
      _carbsController.text = coffee.macros.carbs.toString();
    });
  }

  void _resetForm({required bool closeEditor}) {
    setState(() {
      _editingCoffee = null;
      _showEditor = !closeEditor;
      _formKey.currentState?.reset();
      _nameController.clear();
      _taglineController.clear();
      _descriptionController.clear();
      _categoryController.clear();
      _priceController.clear();
      _discountController.clear();
      _originController.clear();
      _caffeineLevelController.clear();
      _intensityController.clear();
      _brewMinutesController.clear();
      _volumeController.clear();
      _ratingController.clear();
      _tastingNotesController.clear();
      _pictureUrlController.clear();
      _pickedImageBytes = null;
      _sortOrderController.clear();
      _calorieController.clear();
      _proteinController.clear();
      _fatController.clear();
      _carbsController.clear();
    });
  }

  Future<void> _pickImage() async {
    final uploadPictureBloc = context.read<UploadPictureBloc>();
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      imageQuality: 90,
    );
    if (image == null || !mounted) return;

    final bytes = await image.readAsBytes();
    if (!mounted) return;

    final fileName =
        image.name.trim().isNotEmpty ? image.name : path.basename(image.path);
    setState(() => _pickedImageBytes = bytes);
    uploadPictureBloc.add(
      UploadPicture(bytes, fileName),
    );
  }

  Future<void> _confirmDelete(Coffee coffee) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xoá món'),
        content: Text('Xoá "${coffee.name}" khỏi menu?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Huỷ'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Xoá'),
          ),
        ],
      ),
    );

    if (!mounted || shouldDelete != true) return;
    context
        .read<CreateCoffeeBloc>()
        .add(DeleteCoffeeRequested(coffee.coffeeId));
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final picture = _pictureUrlController.text.trim();
    if (picture.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn ảnh sản phẩm')),
      );
      return;
    }

    final currentCoffee = _editingCoffee;
    final name = _nameController.text.trim();
    final coffee = Coffee(
      sortOrder: _parseInt(
        _sortOrderController.text,
        fallback:
            currentCoffee?.sortOrder ?? DateTime.now().millisecondsSinceEpoch,
      ),
      coffeeId: currentCoffee?.coffeeId ?? '',
      picture: picture,
      name: name,
      tagline: _taglineController.text.trim().isEmpty
          ? name
          : _taglineController.text.trim(),
      description: _descriptionController.text.trim(),
      category: _categoryController.text.trim(),
      origin: _originController.text.trim(),
      roastLevel: _caffeineLevelController.text.trim(),
      intensity:
          _clampInt(_parseInt(_intensityController.text, fallback: 3), 1, 5),
      brewMinutes: _parseInt(_brewMinutesController.text, fallback: 4),
      volumeMl: _parseInt(_volumeController.text, fallback: 320),
      rating: _clampDouble(
          _parseDouble(_ratingController.text, fallback: 4.8), 0, 5),
      price: _parseDouble(_priceController.text),
      discount: _clampInt(_parseInt(_discountController.text), 0, 100),
      tastingNotes: _parseTastingNotes(_tastingNotesController.text),
      macros: Macros(
        calories: _parseInt(_calorieController.text),
        proteins: _parseInt(_proteinController.text),
        fat: _parseInt(_fatController.text),
        carbs: _parseInt(_carbsController.text),
      ),
    );

    if (currentCoffee == null) {
      context.read<CreateCoffeeBloc>().add(CreateCoffeeRequested(coffee));
    } else {
      context.read<CreateCoffeeBloc>().add(UpdateCoffeeRequested(coffee));
    }
  }

  String? _required(String? value, String label) {
    if (value == null || value.trim().isEmpty) {
      return '$label không được bỏ trống';
    }
    return null;
  }

  String? _requiredNumber(
    String? value,
    String label, {
    num min = 0,
    num? max,
  }) {
    final requiredError = _required(value, label);
    if (requiredError != null) return requiredError;
    return _optionalNumber(value, label, min: min, max: max);
  }

  String? _optionalNumber(
    String? value,
    String label, {
    num min = 0,
    num? max,
  }) {
    final raw = value?.trim() ?? '';
    if (raw.isEmpty) return null;
    final number = num.tryParse(raw);
    if (number == null) {
      return '$label không hợp lệ';
    }
    if (number < min) {
      return '$label phải từ $min';
    }
    if (max != null && number > max) {
      return '$label tối đa $max';
    }
    return null;
  }

  int _parseInt(String value, {int fallback = 0}) {
    return num.tryParse(value.trim())?.round() ?? fallback;
  }

  double _parseDouble(String value, {double fallback = 0}) {
    return double.tryParse(value.trim()) ?? fallback;
  }

  int _clampInt(int value, int min, int max) {
    if (value < min) return min;
    if (value > max) return max;
    return value;
  }

  double _clampDouble(double value, double min, double max) {
    if (value < min) return min;
    if (value > max) return max;
    return value;
  }

  List<String> _parseTastingNotes(String value) {
    return value
        .split(RegExp(r'[,;\n]'))
        .map((note) => note.trim())
        .where((note) => note.isNotEmpty)
        .toList(growable: false);
  }

  bool _isRemoteImage(String imageUrl) {
    return imageUrl.startsWith('http://') || imageUrl.startsWith('https://');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _taglineController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _priceController.dispose();
    _discountController.dispose();
    _originController.dispose();
    _caffeineLevelController.dispose();
    _intensityController.dispose();
    _brewMinutesController.dispose();
    _volumeController.dispose();
    _ratingController.dispose();
    _tastingNotesController.dispose();
    _pictureUrlController.dispose();
    _sortOrderController.dispose();
    _calorieController.dispose();
    _proteinController.dispose();
    _fatController.dispose();
    _carbsController.dispose();
    super.dispose();
  }
}
