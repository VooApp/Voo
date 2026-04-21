import 'package:flutter/material.dart';
import 'profile_qr_screen.dart';

class HomeScreen extends StatelessWidget {
  final bool isHost;

  const HomeScreen({
    super.key,
    required this.isHost,
  });

  @override
  Widget build(BuildContext context) {
    final invitados = const [
      ('Maria', 16, Color(0xFFEF4444)),
      ('Juan', 21, Color(0xFF22C55E)),
      ('Pedro', 18, Color(0xFFEAB308)),
      ('Anna', 20, Color(0xFF22C55E)),
      ('Alba', 17, Color(0xFFEF4444)),
      ('Marina', 18, Color(0xFFEAB308)),
      ('Paula', 18, Color(0xFF22C55E)),
      ('Luna', 17, Color(0xFFEF4444)),
      ('Lucas', 18, Color(0xFFEAB308)),
      ('Pablo', 21, Color(0xFF22C55E)),
    ];

    final saludo = isHost ? 'Hola Maxi!' : 'Hola Mogi!';
    final codigoSala = 'x420011';
    final tituloLista = isHost ? 'Tus invitados' : 'Invitados de la sala';

    return Scaffold(
      backgroundColor: const Color(0xFF05051C),
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 1.25,
            colors: [
              Color(0xFF171128),
              Color(0xFF0C0A18),
              Color(0xFF05051C),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TopHeader(
                  saludo: saludo,
                  codigoSala: codigoSala,
                  onQrTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProfileQrScreen(
                          isHost: isHost,
                          userName: isHost ? 'Maxi' : 'Mogi',
                          roomCode: codigoSala,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                Text(
                  tituloLista,
                  style: const TextStyle(
                    color: Color(0xFFD78BFF),
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.separated(
                    itemCount: invitados.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final invitado = invitados[index];

                      return _GuestCard(
                        name: invitado.$1,
                        age: invitado.$2,
                        statusColor: invitado.$3,
                        isHost: isHost,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _NavItem(
                        icon: Icons.home_rounded,
                        label: 'Home',
                        selected: true,
                      ),
                      _NavItem(
                        icon: Icons.chat_bubble_outline_rounded,
                        label: 'Chats',
                      ),
                      _NavItem(
                        icon: Icons.emoji_events_outlined,
                        label: 'Ranking',
                      ),
                      _NavItem(
                        icon: Icons.star_outline_rounded,
                        label: 'Retos',
                      ),
                      _NavItem(
                        icon: Icons.settings_outlined,
                        label: 'Ajustes',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TopHeader extends StatelessWidget {
  final String saludo;
  final String codigoSala;
  final VoidCallback onQrTap;

  const _TopHeader({
    required this.saludo,
    required this.codigoSala,
    required this.onQrTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                saludo,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                codigoSala,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        _QrButton(onTap: onQrTap),
      ],
    );
  }
}

class _QrButton extends StatefulWidget {
  final VoidCallback onTap;

  const _QrButton({required this.onTap});

  @override
  State<_QrButton> createState() => _QrButtonState();
}

class _QrButtonState extends State<_QrButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 54,
        height: 54,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFF3B1452),
              Color(0xFF24103A),
            ],
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: const Color(0xFF7E2BE8),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF8B3DFF).withOpacity(_pressed ? 0.45 : 0.18),
              blurRadius: _pressed ? 20 : 12,
              spreadRadius: _pressed ? 1.2 : 0.4,
            ),
          ],
        ),
        child: const Icon(
          Icons.qr_code_2_rounded,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }
}

class _GuestCard extends StatelessWidget {
  final String name;
  final int age;
  final Color statusColor;
  final bool isHost;

  const _GuestCard({
    required this.name,
    required this.age,
    required this.statusColor,
    required this.isHost,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF151525),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFD78BFF).withOpacity(0.5),
          width: 1.4,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: statusColor,
                width: 2.4,
              ),
            ),
            child: const Icon(
              Icons.person,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              '$name, $age',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (isHost)
            const Icon(
              Icons.chevron_right_rounded,
              color: Colors.white54,
              size: 24,
            ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;

  const _NavItem({
    required this.icon,
    required this.label,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFD78BFF) : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            icon,
            color: Colors.black,
            size: 22,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}