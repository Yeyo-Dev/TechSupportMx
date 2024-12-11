import dotenv from 'dotenv';
dotenv.config();

export const {
    PORT = 3000 // Valor predeterminado si no está definido en .env
} = process.env;
