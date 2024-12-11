import express from 'express';
import { pool } from '../conexion.js';
import cookieParser from 'cookie-parser';

const router = express.Router();

// Configurar el middleware para manejar cookies
router.use(cookieParser());

// Ruta para iniciar sesión
router.post('/api/login', async (req, res) => {
  const { nickname, password } = req.body;

  try {
    // Consulta a la base de datos para verificar el usuario
    const resultado = await pool.query(
      'SELECT * FROM public.usuario WHERE nickname = $1 AND password = $2',
      [nickname, password]
    );

    if (resultado.rows.length > 0) {
      // Usuario encontrado, establecer cookie de sesión
      res.cookie('session', {
        userId: resultado.rows[0].id_usuario,
        nickname: resultado.rows[0].nickname,
      }, {
        httpOnly: true, // Protege la cookie del acceso del lado del cliente
        maxAge: 1000 * 60 * 60 * 24, // 1 día de duración
      });

      res.status(200).json({ message: 'Inicio de sesión exitoso' });
    } else {
      res.status(401).json({ message: 'Credenciales inválidas' });
    }
  } catch (error) {
    console.error('Error al iniciar sesión:', error);
    res.status(500).send('Error al iniciar sesión');
  }
});

// Exporta el router
export default router;
