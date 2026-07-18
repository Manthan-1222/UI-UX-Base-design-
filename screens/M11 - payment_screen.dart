import 'package:flutter/material.dart';
import '../widgets/pill_nav_bar.dart';

// ─── Brand colours (from HTML design tokens) ───────────────────────────────
const Color _cSurface              = Color(0xFFF8F9FF);
const Color _cOnSurface            = Color(0xFF011D35);
const Color _cOnSurfaceVariant     = Color(0xFF43474F);
const Color _cPrimary              = Color(0xFF001736);
const Color _cPrimaryContainer     = Color(0xFF002B5B);
const Color _cOnPrimaryContainer   = Color(0xFF7594CA);
const Color _cSurfaceContainerLow  = Color(0xFFEEF4FF);
const Color _cSurfaceContainer     = Color(0xFFE4EFFF);
const Color _cSurfaceContainerHigh = Color(0xFFDBE9FF);
const Color _cSurfaceLowest        = Color(0xFFFFFFFF);
const Color _cOutlineVariant       = Color(0xFFC4C6D0);
const Color _cOutline              = Color(0xFF747780);
const Color _cError                = Color(0xFFBA1A1A);
const Color _cSecondaryContainer   = Color(0xFFDBE3F1);
const Color _cOnSecondaryContainer = Color(0xFF5D6571);
const Color _cPrimaryFixed         = Color(0xFFD6E3FF);
const Color _cOnPrimaryFixed       = Color(0xFF001B3D);
const Color _cOnPrimaryFixedVariant= Color(0xFF264778);

// ─── Data model ─────────────────────────────────────────────────────────────
class _Payment {
  final int id;
  final String customer;
  final double amount;
  final String method;
  final String date;
  final String invoice;
  _Payment({required this.id, required this.customer, required this.amount,
            required this.method, required this.date, required this.invoice});
}

class _CustomerHistory {
  final String phone;
  final double outstanding;
  final double totalPaid;
  final String avatar;
  final List<Map<String, String>> payments;
  _CustomerHistory({required this.phone, required this.outstanding,
                    required this.totalPaid, required this.avatar,
                    required this.payments});
}

// ─── Main Widget ─────────────────────────────────────────────────────────────
class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  // ── Bottom-nav state (mirrors MainShell – Payments tab is index 3) ────────
  int _navIndex = 3; // "Card / Payments" icon is index 3 in PillBottomNavBar

  // ── Internal screen state (1=Dashboard, 2=Record, 3=History, 4=Success) ──
  int _currentScreen = 1;

  // ── Sample data ───────────────────────────────────────────────────────────
  final List<_Payment> _payments = [
    _Payment(id:1, customer:'Rahul Sharma', amount:1250,  method:'Cash',   date:'15 Oct, 2023', invoice:'DK-1024'),
    _Payment(id:2, customer:'Priya Patel',  amount:5000,  method:'UPI',    date:'14 Oct, 2023', invoice:'Credit'),
    _Payment(id:3, customer:'Amit Verma',   amount:2800,  method:'Bank',   date:'13 Oct, 2023', invoice:'DK-1021'),
    _Payment(id:4, customer:'Suresh Singh', amount:12400, method:'Cheque', date:'12 Oct, 2023', invoice:'DK-1019'),
  ];

  final Map<String, _CustomerHistory> _customerHistory = {
    'Rajesh Kumar': _CustomerHistory(
      phone:'+91 98765 43210', outstanding:1200, totalPaid:8400, avatar:'RK',
      payments:[
        {'amount':'2100','method':'UPI',         'date':'Oct 24, 2023','time':'09:45 AM','invoice':'INV-2991'},
        {'amount':'1500','method':'Cash',         'date':'Oct 12, 2023','time':'06:20 PM','invoice':'INV-2842'},
        {'amount':'2400','method':'Net Banking',  'date':'Sep 30, 2023','time':'10:15 AM','invoice':'INV-2711'},
        {'amount':'2400','method':'UPI',          'date':'Sep 01, 2023','time':'08:00 AM','invoice':'INV-2598'},
      ],
    ),
    'Rahul Sharma': _CustomerHistory(
      phone:'+91 98765 43210', outstanding:800, totalPaid:5200, avatar:'RS',
      payments:[{'amount':'1250','method':'Cash','date':'Oct 15, 2023','time':'02:30 PM','invoice':'INV-2801'}],
    ),
    'Priya Patel': _CustomerHistory(
      phone:'+91 98765 43210', outstanding:2000, totalPaid:12000, avatar:'PP',
      payments:[{'amount':'5000','method':'UPI','date':'Oct 14, 2023','time':'11:15 AM','invoice':'INV-2800'}],
    ),
  };

  // ── Record Payment form state ─────────────────────────────────────────────
  String? _selectedCustomerForm;
  final TextEditingController _amountCtrl = TextEditingController(text: '2500');
  String? _selectedMethod;

  // ── History / success state ───────────────────────────────────────────────
  String _historyCustomer = 'Rajesh Kumar';
  String? _filterCustomer;

  // ── Success data ──────────────────────────────────────────────────────────
  String _successAmount   = '';
  String _successCustomer = '';
  String _successMethod   = '';
  String _transactionId   = '';
  String _successDate     = '';
  String _successTime     = '';

  // ─────────────────────────────────────────────────────────────────────────
  void _switchScreen(int s) => setState(() => _currentScreen = s);

  void _confirmPayment() {
    final customer = _selectedCustomerForm;
    final amount   = double.tryParse(_amountCtrl.text);
    if (customer == null || customer.isEmpty || amount == null || _selectedMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields!')));
      return;
    }
    final now = DateTime.now();
    setState(() {
      _payments.insert(0, _Payment(
        id: _payments.length + 1, customer: customer, amount: amount,
        method: _selectedMethod!, date: '${now.day} ${_monthName(now.month)}, ${now.year}',
        invoice: 'INV-${now.millisecondsSinceEpoch}',
      ));
      _successAmount   = '₹${amount.toStringAsFixed(2)}';
      _successCustomer = customer;
      _successMethod   = 'Payment Confirmed via $_selectedMethod';
      _transactionId   = 'PAY-${now.millisecondsSinceEpoch}';
      _successDate     = '${_pad(now.day)} ${_monthName(now.month)} ${now.year}';
      _successTime     = '${_pad(now.hour)}:${_pad(now.minute)}';
      _currentScreen   = 4;
    });
  }

  String _monthName(int m) => const ['','Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'][m];
  String _pad(int v) => v.toString().padLeft(2, '0');

  Color _methodColor(String m) {
    switch(m) {
      case 'Cash':        return const Color(0xFFDCFCE7);
      case 'UPI':         return const Color(0xFFF3E8FF);
      case 'Bank':
      case 'Net Banking': return const Color(0xFFDBEAFE);
      case 'Cheque':      return const Color(0xFFFEF3C7);
      default:            return const Color(0xFFF3F4F6);
    }
  }
  Color _methodTextColor(String m) {
    switch(m) {
      case 'Cash':        return const Color(0xFF166534);
      case 'UPI':         return const Color(0xFF7E22CE);
      case 'Bank':
      case 'Net Banking': return const Color(0xFF1D4ED8);
      case 'Cheque':      return const Color(0xFFB45309);
      default:            return const Color(0xFF374151);
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _cSurface,
      body: Stack(
        children: [
          // ── Content area ─────────────────────────────────────────────────
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: _buildCurrentScreen(),
          ),

          // ── FAB (show only on Dashboard) ─────────────────────────────────
          if (_currentScreen == 1)
            Positioned(
              bottom: 110,
              right: 24,
              child: FloatingActionButton(
                backgroundColor: _cPrimaryContainer,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                onPressed: () => _switchScreen(2),
                child: const Icon(Icons.add, size: 32),
              ),
            ),

          // ── PillBottomNavBar (replaces HTML <nav>) ────────────────────────
          Positioned(
            left: 0, right: 0, bottom: 0,
            child: PillBottomNavBar(
              activeIndex: _navIndex,
              onTabSelected: (i) => setState(() => _navIndex = i),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Screen router ────────────────────────────────────────────────────────
  Widget _buildCurrentScreen() {
    switch (_currentScreen) {
      case 2: return _buildRecordPaymentScreen(key: const ValueKey(2));
      case 3: return _buildCustomerHistoryScreen(key: const ValueKey(3));
      case 4: return _buildSuccessScreen(key: const ValueKey(4));
      default: return _buildDashboard(key: const ValueKey(1));
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SCREEN 1 – Dashboard
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildDashboard({Key? key}) {
    final filtered = _filterCustomer == null
        ? _payments
        : _payments.where((p) => p.customer == _filterCustomer).toList();

    return CustomScrollView(key: key, slivers: [
      // ── App Bar ──────────────────────────────────────────────────────────
      SliverAppBar(
        pinned: true, floating: false, elevation: 1,
        backgroundColor: _cSurface,
        leading: const Padding(
          padding: EdgeInsets.all(12),
          child: Icon(Icons.menu, color: _cPrimary),
        ),
        title: const Text('DairyKhata',
          style: TextStyle(fontWeight: FontWeight.w800, color: _cPrimary, fontSize: 22)),
        actions: const [
          Icon(Icons.search, color: _cOnSurfaceVariant),
          SizedBox(width: 12),
          Icon(Icons.account_circle, color: _cPrimary),
          SizedBox(width: 16),
        ],
      ),

      SliverPadding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 140),
        sliver: SliverList(delegate: SliverChildListDelegate([

          // ── Summary cards ────────────────────────────────────────────────
          Row(children: [
            Expanded(child: _summaryCard('Total Collected', '₹64,200',
              sub: '+12% from last month', subColor: Colors.green.shade700,
              subIcon: Icons.trending_up)),
            const SizedBox(width: 12),
            Expanded(child: _summaryCard('Outstanding', '₹18,200',
              valueColor: _cError, sub: 'Across 14 customers',
              subIcon: Icons.info_outline)),
          ]),
          const SizedBox(height: 12),
          _summaryCard('Payments This Month', '24',
            sub: 'Last payment 2h ago', subIcon: Icons.calendar_today),

          const SizedBox(height: 24),

          // ── Customer filter ───────────────────────────────────────────────
          Container(
            decoration: BoxDecoration(
              color: _cSurfaceLowest,
              border: Border.all(color: _cOutlineVariant),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(children: [
              const SizedBox(width: 12),
              const Icon(Icons.person_search, color: _cOutline),
              const SizedBox(width: 8),
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _filterCustomer,
                    hint: const Text('All Customers',
                      style: TextStyle(color: _cOnSurfaceVariant)),
                    isExpanded: true,
                    icon: const Icon(Icons.expand_more, color: _cOutline),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('All Customers')),
                      ...['Rahul Sharma','Priya Patel','Amit Verma','Rajesh Kumar']
                          .map((n) => DropdownMenuItem(value: n, child: Text(n))),
                    ],
                    onChanged: (v) => setState(() => _filterCustomer = v),
                  ),
                ),
              ),
            ]),
          ),

          const SizedBox(height: 24),

          // ── Recent Payments heading ───────────────────────────────────────
          Text(
            _filterCustomer == null ? 'Recent Payments' : 'Payments — $_filterCustomer',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: _cPrimary),
          ),
          const SizedBox(height: 12),

          // ── Payment cards ─────────────────────────────────────────────────
          if (filtered.isEmpty)
            Center(child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Text('No payments found for $_filterCustomer',
                style: const TextStyle(color: _cOnSurfaceVariant)),
            ))
          else
            ...filtered.map((p) => _paymentCard(p)).toList(),
        ])),
      ),
    ]);
  }

  Widget _summaryCard(String label, String value, {
    Color valueColor = _cPrimary, String sub = '', Color? subColor, IconData? subIcon}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cSurfaceLowest,
        border: Border.all(color: _cOutlineVariant),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4)],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
            color: _cOnSurfaceVariant, letterSpacing: 0.3)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: valueColor)),
        if (sub.isNotEmpty) ...[
          const SizedBox(height: 6),
          Row(children: [
            if (subIcon != null) Icon(subIcon, size: 14, color: subColor ?? _cOnSurfaceVariant),
            const SizedBox(width: 4),
            Text(sub, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
                color: subColor ?? _cOnSurfaceVariant)),
          ]),
        ],
      ]),
    );
  }

  Widget _paymentCard(_Payment p) {
    return GestureDetector(
      onTap: () { setState(() => _historyCustomer = p.customer); _switchScreen(3); },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _cSurfaceLowest,
          border: Border.all(color: _cOutlineVariant),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(children: [
          Container(
            width: 48, height: 48,
            decoration: const BoxDecoration(color: _cSecondaryContainer, shape: BoxShape.circle),
            child: const Icon(Icons.person, color: _cOnSecondaryContainer),
          ),
          const SizedBox(width: 16),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(p.customer, style: const TextStyle(fontWeight: FontWeight.w600,
                fontSize: 14, color: _cOnSurface)),
            Text('${p.invoice} • ${p.date}', style: const TextStyle(fontSize: 12,
                color: _cOnSurfaceVariant)),
          ])),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text('₹${p.amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: _cPrimary)),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: _methodColor(p.method),
                borderRadius: BorderRadius.circular(99),
              ),
              child: Text(p.method, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700,
                  color: _methodTextColor(p.method))),
            ),
          ]),
        ]),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SCREEN 2 – Record Payment (bottom-sheet style)
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildRecordPaymentScreen({Key? key}) {
    return Stack(key: key, children: [
      // Backdrop
      GestureDetector(
        onTap: () => _switchScreen(1),
        child: Container(color: Colors.black45),
      ),

      // Header bar
      Positioned(
        top: 0, left: 0, right: 0,
        child: AppBar(
          backgroundColor: _cSurface, elevation: 1,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: _cPrimary),
            onPressed: () => _switchScreen(1),
          ),
          title: const Text('Record Payment',
            style: TextStyle(fontWeight: FontWeight.w800, color: _cPrimary)),
        ),
      ),

      // Modal sheet
      Positioned(
        bottom: 0, left: 0, right: 0,
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85),
          decoration: const BoxDecoration(
            color: _cSurfaceLowest,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 24, offset: Offset(0,−8))],
          ),
          child: SingleChildScrollView(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Handlebar
              Center(child: Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                width: 32, height: 4,
                decoration: BoxDecoration(color: _cOutlineVariant,
                    borderRadius: BorderRadius.circular(99)),
              )),

              // Header
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Record Payment', style: TextStyle(fontSize: 20,
                      fontWeight: FontWeight.w700, color: _cOnSurface)),
                  SizedBox(height: 2),
                  Text('Step 1: Select Customer', style: TextStyle(fontSize: 13,
                      color: _cOnSurfaceVariant)),
                ]),
              ),
              const Divider(height: 1, color: _cOutlineVariant),

              Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                  // ── Customer picker ────────────────────────────────────────
                  const Text('Select Customer', style: TextStyle(fontSize: 13,
                      fontWeight: FontWeight.w600, color: _cOnSurfaceVariant)),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: _cSurface, border: Border.all(color: _cOutlineVariant),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedCustomerForm,
                        isExpanded: true,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        hint: const Text('Choose a customer',
                          style: TextStyle(color: _cOnSurfaceVariant)),
                        items: ['Rajesh Kumar','Rahul Sharma','Priya Patel',
                                'Amit Verma','Suresh Singh']
                          .map((n) => DropdownMenuItem(value: n, child: Text(n))).toList(),
                        onChanged: (v) => setState(() => _selectedCustomerForm = v),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── Amount field ──────────────────────────────────────────
                  const Text('Enter Amount', style: TextStyle(fontSize: 13,
                      fontWeight: FontWeight.w600, color: _cOnSurfaceVariant)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _amountCtrl,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
                    decoration: InputDecoration(
                      prefixText: '₹ ',
                      prefixStyle: const TextStyle(fontSize: 26, color: _cOnSurfaceVariant),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: _cOutlineVariant),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: _cPrimary, width: 1.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(children: const [
                    Icon(Icons.info, size: 16, color: _cPrimary),
                    SizedBox(width: 4),
                    Text('Outstanding: ₹ 2,500.00',
                      style: TextStyle(fontSize: 13, color: _cPrimary)),
                  ]),
                  const SizedBox(height: 16),

                  // ── Quick amounts ─────────────────────────────────────────
                  Wrap(spacing: 8, children: [
                    for (final amt in [500, 1000, 2000])
                      OutlinedButton(
                        onPressed: () => setState(() => _amountCtrl.text = '$amt'),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: _cOutlineVariant),
                          foregroundColor: _cOnSurfaceVariant,
                          shape: const StadiumBorder(),
                        ),
                        child: Text('₹ $amt'),
                      ),
                    OutlinedButton(
                      onPressed: () => setState(() => _amountCtrl.text = '2500'),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: _cPrimaryFixed,
                        foregroundColor: _cOnPrimaryFixedVariant,
                        side: BorderSide.none,
                        shape: const StadiumBorder(),
                      ),
                      child: const Text('Full Amount'),
                    ),
                  ]),
                  const SizedBox(height: 24),

                  // ── Payment method ────────────────────────────────────────
                  const Text('Payment Method', style: TextStyle(fontSize: 13,
                      fontWeight: FontWeight.w600, color: _cOnSurfaceVariant)),
                  const SizedBox(height: 8),
                  GridView.count(
                    crossAxisCount: 3, shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 8, mainAxisSpacing: 8, childAspectRatio: 1.3,
                    children: [
                      for (final entry in {
                        'Cash':    Icons.payments,
                        'UPI':     Icons.qr_code_2,
                        'Bank':    Icons.account_balance,
                        'Cheque':  Icons.style,
                        'Other':   Icons.more_horiz,
                      }.entries)
                        _methodButton(entry.key, entry.value),
                    ],
                  ),
                  const SizedBox(height: 28),
                ]),
              ),

              // ── Confirm button ─────────────────────────────────────────────
              const Divider(height: 1, color: _cOutlineVariant),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                child: ElevatedButton(
                  onPressed: _confirmPayment,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 56),
                    backgroundColor: _cPrimary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Confirm Payment',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                ),
              ),
            ]),
          ),
        ),
      ),
    ]);
  }

  Widget _methodButton(String label, IconData icon) {
    final isActive = _selectedMethod == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedMethod = label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: isActive ? _cSecondaryContainer : _cSurface,
          border: Border.all(color: isActive ? _cPrimary : _cOutlineVariant, width: isActive ? 1.5 : 1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, color: _cPrimary),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
        ]),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SCREEN 3 – Customer History
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildCustomerHistoryScreen({Key? key}) {
    final hist = _customerHistory[_historyCustomer]
        ?? _customerHistory['Rajesh Kumar']!;

    return CustomScrollView(key: key, slivers: [
      SliverAppBar(
        pinned: true, elevation: 1, backgroundColor: _cSurface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _cPrimary),
          onPressed: () => _switchScreen(1),
        ),
        title: const Text('Customer History',
          style: TextStyle(fontWeight: FontWeight.w800, color: _cPrimary, fontSize: 20)),
        actions: const [
          Icon(Icons.search, color: _cOnSurfaceVariant),
          SizedBox(width: 12),
          Icon(Icons.account_circle, color: _cPrimary),
          SizedBox(width: 16),
        ],
      ),

      SliverPadding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 140),
        sliver: SliverList(delegate: SliverChildListDelegate([

          // ── Customer header ────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _cSurfaceLowest, border: Border.all(color: _cOutlineVariant),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(children: [
              CircleAvatar(
                radius: 28, backgroundColor: _cPrimaryFixed,
                child: Text(hist.avatar, style: const TextStyle(
                  fontWeight: FontWeight.w700, color: _cOnPrimaryFixed, fontSize: 15)),
              ),
              const SizedBox(width: 16),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(_historyCustomer, style: const TextStyle(fontSize: 20,
                    fontWeight: FontWeight.w700, color: _cOnSurface)),
                Text(hist.phone, style: const TextStyle(color: _cOnSurfaceVariant, fontSize: 13)),
              ])),
              ElevatedButton.icon(
                onPressed: () => _switchScreen(2),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Payment'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _cPrimary, foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ]),
          ),

          const SizedBox(height: 16),

          // ── Metrics ───────────────────────────────────────────────────────
          Row(children: [
            Expanded(child: _metricsCard('Total Paid', '₹${hist.totalPaid.toStringAsFixed(0)}',
              textColor: _cPrimary, sub: '12 Payments successful', subIcon: Icons.trending_up)),
            const SizedBox(width: 12),
            Expanded(child: _metricsCard('Outstanding', '₹${hist.outstanding.toStringAsFixed(0)}',
              textColor: _cError, sub: 'Last invoice due in 4 days', subIcon: Icons.history)),
          ]),

          const SizedBox(height: 24),

          // ── Timeline header ───────────────────────────────────────────────
          Row(children: const [
            Text('Payment History', style: TextStyle(fontSize: 20,
                fontWeight: FontWeight.w700, color: _cOnSurface)),
            Spacer(),
            Icon(Icons.filter_list, color: _cOnSurfaceVariant),
          ]),
          const SizedBox(height: 16),

          // ── Timeline ──────────────────────────────────────────────────────
          ...hist.payments.asMap().entries.map((e) {
            final idx = e.key; final p = e.value;
            final isLast = idx == hist.payments.length - 1;
            return IntrinsicHeight(
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                SizedBox(width: 40, child: Column(children: [
                  Container(width: 14, height: 14,
                    decoration: BoxDecoration(
                      color: _cPrimary, shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: _cSurface, spreadRadius: 3)],
                    ),
                  ),
                  if (!isLast) Expanded(child: Container(
                    width: 1,
                    color: _cOutline.withOpacity(0.3),
                  )),
                ])),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _cSurfaceLowest, border: Border.all(color: _cOutlineVariant),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(children: [
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(children: [
                          Text('₹${p['amount']}', style: const TextStyle(fontSize: 18,
                              fontWeight: FontWeight.w700, color: _cOnSurface)),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: _methodColor(p['method']!),
                              borderRadius: BorderRadius.circular(99),
                            ),
                            child: Text(p['method']!, style: TextStyle(fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: _methodTextColor(p['method']!))),
                          ),
                        ]),
                        const SizedBox(height: 4),
                        Text('${p['date']} • ${p['time']}',
                          style: const TextStyle(fontSize: 12, color: _cOnSurfaceVariant)),
                      ])),
                      const Icon(Icons.chevron_right, color: _cOnSurfaceVariant),
                    ]),
                  ),
                ),
              ]),
            );
          }).toList(),

          // Load More
          Center(child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: _cPrimary, side: const BorderSide(color: _cPrimary),
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
            ),
            child: const Text('Load Older Payments', style: TextStyle(fontWeight: FontWeight.w600)),
          )),
        ])),
      ),
    ]);
  }

  Widget _metricsCard(String label, String value,
      {Color textColor = _cPrimary, required String sub, required IconData subIcon}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cSurfaceContainerLow,
        border: Border.all(color: _cOutlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label.toUpperCase(), style: const TextStyle(fontSize: 10,
            fontWeight: FontWeight.w600, color: _cOnSurfaceVariant, letterSpacing: 0.5)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: textColor)),
        const SizedBox(height: 6),
        Row(children: [
          Icon(subIcon, size: 12, color: _cOnSurfaceVariant),
          const SizedBox(width: 4),
          Expanded(child: Text(sub, style: const TextStyle(fontSize: 10, color: _cOnSurfaceVariant))),
        ]),
      ]),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SCREEN 4 – Success / Payment Details
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildSuccessScreen({Key? key}) {
    return CustomScrollView(key: key, slivers: [
      SliverAppBar(
        pinned: true, elevation: 1, backgroundColor: _cSurface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _cPrimary),
          onPressed: () => _switchScreen(1),
        ),
        title: const Text('Payment Details',
          style: TextStyle(fontWeight: FontWeight.w800, color: _cPrimary, fontSize: 20)),
        actions: const [
          Icon(Icons.share, color: _cOnSurfaceVariant),
          SizedBox(width: 8),
          Icon(Icons.print, color: _cOnSurfaceVariant),
          SizedBox(width: 16),
        ],
      ),

      SliverPadding(
        padding: const EdgeInsets.fromLTRB(20, 32, 20, 140),
        sliver: SliverList(delegate: SliverChildListDelegate([

          // ── Success icon ──────────────────────────────────────────────────
          Center(child: Column(children: [
            Container(
              width: 80, height: 80,
              decoration: const BoxDecoration(
                color: _cSecondaryContainer, shape: BoxShape.circle),
              child: const Icon(Icons.check_circle, size: 40, color: _cPrimary),
            ),
            const SizedBox(height: 16),
            const Text('TOTAL AMOUNT PAID', style: TextStyle(fontSize: 11,
                fontWeight: FontWeight.w600, color: _cOnSurfaceVariant, letterSpacing: 0.5)),
            const SizedBox(height: 4),
            Text(_successAmount, style: const TextStyle(fontSize: 32,
                fontWeight: FontWeight.w800, color: _cPrimary)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: _cSurfaceContainerHigh,
                borderRadius: BorderRadius.circular(99),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.payments, size: 16, color: _cOnPrimaryFixedVariant),
                const SizedBox(width: 6),
                Text(_successMethod, style: const TextStyle(fontSize: 13,
                    fontWeight: FontWeight.w600, color: _cOnPrimaryFixedVariant)),
              ]),
            ),
          ])),

          const SizedBox(height: 32),

          // ── Detail cards ──────────────────────────────────────────────────
          Row(children: [
            Expanded(child: _detailCard(
              icon: Icons.fingerprint, label: 'TRANSACTION ID', value: _transactionId)),
            const SizedBox(width: 12),
            Expanded(child: _detailCard(
              icon: Icons.person, label: 'CUSTOMER', value: _successCustomer)),
          ]),
          const SizedBox(height: 12),
          _detailCard(
            icon: Icons.calendar_today, label: 'DATE',
            value: _successDate, extra: _successTime,
            extraIcon: Icons.schedule, extraLabel: 'TIME',
          ),

          const SizedBox(height: 20),

          // ── Info note ─────────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _cSurfaceContainerLow,
              border: Border.all(color: _cOutlineVariant, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Icon(Icons.info_outline, color: _cOutline, size: 18),
              SizedBox(width: 12),
              Expanded(child: Text(
                'Payments are permanent and cannot be modified. If there is a dispute or error, please contact support.',
                style: TextStyle(fontSize: 12, color: _cOnSurfaceVariant),
              )),
            ]),
          ),

          const SizedBox(height: 24),

          // ── Action buttons ────────────────────────────────────────────────
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 56),
              backgroundColor: _cPrimary, foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Download Receipt',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 56),
              foregroundColor: _cOnSurfaceVariant,
              side: const BorderSide(color: _cOutline),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Email Customer',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          ),
        ])),
      ),
    ]);
  }

  Widget _detailCard({required IconData icon, required String label,
      required String value, String? extra, IconData? extraIcon, String? extraLabel}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _cOutlineVariant.withOpacity(0.5)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 4)],
      ),
      child: extra != null
          ? Row(children: [
              Expanded(child: _detailInner(icon, label, value)),
              Container(width: 1, height: 48, color: _cOutlineVariant, margin: const EdgeInsets.symmetric(horizontal: 16)),
              Expanded(child: _detailInner(extraIcon!, extraLabel!, extra)),
            ])
          : _detailInner(icon, label, value),
    );
  }

  Widget _detailInner(IconData icon, String label, String value) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Icon(icon, size: 18, color: _cOnSurfaceVariant),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600,
            color: _cOnSurfaceVariant, letterSpacing: 0.5)),
      ]),
      const SizedBox(height: 6),
      Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: _cPrimary)),
    ]);
  }
}