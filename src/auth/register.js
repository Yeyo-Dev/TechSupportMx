/*CALL registrar_empleado_usuario(
    'Juan', 
    'Pérez', 
    'López', 
    'juan.perez@example.com', 
    1, 
    1, 
    'admin1', 
    'pass123'
);
    p_nombre VARCHAR,
    p_apellido_p VARCHAR,
    p_apellido_m VARCHAR,
    p_email VARCHAR,
    p_id_departamento INT,
    p_id_tipo_usuario INT,
    p_nickname VARCHAR,
    p_password VARCHAR
nombre, apellido_p, apellido_m, email, id_departamento, id_tipo_usuario, nickname, password
*/
import express from 'express';
import { pool } from '../conexion.js';
import cookieParser from 'cookie-parser';

const router = express.Router();

// Configurar el middleware para manejar cookies
router.use(cookieParser());

// Ruta para iniciar sesión
router.post('/api/registrar', async (req, res) => {
  const { nombre, apellido_p, apellido_m, email, id_departamento, id_tipo_usuario, nickname, password } = req.body;
  console.log(req.body);
  

  try {
    // Consulta a la base de datos para verificar el usuario
    const resultado = await pool.query(
      `CALL registrar_empleado_usuario(
      '${nombre}', 
      '${apellido_p}', 
      '${apellido_m}', 
      '${email}', 
      ${id_departamento}, 
      ${id_tipo_usuario},
      '${nickname}'
      ,'${password}'
      );`
    );

    res.status(200).json({ message: 'Registro exitoso', detalles: resultado.rows });
    
  } catch (error) {
    console.error('Error al registrar usuario:', error);
    res.status(500).send('Error al registrar usuario')
  }
});

// Exporta el router
export default router;
