const express = require('express');
const pool = require('./conexion');

const app = express();
const PORT = 3000;

app.use(express.static('view'));
app.use(express.json()); // Para analizar cuerpos de solicitud en JSON
app.use(express.urlencoded({ extended: true }));

// Ruta para obtener todos los elementos
app.get('/api/tabla_usuarios', async (req, res) => {
  try {
    const resultado = await pool.query('SELECT * FROM public.usuario');
    res.json(resultado.rows);
  } catch (error) {
    console.error('Error al obtener datos:', error);
    res.status(500).send('Error al obtener datos');
  }
});

// Ruta para dar de alta un nuevo usuario
app.post('/api/alta_usuarios', async (req, res) => {
  let { id_usuario, id_empleado, id_tipo_usuario, nickname, password } = req.body; 
  try {
    const resultado = await pool.query(
      `INSERT INTO public.usuario(
	     id_usuario, id_empleado, id_tipo_usuario, nickname, password)
	     VALUES (${id_usuario}, ${id_empleado}, ${id_tipo_usuario}, '${nickname}', '${password}');`);

    res.status(201).json({
      message: 'Usuario creado exitosamente',
      usuario: resultado.rows[0], // Devuelve el usuario creado
    });
  } catch (error) {
    console.error('Error al crear usuario:', error);
    res.status(500).send('Error al crear usuario');
  }
});

// Inicia el servidor
app.listen(PORT, () => {
  console.log(`Servidor corriendo en http://localhost:${PORT}`);
});
