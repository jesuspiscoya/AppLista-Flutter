import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:lista_app/pages/articulos_page.dart';
import 'package:lista_app/pages/listas_page.dart';
import 'package:lista_app/pages/nuevo_page.dart';

class HomePage extends StatefulWidget {
  int? index = 0;

  HomePage({super.key, this.index});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Widget> listaPages = [
    const NuevoPage(),
    const ListasPage(),
    const ArticulosPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
        backgroundColor: const Color(0xFF131935),
      ),
      body: SafeArea(
        bottom: false,
        child: Container(
          color: const Color(0xFF090C1C),
          child: FadeIn(
              duration: const Duration(milliseconds: 500),
              child: listaPages[widget.index!]),
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
        decoration: const BoxDecoration(
            color: Color(0xF311122C),
            borderRadius: BorderRadius.all(Radius.circular(50))),
        child: GNav(
          gap: 8,
          selectedIndex: widget.index!,
          color: Colors.white,
          activeColor: Colors.cyanAccent.shade200,
          rippleColor: Colors.indigo.shade700,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
          tabBackgroundGradient: const RadialGradient(
            center: Alignment.bottomLeft,
            radius: 3.5,
            colors: <Color>[
              Color(0xFFAE31E7),
              Color(0xFF204BFC),
              Color(0xFF0190F9),
            ],
          ),
          tabs: const [
            GButton(
              icon: Icons.home_rounded,
              text: 'Inicio',
            ),
            GButton(
              icon: Icons.inventory_rounded,
              text: 'Listas',
            ),
            GButton(
              icon: Icons.checklist_rounded,
              text: 'Articulos',
            ),
          ],
          onTabChange: (value) => setState(() => widget.index = value),
        ),
      ),
    );
  }
}
