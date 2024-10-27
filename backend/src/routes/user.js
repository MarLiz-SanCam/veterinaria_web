const {Router} = require('express');
const conexionMsql = require('../database/database');
const route = Router();

route.get('/', (req, res) => {
    res.status(200).json({message: 'Server on port 8000 and database is connected :)'});
});


//Devuelve todos los usuarios
route.get('/usuarios', async (req, res) => {
    try {
        const [rows] = await req.dbConnection.query('SELECT * FROM usuarios');
        res.json(rows);
    } catch (error) {
        console.log(error);
        res.status(500).json({ message: 'Error al obtener usuarios' });
    }
});

//Devuelve un usuario específico según su id
route.get('/usuarios/:idusuario', async (req, res) => {
    const { idusuario } = req.params;
    try {
        console.log('buscando usuario: ${idusuario}');
        const [rows] = await req.dbConnection.query('SELECT * FROM usuarios WHERE idusuario = ?', [idusuario]);
        if (rows.length > 0) {
            res.json(rows[0]); 
        } else {
            res.status(404).json({ message: 'Usuario no encontrado' });
        }
    } catch (error) {
        console.log(error);
        res.status(500).json({ message: 'Error al obtener usuario' });
    }
});

//Crear un usuario usando el procedimiento almacenado en la base de datos
route.post('/usuarios', async (req, res) => {
    const { nombre, apellido, correo, clave } = req.body;
    let p_opcion = 1; 
    let p_id_usuario = null; 

    try {
        await req.dbConnection.query('SET @opcion = ?, @id_usuario = ?, @nombre = ?, @apellido = ?, @correo = ?, @clave = ?, @valid = 0, @error = "", @fecha = NOW()', 
            [p_opcion, p_id_usuario, nombre, apellido, correo, clave]
        );

        await req.dbConnection.query(
            'CALL p_opcion(@opcion, @id_usuario, @nombre, @apellido, @correo, @clave, @valid, @error, @fecha)'
        );

        const [results] = await req.dbConnection.query('SELECT @valid AS valid, @error AS error, @fecha AS fecha');
        res.json({
            valid: results[0].valid,
            error: results[0].error,
            fecha: results[0].fecha,
        });

    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Error al ejecutar el procedimiento' });
    }
});

// Iniciar sesión usando el procedimiento almacenado en la base de datos
route.post('/login', async (req, res) => {
    const { correo, clave } = req.body;

    try {
        await req.dbConnection.query(`
            SET @opcion = 5, 
                @id_usuario = NULL, 
                @nombre = NULL, 
                @apellido = NULL, 
                @correo = ?, 
                @clave = ?, 
                @valid = 0, 
                @error = "", 
                @fecha = NOW();
            `, [correo, clave]
        );

        await req.dbConnection.query(
            'CALL p_opcion(@opcion, @id_usuario, @nombre, @apellido, @correo, @clave, @valid, @error, @fecha)'
        );

        const [results] = await req.dbConnection.query(
            'SELECT @valid AS valid, @error AS error, @fecha AS fecha, @id_usuario AS idusuario'
        );

        res.json({
            valid: results[0].valid,
            error: results[0].error,
            fecha: results[0].fecha,
            idusuario: results[0].idusuario,
        });

    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Error en validación de login' });
    }
});



//Eliminar usuario usando el proceso almacenado en la base de datos
route.delete('/usuarios/:idusuario', async (req, res) => {
    const { idusuario } = req.params;
    const p_opcion = 2; 

    try {
        await req.dbConnection.query(
            'SET @opcion = ?, @id_usuario = ?, @nombre = NULL, @apellido = NULL, @email = NULL, @password = NULL, @valid = 0, @error = "", @fecha = NOW()', 
            [p_opcion, idusuario]
        );

        await req.dbConnection.query(
            'CALL p_opcion(@opcion, @id_usuario, @nombre, @apellido, @email, @password, @valid, @error, @fecha)'
        );

        const [results] = await req.dbConnection.query('SELECT @valid AS valid, @error AS error, @fecha AS fecha');

        res.json({
            valid: results[0].valid,
            error: results[0].error,
            fecha: results[0].fecha,
        });

    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Error al eliminar usuario' });
    }
});


// //Actualizar usuario usando el proceso almacenado en la base de datos
route.put('/usuarios/:idusuario', async (req, res) => {
    const { idusuario } = req.params;
    const { nombre, apellido, correo, clave } = req.body;
    const p_opcion = 3; 

    try {
        await req.dbConnection.query(
            'SET @opcion = ?, @id_usuario = ?, @nombre = ?, @apellido = ?, @correo = ?, @clave = ?, @valid = 0, @error = "", @fecha = NOW()', 
            [p_opcion, idusuario, nombre, apellido, correo, clave]
        );

        await req.dbConnection.query(
            'CALL p_opcion(@opcion, @id_usuario, @nombre, @apellido, @correo, @clave, @valid, @error, @fecha)'
        );

        const [results] = await req.dbConnection.query('SELECT @valid AS valid, @error AS error, @fecha AS fecha');
        res.json({
            valid: results[0].valid,
            error: results[0].error,
            fecha: results[0].fecha,
        });

    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Error al editar usuario' });
    }
});

module.exports = route;