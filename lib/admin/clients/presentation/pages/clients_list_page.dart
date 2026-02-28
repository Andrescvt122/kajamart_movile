import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/datasources/clients_remote_data_source.dart';
import '../../data/repositories/clients_repository_impl.dart';
import '../providers/clients_notifier.dart';
import '../widgets/client_card.dart';
import 'client_detail_page.dart';

class ClientsListPage extends StatelessWidget {
  const ClientsListPage({super.key});

  static ClientsRepositoryImpl createClientsRepository() {
    const String baseUrl = 'http://localhost:3000/kajamart/api';
    return ClientsRepositoryImpl(
      remote: ClientsRemoteDataSource(baseUrl: baseUrl),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ClientsNotifier(repository: createClientsRepository())
        ..loadClients(),
      child: const _ClientsListView(),
    );
  }
}

class _ClientsListView extends StatefulWidget {
  const _ClientsListView();

  @override
  State<_ClientsListView> createState() => _ClientsListViewState();
}

class _ClientsListViewState extends State<_ClientsListView> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE4EFE8),
      body: SafeArea(
        child: ClientsListEmbedBody(searchController: _searchController),
      ),
    );
  }
}

class ClientsListEmbedBody extends StatelessWidget {
  final TextEditingController searchController;
  final bool showSearch;

  const ClientsListEmbedBody({
    super.key,
    required this.searchController,
    this.showSearch = true,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ClientsNotifier>(
      builder: (context, notifier, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(18, 20, 18, 2),
              child: Text(
                'Clientes',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0E6E54),
                  height: 0.95,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(18, 0, 18, 14),
              child: Text(
                'Listado de clientes',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF677A70),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (showSearch)
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 8, 18, 14),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Buscar clientes...',
                    hintStyle: const TextStyle(color: Color(0xFF95A39D)),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Color(0xFF9AA8A2),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF0F2F1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(28),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                  ),
                  onChanged: notifier.filterByQuery,
                ),
              ),
            Expanded(child: _ClientsContent()),
          ],
        );
      },
    );
  }
}

class _ClientsContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<ClientsNotifier>(context);

    switch (notifier.status) {
      case ClientsStatus.loading:
        return const Center(
          child: CircularProgressIndicator(color: Color(0xFF0A7A5A)),
        );
      case ClientsStatus.error:
        return Center(child: Text('Error: ${notifier.errorMessage}'));
      case ClientsStatus.loaded:
        if (notifier.filteredClients.isEmpty) {
          return const Center(child: Text('No se encontraron clientes'));
        }
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 24),
          itemCount: notifier.filteredClients.length,
          itemBuilder: (context, index) {
            final client = notifier.filteredClients[index];
            return ClientCard(
              client: client,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ClientDetailPage(client: client),
                ),
              ),
            );
          },
        );
      case ClientsStatus.initial:
      default:
        return const SizedBox.shrink();
    }
  }
}

Widget createClientsProviderWidget() {
  return ChangeNotifierProvider(
    create: (_) => ClientsNotifier(
      repository: ClientsRepositoryImpl(
        remote: ClientsRemoteDataSource(
          baseUrl: 'http://localhost:3000/kajamart/api',
        ),
      ),
    )..loadClients(),
    child: const _ClientsEmbedWrapper(),
  );
}

class _ClientsEmbedWrapper extends StatefulWidget {
  const _ClientsEmbedWrapper();

  @override
  State<_ClientsEmbedWrapper> createState() => _ClientsEmbedWrapperState();
}

class _ClientsEmbedWrapperState extends State<_ClientsEmbedWrapper> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE4EFE8),
      body: SafeArea(
        child: ClientsListEmbedBody(
          searchController: _searchController,
          showSearch: true,
        ),
      ),
    );
  }
}
