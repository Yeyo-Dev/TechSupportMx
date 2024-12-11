import express from 'express';
import cookieParser from 'cookie-parser';

const router = express.Router();

// Configurar el middleware para manejar cookies
router.use(cookieParser());

// Ruta para verificar si la sesión está activa
router.get('/api/check-session', (req, res) => {
  const sessionCookie = req.cookies.session;

  if (sessionCookie) {
    // Sesión encontrada
    res.status(200).json({
      message: 'Sesión activa',
      session: sessionCookie,
    });
  } else {
    // No hay sesión
    res.status(401).json({
      message: 'Sesión no iniciada',
    });
  }
});

// Ruta para cerrar sesión
router.get('/api/logout', (req, res) => {
    res.clearCookie('session', {
      httpOnly: true, // Asegura que solo el servidor pueda acceder a la cookie
      secure: false,  // Cambia a true si usas HTTPS
    });
  
    res.status(200).json({
      message: 'Sesión cerrada exitosamente',
    });
  });
  

export default router;
