import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: _topBar(context),
        body: TabBarView(
          children: [
            Center(child: Text('Recent projects')),
            Center(child: Text('Drafts')),
          ],
        ),
      ),
    );
  }

  _topBar(BuildContext context) {
    return AppBar(
      title: Text('My projects', style: Theme.of(context).textTheme.titleMedium),
      actions: [
        IconButton(
          icon: Icon(Icons.settings_outlined),
          onPressed: () {},
          splashRadius: 20.0,
        ),
        SizedBox(width: 8.0),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight - 10.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: TabBar(
            padding: EdgeInsets.only(left: 16.0),
            isScrollable: true,
            labelStyle: Theme.of(context).textTheme.titleSmall,
            tabs: [
              Tab(text: 'Recent projects'),
              Tab(text: 'Drafts'),
            ],
          ),
        ),
      ),
    );
  }
}
