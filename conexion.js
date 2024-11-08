const { Pool } = require('pg');

// Configuración de la base de datos
const pool = new Pool({
  user: 'postgres',
  host: 'localhost',
  database: 'TechSupportMx',
  password: 'Hola Mundo',
  port: 5432,
});

// Exportamos pool para usarlo en otras partes de la aplicación
module.exports = pool;
