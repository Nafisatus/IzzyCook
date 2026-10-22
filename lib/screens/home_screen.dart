import 'package:flutter/material.dart';

import '../models/meal.dart';
import '../services/meal_service.dart';
import '../widgets/error_view.dart';
import '../widgets/meal_card.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const String _allAreas = 'All';

  final MealService _service = MealService();
  final TextEditingController _controller =
      TextEditingController(text: 'chicken');

  late Future<List<Meal>> _future;
  String _selectedArea = _allAreas;

  @override
  void initState() {
    super.initState();
    _future = _service.searchMeals(_controller.text);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _search() {
    final query = _controller.text.trim();
    if (query.isEmpty) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _selectedArea = _allAreas;
      _future = _service.searchMeals(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IzzyCook'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _controller,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _search(),
              decoration: InputDecoration(
                hintText: 'Search recipes, e.g. chicken',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: _search,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Meal>>(
              future: _future,
              builder: (context, snapshot) {
                // 1. LOADING
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // 2. ERROR
                if (snapshot.hasError) {
                  final message = snapshot.error
                      .toString()
                      .replaceFirst('Exception: ', '');
                  return ErrorView(message: message, onRetry: _search);
                }

                // 3. SUCCESS
                final meals = snapshot.data ?? [];
                if (meals.isEmpty) {
                  return const Center(
                    child: Text('No recipes found. Try another keyword.'),
                  );
                }
                return _buildContent(meals);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(List<Meal> meals) {
    // Data processing: collect the unique areas from the API results
    final areas = <String>{_allAreas, ...meals.map((m) => m.area)}.toList();

    final filtered = _selectedArea == _allAreas
        ? meals
        : meals.where((m) => m.area == _selectedArea).toList();

    return Column(
      children: [
        SizedBox(
          height: 48,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: areas.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final area = areas[index];
              return ChoiceChip(
                label: Text(area),
                selected: _selectedArea == area,
                onSelected: (_) => setState(() => _selectedArea = area),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('${filtered.length} recipes found',
                style: Theme.of(context).textTheme.bodySmall),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 16),
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final meal = filtered[index];
              return MealCard(
                meal: meal,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailScreen(meal: meal),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}