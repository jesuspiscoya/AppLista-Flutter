import 'package:flutter/material.dart';
import 'package:lista_app/pages/historial_page.dart';
import 'package:lista_app/pages/nuevo_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;
  final List<Widget> listaPages = [const NuevoPage(), const HistorialPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
        backgroundColor: const Color(0xFF17152D),
      ),
      body: SafeArea(
        child: Container(
          color: const Color(0xFF17152D),
          child: listaPages[index],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.white,
        backgroundColor: Colors.black,
        items: const [
          BottomNavigationBarItem(label: 'Nuevo', icon: Icon(Icons.home)),
          BottomNavigationBarItem(label: 'Historial', icon: Icon(Icons.save)),
        ],
        onTap: (value) => setState(() => index = value),
      ),
    );
  }
}
