const express = require('express');
const cors = require('cors');
const app = express();
const conexionMsql = require('./database/database');

//Configuración
app.set('port', process.env.PORT || 8000);

//Middlewares
app.use(express.json());
app.use(cors());


//Iniciar conexión a la base de datos
let dbConnection;
conexionMsql().then(connection => {
    dbConnection = connection;
}).catch(err => {
    console.error(err);
    process.exit(1); // Salir si no se puede conectar
});


//Rutas 
app.use((req, res, next) => {
    req.dbConnection = dbConnection;
    next();
});
app.use(require('./routes/user'));

//Iniciar servidor
app.listen(app.get('port'), () => {
    console.log('Servidor en el puerto', app.get('port'));
});