          /*return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final evento = snapshot.data![index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  leading: const Icon(Icons.event, size: 40, color: Colors.orange),
                  title: Text(evento.titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("${evento.fecha} - ${evento.lugar}"),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Navegar al formulario enviando el evento seleccionado
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InscripcionFormScreen(evento: evento),
                      ),
                    );
                  },
                ),
              );
            },
          );*/