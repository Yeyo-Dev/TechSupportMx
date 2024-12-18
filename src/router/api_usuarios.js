import { pool } from '../conexion.js';  // Ajusta la ruta según sea necesario
import express from 'express';

const router = express.Router();

// Ruta para obtener todos los usuarios
router.get('/api/tabla_usuarios', async (req, res) => {
  try {
    const resultado = await pool.query('SELECT * FROM public.usuario');
    res.json(resultado.rows);
  } catch (error) {
    console.error('Error al obtener datos:', error);
    res.status(500).send('Error al obtener datos');
  }
});

// Ruta para crear un nuevo usuario
router.post('/api/alta_usuarios', async (req, res) => {
  let { id_usuario, id_empleado, id_tipo_usuario, nickname, password } = req.body; 
  try {
    const resultado = await pool.query(
      `INSERT INTO public.usuario(
         id_usuario, id_empleado, id_tipo_usuario, nickname, password)
         VALUES (${id_usuario}, ${id_empleado}, ${id_tipo_usuario}, '${nickname}', '${password}');`
    );
    res.status(201).json({
      message: 'Usuario creado exitosamente',
    });
  } catch (error) {
    console.error('Error al crear usuario:', error);
    res.status(500).send('Error al crear usuario');
  }
});

// Exporta el router para usarlo en otros archivos
export default router;
