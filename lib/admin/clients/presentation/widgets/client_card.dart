import 'package:flutter/material.dart';

import '../../data/models/client_model.dart';

class ClientCard extends StatelessWidget {
  final AdminClientModel client;
  final VoidCallback onTap;

  const ClientCard({super.key, required this.client, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bool isActive = client.estado.toLowerCase().contains('activo');

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFC6E8D5)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 8,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            'ID ${client.id}',
                            style: const TextStyle(
                              color: Color(0xFF74847D),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: isActive
                                  ? const Color(0xFFDDF3E6)
                                  : const Color(0xFFEDEDED),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Text(
                              isActive ? 'Activo' : client.estado,
                              style: TextStyle(
                                color: isActive
                                    ? const Color(0xFF1A7F4D)
                                    : const Color(0xFF69756F),
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        client.nombre,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF121B17),
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Color(0xFF586660),
                  size: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
