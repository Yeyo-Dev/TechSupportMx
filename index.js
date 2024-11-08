const express = require('express');
const pool = require('./conexion');

const app = express();
const PORT = 3000;

app.use(express.static('view'));

// Ruta para obtener todos los elementos
app.get('/api/tabla_usuarios', async (req, res) => {
  try {
    const resultado = await pool.query('SELECT * FROM public.usuario'); // Cambia la consulta según tu tabla
    res.json(resultado.rows); // Enviar los datos como JSON
  } catch (error) {
    console.error('Error al obtener datos:', error);
    res.status(500).send('Error al obtener datos');
  }
});

// Inicia el servidor
app.listen(PORT, () => {
  console.log(`Servidor corriendo en http://localhost:${PORT}`);
});
