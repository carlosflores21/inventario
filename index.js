const express = require('express');
const app = express();
const PORT = 3000;

app.use(express.json());

// Datos
let inventario = [
  { id: 1, nombre: 'Cuaderno', cantidad: 20, precio: 2.5 },
  { id: 2, nombre: 'Lapicero', cantidad: 50, precio: 0.5 },
];

// Rutas de la API
app.get('/productos', (req, res) => {
  res.json(inventario);
});

app.listen(PORT, '0.0.0.0', () => {
    console.log(`Servidor corriendo en http://0.0.0.0:${PORT}`);
});