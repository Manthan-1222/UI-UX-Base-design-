import 'package:flutter/material.dart';
import '../models/customer.dart';

// --- Colors from HTML ---
const Color cSurface = Color(0xfff8f9ff);
const Color cOnSurface = Color(0xff011d35);
const Color cOnSurfaceVariant = Color(0xff43474f);
const Color cSurfaceContainer = Color(0xffe4efff);
const Color cSurfaceContainerLow = Color(0xffeef4ff);
const Color cSurfaceContainerHigh = Color(0xffdbe9ff);
const Color cPrimaryContainer = Color(0xff002b5b);
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
const Color cPrimaryFixed = Color(0xffd6e3ff);
const Color cPrimaryFixedDim = Color(0xffa9c7ff);
const Color cTertiaryFixed = Color(0xffcee5ff);

const Color cGreenActive = Color(0xFF10b981);
const Color cSurfaceVariant = Color(0xFFF1F5F9);
const Color cGreyPaused = Color(0xFF94A3B8);

enum CustomerViewState { list, detail, edit }

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({Key? key}) : super(key: key);

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  CustomerViewState _currentState = CustomerViewState.list;
  Customer? _selectedCustomer;
  
  List<Customer> customers = [
    Customer(
      id: 1,
      name: 'John Doe',
      phone: '+91 98765 43210',
      type: 'fixed',
      location: 'House No. 42, Green Valley Apartments, Block C, Sector 15',
      status: 'active',
      avatar: 'JD',
      avatarClass: 'avatar-1',
      balance: 1240,
      dailySupply: '2.0L',
      morningSupply: '1.5L',
      eveningSupply: '0.5L',
      joined: 'Oct 12, 2023',
      transactions: [
        Transaction(type: 'supply', title: 'Delivered: 2.0L Buffalo Milk', desc: 'Morning slot completed by Delivery Boy Arjun', date: 'Today', amount: 90),
        Transaction(type: 'payment', title: 'Payment Received: ₹500', desc: 'Via UPI - Transaction ID: #9204910', date: 'Oct 24', amount: -500),
      ],
    ),
    Customer(
      id: 2,
      name: 'Rajesh Kumar',
      phone: '+91 88888 77777',
      type: 'fixed',
      location: 'B-402, Skyline Towers, New Town Extension',
      status: 'paused',
      avatar: 'RK',
      avatarClass: 'avatar-2',
      balance: 12450,
      dailySupply: '2.5L',
      morningSupply: '1.5L',
      eveningSupply: '1.0L',
      joined: 'Sep 15, 2023',
      transactions: [
        Transaction(type: 'supply', title: 'Milk Supply (Morning)', desc: '25 Oct • 1.5L', date: '25 Oct', amount: 90),
        Transaction(type: 'payment', title: 'Partial Payment', desc: '22 Oct • Cash', date: '22 Oct', amount: -500),
      ],
    ),
    Customer(
      id: 3,
      name: 'Vikram Singh',
      phone: '+91 99900 11122',
      type: 'fixed',
      location: 'Quarter 12, Police Housing Complex, Civil Lines',
      status: 'active',
      avatar: 'VS',
      avatarClass: 'avatar-3',
      balance: 850,
      dailySupply: '1.5L',
      morningSupply: '1.0L',
      eveningSupply: '0.5L',
      joined: 'Sep 10, 2023',
      transactions: [
        Transaction(type: 'supply', title: 'Delivered: 1.5L Cow Milk', desc: 'Morning slot - Regular delivery', date: 'Today', amount: 75),
        Transaction(type: 'payment', title: 'Payment Received: ₹300', desc: 'Via Cash', date: 'Oct 20', amount: -300),
      ],
    ),
    Customer(
      id: 4,
      name: 'Suresh Mehra',
      phone: '+91 98765 00000',
      type: 'ondemand',
      location: 'Sector 22, Green Park',
      status: 'active',
      avatar: 'SM',
      avatarClass: 'avatar-4',
      balance: 650,
      joined: 'Oct 5, 2023',
      transactions: [
        Transaction(type: 'supply', title: 'Delivered: 1.0L Buffalo Milk', desc: 'On-demand order', date: 'Today', amount: 50),
      ],
    ),
  ];

  int _nextId = 7;
  String _currentFilter = 'all'; // all, fixed, ondemand
  String _currentSearch = '';
  
  bool _showSearchBar = false;
  final TextEditingController _searchController = TextEditingController();

  // Edit State
  final TextEditingController _editNameCtrl = TextEditingController();
  final TextEditingController _editPhoneCtrl = TextEditingController();
  final TextEditingController _editAddressCtrl = TextEditingController();
  String _editType = 'fixed';
  String _editStatus = 'active';

  // Add State
  final TextEditingController _addNameCtrl = TextEditingController();
  final TextEditingController _addPhoneCtrl = TextEditingController();
  final TextEditingController _addAddressCtrl = TextEditingController();
  String _addType = 'fixed';

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
    _editNameCtrl.dispose();
    _editPhoneCtrl.dispose();
    _editAddressCtrl.dispose();
    _addNameCtrl.dispose();
    _addPhoneCtrl.dispose();
    _addAddressCtrl.dispose();
    super.dispose();
  }

  Color _getAvatarColor(String avatarClass) {
    switch (avatarClass) {
      case 'avatar-1': return cPrimaryFixed;
      case 'avatar-2': return cSecondaryFixed;
      case 'avatar-3': return cPrimaryContainer;
      case 'avatar-4': return cTertiaryFixed;
      case 'avatar-5': return cSecondaryContainer;
      case 'avatar-6': return cPrimaryFixed;
      default: return cSurfaceVariant;
    }
  }

  Color _getAvatarTextColor(String avatarClass) {
    if (avatarClass == 'avatar-3') return Colors.white;
    if (avatarClass == 'avatar-2' || avatarClass == 'avatar-5') return cSecondary;
    return cPrimary;
  }

  void _showSnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: cGreenActive),
            const SizedBox(width: 12),
            Text(msg, style: const TextStyle(color: cInverseOnSurface, fontFamily: 'Manrope')),
          ],
        ),
        backgroundColor: cInverseSurface,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _openAddModal() {
    _addNameCtrl.clear();
    _addPhoneCtrl.clear();
    _addAddressCtrl.clear();
    _addType = 'fixed';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                ),
                padding: const EdgeInsets.all(24),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 48,
                          height: 6,
                          decoration: BoxDecoration(color: cOutlineVariant.withOpacity(0.5), borderRadius: BorderRadius.circular(3)),
                          margin: const EdgeInsets.only(bottom: 24),
                        ),
                      ),
                      const Text("Add Customer", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: cOnSurface, fontFamily: 'Manrope')),
                      const SizedBox(height: 24),
                      
                      // Customer Type
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setModalState(() => _addType = 'fixed'),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  border: Border.all(color: _addType == 'fixed' ? cPrimary : cOutlineVariant, width: 2),
                                  borderRadius: BorderRadius.circular(12),
                                  color: _addType == 'fixed' ? cPrimary.withOpacity(0.05) : Colors.white,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Icon(Icons.calendar_today, color: _addType == 'fixed' ? cPrimary : cOnSurfaceVariant),
                                        Container(
                                          width: 16, height: 16,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(color: _addType == 'fixed' ? cPrimary : cOutlineVariant, width: 2),
                                            color: _addType == 'fixed' ? cPrimary : Colors.transparent,
                                          ),
                                          child: _addType == 'fixed' ? Center(child: Container(width: 6, height: 6, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle))) : null,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text("Fixed Customer", style: TextStyle(fontWeight: FontWeight.w600, color: _addType == 'fixed' ? cPrimary : cOnSurfaceVariant)),
                                    const SizedBox(height: 4),
                                    Text("Auto daily entries", style: TextStyle(fontSize: 12, color: cOnSurfaceVariant)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setModalState(() => _addType = 'ondemand'),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  border: Border.all(color: _addType == 'ondemand' ? cPrimary : cOutlineVariant, width: 2),
                                  borderRadius: BorderRadius.circular(12),
                                  color: _addType == 'ondemand' ? cPrimary.withOpacity(0.05) : Colors.white,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Icon(Icons.touch_app, color: _addType == 'ondemand' ? cPrimary : cOnSurfaceVariant),
                                        Container(
                                          width: 16, height: 16,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(color: _addType == 'ondemand' ? cPrimary : cOutlineVariant, width: 2),
                                            color: _addType == 'ondemand' ? cPrimary : Colors.transparent,
                                          ),
                                          child: _addType == 'ondemand' ? Center(child: Container(width: 6, height: 6, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle))) : null,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text("On-Demand", style: TextStyle(fontWeight: FontWeight.w600, color: _addType == 'ondemand' ? cPrimary : cOnSurfaceVariant)),
                                    const SizedBox(height: 4),
                                    Text("Manual entry", style: TextStyle(fontSize: 12, color: cOnSurfaceVariant)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      _buildLabel("Full Name"),
                      const SizedBox(height: 4),
                      TextField(
                        controller: _addNameCtrl,
                        decoration: _inputDeco("e.g. Rahul Sharma"),
                      ),
                      const SizedBox(height: 16),

                      _buildLabel("Phone Number"),
                      const SizedBox(height: 4),
                      TextField(
                        controller: _addPhoneCtrl,
                        keyboardType: TextInputType.phone,
                        decoration: _inputDeco("+91 98765 43210"),
                      ),
                      const SizedBox(height: 16),

                      _buildLabel("Address"),
                      const SizedBox(height: 4),
                      TextField(
                        controller: _addAddressCtrl,
                        maxLines: 3,
                        decoration: _inputDeco("Flat No, Wing, Society Name..."),
                      ),
                      const SizedBox(height: 24),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_addNameCtrl.text.trim().isEmpty || _addPhoneCtrl.text.trim().isEmpty) return;
                            
                            final initials = _addNameCtrl.text.trim().split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join('').toUpperCase();
                            
                            setState(() {
                              customers.add(Customer(
                                id: _nextId++,
                                name: _addNameCtrl.text.trim(),
                                phone: _addPhoneCtrl.text.trim(),
                                type: _addType,
                                location: _addAddressCtrl.text.trim(),
                                status: 'active',
                                avatar: initials,
                                avatarClass: 'avatar-1',
                                balance: 0,
                                dailySupply: _addType == 'fixed' ? '2.0L' : null,
                                morningSupply: _addType == 'fixed' ? '1.0L' : null,
                                eveningSupply: _addType == 'fixed' ? '1.0L' : null,
                                joined: 'Today',
                                transactions: [],
                              ));
                              _currentFilter = _addType; // switch to the added tab
                            });
                            Navigator.pop(context);
                            _showSnackbar("Customer added successfully!");
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: cPrimary,
                            foregroundColor: cOnError,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text("Save Customer Profile", style: TextStyle(fontWeight: FontWeight.w600, fontFamily: 'Manrope')),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            foregroundColor: cPrimary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text("Cancel", style: TextStyle(fontWeight: FontWeight.w600, fontFamily: 'Manrope')),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        );
      }
    );
  }

  void _openEditView(Customer c) {
    setState(() {
      _selectedCustomer = c;
      _editNameCtrl.text = c.name;
      _editPhoneCtrl.text = c.phone;
      _editAddressCtrl.text = c.location;
      _editType = c.type;
      _editStatus = c.status;
      _currentState = CustomerViewState.edit;
    });
  }

  void _saveEdit() {
    if (_selectedCustomer == null) return;
    if (_editNameCtrl.text.trim().isEmpty || _editPhoneCtrl.text.trim().isEmpty) return;

    setState(() {
      _selectedCustomer!.name = _editNameCtrl.text.trim();
      _selectedCustomer!.phone = _editPhoneCtrl.text.trim();
      _selectedCustomer!.location = _editAddressCtrl.text.trim();
      _selectedCustomer!.type = _editType;
      _selectedCustomer!.status = _editStatus;
      
      _selectedCustomer!.avatar = _editNameCtrl.text.trim().split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join('').toUpperCase();

      _currentState = CustomerViewState.detail;
    });
    _showSnackbar("Customer updated successfully!");
  }

  void _confirmDelete(Customer c) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 48, height: 6, decoration: BoxDecoration(color: cOutlineVariant.withOpacity(0.5), borderRadius: BorderRadius.circular(3)), margin: const EdgeInsets.only(bottom: 24)),
              Container(
                width: 64, height: 64,
                decoration: BoxDecoration(color: cErrorContainer, borderRadius: BorderRadius.circular(16)),
                child: const Icon(Icons.delete_outline, color: cError, size: 32),
              ),
              const SizedBox(height: 16),
              const Text("Delete Customer Record?", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: cPrimary, fontFamily: 'Manrope')),
              const SizedBox(height: 12),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(color: cOnSurfaceVariant, fontSize: 16, fontFamily: 'Manrope'),
                  children: [
                    const TextSpan(text: "Are you sure you want to delete "),
                    TextSpan(text: c.name, style: const TextStyle(fontWeight: FontWeight.w600, color: cPrimary)),
                    const TextSpan(text: "? All records will be permanently removed. This action cannot be undone."),
                  ]
                )
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      customers.removeWhere((item) => item.id == c.id);
                      _currentState = CustomerViewState.list;
                      _selectedCustomer = null;
                    });
                    _showSnackbar("Customer deleted successfully");
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: cError, foregroundColor: cOnError, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  child: const Text("Confirm Delete", style: TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(foregroundColor: cPrimary, side: const BorderSide(color: cOutlineVariant), padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  child: const Text("Cancel", style: TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    switch (_currentState) {
      case CustomerViewState.list: child = _buildListView(); break;
      case CustomerViewState.detail: child = _buildDetailView(); break;
      case CustomerViewState.edit: child = _buildEditView(); break;
    }

    return Scaffold(
      backgroundColor: cSurface,
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: KeyedSubtree(
            key: ValueKey<CustomerViewState>(_currentState),
            child: child,
          ),
        ),
      ),
      floatingActionButton: _currentState == CustomerViewState.list
          ? FloatingActionButton(
              onPressed: _openAddModal,
              backgroundColor: cPrimary,
              child: const Icon(Icons.add, color: Colors.white, size: 28),
            )
          : null,
      // bottomNavigationBar removed, using MainShell
    );
  }

  Widget _buildListView() {
    List<Customer> filtered = customers.where((c) {
      bool matchFilter = _currentFilter == 'all' || c.type == _currentFilter;
      bool matchSearch = _currentSearch.isEmpty || 
          c.name.toLowerCase().contains(_currentSearch.toLowerCase()) || 
          c.phone.contains(_currentSearch);
      return matchFilter && matchSearch;
    }).toList();

    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
            boxShadow: [BoxShadow(color: Color(0x05000000), offset: Offset(0, 2), blurRadius: 4)],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Text("📝", style: TextStyle(fontSize: 20)),
                  SizedBox(width: 8),
                  Text("DairyKhata", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: cOnSurface, fontFamily: 'Manrope')),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.search, color: cOnSurfaceVariant),
                    onPressed: () {
                      setState(() {
                        _showSearchBar = !_showSearchBar;
                        if (!_showSearchBar) _searchController.clear();
                      });
                    },
                  ),
                  Stack(
                    children: [
                      IconButton(icon: const Icon(Icons.notifications, color: cOnSurfaceVariant), onPressed: () {}),
                      Positioned(right: 8, top: 8, child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: cError, shape: BoxShape.circle))),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),

        // Search Bar
        if (_showSearchBar)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search by name or phone...",
                prefixIcon: const Icon(Icons.search, color: cOnSurfaceVariant),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: cOutlineVariant)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: cOutlineVariant)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: cPrimary)),
              ),
            ),
          ),

        // Tabs
        Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(color: cSecondaryContainer, borderRadius: BorderRadius.circular(16)),
            child: Row(
              children: [
                _buildTab('all', 'All', customers.length),
                _buildTab('fixed', 'Fixed', customers.where((c) => c.type == 'fixed').length),
                _buildTab('ondemand', 'On-Demand', customers.where((c) => c.type == 'ondemand').length),
              ],
            ),
          ),
        ),

        // Grid / List
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 400,
              mainAxisExtent: 180,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: filtered.length,
            itemBuilder: (context, index) => _buildCustomerCard(filtered[index]),
          ),
        ),
      ],
    );
  }

  Widget _buildTab(String filter, String label, int count) {
    bool isActive = _currentFilter == filter;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _currentFilter = filter),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isActive ? [const BoxShadow(color: Color(0x1A000000), offset: Offset(0, 2), blurRadius: 4)] : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(label, style: TextStyle(color: isActive ? cPrimary : cOnSurfaceVariant, fontWeight: FontWeight.w600, fontFamily: 'Manrope')),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: isActive ? cPrimary : cOnSurfaceVariant, borderRadius: BorderRadius.circular(10)),
                child: Text(count.toString(), style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomerCard(Customer c) {
    return GestureDetector(
      onTap: () => setState(() {
        _selectedCustomer = c;
        _currentState = CustomerViewState.detail;
      }),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cOutlineVariant),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 48, height: 48,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: _getAvatarColor(c.avatarClass)),
                      child: Center(child: Text(c.avatar, style: TextStyle(fontWeight: FontWeight.bold, color: _getAvatarTextColor(c.avatarClass)))),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(c.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: cPrimary, fontFamily: 'Manrope')),
                        const SizedBox(height: 4),
                        Text(c.phone, style: const TextStyle(fontSize: 14, color: cOnSurfaceVariant)),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: c.type == 'fixed' ? cSurfaceVariant : cSecondaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(c.type == 'fixed' ? 'FIXED' : 'ON-DEMAND', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: c.type == 'fixed' ? cPrimary : cOnSurfaceVariant)),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  const Icon(Icons.location_on, size: 16, color: cOnSurfaceVariant),
                  const SizedBox(width: 8),
                  Expanded(child: Text(c.location, style: const TextStyle(fontSize: 14, color: cOnSurfaceVariant), maxLines: 1, overflow: TextOverflow.ellipsis)),
                ],
              ),
            ),
            const Divider(height: 1, color: cOutlineVariant),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(width: 8, height: 8, decoration: BoxDecoration(color: c.status == 'active' ? cGreenActive : cGreyPaused, shape: BoxShape.circle)),
                    const SizedBox(width: 6),
                    Text(c.status == 'active' ? 'Active' : 'Paused', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: c.status == 'active' ? cGreenActive : cGreyPaused)),
                  ],
                ),
                if (c.type == 'fixed' && c.dailySupply != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: cPrimaryFixed, borderRadius: BorderRadius.circular(8)),
                    child: Text(c.dailySupply!, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: cPrimary)),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailView() {
    final c = _selectedCustomer!;
    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
            boxShadow: [BoxShadow(color: Color(0x05000000), offset: Offset(0, 2), blurRadius: 4)],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: cPrimary),
                onPressed: () => setState(() => _currentState = CustomerViewState.list),
              ),
              const Text("Customer Profile", style: TextStyle(color: cOnSurface, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Manrope')),
              const SizedBox(width: 48), // balance
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Card
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: cOutlineVariant),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(c.name, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: cPrimary, fontFamily: 'Manrope')),
                                    const SizedBox(width: 12),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: c.type == 'fixed' ? cSurfaceVariant : cSecondaryContainer,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(c.type == 'fixed' ? 'Fixed' : 'On-Demand', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: c.type == 'fixed' ? cPrimary : cOnSurfaceVariant)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () => _openEditView(c),
                                icon: const Icon(Icons.edit, color: cSecondary, size: 20),
                                style: IconButton.styleFrom(backgroundColor: cSurfaceContainerHigh, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                              ),
                              IconButton(
                                onPressed: () => _confirmDelete(c),
                                icon: Icon(Icons.delete, color: cError.withOpacity(0.8), size: 20),
                                style: IconButton.styleFrom(backgroundColor: cErrorContainer.withOpacity(0.5), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                              ),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(children: [const Icon(Icons.call, size: 18, color: cOnSurfaceVariant), const SizedBox(width: 8), Text(c.phone, style: const TextStyle(color: cOnSurfaceVariant))]),
                      const SizedBox(height: 12),
                      Row(children: [const Icon(Icons.location_on, size: 18, color: cOnSurfaceVariant), const SizedBox(width: 8), Expanded(child: Text(c.location, style: const TextStyle(color: cOnSurfaceVariant)))]),
                      const SizedBox(height: 12),
                      Row(children: [const Icon(Icons.calendar_today, size: 18, color: cOnSurfaceVariant), const SizedBox(width: 8), Text('Joined ${c.joined}', style: const TextStyle(color: cOnSurfaceVariant))]),
                      const SizedBox(height: 20),
                      const Divider(height: 1, color: cOutlineVariant),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: cPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                              child: const Icon(Icons.local_shipping, color: Colors.white),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Customer Logistics", style: TextStyle(fontSize: 12, color: cPrimaryFixedDim)),
                                  const Text("View Delivery Setup", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right, color: Colors.white),
                          ],
                        ),
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 16),
                // Stats grid
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: cOutlineVariant)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text("CURRENT BALANCE", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: cOnSurfaceVariant)),
                                Icon(Icons.account_balance_wallet, color: cPrimary),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text("₹${c.balance}", style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: cPrimary)),
                                const SizedBox(width: 8),
                                if (c.balance > 0)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(color: cErrorContainer, borderRadius: BorderRadius.circular(12)),
                                    child: const Text("Due", style: TextStyle(color: cError, fontSize: 11, fontWeight: FontWeight.bold)),
                                  )
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(child: ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: cPrimary, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))), child: const Text("Record Payment", style: TextStyle(fontSize: 11)))),
                                const SizedBox(width: 8),
                                Expanded(child: OutlinedButton(onPressed: () {}, style: OutlinedButton.styleFrom(foregroundColor: cPrimary, side: const BorderSide(color: cPrimary), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))), child: const Text("Send Reminder", style: TextStyle(fontSize: 11)))),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                
                if (c.type == 'fixed' && c.dailySupply != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: cOutlineVariant)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("DAILY SUBSCRIPTION", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: cOnSurfaceVariant)),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Text(c.dailySupply!, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: cPrimary)),
                            const SizedBox(width: 8),
                            const Text("Buffalo Milk", style: TextStyle(fontSize: 14, color: cOnSurfaceVariant)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Morning", style: TextStyle(fontSize: 12, color: cOnSurfaceVariant)),
                            Text(c.morningSupply ?? '-', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: cPrimary)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Evening", style: TextStyle(fontSize: 12, color: cOnSurfaceVariant)),
                            Text(c.eveningSupply ?? '-', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: cPrimary)),
                          ],
                        )
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 16),
                // Activity List
                Container(
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: cOutlineVariant)),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: const BoxDecoration(color: cSurface, borderRadius: BorderRadius.vertical(top: Radius.circular(16)), border: Border(bottom: BorderSide(color: cOutlineVariant))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text("RECENT ACTIVITY", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: cPrimary)),
                            Text("View All", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: cPrimary, decoration: TextDecoration.underline)),
                          ],
                        ),
                      ),
                      if (c.transactions.isEmpty)
                        const Padding(padding: EdgeInsets.all(24), child: Center(child: Text("No recent activity", style: TextStyle(color: cOnSurfaceVariant)))),
                      ...c.transactions.map((t) => Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 32, height: 32,
                              decoration: const BoxDecoration(color: cSurfaceContainer, shape: BoxShape.circle),
                              child: Icon(t.type == 'payment' ? Icons.account_balance_wallet : Icons.local_shipping, size: 16, color: cPrimary),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(child: Text(t.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14))),
                                      Text(t.date, style: const TextStyle(fontSize: 12, color: cOnSurfaceVariant)),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(t.desc, style: const TextStyle(fontSize: 14, color: cOnSurfaceVariant)),
                                ],
                              ),
                            )
                          ],
                        ),
                      )).toList(),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEditView() {
    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: cPrimary),
                onPressed: () => setState(() => _currentState = CustomerViewState.detail),
              ),
              const Text("Edit Customer", style: TextStyle(color: cOnSurface, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Manrope')),
              const SizedBox(width: 48),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLabel("Customer Type"),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(color: cSurfaceContainer, borderRadius: BorderRadius.circular(10), border: Border.all(color: cSurfaceContainerHigh)),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _editType = 'fixed'),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: _editType == 'fixed' ? cPrimary : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: _editType == 'fixed' ? [const BoxShadow(color: Color(0x26000000), offset: Offset(0, 1), blurRadius: 4)] : [],
                            ),
                            child: Center(child: Text("Fixed", style: TextStyle(fontWeight: FontWeight.w600, color: _editType == 'fixed' ? Colors.white : cOnSurfaceVariant))),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _editType = 'ondemand'),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: _editType == 'ondemand' ? cPrimary : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: _editType == 'ondemand' ? [const BoxShadow(color: Color(0x26000000), offset: Offset(0, 1), blurRadius: 4)] : [],
                            ),
                            child: Center(child: Text("On-Demand", style: TextStyle(fontWeight: FontWeight.w600, color: _editType == 'ondemand' ? Colors.white : cOnSurfaceVariant))),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                _buildLabel("Full Name"),
                const SizedBox(height: 8),
                TextField(
                  controller: _editNameCtrl,
                  decoration: _inputDeco("Full Name"),
                ),
                const SizedBox(height: 20),

                _buildLabel("Phone Number"),
                const SizedBox(height: 8),
                TextField(
                  controller: _editPhoneCtrl,
                  keyboardType: TextInputType.phone,
                  decoration: _inputDeco("Phone Number", icon: Icons.call),
                ),
                const SizedBox(height: 20),

                _buildLabel("Address"),
                const SizedBox(height: 8),
                TextField(
                  controller: _editAddressCtrl,
                  maxLines: 3,
                  decoration: _inputDeco("Address"),
                ),
                const SizedBox(height: 20),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: cOutlineVariant)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Account Status", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                          Text(_editStatus == 'active' ? 'Active' : 'Paused', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: _editStatus == 'active' ? cGreenActive : cOnSurfaceVariant)),
                        ],
                      ),
                      Switch(
                        value: _editStatus == 'active',
                        onChanged: (val) => setState(() => _editStatus = val ? 'active' : 'paused'),
                        activeColor: Colors.white,
                        activeTrackColor: cPrimary,
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor: cOutlineVariant,
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _saveEdit,
                    icon: const Icon(Icons.save),
                    label: const Text("Save Changes", style: TextStyle(fontWeight: FontWeight.w600)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cPrimary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: cOnSurfaceVariant)),
    );
  }

  InputDecoration _inputDeco(String hint, {IconData? icon}) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: icon != null ? Icon(icon, color: cOnSurfaceVariant) : null,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: cOutlineVariant)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: cOutlineVariant)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: cPrimary)),
    );
  }

  // Removed _buildBottomNav and _buildNavItem
}
