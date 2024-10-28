// routes/citas.js
const express = require('express');
const router = express.Router();

// Obtener todas las citas
router.get('/citas', async (req, res) => {
  try {
    const [rows] = await req.dbConnection.query('SELECT * FROM citas');
    res.json(rows);
  } catch (error) {
    console.error('Error al obtener las citas:', error);
    res.status(500).json({ error: 'Error al obtener las citas' });
  }
});

// Obtener una cita por ID
router.get('/citas/:id', async (req, res) => {
  const { id } = req.params;
  try {
    const [rows] = await req.dbConnection.query('SELECT * FROM citas WHERE idCita = ?', [id]);
    if (rows.length > 0) {
      res.json(rows[0]);
    } else {
      res.status(404).json({ error: 'Cita no encontrada' });
    }
  } catch (error) {
    console.error('Error al obtener la cita:', error);
    res.status(500).json({ error: 'Error al obtener la cita' });
  }
});

// Crear una nueva cita
router.post('/citas', async (req, res) => {
  const { idMascota, fecha, motivo, diagnostico, peso, altura, largo, pago_total } = req.body;
  try {
    const [result] = await req.dbConnection.query(
      'INSERT INTO citas (idMascota, fecha, motivo, diagnostico, peso, altura, largo, pago_total) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
      [idMascota, fecha, motivo, diagnostico, peso, altura, largo, pago_total]
    );
    res.json({ message: 'Cita creada exitosamente', idCita: result.insertId });
  } catch (error) {
    console.error('Error al crear la cita:', error);
    res.status(500).json({ error: 'Error al crear la cita' });
  }
});

// Actualizar una cita existente
router.put('/citas/:id', async (req, res) => {
  const { id } = req.params;
  const { idMascota, fecha, motivo, diagnostico, peso, altura, largo, pago_total } = req.body;
  try {
    const [result] = await req.dbConnection.query(
      'UPDATE citas SET idMascota = ?, fecha = ?, motivo = ?, diagnostico = ?, peso = ?, altura = ?, largo = ?, pago_total = ? WHERE idCita = ?',
      [idMascota, fecha, motivo, diagnostico, peso, altura, largo, pago_total, id]
    );
    if (result.affectedRows > 0) {
      res.json({ message: 'Cita actualizada exitosamente' });
    } else {
      res.status(404).json({ error: 'Cita no encontrada' });
    }
  } catch (error) {
    console.error('Error al actualizar la cita:', error);
    res.status(500).json({ error: 'Error al actualizar la cita' });
  }
});

// Eliminar una cita
router.delete('/citas/:id', async (req, res) => {
  const { id } = req.params;
  try {
    const [result] = await req.dbConnection.query('DELETE FROM citas WHERE idCita = ?', [id]);
    if (result.affectedRows > 0) {
      res.json({ message: 'Cita eliminada exitosamente' });
    } else {
      res.status(404).json({ error: 'Cita no encontrada' });
    }
  } catch (error) {
    console.error('Error al eliminar la cita:', error);
    res.status(500).json({ error: 'Error al eliminar la cita' });
  }
});

module.exports = router;
