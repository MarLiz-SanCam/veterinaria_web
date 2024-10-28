// routes/razas.js
const express = require('express');
const router = express.Router();

// Obtener todas las razas
router.get('/razas', async (req, res) => {
  try {
    const [rows] = await req.dbConnection.query('SELECT * FROM razas');
    res.json(rows);
  } catch (error) {
    console.error('Error al obtener las razas:', error);
    res.status(500).json({ error: 'Error al obtener las razas' });
  }
});

// Obtener una raza por ID
router.get('/razas/:id', async (req, res) => {
  const { id } = req.params;
  try {
    const [rows] = await req.dbConnection.query('SELECT * FROM razas WHERE idRaza = ?', [id]);
    if (rows.length > 0) {
      res.json(rows[0]);
    } else {
      res.status(404).json({ error: 'Raza no encontrada' });
    }
  } catch (error) {
    console.error('Error al obtener la raza:', error);
    res.status(500).json({ error: 'Error al obtener la raza' });
  }
});

// Crear una nueva raza
router.post('/razas', async (req, res) => {
  const { idRaza, especie } = req.body;
  try {
    const [result] = await req.dbConnection.query(
      'INSERT INTO razas (idRaza, especie) VALUES (?, ?)',
      [idRaza, especie]
    );
    res.json({ message: 'Raza creada exitosamente', idRaza: result.insertId });
  } catch (error) {
    console.error('Error al crear la raza:', error);
    res.status(500).json({ error: 'Error al crear la raza' });
  }
});

// Actualizar una raza existente
router.put('/razas/:id', async (req, res) => {
  const { id } = req.params;
  const { especie } = req.body;
  try {
    const [result] = await req.dbConnection.query(
      'UPDATE razas SET especie = ? WHERE idRaza = ?',
      [especie, id]
    );
    if (result.affectedRows > 0) {
      res.json({ message: 'Raza actualizada exitosamente' });
    } else {
      res.status(404).json({ error: 'Raza no encontrada' });
    }
  } catch (error) {
    console.error('Error al actualizar la raza:', error);
    res.status(500).json({ error: 'Error al actualizar la raza' });
  }
});

// Eliminar una raza
router.delete('/razas/:id', async (req, res) => {
  const { id } = req.params;
  try {
    const [result] = await req.dbConnection.query('DELETE FROM razas WHERE idRaza = ?', [id]);
    if (result.affectedRows > 0) {
      res.json({ message: 'Raza eliminada exitosamente' });
    } else {
      res.status(404).json({ error: 'Raza no encontrada' });
    }
  } catch (error) {
    console.error('Error al eliminar la raza:', error);
    res.status(500).json({ error: 'Error al eliminar la raza' });
  }
});

module.exports = router;
