import { pool } from '../conexion.js';  // Ajusta la ruta según la ubicación de conexion.js
import express from 'express';

const router = express.Router();


router.post('/api/buscar_empleado', async (req, res) => {
    let parametro  = req.body.b
    try {   
      const resultado = await pool.query(`
        
    SELECT 
        e.id_empleado,
        e.nombre,
        e.apellido_m,
        e.apellido_p,
        e.id_departamento,
        u.nickname,
        u.password,
        u.id_usuario,
        u.id_tipo_usuario
    FROM
        empleado e
    INNER JOIN
        usuario u ON e.id_empleado = u.id_empleado
    WHERE 
        e.id_empleado = ${parametro};       `);
      
      res.json(resultado.rows);
    } catch (error) {
      console.error('Error al obtener datos:', error);
      res.status(500).send('Error al obtener datos');
    }
  });
  

  export default router;
