import 'package:flutter/material.dart';
import '../models/product.dart';
// --- Colors from HTML ---
const Color cSurface = Color(0xfff8f9ff);
const Color cOnSurface = Color(0xff011d35);
const Color cOnSurfaceVariant = Color(0xff43474f);
const Color cSurfaceContainer = Color(0xffe4efff);
const Color cSurfaceContainerLow = Color(0xffeef4ff);
const Color cPrimaryContainer = Color(0xff002b5b);
const Color cOnPrimaryContainer = Color(0xff7594ca); // Adjust if needed
const Color cPrimary = Color(0xff001736);
const Color cOutlineVariant = Color(0xffc4c6d0);
const Color cOutline = Color(0xff747780);
const Color cSecondary = Color(0xff575f6b);
const Color cSecondaryContainer = Color(0xffdbe3f1);
const Color cOnSecondaryContainer = Color(0xff5d6571);
const Color cSecondaryFixed = Color(0xffdbe3f1);
const Color cOnSecondaryFixedVariant = Color(0xff3f4752);
const Color cErrorContainer = Color(0xffffdad6);
const Color cError = Color(0xffba1a1a);
const Color cOnError = Color(0xffffffff);
const Color cInverseSurface = Color(0xff19324b);
const Color cInverseOnSurface = Color(0xffe9f1ff);
const Color cPrimaryFixedDim = Color(0xffa9c7ff);

const Color cBlue700 = Color(0xFF1D4ED8); // Closest to blue-700
const Color cBlue50 = Color(0xFFEFF6FF);  // Closest to blue-50

enum ProductViewState { list, add, edit }

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  ProductViewState _currentState = ProductViewState.list;
  
  List<Product> products = [
    Product(
      id: 1,
      name: "Buffalo Milk (A2)",
      category: "Milk",
      unit: "Litre",
      price: 60,
      stock: 420,
      visible: true,
      img: "https://lh3.googleusercontent.com/aida-public/AB6AXuBRjpsVJAhcuDFpmAQ1ezuNIHbDwAKJswS8SzRZMgUg05OVoVUinfHJ0Arv0h2EADpAqWAszkjxTMHqZmC4NfCvFU4-_9i_XOMvp5FFtIIJ6SLE46-MR5D3e2-uIbvrVzQPcuXFu0YCcX6UR01kLkEIXZABec7oWcJlrcDpxLd5sggY0VA81ESZDxdlbSWSl1_3ubN5rthvBsO5AIVILTd48mQTq4YsQPlFZVFi3ZsznlWv-whflvN8Shr-v9JtBlTMo3iYAgSjO6-u",
    ),
    Product(
      id: 2,
      name: "Full Cream Curd",
      category: "Curd",
      unit: "500g",
      price: 45,
      stock: 180,
      visible: true,
      img: "https://lh3.googleusercontent.com/aida-public/AB6AXuBRUihs35IwJGKIuP3vgyaCcpUdMb8RkCSqsQ_jcI_1uquu-VIqA1UTcKxLcFVtqUvsWSh4D4ukm8ZFpVgqWEDWQ64ooZelev9SaVo0OWFA0_mA-GDhXk9ho6Ea-sQvj_JYlFeSs1hDzqePulLgQtPuY3f5-k4MhS9XSk2k9fkF9NwTVsi3OnniT_UtX_NCVzubsYULh1CuwHZw0jCkk3Dc1kyCK73x3rDk4YPn2Yfzvv8kAG40DYsnhsiKa_240p33vKrXlRiLVVnl",
    ),
    Product(
      id: 3,
      name: "Pure Desi Ghee",
      category: "Ghee",
      unit: "1kg",
      price: 650,
      stock: 92,
      visible: true,
      img: "https://lh3.googleusercontent.com/aida-public/AB6AXuDA4-XPOWExhp6-ZbGB1oIA9KPHXUVjaMHEGjbFh5OoIh3uK6xgGmBHKDG4g9vApv9gKD_zAFOLmd5z0Q40YwrXiROcH6dUb4Uf-WNF8WBcYO2DqhRH9gDSq8Z2SYYkahyj7hszrgXabT-aEK37HnoQrmwOfkVWS8RoyUrnZE-hLNj1onI5Be7tFXilAiZV8pZThkLfUOzpHK4Ef2XQ4ZINAQAbMd3Mg0cWrNcFrD0m_OMVSRdV6lagz6OVhNUKpnY4tSDdNzKqRsAY",
    ),
    Product(
      id: 4,
      name: "Malai Paneer",
      category: "Paneer",
      unit: "200g",
      price: 90,
      stock: 65,
      visible: true,
      img: "https://lh3.googleusercontent.com/aida-public/AB6AXuCNBtAFcbDs2SphMDtn8y_FGvvRadRcWzUaExhDH9YRbAT0lWllSZAGGT6GBDvHS90N0iJ0CEBRi5NEkFXM1-4q-u1QOGYz9P6nxKdfq8HDXMolRRvUkrCoCzJAfznaatHwh-G3nDBIZDN7UpG1Ywak3dlUB4yShEDr9du_S1tN6I19a2kv4iczfN26y0uNjSjx7PKlGCIbSPAikPqGiq8hrshNmiK--ooBHTsHvkuB6VwzHrR-NqwvPvJQBzi3AhcHQPxF7xheMatv",
    ),
  ];

  int _nextId = 5;
  String _currentCat = "All";
  String _currentSearch = "";
  bool _sortAsc = true;
  Product? _editingProduct;
  
  bool _showSearchBar = false;
  final TextEditingController _searchController = TextEditingController();

  // Add Product State
  String? _addCat;
  final TextEditingController _addNameCtrl = TextEditingController();
  final TextEditingController _addPriceCtrl = TextEditingController();
  String _addUnit = "liter";
  bool _addErrCat = false;
  bool _addErrName = false;
  bool _addErrPrice = false;

  // Edit Product State
  final TextEditingController _editNameCtrl = TextEditingController();
  final TextEditingController _editPriceCtrl = TextEditingController();
  final TextEditingController _editStockCtrl = TextEditingController();
  String? _editCat;
  String? _editUnit;
  bool _editVisible = true;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _currentSearch = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _addNameCtrl.dispose();
    _addPriceCtrl.dispose();
    _editNameCtrl.dispose();
    _editPriceCtrl.dispose();
    _editStockCtrl.dispose();
    super.dispose();
  }

  void _showSnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Color(0xFF81B1FF)),
            const SizedBox(width: 12),
            Text(msg, style: const TextStyle(color: cInverseOnSurface, fontFamily: 'Manrope')),
          ],
        ),
        backgroundColor: cInverseSurface,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        action: SnackBarAction(
          label: 'DISMISS',
          textColor: cPrimaryFixedDim,
          onPressed: () {},
        ),
      ),
    );
  }

  void _confirmDelete(Product p) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 6,
                decoration: BoxDecoration(
                  color: cOutlineVariant.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: cErrorContainer,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.delete_forever, color: cError, size: 32),
              ),
              const SizedBox(height: 16),
              const Text(
                "Delete this product?",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: cOnSurface, fontFamily: 'Manrope'),
              ),
              const SizedBox(height: 8),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(fontSize: 16, color: cOnSurfaceVariant, fontFamily: 'Manrope'),
                  children: [
                    const TextSpan(text: "This action is permanent and cannot be undone. All data associated with "),
                    TextSpan(text: p.name, style: const TextStyle(fontWeight: FontWeight.w600, color: cOnSurface)),
                    const TextSpan(text: " will be removed."),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      products.removeWhere((item) => item.id == p.id);
                    });
                    _showSnackbar("Product deleted successfully");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cError,
                    foregroundColor: cOnError,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: const Text("Delete", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: cOnSurface,
                    side: const BorderSide(color: cOutline),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Cancel", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  void _saveAdd() {
    setState(() {
      _addErrCat = _addCat == null;
      _addErrName = _addNameCtrl.text.trim().isEmpty;
      _addErrPrice = _addPriceCtrl.text.trim().isEmpty || double.tryParse(_addPriceCtrl.text) == null;
    });

    if (!_addErrCat && !_addErrName && !_addErrPrice) {
      setState(() {
        products.add(Product(
          id: _nextId++,
          name: _addNameCtrl.text.trim(),
          category: _addCat!,
          unit: _addUnit,
          price: double.parse(_addPriceCtrl.text),
          stock: 0,
          visible: true,
          img: "https://lh3.googleusercontent.com/aida-public/AB6AXuBqhAycqZX9j8ZCS6dLtyljIXaH-enAwY0WRwDZkmKUHL3hQOMj2QPSEXzJru6RlDU69-5d_oB1MbVc9TtgNfYvrTqknPnBNZ4s8yTkyBQ1UML3U5iLAx8szMHgHUvmeZzwJIVJtJHdL_oi9LieF3J36MR3cd7wXPpsef9U2Ths37cYy8Gq23RUXAcNIUxpt28NQh4EGubs-_3xg8SMQ0Zgd4WbRN3j5i_XUi7VKCeLIaT7wsB9vDzq8FuhuMD6BWVPnHYQzmx7wEjd",
        ));
        _currentState = ProductViewState.list;
      });
      _showSnackbar("Product added successfully");
    }
  }

  void _saveEdit() {
    if (_editNameCtrl.text.trim().isEmpty || _editPriceCtrl.text.trim().isEmpty || _editingProduct == null) return;
    setState(() {
      _editingProduct!.name = _editNameCtrl.text.trim();
      _editingProduct!.category = _editCat ?? _editingProduct!.category;
      _editingProduct!.unit = _editUnit ?? _editingProduct!.unit;
      _editingProduct!.price = double.tryParse(_editPriceCtrl.text) ?? _editingProduct!.price;
      _editingProduct!.stock = int.tryParse(_editStockCtrl.text) ?? _editingProduct!.stock;
      _editingProduct!.visible = _editVisible;
      
      _currentState = ProductViewState.list;
    });
    _showSnackbar("Product updated successfully");
  }

  void _openEdit(Product p) {
    setState(() {
      _editingProduct = p;
      _editNameCtrl.text = p.name;
      _editPriceCtrl.text = p.price.toString();
      _editStockCtrl.text = p.stock.toString();
      _editCat = p.category;
      _editUnit = p.unit;
      _editVisible = p.visible;
      _currentState = ProductViewState.edit;
    });
  }

  void _openAdd() {
    setState(() {
      _addCat = null;
      _addNameCtrl.clear();
      _addPriceCtrl.clear();
      _addUnit = "liter";
      _addErrCat = false;
      _addErrName = false;
      _addErrPrice = false;
      _currentState = ProductViewState.add;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    switch (_currentState) {
      case ProductViewState.list:
        child = _buildListView();
        break;
      case ProductViewState.add:
        child = _buildAddView();
        break;
      case ProductViewState.edit:
        child = _buildEditView();
        break;
    }

    return Scaffold(
      backgroundColor: cSurface,
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 280),
          transitionBuilder: (Widget child, Animation<double> animation) {
            final offsetAnimation = Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            ));
            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
          child: KeyedSubtree(
            key: ValueKey<ProductViewState>(_currentState),
            child: child,
          ),
        ),
      ),
    );
  }

  // ==========================================
  // LIST VIEW
  // ==========================================
  Widget _buildListView() {
    List<Product> filtered = products.where((p) {
      final matchCat = _currentCat == "All" || p.category == _currentCat;
      final matchSearch = _currentSearch.isEmpty ||
          p.name.toLowerCase().contains(_currentSearch.toLowerCase()) ||
          p.category.toLowerCase().contains(_currentSearch.toLowerCase());
      return matchCat && matchSearch;
    }).toList();

    filtered.sort((a, b) => _sortAsc ? a.name.compareTo(b.name) : b.name.compareTo(a.name));

    return Stack(
      children: [
        Column(
          children: [
            // AppBar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.arrow_back, color: cPrimaryContainer),
                      const SizedBox(width: 16),
                      const Text(
                        "SecurePort",
                        style: TextStyle(
                          color: cPrimaryContainer,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                          fontFamily: 'Manrope',
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.search, color: Color(0xFF94A3B8)),
                        onPressed: () {
                          setState(() {
                            _showSearchBar = !_showSearchBar;
                            if (!_showSearchBar) _searchController.clear();
                          });
                        },
                      ),
                      const Icon(Icons.help_outline, color: Color(0xFF94A3B8)),
                    ],
                  )
                ],
              ),
            ),
            
            // Search Bar
            if (_showSearchBar)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Search products…",
                    hintStyle: const TextStyle(color: cOutlineVariant, fontSize: 14),
                    prefixIcon: const Icon(Icons.search, color: Color(0xFF94A3B8)),
                    filled: true,
                    fillColor: cSurfaceContainerLow,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: cOutlineVariant),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: cOutlineVariant),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: cPrimaryContainer),
                    ),
                  ),
                ),
              ),

            // Category Tabs
            Container(
              color: cSurface,
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: ["All", "Milk", "Curd", "Ghee", "Paneer", "Butter"].map((cat) {
                    final isActive = _currentCat == cat;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () => setState(() => _currentCat = cat),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          decoration: BoxDecoration(
                            color: isActive ? cPrimaryContainer : Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: isActive ? cPrimaryContainer : cOutlineVariant),
                          ),
                          child: Text(
                            cat == "All" ? "All Products" : cat,
                            style: TextStyle(
                              color: isActive ? Colors.white : cOnSurfaceVariant,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              fontFamily: 'Manrope',
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            // Product List
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${filtered.length} product${filtered.length == 1 ? '' : 's'}",
                            style: const TextStyle(color: cOnSurfaceVariant, fontSize: 14)),
                        GestureDetector(
                          onTap: () => setState(() => _sortAsc = !_sortAsc),
                          child: const Text("Sort ↕",
                              style: TextStyle(color: cPrimaryContainer, fontWeight: FontWeight.w600, fontSize: 12)),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: filtered.isEmpty
                        ? _buildEmptyState()
                        : ListView.separated(
                            padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
                            itemCount: filtered.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 16),
                            itemBuilder: (ctx, idx) => _buildProductCard(filtered[idx]),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),

        // FAB
        Positioned(
          right: 24,
          bottom: 84, // elevated above the bottom nav
          child: GestureDetector(
            onTap: _openAdd,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Simplified pulse effect
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: const Color(0xFFFF8C00).withOpacity(0.3), blurRadius: 20, spreadRadius: 5)
                    ],
                  ),
                ),
                Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF8C00),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 32),
                ),
              ],
            ),
          ),
        ),

        // Removed Bottom Navigation
        // PillBottomNavBar will be provided by MainShell
      ],
    );
  }

  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: const BoxDecoration(color: cSurfaceContainer, shape: BoxShape.circle),
          child: const Icon(Icons.inventory_2_outlined, size: 40, color: cOnSurfaceVariant),
        ),
        const SizedBox(height: 16),
        const Text("No products found",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: cOnSurface)),
        const SizedBox(height: 4),
        const Text("Try a different filter or add a new product.",
            style: TextStyle(fontSize: 14, color: cOnSurfaceVariant)),
      ],
    );
  }

  Widget _buildProductCard(Product p) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cOutlineVariant),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: cSurfaceContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            clipBehavior: Clip.hardEdge,
            child: Image.network(p.img, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported, color: cOnSurfaceVariant)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(p.category, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: cOnSurfaceVariant)),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => _openEdit(p),
                          child: const Icon(Icons.edit, size: 20, color: cSecondary),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () => _confirmDelete(p),
                          child: Icon(Icons.delete, size: 20, color: cError.withOpacity(0.7)),
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 4),
                Text(p.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: cOnSurface, height: 1.2)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text("₹${p.price.toStringAsFixed(p.price.truncateToDouble() == p.price ? 0 : 2)}", 
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: cPrimary)),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: cSecondaryContainer,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(p.unit, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: cOnSecondaryContainer)),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: p.visible ? Colors.green[500] : Colors.grey[300],
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(p.visible ? "Active" : "Hidden", 
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: p.visible ? Colors.green[600] : Colors.grey[400])),
                      ],
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  // ==========================================
  // ADD VIEW
  // ==========================================
  Widget _buildAddView() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFF94A3B8)),
                onPressed: () => setState(() => _currentState = ProductViewState.list),
              ),
              const Text("Add New Product", style: TextStyle(color: cPrimaryContainer, fontSize: 18, fontWeight: FontWeight.w600)),
              const Icon(Icons.help_outline, color: Color(0xFF94A3B8)),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLabel("Category"),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: _addErrCat ? cError : cOutlineVariant),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: _addCat,
                      hint: const Text("Select a category"),
                      items: ["Milk", "Curd", "Ghee", "Paneer", "Butter"].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (val) => setState(() { _addCat = val; _addErrCat = false; }),
                    ),
                  ),
                ),
                if (_addErrCat) const Padding(padding: EdgeInsets.only(top: 4), child: Text("Please select a category.", style: TextStyle(color: cError, fontSize: 12))),
                const SizedBox(height: 24),

                _buildLabel("Product Name"),
                const SizedBox(height: 8),
                TextField(
                  controller: _addNameCtrl,
                  onChanged: (_) => setState(() => _addErrName = false),
                  decoration: InputDecoration(
                    hintText: "e.g. Organic Whole Milk",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: _addErrName ? cError : cOutlineVariant)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: _addErrName ? cError : cOutlineVariant)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: cPrimaryContainer)),
                  ),
                ),
                if (_addErrName) const Padding(padding: EdgeInsets.only(top: 4), child: Text("Please enter a product name.", style: TextStyle(color: cError, fontSize: 12))),
                const SizedBox(height: 24),

                _buildLabel("Unit Type"),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: ["liter", "kg", "cup", "piece", "packet", "bottle", "gram"].map((unit) {
                    final isActive = _addUnit == unit;
                    return GestureDetector(
                      onTap: () => setState(() => _addUnit = unit),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                          color: isActive ? cPrimaryContainer : cSecondaryFixed,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(unit, style: TextStyle(color: isActive ? Colors.white : cOnSecondaryFixedVariant, fontWeight: FontWeight.w600, fontSize: 14)),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                _buildLabel("Price per unit"),
                const SizedBox(height: 8),
                TextField(
                  controller: _addPriceCtrl,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  onChanged: (_) => setState(() => _addErrPrice = false),
                  decoration: InputDecoration(
                    prefixIcon: const Padding(padding: EdgeInsets.all(12), child: Text("₹", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: cOnSurface))),
                    prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                    hintText: "0.00",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: _addErrPrice ? cError : cOutlineVariant)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: _addErrPrice ? cError : cOutlineVariant)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: cPrimaryContainer)),
                  ),
                ),
                if (_addErrPrice) const Padding(padding: EdgeInsets.only(top: 4), child: Text("Please enter a valid price.", style: TextStyle(color: cError, fontSize: 12))),
                const SizedBox(height: 24),

                // Insight card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cSurfaceContainer,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: cOutlineVariant.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                        clipBehavior: Clip.hardEdge,
                        child: Image.network("https://lh3.googleusercontent.com/aida-public/AB6AXuBqhAycqZX9j8ZCS6dLtyljIXaH-enAwY0WRwDZkmKUHL3hQOMj2QPSEXzJru6RlDU69-5d_oB1MbVc9TtgNfYvrTqknPnBNZ4s8yTkyBQ1UML3U5iLAx8szMHgHUvmeZzwJIVJtJHdL_oi9LieF3J36MR3cd7wXPpsef9U2Ths37cYy8Gq23RUXAcNIUxpt28NQh4EGubs-_3xg8SMQ0Zgd4WbRN3j5i_XUi7VKCeLIaT7wsB9vDzq8FuhuMD6BWVPnHYQzmx7wEjd", fit: BoxFit.cover),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Inventory Insight", style: TextStyle(color: cPrimaryContainer, fontWeight: FontWeight.w600, fontSize: 14)),
                            SizedBox(height: 4),
                            Text("Adding units helps in accurate stock tracking and financial reporting.", style: TextStyle(color: cOnSurfaceVariant, fontSize: 14)),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Color(0xFFF1F5F9))),
          ),
          child: ElevatedButton.icon(
            onPressed: _saveAdd,
            icon: const Icon(Icons.save, size: 20),
            label: const Text("Save Product", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            style: ElevatedButton.styleFrom(
              backgroundColor: cPrimaryContainer,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 56),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              elevation: 4,
            ),
          ),
        )
      ],
    );
  }

  // ==========================================
  // EDIT VIEW
  // ==========================================
  Widget _buildEditView() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(color: Color(0x140052CC), blurRadius: 20, offset: Offset(0, 4))],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: cBlue700),
                onPressed: () => setState(() => _currentState = ProductViewState.list),
              ),
              const Text("Edit Product", style: TextStyle(color: cBlue700, fontSize: 14, fontWeight: FontWeight.w600)),
              const Icon(Icons.help_outline, color: cBlue700),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Visual Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: cOutlineVariant.withOpacity(0.3)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(color: cSurfaceContainer, borderRadius: BorderRadius.circular(8)),
                        clipBehavior: Clip.hardEdge,
                        child: _editingProduct != null 
                          ? Image.network(_editingProduct!.img, fit: BoxFit.cover, errorBuilder: (_,__,___) => const Icon(Icons.image_not_supported)) 
                          : const SizedBox(),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("CURRENTLY EDITING", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0x99001736), letterSpacing: 1.5)),
                          const SizedBox(height: 4),
                          Text(_editingProduct?.name ?? "—", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: cPrimary)),
                          const SizedBox(height: 2),
                          const Text("SKU: —", style: TextStyle(fontSize: 14, color: cSecondary)),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Form
                _buildLabel("Product Name", color: cPrimary),
                const SizedBox(height: 8),
                _buildTextField(_editNameCtrl),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel("Category", color: cPrimary),
                          const SizedBox(height: 8),
                          _buildDropdown(_editCat, ["Milk", "Curd", "Ghee", "Paneer", "Butter"], (v) => setState(() => _editCat = v)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel("Unit Type", color: cPrimary),
                          const SizedBox(height: 8),
                          _buildDropdown(_editUnit, ["Litre", "kg", "Pouch", "Box", "g", "piece", "500g", "1kg", "200g"], (v) => setState(() => _editUnit = v)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Price
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cSurfaceContainerLow,
                    border: Border.all(color: cPrimary.withOpacity(0.05)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.payments, size: 18, color: cPrimary),
                          SizedBox(width: 8),
                          Text("Price per unit (Rate)", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: cPrimary)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _editPriceCtrl,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: cPrimary),
                        decoration: InputDecoration(
                          prefixIcon: const Padding(padding: EdgeInsets.only(left: 16, right: 8, top: 14), child: Text("₹", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: cPrimary))),
                          prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(vertical: 16),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: cOutlineVariant)),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: cOutlineVariant)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: cPrimary)),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text("Last updated recently", style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: cSecondary)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Stock & Visibility
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.white, border: Border.all(color: cOutlineVariant), borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.inventory_2, color: cSecondary),
                          SizedBox(width: 8),
                          Text("In Stock Inventory", style: TextStyle(fontSize: 16, color: cOnSurface)),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 80,
                            height: 32,
                            child: TextField(
                              controller: _editStockCtrl,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: cPrimary),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                filled: true,
                                fillColor: cSurfaceContainerLow,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: cOutlineVariant)),
                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: cOutlineVariant)),
                                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: cPrimary)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text("units", style: TextStyle(fontSize: 12, color: cSecondary)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.white, border: Border.all(color: cOutlineVariant), borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.visibility, color: cSecondary),
                          SizedBox(width: 8),
                          Text("Visible in Catalog", style: TextStyle(fontSize: 16, color: cOnSurface)),
                        ],
                      ),
                      Switch(
                        value: _editVisible,
                        onChanged: (val) => setState(() => _editVisible = val),
                        activeColor: Colors.white,
                        activeTrackColor: cPrimary,
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor: cOutlineVariant,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: cBlue50)),
          ),
          child: ElevatedButton(
            onPressed: _saveEdit,
            style: ElevatedButton.styleFrom(
              backgroundColor: cPrimary,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 56),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 4,
            ),
            child: const Text("Save Changes", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String text, {Color color = cOnSurfaceVariant}) {
    return Text(text, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color, letterSpacing: 0.2));
  }

  Widget _buildTextField(TextEditingController controller) {
    return TextField(
      controller: controller,
      style: const TextStyle(fontSize: 16, color: cOnSurface),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: cOutlineVariant)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: cOutlineVariant)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: cPrimary)),
      ),
    );
  }

  Widget _buildDropdown(String? value, List<String> items, ValueChanged<String?> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: cOutlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: value,
          icon: const Icon(Icons.expand_more, color: cSecondary),
          items: items.map((String val) {
            return DropdownMenuItem<String>(
              value: val,
              child: Text(val, style: const TextStyle(fontSize: 16, color: cOnSurface)),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  // Removed _buildNavItem

}
