import express from 'express';  //Importar express
import {pool} from './conexion.js'; // Importar configuración de la BD
import {PORT} from './config.js'; //Importar configuraciones de puertos
import router from './router/routes.js'; // Importar las rutas desde el archivo
import authRouter from './auth/login.js'; // Importar el router de login
import authRegister from './auth/register.js';
import authSession from './auth/sesion.js';

const app = express();

app.use(express.static('view'));
app.use(express.json()); // Para analizar cuerpos de solicitud en JSON
app.use(express.urlencoded({ extended: true }));

// Usar las rutas del router
app.use(router);

// Usar las rutas de autenticación
app.use(authRouter);
app.use(authRegister);
app.use(authSession);

// Inicia el servidor
app.listen(PORT, () => {
  console.log(`Servidor corriendo en http://localhost:${PORT}`);
});
