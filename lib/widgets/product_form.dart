import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/product.dart';

class ProductForm extends StatefulWidget {
  final Product? product;
  final int userId;
  final Function(Product) onSave;
  final VoidCallback onCancel;

  const ProductForm({
    Key? key,
    this.product,
    required this.userId,
    required this.onSave,
    required this.onCancel,
  }) : super(key: key);

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _stockController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _categoryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _nameController.text = widget.product!.name;
      _priceController.text = widget.product!.price.toString();
      _descriptionController.text = widget.product!.description;
      _stockController.text = widget.product!.stock.toString();
      _imageUrlController.text = widget.product!.imageUrl;
      _categoryController.text = widget.product!.category;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _stockController.dispose();
    _imageUrlController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final product = Product(
        id: widget.product?.id ?? 0,
        userId: widget.userId,
        name: _nameController.text,
        price: double.parse(_priceController.text),
        description: _descriptionController.text,
        stock: int.parse(_stockController.text),
        imageUrl: _imageUrlController.text,
        category: _categoryController.text,
        createdAt: widget.product?.createdAt ?? '',
        updatedAt: widget.product?.updatedAt ?? '',
      );
      
      widget.onSave(product);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEdit = widget.product != null;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    isEdit ? Icons.edit : Icons.add,
                    color: AppTheme.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  isEdit ? 'Edit Produk' : 'Tambah Produk Baru',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Nama Produk *',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _nameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nama produk wajib diisi';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          hintText: 'Contoh: Mawar Merah',
                          prefixIcon: Icon(Icons.local_florist),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Harga (Rp) *',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _priceController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Harga wajib diisi';
                          }
                          final parsedValue = double.tryParse(value);
                          if (parsedValue == null) {
                            return 'Masukkan angka yang valid';
                          }
                          if (parsedValue <= 0) {
                            return 'Harga harus lebih dari 0';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          hintText: 'Contoh: 75000',
                          prefixIcon: Icon(Icons.attach_money),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Kategori',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _categoryController,
                        decoration: const InputDecoration(
                          hintText: 'Contoh: Bunga Potong',
                          prefixIcon: Icon(Icons.category),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Stok *',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _stockController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Stok wajib diisi';
                          }
                          final parsedValue = int.tryParse(value);
                          if (parsedValue == null) {
                            return 'Masukkan angka yang valid';
                          }
                          if (parsedValue < 0) {
                            return 'Stok tidak boleh negatif';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          hintText: 'Contoh: 10',
                          prefixIcon: Icon(Icons.inventory),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'URL Gambar',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _imageUrlController,
                        decoration: const InputDecoration(
                          hintText: 'https://example.com/gambar.jpg',
                          prefixIcon: Icon(Icons.image),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Deskripsi',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          hintText: 'Deskripsi produk...',
                          prefixIcon: Icon(Icons.description),
                          alignLabelWithHint: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: widget.onCancel,
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(0, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Batal'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      minimumSize: const Size(0, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(isEdit ? 'Update' : 'Simpan'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}