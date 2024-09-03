import 'dart:convert';

import 'package:flutter/material.dart';

part '_data.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const JSONTaskApp());
}

class JSONTaskApp extends StatelessWidget {
  const JSONTaskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter JSON Task App',
      home: HomeView(),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<AndroidVerison> parseJSON(String jsonString) {
    final _parsedJSON = json.decode(jsonString);

    List<AndroidVerison> _androidVersions = [];
    for (var versionEntries in _parsedJSON) {
      // Process when versionEntries is a Map<String, dynamic>
      if (versionEntries is Map<String, dynamic>) {
        versionEntries.forEach((key, value) {
          if (value is Map<String, dynamic>) {
            final _data = AndroidVerison(
              id: value['id'] as int?,
              title: value['title'],
            );
            _androidVersions.add(_data);
          }
        });
      }
      // Process when versionEntries is a List
      if (versionEntries is List) {
        for (var element in versionEntries) {
          if (element is Map<String, dynamic>) {
            final _data = AndroidVerison(
              id: element['id'] as int?,
              title: element['title'],
            );
            _androidVersions.add(_data);
          }
        }
      }
    }

    return _androidVersions;
  }

  List<AndroidVerison> output1 = [];
  List<AndroidVerison> output2 = [];

  @override
  void initState() {
    super.initState();
    output1 = parseJSON(input1);
    output2 = parseJSON(input2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter JSON Task')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Displays output for Input-1
            ElevatedButton(
              onPressed: () => _showDataDialog(context, output1),
              child: const Text('Display output for Input-1'),
            ),
            const SizedBox(height: 8),

            // Displays output for Input-2
            ElevatedButton(
              onPressed: () => _showDataDialog(context, output2),
              child: const Text('Display output for Input-2'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDataDialog(BuildContext ctx, List<AndroidVerison> data) async {
    await showDialog(
      context: ctx,
      builder: (popupContext) {
        return DataDialog(versionList: data);
      },
    );
  }
}

class DataDialog extends StatelessWidget {
  const DataDialog({
    super.key,
    required this.versionList,
  });
  final List<AndroidVerison> versionList;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          // Dialog Header
          Text(
            'Android Version List',
            style: _theme.textTheme.headlineMedium,
          ),

          // Version List Data Table
          Flexible(
            child: SizedBox(
              width: double.maxFinite,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: DataTable(
                  border: TableBorder.all(),
                  columns: const [
                    DataColumn(label: Text('ID')),
                    DataColumn(label: Text("Version Name")),
                  ],
                  rows: versionList.map((version) {
                    return DataRow(
                      cells: [
                        DataCell(Text("${version.id ?? 'N/A'}")),
                        DataCell(Text(version.title ?? 'N/A')),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),

          // Close Dialog
          Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ),
        ],
      ),
    );
  }
}
