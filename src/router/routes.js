import express from 'express';
import usuariosRoutes from './api_usuarios.js';
import apinoOrganizadosRoutes from './apis_no_organizadas.js';
import apispdf from './apis_pdf.js';
import apiPrueba from './api_prueba.js';
//import ticketsRoutes from './tickets.js';

const router = express.Router();

// Usa las rutas específicas de cada archivo
router.use(usuariosRoutes);
router.use(apinoOrganizadosRoutes);
router.use(apispdf);
router.use(apiPrueba);
//router.use(ticketsRoutes);

// Exporta el enrutador combinado
export default router;
