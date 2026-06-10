import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({Key? key}) : super(key: key);

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  // Store management state
  bool _hasStore = false;
  String _storeName = '';
  String _storeCategory = 'Roses & Lilies';
  String _storeDescription = '';
  String _storeLocation = 'Jakarta, Indonesia';

  // Vendor product listing
  final List<Map<String, dynamic>> _myProducts = [
    {
      'name': 'Sweet Orchid Basket',
      'price': 65.00,
      'stock': 12,
      'image': 'https://images.unsplash.com/photo-1567306226416-28f0efdc88ce?q=80&w=200&auto=format&fit=crop',
    },
    {
      'name': 'Red Velvet Rose Box',
      'price': 48.00,
      'stock': 24,
      'image': 'https://images.unsplash.com/photo-1520763185298-1b434c919102?q=80&w=200&auto=format&fit=crop',
    },
  ];

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _locController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _locController.dispose();
    super.dispose();
  }

  void _createStore() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _storeName = _nameController.text;
        _storeDescription = _descController.text;
        _storeLocation = _locController.text.isNotEmpty ? _locController.text : 'Jakarta, Indonesia';
        _hasStore = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: const [
              Icon(Icons.storefront, color: Colors.white),
              SizedBox(width: 12),
              Text('Toko Bunga Anda Berhasil Didirikan! 🎉'),
            ],
          ),
          backgroundColor: AppTheme.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  void _showAddProductDialog() {
    final nameCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    final stockCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: const [
              Icon(Icons.add_shopping_cart, color: AppTheme.primary),
              SizedBox(width: 10),
              Text('Tambah Produk Bunga'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Nama Produk Bunga',
                    hintText: 'Contoh: Lavender Dream Bouquet',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: priceCtrl,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Harga (USD)',
                    hintText: 'Contoh: 35.00',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: stockCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Stok Awal',
                    hintText: 'Contoh: 15',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal', style: TextStyle(color: AppTheme.textSecondary)),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameCtrl.text.isNotEmpty && priceCtrl.text.isNotEmpty) {
                  final price = double.tryParse(priceCtrl.text) ?? 29.99;
                  final stock = int.tryParse(stockCtrl.text) ?? 10;
                  
                  setState(() {
                    _myProducts.insert(0, {
                      'name': nameCtrl.text,
                      'price': price,
                      'stock': stock,
                      'image': 'https://images.unsplash.com/photo-1596436889106-be35e843f974?q=80&w=200&auto=format&fit=crop',
                    });
                  });
                  Navigator.pop(context);
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Produk "${nameCtrl.text}" berhasil dipajang!'),
                      backgroundColor: AppTheme.success,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                minimumSize: const Size(80, 40),
              ),
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(
          _hasStore ? 'Dashboard Toko' : 'Mulai Usaha Bunga',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: _hasStore ? _buildVendorDashboard(theme) : _buildCreateStoreForm(theme, size),
      ),
    );
  }

  // State A: Form to Create Store
  Widget _buildCreateStoreForm(ThemeData theme, Size size) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Graphic Banner Banner
          Container(
            height: 140,
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -20,
                  bottom: -20,
                  child: Opacity(
                    opacity: 0.15,
                    child: Icon(Icons.storefront, size: 160, color: Colors.white),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Buka Toko SnapFlorist',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Jangkau jutaan pecinta bunga di seluruh Indonesia dan kembangkan bisnis florist Anda bersama kami.',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Form Card Card
          Card(
            elevation: 2,
            shadowColor: Colors.black12,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Store Name
                    Text(
                      'Nama Toko Bunga',
                      style: theme.textTheme.titleMedium?.copyWith(fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nama toko tidak boleh kosong';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Contoh: Rose Bouquet Palace',
                        prefixIcon: Icon(Icons.storefront),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Primary category selector
                    Text(
                      'Kategori Spesialisasi',
                      style: theme.textTheme.titleMedium?.copyWith(fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _storeCategory,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.category_outlined),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'Roses & Lilies', child: Text('Mawar & Lili (Roses & Lilies)')),
                        DropdownMenuItem(value: 'Sunflowers & Daisies', child: Text('Bunga Matahari (Sunflowers)')),
                        DropdownMenuItem(value: 'Orchid Arrangements', child: Text('Anggrek (Orchids)')),
                        DropdownMenuItem(value: 'Custom Bridal Bouquets', child: Text('Karangan Pengantin (Bridal)')),
                      ],
                      onChanged: (val) {
                        setState(() {
                          _storeCategory = val ?? 'Roses & Lilies';
                        });
                      },
                    ),

                    const SizedBox(height: 16),

                    // Description
                    Text(
                      'Deskripsi Toko',
                      style: theme.textTheme.titleMedium?.copyWith(fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _descController,
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Deskripsi toko tidak boleh kosong';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Tulis keunikan bunga atau layanan toko Anda...',
                        prefixIcon: Icon(Icons.description_outlined),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Location
                    Text(
                      'Lokasi Toko',
                      style: theme.textTheme.titleMedium?.copyWith(fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _locController,
                      decoration: const InputDecoration(
                        hintText: 'Contoh: Jakarta Barat (Kosongkan jika online)',
                        prefixIcon: Icon(Icons.location_on_outlined),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Submit Button Button
                    ElevatedButton(
                      onPressed: _createStore,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text('Daftarkan Toko Baru Anda'),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // State B: Shop Dashboard UI
  Widget _buildVendorDashboard(ThemeData theme) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Store Header Info Card Card
          Card(
            elevation: 1,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryLight,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.storefront, color: AppTheme.primary, size: 32),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _storeName,
                          style: theme.textTheme.titleLarge?.copyWith(fontSize: 18),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.local_florist, color: AppTheme.accent, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              _storeCategory,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: AppTheme.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Icon(Icons.location_on, color: Colors.redAccent, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              _storeLocation,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: AppTheme.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        if (_storeDescription.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            _storeDescription,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontSize: 11,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // 2. Quick Stat Counters Counters
          Row(
            children: [
              _buildStatCard('Omset', '\$4,250.00', Icons.monetization_on, Colors.green),
              const SizedBox(width: 12),
              _buildStatCard('Produk', _myProducts.length.toString(), Icons.shopping_basket, Colors.blue),
              const SizedBox(width: 12),
              _buildStatCard('Pesanan', '3 Baru', Icons.receipt_long, Colors.orange),
            ],
          ),

          const SizedBox(height: 24),

          // 3. Section Title with Add Product Action
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Daftar Bunga Toko Saya',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: _showAddProductDialog,
                icon: const Icon(Icons.add, size: 16, color: Colors.white),
                label: const Text('Tambah Bunga', style: TextStyle(fontSize: 12)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  minimumSize: const Size(120, 36),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // 4. List view of vendor products
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _myProducts.length,
            itemBuilder: (context, index) {
              final prod = _myProducts[index];
              return Card(
                elevation: 0,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: AppTheme.border),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          prod['image'],
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (c, o, s) => const Icon(Icons.local_florist, size: 40),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              prod['name'],
                              style: theme.textTheme.titleMedium?.copyWith(fontSize: 14),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Stok: ${prod['stock']} ikat',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: AppTheme.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '\$${prod['price'].toStringAsFixed(2)}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: AppTheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          
          const SizedBox(height: 20),
          
          // Button to temporarily simulate returning to A (for demoing purposes)
          TextButton.icon(
            onPressed: () {
              setState(() {
                _hasStore = false;
              });
            },
            icon: const Icon(Icons.settings_backup_restore, size: 16),
            label: const Text('Simulasi Reset (Buka Toko Baru)'),
            style: TextButton.styleFrom(foregroundColor: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }

  // Utility to build stat card counters
  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppTheme.border),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 12),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
