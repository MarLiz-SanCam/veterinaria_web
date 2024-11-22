const { Router } = require('express');
const route = Router();

// Obtener todas las mascotas
route.get('/mascotas', async (req, res) => {
    try {
        await req.dbConnection.query(`
            SET @opcion = 5, @idMascota = NULL, @especimen = NULL, @raza = NULL, 
                @iddueño = NULL, @nombre = NULL, @nacimiento = NULL, @valid = 0, @error = "";
        `);

        const [rows] = await req.dbConnection.query('CALL abcc_mascotas(@opcion, @idMascota, @especimen, @raza, @iddueño, @nombre, @nacimiento, @valid, @error)');
        res.json(rows[0]);
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Error al obtener las mascotas' });
    }
});

// Obtener una mascota específica
route.get('/mascotas/:idMascota', async (req, res) => {
    const { idMascota } = req.params;
    try {
        console.log('Buscando mascota');
        const [rows] = await req.dbConnection.query('SELECT * FROM mascotas WHERE idMascota = ?', [idMascota]);
        if (rows.length > 0) {
            res.json(rows[0]);
        } else {
            res.status(404).json({ message: 'Mascota no encontrada' });
        }
    } catch (error) {
        console.log(error);
        res.status(500).json({ message: 'Error al obtener la mascota' });
    }
});

// Crear una nueva mascota
route.post('/mascotas', async (req, res) => {
    const { especimen, raza, iddueño, nombre, nacimiento } = req.body;

    try {
        await req.dbConnection.query(`
            SET @opcion = 1, @idMascota = NULL, @especimen = ?, @raza = ?, 
                @iddueño = ?, @nombre = ?, @nacimiento = ?, @valid = 0, @error = "";
        `, [especimen, raza, iddueño, nombre, nacimiento]);

        await req.dbConnection.query('CALL abcc_mascotas(@opcion, @idMascota, @especimen, @raza, @iddueño, @nombre, @nacimiento, @valid, @error)');
        const [results] = await req.dbConnection.query('SELECT @valid AS valid, @error AS error');
        res.json(results[0]);
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Error al crear la mascota' });
    }
});

// Eliminar una mascota
route.delete('/mascotas/:idMascota', async (req, res) => {
    const { idMascota } = req.params;

    try {
        await req.dbConnection.query(`
            SET @opcion = 2, @idMascota = ?, @especimen = NULL, @raza = NULL, 
                @iddueño = NULL, @nombre = NULL, @nacimiento = NULL, @valid = 0, @error = "";
        `, [idMascota]);

        await req.dbConnection.query('CALL abcc_mascotas(@opcion, @idMascota, @especimen, @raza, @iddueño, @nombre, @nacimiento, @valid, @error)');
        const [results] = await req.dbConnection.query('SELECT @valid AS valid, @error AS error');
        res.json(results[0]);
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Error al eliminar la mascota' });
    }
});

// Editar una mascota
route.put('/mascotas/:idMascota', async (req, res) => {
    const { idMascota } = req.params;
    const { especimen, raza, iddueño, nombre, nacimiento } = req.body;

    try {
        await req.dbConnection.query(`
            SET @opcion = 3, @idMascota = ?, @especimen = ?, @raza = ?, 
                @iddueño = ?, @nombre = ?, @nacimiento = ?, @valid = 0, @error = "";
        `, [idMascota, especimen, raza, iddueño, nombre, nacimiento]);

        await req.dbConnection.query('CALL abcc_mascotas(@opcion, @idMascota, @especimen, @raza, @iddueño, @nombre, @nacimiento, @valid, @error)');
        const [results] = await req.dbConnection.query('SELECT @valid AS valid, @error AS error');
        res.json(results[0]);
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Error al editar la mascota' });
    }
});

module.exports = route;
