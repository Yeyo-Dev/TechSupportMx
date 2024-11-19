import { pool } from '../conexion.js';  // Ajusta la ruta según la ubicación de conexion.js
import express from 'express';

const router = express.Router();


// Ruta para obtener todos los elementos
router.get('/api/tabla_usuarios', async (req, res) => {
    try {
      const resultado = await pool.query('SELECT * FROM public.usuario');
      res.json(resultado.rows);
    } catch (error) {
      console.error('Error al obtener datos:', error);
      res.status(500).send('Error al obtener datos');
    }
  });
  
  router.post('/api/tabla_empleados', async (req, res) => {
    let parametro  = req.body.b
    try {   
      const resultado = await pool.query(`SELECT id_empleado, nombre, apellido_p, apellido_m, id_departamento FROM public.empleado WHERE id_empleado = ${parametro}`);
      
      res.json(resultado.rows);
    } catch (error) {
      console.error('Error al obtener datos:', error);
      res.status(500).send('Error al obtener datos');
    }
  });
  
  router.post('/api/eliminar_empleados', async (req, res) => {
    let parametro  = req.body.b
    try {   
      const resultado = await pool.query(`DELETE FROM public.empleado WHERE id_empleado = ${parametro}`);
      
      res.status(201).json({
        message: 'Empleado eliminado exitosamente',
        usuario: resultado.rows[0], // Devuelve el usuario creado
      });
    } catch (error) {
      console.error('Error al obtener datos:', error);
      res.status(500).send('Error al obtener datos');
    }
  });
  
  // Ruta para dar de alta un nuevo usuario
  router.post('/api/actualiza_empleados', async (req, res) => {
    let { id_empleado, nombre, apellido_p, apellido_m, id_departamento } = req.body; 
    try {
      const resultado = await pool.query(
        `UPDATE public.empleado
      SET id_empleado=${id_empleado}, nombre='${nombre}', apellido_p='${apellido_p}', apellido_m='${apellido_m}', id_departamento=${id_departamento}
      WHERE id_empleado=${id_empleado};`);
  
      res.status(201).json({
        message: 'Usuario modificado exitosamente',
        usuario: resultado.rows[0], // Devuelve el usuario creado
      });
    } catch (error) {
      console.error('Error al crear usuario:', error);
      res.status(500).send('Error al crear usuario');
    }
  });
  
  // Ruta para dar de alta un nuevo usuario
  router.post('/api/alta_usuarios', async (req, res) => {
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
  /////////////////
  // 1. Listado de empleados y sus departamentos
  router.get('/api/empleados_departamentos', async (req, res) => {
    try {
      const resultado = await pool.query(`
        SELECT Empleado.nombre, Empleado.apellido_p, Empleado.apellido_m, Departamento.nombre_departamento
        FROM Empleado
        JOIN Departamento ON Empleado.id_departamento = Departamento.id_departamento
      `);
      res.json(resultado.rows);
    } catch (error) {
      console.error('Error al obtener empleados y departamentos:', error);
      res.status(500).send('Error al obtener empleados y departamentos');
    }
  });
  
  // 2. Tickets abiertos por cada usuario
  router.get('/api/tickets_por_usuario', async (req, res) => {
    try {
      const resultado = await pool.query(`
        SELECT Usuario.nickname, COUNT(Ticket.id_ticket) AS cantidad_tickets
        FROM Usuario
        JOIN Ticket ON Usuario.id_usuario = Ticket.id_usuario
        GROUP BY Usuario.nickname
      `);
      res.json(resultado.rows);
    } catch (error) {
      console.error('Error al obtener tickets por usuario:', error);
      res.status(500).send('Error al obtener tickets por usuario');
    }
  });
  
  // 3. Equipos que requieren mantenimiento (últimos 6 meses)
  router.get('/api/equipos_mantenimiento', async (req, res) => {
    try {
      const resultado = await pool.query(`
        SELECT id_equipo, caracteristica, fecha_ult_mantenimiento
        FROM Equipo
        WHERE fecha_ult_mantenimiento < CURRENT_DATE - INTERVAL '6 months'
      `);
      res.json(resultado.rows);
    } catch (error) {
      console.error('Error al obtener equipos que requieren mantenimiento:', error);
      res.status(500).send('Error al obtener equipos que requieren mantenimiento');
    }
  });
  
  // 4. Historial de cambios de estado para un ticket específico
  router.get('/api/historial_estado_ticket/', async (req, res) => {
    //const { id_ticket } = req.params;
    try {
      const resultado = await pool.query(`
        SELECT Estado.nombre_estado, Estado_Ticket.fecha_cambio, Estado_Ticket.comentario
        FROM Estado_Ticket
        JOIN Estado ON Estado_Ticket.id_estado = Estado.id_estado
        --WHERE Estado_Ticket.id_ticket = $1
        ORDER BY Estado_Ticket.fecha_cambio
      `)//, [id_ticket]);
      res.json(resultado.rows);
    } catch (error) {
      console.error('Error al obtener historial de estados del ticket:', error);
      res.status(500).send('Error al obtener historial de estados del ticket');
    }
  });
  
  // 5. Reporte de incidencias por tipo
  router.get('/api/incidencias_por_tipo', async (req, res) => {
    try {
      const resultado = await pool.query(`
        SELECT Tipo_Incidencia.nombre_tipo, COUNT(Ticket.id_ticket) AS cantidad_incidencias
        FROM Tipo_Incidencia
        JOIN Ticket ON Tipo_Incidencia.id_tipo_incidencia = Ticket.id_tipo_incidencia
        GROUP BY Tipo_Incidencia.nombre_tipo
      `);
      res.json(resultado.rows);
    } catch (error) {
      console.error('Error al obtener incidencias por tipo:', error);
      res.status(500).send('Error al obtener incidencias por tipo');
    }
  });
  
  // 6. Número de mantenimientos realizados por técnico
  router.get('/api/mantenimientos_por_tecnico', async (req, res) => {
    try {
      const resultado = await pool.query(`
        SELECT Tecnico.id_tecnico, Empleado.nombre, Empleado.apellido_p, COUNT(Mantenimiento.id_mantenimiento) AS cantidad_mantenimientos
        FROM Mantenimiento
        JOIN Tecnico ON Mantenimiento.id_tecnico = Tecnico.id_tecnico
        JOIN Empleado ON Tecnico.id_empleado = Empleado.id_empleado
        GROUP BY Tecnico.id_tecnico, Empleado.nombre, Empleado.apellido_p
      `);
      res.json(resultado.rows);
    } catch (error) {
      console.error('Error al obtener mantenimientos por técnico:', error);
      res.status(500).send('Error al obtener mantenimientos por técnico');
    }
  });
  
  // 7. Detalle de tickets y sus estados actuales
  router.get('/api/tickets_estados', async (req, res) => {
    try {
      const resultado = await pool.query(`
        SELECT Ticket.id_ticket, Usuario.nickname, Equipo.caracteristica, Estado.nombre_estado, Ticket.descripcion
        FROM Ticket
        JOIN Usuario ON Ticket.id_usuario = Usuario.id_usuario
        JOIN Equipo ON Ticket.id_equipo = Equipo.id_equipo
        JOIN Estado_Ticket ON Ticket.id_ticket = Estado_Ticket.id_ticket
        JOIN Estado ON Estado_Ticket.id_estado = Estado.id_estado
        WHERE Estado_Ticket.fecha_cambio = (
            SELECT MAX(fecha_cambio)
            FROM Estado_Ticket AS et
            WHERE et.id_ticket = Ticket.id_ticket
        )
      `);
      res.json(resultado.rows);
    } catch (error) {
      console.error('Error al obtener detalles de tickets y estados:', error);
      res.status(500).send('Error al obtener detalles de tickets y estados');
    }
  });
  
  // 8. Técnicos por especialidad
  router.get('/api/tecnicos_especialidad', async (req, res) => {
    try {
      const resultado = await pool.query(`
        SELECT especialidad, COUNT(id_tecnico) AS cantidad_tecnicos
        FROM Tecnico
        GROUP BY especialidad
      `);
      res.json(resultado.rows);
    } catch (error) {
      console.error('Error al obtener técnicos por especialidad:', error);
      res.status(500).send('Error al obtener técnicos por especialidad');
    }
  });
  
  // 9. Tickets creados en el último mes
  router.get('/api/tickets_ultimo_mes', async (req, res) => {
    try {
      const resultado = await pool.query(`
        SELECT id_ticket, id_usuario, id_equipo, id_tipo_incidencia, fecha_creacion, descripcion
        FROM Ticket
        WHERE fecha_creacion >= CURRENT_DATE - INTERVAL '1 month'
      `);
      res.json(resultado.rows);
    } catch (error) {
      console.error('Error al obtener tickets del último mes:', error);
      res.status(500).send('Error al obtener tickets del último mes');
    }
  });
  
  // 10. Detalles de usuarios con sus tipos
  router.get('/api/usuarios_tipos', async (req, res) => {
    try {
      const resultado = await pool.query(`
        SELECT Usuario.nickname, Empleado.nombre, Empleado.apellido_p, Tipo_Usuario.nombre_tipo
        FROM Usuario
        JOIN Empleado ON Usuario.id_empleado = Empleado.id_empleado
        JOIN Tipo_Usuario ON Usuario.id_tipo_usuario = Tipo_Usuario.id_tipo_usuario
      `);
      res.json(resultado.rows);
    } catch (error) {
      console.error('Error al obtener usuarios y tipos:', error);
      res.status(500).send('Error al obtener usuarios y tipos');
    }
  });

// POST route to get the maintenance report details
router.get('/api/reporte_mantenimiento/:id_equipo', async (req, res) => {
  const { id_equipo } = req.params; // Assuming the client sends the equipment ID to retrieve data
  console.log(id_equipo);
  try {
    // SQL query to retrieve the report data
    const query = `
      SELECT 
        E.nombre AS usuario_nombre,
        E.apellido_p AS usuario_apellido_paterno,
        E.apellido_m AS usuario_apellido_materno,
        D.nombre_departamento,
        EQ.id_equipo,
        EQ.caracteristica,
        M.fecha_mantenimiento,
        M.descripcion AS reporte_descripcion,
        TE.id_tecnico,
        TE.especialidad,
        ET.nombre AS tecnico_nombre,
        ET.apellido_p AS tecnico_apellido_paterno,
        ET.apellido_m AS tecnico_apellido_materno
      FROM 
        Empleado E
      JOIN 
        Departamento D ON E.id_departamento = D.id_departamento
      JOIN 
        Equipo EQ ON EQ.id_departamento = E.id_departamento
      JOIN 
        Mantenimiento M ON M.id_equipo = EQ.id_equipo
      JOIN 
        Tecnico TE ON M.id_tecnico = TE.id_tecnico
      JOIN 
        Empleado ET ON TE.id_empleado = ET.id_empleado
      WHERE 
        EQ.id_equipo = ${id_equipo}
      ORDER BY 
        M.fecha_mantenimiento DESC
      LIMIT 1; -- Get the most recent maintenance
    `;

    // Execute the query
    const resultado = await pool.query(query);

    // If no data is found
    if (resultado.rows.length === 0) {
      return res.status(404).json({ message: 'No data found for the given equipment ID' });
    }

    // Return the result
    res.json(resultado.rows[0]);

  } catch (error) {
    console.error('Error retrieving maintenance report data:', error);
    res.status(500).send('Error retrieving maintenance report data');
  }
});

export default router;
