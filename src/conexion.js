import pkg from 'pg';
import dotenv from 'dotenv';
dotenv.config();

const { Pool } = pkg;

// Configuración de la base de datos usando variables de entorno

// Usa la variable DATABASE_URL del entorno
/*export const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
});
*/
export const pool = new Pool({
  user: process.env.DB_USER,
  host: process.env.DB_HOST,
  database: process.env.DB_NAME,
  password: process.env.DB_PASSWORD,
  port: process.env.DB_PORT,
});


export default pool;

