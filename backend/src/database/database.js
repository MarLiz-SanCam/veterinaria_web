const mysql2 = require('mysql2/promise');

//const conexionMsql = mysql2.createConnection({
//    host: 'localhost', 
//    user: 'root',
//    password: 'root',
//    database: 'veterinaria'
//});

const conexionMsql = async () => {
    try{
        const connection = await mysql2.createConnection({
            host: 'localhost',
            user: 'root',
            password: 'root',
            database: 'veterinaria'
        });
        console.log('Base de datos conectada');
        return connection;
    }
    catch(error){
        console.error('Error de conexión a la base de datos', error);
        throw error;
    }
}

//conexionMsql.connect(function(error){
//    if(error){
//        console.log(error)
//        return;
//    }else{
//        console.log('Base de datos conectada');
//    }
//});

module.exports = conexionMsql;
