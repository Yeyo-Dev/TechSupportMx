import { pool } from '../conexion.js';  // Ajusta la ruta según sea necesario
import express from 'express';

const router = express.Router();

//apis

router.get('/api/consulta_tecnico', async (req, res) => {
    try {
      const resultado = await pool.query(`
        SELECT *
        FROM Tecnico;
      `);
      res.json(resultado.rows);
    } catch (error) {
      console.error('Error al obtener los tecnicos:', error);
      res.status(500).send('Error al obtener los tecnicos');
    }
  });
  

// Exporta el router para usarlo en otros archivos
export default router;