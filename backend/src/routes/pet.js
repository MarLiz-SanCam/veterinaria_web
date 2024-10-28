// routes/mascotas.js
const express = require('express');
const router = express.Router();

// Obtener todas las mascotas
router.get('/mascotas', async (req, res) => {
  try {
    const [rows] = await req.dbConnection.query('SELECT * FROM mascotas');
    res.json(rows);
  } catch (error) {
    console.error('Error al obtener las mascotas:', error);
    res.status(500).json({ error: 'Error al obtener las mascotas' });
  }
});

// Obtener una mascota por ID
router.get('/mascotas/:id', async (req, res) => {
  const { id } = req.params;
  try {
    const [rows] = await req.dbConnection.query('SELECT * FROM mascotas WHERE idMascota = ?', [id]);
    if (rows.length > 0) {
      res.json(rows[0]);
    } else {
      res.status(404).json({ error: 'Mascota no encontrada' });
    }
  } catch (error) {
    console.error('Error al obtener la mascota:', error);
    res.status(500).json({ error: 'Error al obtener la mascota' });
  }
});

// Crear una nueva mascota
router.post('/mascotas', async (req, res) => {
  const { especimen, raza, iddueño, nombre, nacimiento } = req.body;
  try {
    const [result] = await req.dbConnection.query(
      'INSERT INTO mascotas (especimen, raza, iddueño, nombre, nacimiento) VALUES (?, ?, ?, ?, ?)',
      [especimen, raza, iddueño, nombre, nacimiento]
    );
    res.json({ message: 'Mascota creada exitosamente', idMascota: result.insertId });
  } catch (error) {
    console.error('Error al crear la mascota:', error);
    res.status(500).json({ error: 'Error al crear la mascota' });
  }
});

// Actualizar una mascota existente
router.put('/mascotas/:id', async (req, res) => {
  const { id } = req.params;
  const { especimen, raza, iddueño, nombre, nacimiento } = req.body;
  try {
    const [result] = await req.dbConnection.query(
      'UPDATE mascotas SET especimen = ?, raza = ?, iddueño = ?, nombre = ?, nacimiento = ? WHERE idMascota = ?',
      [especimen, raza, iddueño, nombre, nacimiento, id]
    );
    if (result.affectedRows > 0) {
      res.json({ message: 'Mascota actualizada exitosamente' });
    } else {
      res.status(404).json({ error: 'Mascota no encontrada' });
    }
  } catch (error) {
    console.error('Error al actualizar la mascota:', error);
    res.status(500).json({ error: 'Error al actualizar la mascota' });
  }
});

// Eliminar una mascota
router.delete('/mascotas/:id', async (req, res) => {
  const { id } = req.params;
  try {
    const [result] = await req.dbConnection.query('DELETE FROM mascotas WHERE idMascota = ?', [id]);
    if (result.affectedRows > 0) {
      res.json({ message: 'Mascota eliminada exitosamente' });
    } else {
      res.status(404).json({ error: 'Mascota no encontrada' });
    }
  } catch (error) {
    console.error('Error al eliminar la mascota:', error);
    res.status(500).json({ error: 'Error al eliminar la mascota' });
  }
});

module.exports = router;
