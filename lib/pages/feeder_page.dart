import "package:flutter/material.dart";

import "Feeder Files/feeder_sidebar.dart";
import "Feeder Files/feeder_table.dart";

class FeederScreen extends StatefulWidget {
  const FeederScreen({super.key});

  @override
  State<FeederScreen> createState() => _FeederScreenState();
}

class _FeederScreenState extends State<FeederScreen> {
  
  Widget tableWrap(FeederTable table) {
    return Flexible ( 
      child: Container(
        margin: const EdgeInsets.all(20),
        constraints: const BoxConstraints(
          // maxWidth: 600, 
          minWidth: 600
        ),
        child: table
      )
    ); 
  }

  Widget sidebarWrap(FeederSidebar sidebar) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: const BorderRadius.all(Radius.circular(10))),
      margin: const EdgeInsets.all(20),
      constraints: const BoxConstraints(
        maxWidth: 400,
        minWidth: 400,
      ),
      child: sidebar
    );
  }

  @override
  Widget build(BuildContext context) {
    FeederTable fTable = const FeederTable();
    FeederSidebar fSidebar = const FeederSidebar();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule'),
      ),
      body: Row(
        children: [tableWrap(fTable), sidebarWrap(fSidebar)],
      )
    );
  }
}
