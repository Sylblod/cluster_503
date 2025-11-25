/*
  child: InkWell(

    onTap: () {
      if (evento.activo) {
        // SI ESTÁ ACTIVO: Dejar pasar
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InscripcionFormScreen(evento: evento),
          ),
        );
      } else {

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Las inscripciones para este evento están cerradas.'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.red,
          ),
        );
      }
    },

    //corte

    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ... (Aquí va tu código de la imagen que ya arreglamos) ...
        ClipRRect(
             borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
             child: Image.network(
               evento.imagenUrl,
               height: 120,
               width: double.infinity,
               fit: BoxFit.cover,
               errorBuilder: (ctx, err, stack) => Container(height: 120, color: Colors.grey.shade300),
             ),
        ),

        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---------------------------------------------------------
              // 2. INDICADORES VISUALES (FILA DE CHIPS)
              // ---------------------------------------------------------
              Row(
                children: [
                  // CHIP TIPO (Torneo/Examen)
                  Chip(
                    label: Text(evento.tipo == 'torneo' ? "TORNEO" : "EXAMEN"), // Ojo: usa minúsculas si así viene de BD
                    backgroundColor: evento.tipo == 'torneo' 
                        ? Colors.orange.shade100 
                        : Colors.blue.shade100,
                    labelStyle: TextStyle(
                      color: evento.tipo == 'torneo' 
                          ? Colors.orange.shade900 
                          : Colors.blue.shade900,
                      fontWeight: FontWeight.bold,
                      fontSize: 10, // Un poco más pequeño para que quepan
                    ),
                    padding: EdgeInsets.zero, // Reduce espacio interno
                    visualDensity: VisualDensity.compact,
                  ),
                  
                  const SizedBox(width: 8), // Espacio entre etiquetas

                  // --- NUEVO: CHIP DE ESTADO (Abierto/Cerrado) ---
                  Chip(
                    label: Text(evento.activo ? "ABIERTO" : "CERRADO"),
                    backgroundColor: evento.activo 
                        ? Colors.green.shade100 
                        : Colors.red.shade100,
                    labelStyle: TextStyle(
                      color: evento.activo 
                          ? Colors.green.shade900 
                          : Colors.red.shade900,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
              
              // Fecha separada para que no estorbe a los chips
              const SizedBox(height: 4),
              Text(evento.fecha, style: const TextStyle(color: Colors.grey, fontSize: 12)),

              const SizedBox(height: 8),
              
              // Título
              Text(
                evento.titulo,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1565C0),
                ),
              ),
              
              // Lugar...
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(evento.lugar),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  ),
);

*/