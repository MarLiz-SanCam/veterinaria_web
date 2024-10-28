// routes/tratamientos.js
const express = require('express');
const router = express.Router();

// Obtener todos los tratamientos
router.get('/tratamientos', async (req, res) => {
  try {
    const [rows] = await req.dbConnection.query('SELECT * FROM tratamientos');
    res.json(rows);
  } catch (error) {
    console.error('Error al obtener tratamientos:', error);
    res.status(500).json({ error: 'Error al obtener tratamientos' });
  }
});

// Obtener un tratamiento por ID
router.get('/tratamientos/:id', async (req, res) => {
  const { id } = req.params;
  try {
    const [rows] = await req.dbConnection.query('SELECT * FROM tratamientos WHERE idTratamiento = ?', [id]);
    if (rows.length > 0) {
      res.json(rows[0]);
    } else {
      res.status(404).json({ error: 'Tratamiento no encontrado' });
    }
  } catch (error) {
    console.error('Error al obtener tratamiento:', error);
    res.status(500).json({ error: 'Error al obtener tratamiento' });
  }
});

// Crear un nuevo tratamiento
router.post('/tratamientos', async (req, res) => {
  const { nombre, descripcion, tipo, precio } = req.body;
  try {
    const [result] = await req.dbConnection.query(
      'INSERT INTO tratamientos (nombre, descripcion, tipo, precio) VALUES (?, ?, ?, ?)',
      [nombre, descripcion, tipo, precio]
    );
    res.json({ message: 'Tratamiento creado exitosamente', idTratamiento: result.insertId });
  } catch (error) {
    console.error('Error al crear tratamiento:', error);
    res.status(500).json({ error: 'Error al crear tratamiento' });
  }
});

// Actualizar un tratamiento existente
router.put('/tratamientos/:id', async (req, res) => {
  const { id } = req.params;
  const { nombre, descripcion, tipo, precio } = req.body;
  try {
    const [result] = await req.dbConnection.query(
      'UPDATE tratamientos SET nombre = ?, descripcion = ?, tipo = ?, precio = ? WHERE idTratamiento = ?',
      [nombre, descripcion, tipo, precio, id]
    );
    if (result.affectedRows > 0) {
      res.json({ message: 'Tratamiento actualizado exitosamente' });
    } else {
      res.status(404).json({ error: 'Tratamiento no encontrado' });
    }
  } catch (error) {
    console.error('Error al actualizar tratamiento:', error);
    res.status(500).json({ error: 'Error al actualizar tratamiento' });
  }
});

// Eliminar un tratamiento
router.delete('/tratamientos/:id', async (req, res) => {
  const { id } = req.params;
  try {
    const [result] = await req.dbConnection.query('DELETE FROM tratamientos WHERE idTratamiento = ?', [id]);
    if (result.affectedRows > 0) {
      res.json({ message: 'Tratamiento eliminado exitosamente' });
    } else {
      res.status(404).json({ error: 'Tratamiento no encontrado' });
    }
  } catch (error) {
    console.error('Error al eliminar tratamiento:', error);
    res.status(500).json({ error: 'Error al eliminar tratamiento' });
  }
});

module.exports = router;
