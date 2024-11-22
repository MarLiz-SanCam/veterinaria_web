const { Router } = require('express');
const route = Router();

// Obtener todos los propietarios
route.get('/propietarios', async (req, res) => {
    try {
        // Establecemos la opción de consulta de todos los propietarios
        await req.dbConnection.query(`
            SET @opcion = 5, @idPropietario = NULL, @nombre = NULL, @direccion = NULL, @telefono = NULL, 
                @valid = 0, @error = "";
        `);

        // Llamamos al procedimiento almacenado para obtener todos los propietarios
        const [rows] = await req.dbConnection.query('CALL abcc_propietarios(@opcion, @idPropietario, @nombre, @direccion, @telefono, @valid, @error)');
        res.json(rows[0]);
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Error al obtener los propietarios' });
    }
});

// Obtener un propietario por ID
route.get('/propietarios/:idPropietario', async (req, res) => {
  const { idPropietario } = req.params;
  try {
    // Consultamos el propietario por su ID
    const [rows] = await req.dbConnection.query('SELECT * FROM propietarios WHERE idPropietario = ?', [idPropietario]);
    if (rows.length > 0) {
      res.json(rows[0]);
    } else {
      res.status(404).json({ message: 'Propietario no encontrado' });
    }
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Error al obtener el propietario' });
  }
});

// Crear un nuevo propietario
route.post('/propietarios', async (req, res) => {
    const { nombre, direccion, telefono } = req.body;

    try {
        await req.dbConnection.query(`
            SET @opcion = 1, @idPropietario = NULL, @nombre = ?, @direccion = ?, @telefono = ?, 
                @valid = 0, @error = "";
        `, [nombre, direccion, telefono]);

        await req.dbConnection.query('CALL abcc_propietarios(@opcion, @idPropietario, @nombre, @direccion, @telefono, @valid, @error)');
        
        const [results] = await req.dbConnection.query('SELECT @valid AS valid, @error AS error');
        res.json(results[0]);
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Error al crear el propietario' });
    }
});

// Eliminar un propietario
route.delete('/propietarios/:idPropietario', async (req, res) => {
    const { idPropietario } = req.params;

    try {
        await req.dbConnection.query(`
            SET @opcion = 2, @idPropietario = ?, @nombre = NULL, @direccion = NULL, @telefono = NULL, 
                @valid = 0, @error = "";
        `, [idPropietario]);

        await req.dbConnection.query('CALL abcc_propietarios(@opcion, @idPropietario, @nombre, @direccion, @telefono, @valid, @error)');
        
        const [results] = await req.dbConnection.query('SELECT @valid AS valid, @error AS error');
        res.json(results[0]);
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Error al eliminar el propietario' });
    }
});

// Editar un propietario
route.put('/propietarios/:idPropietario', async (req, res) => {
    const { idPropietario } = req.params;
    const { nombre, direccion, telefono } = req.body;

    try {
        // Establecemos la opción de editar propietario
        await req.dbConnection.query(`
            SET @opcion = 3, @idPropietario = ?, @nombre = ?, @direccion = ?, @telefono = ?, 
                @valid = 0, @error = "";
        `, [idPropietario, nombre, direccion, telefono]);

        // Llamamos al procedimiento almacenado para editar el propietario
        await req.dbConnection.query('CALL abcc_propietarios(@opcion, @idPropietario, @nombre, @direccion, @telefono, @valid, @error)');
        
        // Obtenemos el resultado de la validación
        const [results] = await req.dbConnection.query('SELECT @valid AS valid, @error AS error');
        res.json(results[0]);
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Error al editar el propietario' });
    }
});

module.exports = route;
