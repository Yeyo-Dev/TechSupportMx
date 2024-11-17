import pkg from 'pg';
const { Pool } = pkg;

// Configuración de la base de datos
export const pool = new Pool({
  user: 'postgres',
  host: 'localhost',
  database: 'TechSupportMx',
  password: 'Hola Mundo',
  port: 5432,
});
