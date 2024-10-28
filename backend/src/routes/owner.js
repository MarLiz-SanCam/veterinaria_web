// routes/propietarios.js
const express = require('express');
const router = express.Router();

// Obtener todos los propietarios
router.get('/propietarios', async (req, res) => {
  try {
    const [rows] = await req.dbConnection.query('SELECT * FROM propietarios');
    res.json(rows);
  } catch (error) {
    console.error('Error al obtener los propietarios:', error);
    res.status(500).json({ error: 'Error al obtener los propietarios' });
  }
});

// Obtener un propietario por ID
router.get('/propietarios/:id', async (req, res) => {
  const { id } = req.params;
  try {
    const [rows] = await req.dbConnection.query('SELECT * FROM propietarios WHERE idPropietario = ?', [id]);
    if (rows.length > 0) {
      res.json(rows[0]);
    } else {
      res.status(404).json({ error: 'Propietario no encontrado' });
    }
  } catch (error) {
    console.error('Error al obtener el propietario:', error);
    res.status(500).json({ error: 'Error al obtener el propietario' });
  }
});

// Crear un nuevo propietario
router.post('/propietarios', async (req, res) => {
  const { nombre, direccion, telefono } = req.body;
  try {
    const [result] = await req.dbConnection.query(
      'INSERT INTO propietarios (nombre, direccion, telefono) VALUES (?, ?, ?)',
      [nombre, direccion, telefono]
    );
    res.json({ message: 'Propietario creado exitosamente', idPropietario: result.insertId });
  } catch (error) {
    console.error('Error al crear el propietario:', error);
    res.status(500).json({ error: 'Error al crear el propietario' });
  }
});

// Actualizar un propietario existente
router.put('/propietarios/:id', async (req, res) => {
  const { id } = req.params;
  const { nombre, direccion, telefono } = req.body;
  try {
    const [result] = await req.dbConnection.query(
      'UPDATE propietarios SET nombre = ?, direccion = ?, telefono = ? WHERE idPropietario = ?',
      [nombre, direccion, telefono, id]
    );
    if (result.affectedRows > 0) {
      res.json({ message: 'Propietario actualizado exitosamente' });
    } else {
      res.status(404).json({ error: 'Propietario no encontrado' });
    }
  } catch (error) {
    console.error('Error al actualizar el propietario:', error);
    res.status(500).json({ error: 'Error al actualizar el propietario' });
  }
});

// Eliminar un propietario
router.delete('/propietarios/:id', async (req, res) => {
  const { id } = req.params;
  try {
    const [result] = await req.dbConnection.query('DELETE FROM propietarios WHERE idPropietario = ?', [id]);
    if (result.affectedRows > 0) {
      res.json({ message: 'Propietario eliminado exitosamente' });
    } else {
      res.status(404).json({ error: 'Propietario no encontrado' });
    }
  } catch (error) {
    console.error('Error al eliminar el propietario:', error);
    res.status(500).json({ error: 'Error al eliminar el propietario' });
  }
});

module.exports = router;
