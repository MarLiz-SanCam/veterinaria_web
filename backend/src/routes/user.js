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
            res.json(rows[0]); // Enviamos solo el usuario encontrado
        } else {
            res.status(404).json({ message: 'Usuario no encontrado' });
        }
    } catch (error) {
        console.log(error);
        res.status(500).json({ message: 'Error al obtener usuario' });
    }
});

// //Agrega un usuario usando el proceso almacenado en la base de datos

// route.post('/usuarios', (req, res) => {
//     const { nombre, apellido, correo, clave } = req.body;
//     const p_opcion = 1; // Opción para alta
//     const p_id_usuario = null; // NULL para alta

//     // Inicializar las variables de salida
//     conexionMsql.query('SET @valid = 0, @error = "", @fecha = NOW()', (err) => {
//         if (err) {
//             console.log(err);
//             return res.status(500).json({ message: 'Error al inicializar variables de salida' });
//         }

//         // Llamar al procedimiento almacenado
//         conexionMsql.query(
//             'CALL p_opcion(?, ?, ?, ?, ?, ?, @valid, @error, @fecha)',
//             [p_opcion, p_id_usuario, nombre, apellido, correo, clave],
//             (err) => {
//                 if (err) {
//                     console.log(err);
//                     return res.status(500).json({ message: 'Error al ejecutar el procedimiento' });
//                 }

//                 // Obtener resultados de salida
//                 conexionMsql.query('SELECT @valid AS valid, @error AS error, @fecha AS fecha', (error, results) => {
//                     if (error) {
//                         console.log(error);
//                         return res.status(500).json({ message: 'Error al obtener resultados' });
//                     }

//                     res.json({
//                         valid: results[0].valid,
//                         error: results[0].error,
//                         fecha: results[0].fecha,
//                     });
//                 });
//             }
//         );
//     });
// });
route.post('/usuarios', async (req, res) => {
    const { nombre, apellido, correo, clave } = req.body;
    let p_opcion = 1; // Opción para alta
    let p_id_usuario = null; // NULL para alta
    

    try {
        await req.dbConnection.query('SET @opcion = ?, @id_usuario = ?, @nombre = ?, @apellido = ?, @correo = ?, @clave = ?, @valid = 0, @error = "", @fecha = NOW()', 
            [p_opcion, p_id_usuario, nombre, apellido, correo, clave]);

        // Llamar al procedimiento almacenado
        await req.dbConnection.query(
            'CALL p_opcion(@opcion, @id_usuario, @nombre, @apellido, @correo, @clave, @valid, @error, @fecha)'
        );

        // Obtener resultados de salida
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


// //Iniciar sesión usanddo el proceso almacenado en la base de datos

// Iniciar sesión usando el procedimiento almacenado en la base de datos
route.post('/login', async (req, res) => {
    const { correo, clave } = req.body;

    try {
        // Establece todas las variables requeridas, tanto de entrada como de salida
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
        `, [correo, clave]);

        // Llama al procedimiento almacenado usando solo las variables de sesión de MySQL
        await req.dbConnection.query(
            'CALL p_opcion(@opcion, @id_usuario, @nombre, @apellido, @correo, @clave, @valid, @error, @fecha)'
        );

        // Obtén los valores de salida de las variables de sesión
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



// //Eliminar usuario usando el proceso almacenado en la base de datos

route.delete('/usuarios/:idusuario', async (req, res) => {
    const { idusuario } = req.params;
    const p_opcion = 2; // Opción para eliminar

    try {
        // Asignar valores a las variables de sesión para usarlas en el procedimiento almacenado
        await req.dbConnection.query(
            'SET @opcion = ?, @id_usuario = ?, @nombre = NULL, @apellido = NULL, @email = NULL, @password = NULL, @valid = 0, @error = "", @fecha = NOW()', 
            [p_opcion, idusuario]
        );

        // Llamar al procedimiento almacenado usando las variables de sesión
        await req.dbConnection.query(
            'CALL p_opcion(@opcion, @id_usuario, @nombre, @apellido, @email, @password, @valid, @error, @fecha)'
        );

        // Obtener los resultados de salida
        const [results] = await req.dbConnection.query('SELECT @valid AS valid, @error AS error, @fecha AS fecha');

        // Enviar la respuesta
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
// Endpoint para editar un usuario
route.put('/usuarios/:idusuario', async (req, res) => {
    const { idusuario } = req.params;
    const { nombre, apellido, email, password } = req.body;
    const p_opcion = 3; // Opción para editar usuario

    try {
        // Configuramos las variables de sesión
        await req.dbConnection.query(
            'SET @opcion = ?, @id_usuario = ?, @nombre = ?, @apellido = ?, @email = ?, @password = ?, @valid = 0, @error = "", @fecha = NOW()', 
            [p_opcion, idusuario, nombre, apellido, email, password]
        );

        // Ejecutamos el procedimiento almacenado
        await req.dbConnection.query(
            'CALL p_opcion(@opcion, @id_usuario, @nombre, @apellido, @email, @password, @valid, @error, @fecha)'
        );

        // Obtenemos los resultados de salida
        const [results] = await req.dbConnection.query('SELECT @valid AS valid, @error AS error, @fecha AS fecha');

        // Enviamos la respuesta
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

// route.put('/usuarios/:idusuario', (req, res) => {
//     const { idusuario } = req.params;
//     const { nombre, apellido, correo, clave } = req.body;
//     let valid = 0;
//     let error = '';
//     let fecha = new Date();

//     conexionMsql.query(
//         'CALL p_opcion(?, ?, ?, ?, ?, ?, @valid, @error, @fecha)',
//         [3, idusuario, nombre, apellido, correo, clave, valid, error, fecha],
//         (error) => {
//             if (!error) {
//                 conexionMsql.query('SELECT @valid AS valid, @error AS error', (error, results) => {
//                     res.json({
//                         valid: results[0].valid,
//                         error: results[0].error,
//                     });
//                 });
//             } else {
//                 console.log(error);
//                 res.status(500).json({ message: 'Error al editar usuario' });
//             }
//         }
//     );
// });

module.exports = route;