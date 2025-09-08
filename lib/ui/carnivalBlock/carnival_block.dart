import 'package:flutter/material.dart';

class CarnivalBlockPage extends StatefulWidget {
  const CarnivalBlockPage({super.key});

  @override
  State<CarnivalBlockPage> createState() => _CarnivalBlockPageState();
}

class _CarnivalBlockPageState extends State<CarnivalBlockPage> {
  final String _blockName = 'Então Brilha'; // Mock block name
  List<Map<String, String>> _members = [
    {'firstName': 'João', 'lastName': 'Silva'},
    {'firstName': 'Maria', 'lastName': 'Santos'},
    {'firstName': 'Pedro', 'lastName': 'Almeida'},
    {'firstName': 'Ana', 'lastName': 'Pereira'},
    {'firstName': 'Carlos', 'lastName': 'Oliveira'},
    {'firstName': 'Sofia', 'lastName': 'Costa'},
    {'firstName': 'Ricardo', 'lastName': 'Martins'},
  ];
  Set<int> _selectedMembers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_blockName, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.grey[850],
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.purpleAccent.shade100),
            onPressed: () {
              // Handle edit action
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: _members.length,
            itemBuilder: (context, index) {
              final member = _members[index];
              final isSelected = _selectedMembers.contains(index);
              return Card(
                color: Colors.grey[800], // Darker card background
                elevation: isSelected
                    ? 8.0
                    : 2.0, // Adjust shadow for dark mode
                margin: const EdgeInsets.symmetric(
                  vertical: 4.0,
                  horizontal: 8.0,
                ),
                child: ListTile(
                  title: Text(
                    '${member['firstName']} ${member['lastName']}',
                    style: const TextStyle(color: Colors.white),
                  ),
                  selected: isSelected,
                  selectedTileColor: Colors.purple.withOpacity(0.3),
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedMembers.remove(index);
                      } else {
                        _selectedMembers.add(index);
                      }
                    });
                  },
                ),
              );
            },
          ),
          if (_selectedMembers.isNotEmpty)
            Positioned(
              left: 16.0,
              bottom: 16.0,
              child: FloatingActionButton(
                onPressed: () {
                  setState(() {
                    // For now, just clear selected members
                    _selectedMembers.clear();
                  });
                },
                backgroundColor: Colors.red.shade800,
                child: const Icon(Icons.delete, color: Colors.white),
              ),
            ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle add member action
        },
        backgroundColor: Colors.purpleAccent.shade100,
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}
