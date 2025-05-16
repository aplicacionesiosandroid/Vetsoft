import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:vet_sotf_app/presentation/screens/chatBoot/chat_show_screen.dart';
import 'package:vet_sotf_app/providers/chat_provider.dart';

class ChatHistoryScreen extends StatefulWidget {
  const ChatHistoryScreen({Key? key}) : super(key: key);

  @override
  State<ChatHistoryScreen> createState() => _ChatHistoryScreenState();
}

class _ChatHistoryScreenState extends State<ChatHistoryScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<ChatProvider>(context, listen: false).fetchHistorialChat();
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    final historialChat = chatProvider.historialChat;

    return Scaffold(
      backgroundColor: Color(0xFF007AA2),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 110,
                color: Color(0xFF007AA2),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(35),
                    ),
                  ),
                  child: ListView(
                    padding: EdgeInsets.only(top: 50),
                    children: [
                      if (historialChat['esta_semana']!.isNotEmpty) ...[
                        _buildSectionTitle(context, 'Esta semana'),
                        _buildChatHistory(context, historialChat['esta_semana']!),
                      ],
                      if (historialChat['semana_pasada']!.isNotEmpty) ...[
                        _buildSectionTitle(context, 'Semana pasada'),
                        _buildChatHistory(context, historialChat['semana_pasada']!),
                      ],
                      if (historialChat['antiguo']!.isNotEmpty) ...[
                        _buildSectionTitle(context, 'Antiguo'),
                        _buildChatHistory(context, historialChat['antiguo']!),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
          _buildCustomAppBar(context),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
          color: const Color.fromARGB(255, 107, 104, 104),
        ),
      ),
    );
  }

  Widget _buildChatHistory(BuildContext context, List<Map<String, dynamic>> data) {
  return ListView.builder(
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    padding: EdgeInsets.symmetric(vertical: 10),
    itemCount: data.length,
    itemBuilder: (context, index) {
      final item = data[index];
      String question = item['pregunta'] as String? ?? 'Pregunta no disponible';
      String answer = item['respuesta'] as String? ?? 'Respuesta no disponible';
      String date = item['fecha'] as String? ?? 'Fecha no disponible';
      return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Color(0xFF0085AF),
          child: Icon(Iconsax.message, color: Colors.white),
        ),
        title: Text(question),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(answer),
            SizedBox(height: 8.0),
            Text(date),
          ],
        ),
        trailing: Icon(Icons.chevron_right),
            onTap: () {
              // Llamar al método fetchChatDetail con el ID del historial
              Provider.of<ChatProvider>(context, listen: false).fetchChatDetail(item['historial_id']);
              // Navegar al ChatShowScreen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  ChatShowScreen()),
              );
            },
          ),
        );
      },
    );
  }

  Positioned _buildCustomAppBar(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top,
      left: 0,
      right: 0,
      child: AppBar(
        title: Text(
          'Historial',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Iconsax.arrow_left, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Iconsax.search_normal, color: Colors.white),
            onPressed: () {
              // Implementar acción de búsqueda
            },
          ),
        ],
      ),
    );
  }
}
