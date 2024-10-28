// routes/especies.js
const express = require('express');
const router = express.Router();

// Obtener todas las especies
router.get('/especies', async (req, res) => {
  try {
    const [rows] = await req.dbConnection.query('SELECT * FROM especies');
    res.json(rows);
  } catch (error) {
    console.error('Error al obtener especies:', error);
    res.status(500).json({ error: 'Error al obtener especies' });
  }
});

// Obtener una especie por ID
router.get('/especies/:id', async (req, res) => {
  const { id } = req.params;
  try {
    const [rows] = await req.dbConnection.query('SELECT * FROM especies WHERE idEspecie = ?', [id]);
    if (rows.length > 0) {
      res.json(rows[0]);
    } else {
      res.status(404).json({ error: 'Especie no encontrada' });
    }
  } catch (error) {
    console.error('Error al obtener especie:', error);
    res.status(500).json({ error: 'Error al obtener especie' });
  }
});

// Crear una nueva especie
router.post('/especies', async (req, res) => {
  const { idEspecie, Nombre } = req.body;
  try {
    const [result] = await req.dbConnection.query(
      'INSERT INTO especies (idEspecie, Nombre) VALUES (?, ?)',
      [idEspecie, Nombre]
    );
    res.json({ message: 'Especie creada exitosamente', idEspecie: result.insertId });
  } catch (error) {
    console.error('Error al crear especie:', error);
    res.status(500).json({ error: 'Error al crear especie' });
  }
});

// Actualizar una especie existente
router.put('/especies/:id', async (req, res) => {
  const { id } = req.params;
  const { Nombre } = req.body;
  try {
    const [result] = await req.dbConnection.query(
      'UPDATE especies SET Nombre = ? WHERE idEspecie = ?',
      [Nombre, id]
    );
    if (result.affectedRows > 0) {
      res.json({ message: 'Especie actualizada exitosamente' });
    } else {
      res.status(404).json({ error: 'Especie no encontrada' });
    }
  } catch (error) {
    console.error('Error al actualizar especie:', error);
    res.status(500).json({ error: 'Error al actualizar especie' });
  }
});

// Eliminar una especie
router.delete('/especies/:id', async (req, res) => {
  const { id } = req.params;
  try {
    const [result] = await req.dbConnection.query('DELETE FROM especies WHERE idEspecie = ?', [id]);
    if (result.affectedRows > 0) {
      res.json({ message: 'Especie eliminada exitosamente' });
    } else {
      res.status(404).json({ error: 'Especie no encontrada' });
    }
  } catch (error) {
    console.error('Error al eliminar especie:', error);
    res.status(500).json({ error: 'Error al eliminar especie' });
  }
});

module.exports = router;
