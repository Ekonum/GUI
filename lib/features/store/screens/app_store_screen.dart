import 'package:ekonum_app/config/colors.dart';
import 'package:ekonum_app/core/providers/app_provider.dart';
import 'package:ekonum_app/core/providers/store_provider.dart';
import 'package:ekonum_app/features/common/widgets/search_field.dart';
import 'package:ekonum_app/features/store/widgets/app_store_item.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppStoreScreen extends StatefulWidget {
  const AppStoreScreen({super.key});

  @override
  State<AppStoreScreen> createState() => _AppStoreScreenState();
}

class _AppStoreScreenState extends State<AppStoreScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Get categories from provider to set TabController length
    final categories = context.read<StoreProvider>().categories;
    _tabController = TabController(length: categories.length, vsync: this);

    // Initialize search controller text
    _searchController.text = context.read<StoreProvider>().searchQuery;

    // Add listener to update provider when tab changes
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        final selectedCategory = categories[_tabController.index];
        context.read<StoreProvider>().setCategory(selectedCategory);
      }
    });

    // Sync tab controller if provider's category changes externally (less common)
    context.read<StoreProvider>().addListener(_syncTabController);
  }

  void _syncTabController() {
    final providerCategory = context.read<StoreProvider>().selectedCategory;
    final categories = context.read<StoreProvider>().categories;
    final desiredIndex = categories.indexOf(providerCategory);
    if (desiredIndex != -1 && _tabController.index != desiredIndex) {
      _tabController.animateTo(desiredIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Watch the provider for filtered apps and categories
    final storeProvider = context.watch<StoreProvider>();
    final categories = storeProvider.categories;
    final filteredApps = storeProvider.filteredApps;
    // Read AppProvider for install/uninstall actions
    final appProvider = context.read<AppProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('App Store')),
      body: NestedScrollView(
        // Allows app bar and tabs to scroll nicely
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                child: SearchField(
                  controller: _searchController,
                  hintText: 'Search apps...',
                  // Update provider on change
                  onChanged:
                      (value) => context.read<StoreProvider>().search(value),
                ),
              ),
            ),
            SliverAppBar(
              // Use SliverAppBar for sticky tabs
              pinned: true,
              // Keep tabs visible while scrolling list
              primary: false,
              // Prevent nested scroll view issues
              toolbarHeight: 0,
              // Hide the default toolbar part
              backgroundColor: theme.scaffoldBackgroundColor,
              // Match background
              surfaceTintColor: theme.scaffoldBackgroundColor,
              // Match background
              automaticallyImplyLeading: false,
              // No back button needed here
              bottom: TabBar(
                controller: _tabController,
                isScrollable: true,
                // Allow scrolling if many categories
                tabs:
                    categories.map((category) => Tab(text: category)).toList(),
                indicatorColor: theme.primaryColor,
                labelColor: theme.primaryColor,
                unselectedLabelColor: AppColors.textSecondary,
                indicatorSize: TabBarIndicatorSize.label,
                // Underline only label
                tabAlignment: TabAlignment.start,
                // Align tabs to the left
                indicatorWeight: 3.0,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                ), // Bold selected tab
              ),
            ),
          ];
        },
        // Use TabBarView or direct ListView based on complexity
        // Using ListView directly is simpler here as filtering is done in provider
        body: RefreshIndicator(
          // Added RefreshIndicator
          onRefresh:
              () =>
                  context.read<StoreProvider>().fetchAvailableApps(appProvider),
          child:
              filteredApps.isEmpty
                  ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Text(
                        storeProvider.searchQuery.isEmpty
                            ? 'No apps found in this category.'
                            : 'No apps found matching "${storeProvider.searchQuery}".',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                  : ListView.builder(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
                    itemCount: filteredApps.length,
                    itemBuilder: (context, index) {
                      final app = filteredApps[index];
                      return AppStoreItem(
                        storeApp: app, // Pass the whole StoreApp model
                        onInstall: () {
                          // Call provider method
                          context.read<StoreProvider>().installApp(
                            app.id,
                            appProvider,
                          );
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Starting install for ${app.name}...',
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        onUninstall: () async {
                          // Confirmation Dialog
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder:
                                (context) => AlertDialog(
                                  title: Text('Uninstall ${app.name}?'),
                                  content: const Text(
                                    'Are you sure you want to uninstall this application? Its data might be removed too (depending on the app).',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed:
                                          () => Navigator.pop(context, false),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed:
                                          () => Navigator.pop(context, true),
                                      style: TextButton.styleFrom(
                                        foregroundColor: AppColors.error,
                                      ),
                                      child: const Text('Uninstall'),
                                    ),
                                  ],
                                ),
                          );
                          if (confirm == true) {
                            // Call provider method after confirmation
                            context.read<StoreProvider>().uninstallApp(
                              app.id,
                              appProvider,
                            );
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Starting uninstall for ${app.name}...',
                                ),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          }
                        },
                        onTap: () {
                          // TODO: Navigate to app details/config screen in store?
                          if (kDebugMode) {
                            print('Tapped store item: ${app.name}');
                          }
                          // Maybe show a bottom sheet with more details?
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled:
                                true, // Allow taller bottom sheet
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(16),
                              ),
                            ),
                            builder:
                                (context) => DraggableScrollableSheet(
                                  // Make it draggable
                                  expand: false,
                                  initialChildSize: 0.5,
                                  // Start at half height
                                  minChildSize: 0.3,
                                  maxChildSize: 0.8,
                                  builder: (context, scrollController) {
                                    return SingleChildScrollView(
                                      controller: scrollController,
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            app.name,
                                            style:
                                                theme.textTheme.headlineSmall,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            app.description,
                                            style: theme.textTheme.bodyLarge,
                                          ),
                                          const SizedBox(height: 16),
                                          Wrap(
                                            // Use Wrap for chips
                                            spacing: 8.0,
                                            runSpacing: 4.0,
                                            children: [
                                              Chip(
                                                label: Text(
                                                  'Category: ${app.category}',
                                                ),
                                              ),
                                              Chip(
                                                label: Text(
                                                  'CPU: ${app.cpuRequirement}',
                                                ),
                                              ),
                                              Chip(
                                                label: Text(
                                                  'RAM: ${app.ramRequirement}',
                                                ),
                                              ),
                                              Chip(
                                                label: Text(
                                                  app.isInstalled
                                                      ? 'Installed'
                                                      : 'Not Installed',
                                                ),
                                                backgroundColor:
                                                    app.isInstalled
                                                        ? AppColors.success
                                                            .withValues(
                                                              alpha: 0.2,
                                                            )
                                                        : AppColors.warning
                                                            .withValues(
                                                              alpha: 0.2,
                                                            ),
                                              ),
                                            ],
                                          ),

                                          const SizedBox(height: 24),
                                          // Add install/uninstall button here too
                                          ElevatedButton.icon(
                                            onPressed:
                                                app.isProcessing
                                                    ? null
                                                    : (app.isInstalled
                                                        ? () => context
                                                            .read<
                                                              StoreProvider
                                                            >()
                                                            .uninstallApp(
                                                              app.id,
                                                              appProvider,
                                                            )
                                                        : () => context
                                                            .read<
                                                              StoreProvider
                                                            >()
                                                            .installApp(
                                                              app.id,
                                                              appProvider,
                                                            )),
                                            icon:
                                                app.isProcessing
                                                    ? const SizedBox(
                                                      width: 18,
                                                      height: 18,
                                                      child:
                                                          CircularProgressIndicator(
                                                            strokeWidth: 2,
                                                            color: Colors.white,
                                                          ),
                                                    )
                                                    : Icon(
                                                      app.isInstalled
                                                          ? Icons.delete_outline
                                                          : Icons
                                                              .download_outlined,
                                                    ),
                                            label: Text(
                                              app.isProcessing
                                                  ? 'Processing...'
                                                  : (app.isInstalled
                                                      ? 'Uninstall'
                                                      : 'Install'),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  app.isInstalled
                                                      ? AppColors.error
                                                      : AppColors.primary,
                                              minimumSize: const Size(
                                                double.infinity,
                                                45,
                                              ), // Full width
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                          );
                        },
                      );
                    },
                  ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Remove listener to prevent memory leaks
    context.read<StoreProvider>().removeListener(_syncTabController);
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
