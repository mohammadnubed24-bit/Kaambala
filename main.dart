import 'package:flutter/material.dart';

void main() => runApp(const KaamWalaApp());

class KaamWalaApp extends StatelessWidget {
  const KaamWalaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KaamWala',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class Service {
  final String name;
  final String category;
  final String icon;
  final int startingPrice;
  const Service(this.name, this.category, this.icon, this.startingPrice);
}

const services = <Service>[
  Service('Fan repair / installation', 'Electrician', '🌀', 149),
  Service('Switch & socket repair', 'Electrician', '🔌', 99),
  Service('Light installation', 'Electrician', '💡', 99),
  Service('Wiring repair', 'Electrician', '⚡', 199),
  Service('Door repair', 'Carpenter', '🚪', 199),
  Service('Furniture repair', 'Carpenter', '🪑', 249),
  Service('Shelf installation', 'Carpenter', '🧰', 199),
  Service('Lock / handle fitting', 'Carpenter', '🔧', 149),
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final visible = selectedCategory == 'All'
        ? services
        : services.where((s) => s.category == selectedCategory).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('KaamWala 🛠️', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            tooltip: 'Provider dashboard',
            icon: const Icon(Icons.engineering_outlined),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const ProviderPage())),
          ),
          IconButton(
            tooltip: 'Admin dashboard',
            icon: const Icon(Icons.admin_panel_settings_outlined),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const AdminPage())),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Home repair, made simple',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          const Text('Trusted electricians and carpenters at your doorstep.'),
          const SizedBox(height: 18),
          TextField(
            decoration: InputDecoration(
              hintText: 'Search a service',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
          const SizedBox(height: 16),
          Row(children: [
            _chip('All'),
            const SizedBox(width: 8),
            _chip('Electrician'),
            const SizedBox(width: 8),
            _chip('Carpenter'),
          ]),
          const SizedBox(height: 18),
          const Text('Popular services',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          ...visible.map((s) => Card(
            child: ListTile(
              leading: CircleAvatar(child: Text(s.icon, style: const TextStyle(fontSize: 21))),
              title: Text(s.name, style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text('${s.category} • From ₹${s.startingPrice}'),
              trailing: FilledButton(
                onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => BookingPage(service: s))),
                child: const Text('Book'),
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _chip(String text) => ChoiceChip(
    label: Text(text),
    selected: selectedCategory == text,
    onSelected: (_) => setState(() => selectedCategory = text),
  );
}

class BookingPage extends StatefulWidget {
  final Service service;
  const BookingPage({super.key, required this.service});
  @override State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final name = TextEditingController();
  final phone = TextEditingController();
  final address = TextEditingController();
  final problem = TextEditingController();

  @override
  void dispose() {
    name.dispose(); phone.dispose(); address.dispose(); problem.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book Service')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('${widget.service.icon} ${widget.service.name}',
              style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text('Starting price: ₹${widget.service.startingPrice}'),
          const SizedBox(height: 20),
          _field(name, 'Your name', Icons.person_outline),
          _field(phone, 'Mobile number', Icons.phone_outlined,
              keyboard: TextInputType.phone),
          _field(address, 'Service address', Icons.location_on_outlined),
          _field(problem, 'Describe the problem', Icons.notes_outlined, maxLines: 4),
          const SizedBox(height: 10),
          FilledButton.icon(
            icon: const Icon(Icons.check_circle_outline),
            label: const Padding(
              padding: EdgeInsets.symmetric(vertical: 14),
              child: Text('Confirm Booking'),
            ),
            onPressed: () {
              if (name.text.trim().isEmpty || phone.text.trim().isEmpty ||
                  address.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill name, mobile and address.')));
                return;
              }
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => BookingStatusPage(service: widget.service)));
            },
          ),
        ],
      ),
    );
  }

  Widget _field(TextEditingController c, String label, IconData icon,
      {TextInputType? keyboard, int maxLines = 1}) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: TextField(
      controller: c,
      keyboardType: keyboard,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
  );
}

class BookingStatusPage extends StatelessWidget {
  final Service service;
  const BookingStatusPage({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Booking Status')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(Icons.check_circle, size: 90),
            const SizedBox(height: 18),
            const Text('Booking received!',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('${service.name} • ₹${service.startingPrice}+'),
            const SizedBox(height: 22),
            const ListTile(leading: Icon(Icons.radio_button_checked),
                title: Text('Booking submitted')),
            const ListTile(leading: Icon(Icons.radio_button_unchecked),
                title: Text('Provider accepts booking')),
            const ListTile(leading: Icon(Icons.radio_button_unchecked),
                title: Text('Provider reaches your address')),
            const ListTile(leading: Icon(Icons.radio_button_unchecked),
                title: Text('Service completed')),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
              child: const Text('Back to Home'),
            ),
          ]),
        ),
      ),
    );
  }
}

class ProviderPage extends StatelessWidget {
  const ProviderPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Provider Dashboard')),
    body: ListView(padding: const EdgeInsets.all(16), children: [
      const Text('Hello, Service Provider 👷',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      const SizedBox(height: 16),
      Card(child: ListTile(
        leading: const Icon(Icons.toggle_on, size: 38),
        title: const Text('Available for jobs'),
        subtitle: const Text('You can receive new booking requests'),
        trailing: Switch(value: true, onChanged: (_) {}),
      )),
      const SizedBox(height: 10),
      const Text('New booking requests',
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
      Card(child: ListTile(
        leading: const CircleAvatar(child: Text('⚡')),
        title: const Text('Switch & socket repair'),
        subtitle: const Text('Customer • Nearby • ₹99+'),
        trailing: FilledButton(onPressed: () {}, child: const Text('Accept')),
      )),
      Card(child: ListTile(
        leading: const CircleAvatar(child: Text('🚪')),
        title: const Text('Door repair'),
        subtitle: const Text('Customer • Nearby • ₹199+'),
        trailing: FilledButton(onPressed: () {}, child: const Text('Accept')),
      )),
      const SizedBox(height: 10),
      const Card(child: ListTile(
        leading: Icon(Icons.account_balance_wallet_outlined),
        title: Text('Today’s earnings'),
        subtitle: Text('₹0 demo'),
      )),
    ]),
  );
}

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Admin Dashboard')),
    body: ListView(padding: const EdgeInsets.all(16), children: const [
      Text('Admin Panel',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      SizedBox(height: 16),
      Card(child: ListTile(
        leading: Icon(Icons.people_outline),
        title: Text('Customers'),
        subtitle: Text('Manage customer accounts'),
        trailing: Text('0'),
      )),
      Card(child: ListTile(
        leading: Icon(Icons.engineering_outlined),
        title: Text('Service Providers'),
        subtitle: Text('Approve and manage electricians/carpenters'),
        trailing: Text('0'),
      )),
      Card(child: ListTile(
        leading: Icon(Icons.receipt_long_outlined),
        title: Text('Bookings'),
        subtitle: Text('Monitor all service bookings'),
        trailing: Text('0'),
      )),
      Card(child: ListTile(
        leading: Icon(Icons.star_outline),
        title: Text('Reviews & complaints'),
        subtitle: Text('Review customer feedback'),
      )),
    ]),
  );
}
