const { Router } = require('express');
const route = Router();

// Obtener todas las citas
route.get('/citas', async (req, res) => {
    try {
        await req.dbConnection.query(`
            SET @opcion = 5, @idCita = NULL, @idMascota = NULL, @fecha = NULL, 
                @motivo = NULL, @diagnostico = NULL, @peso = NULL, @altura = NULL, 
                @largo = NULL, @pago_total = NULL, @valid = 0, @error = "";
        `);

        const [rows] = await req.dbConnection.query('CALL abcc_appointments(@opcion, @idCita, @idMascota, @fecha, @motivo, @diagnostico, @peso, @altura, @largo, @pago_total, @valid, @error)');
        res.json(rows[0]);
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Error al obtener las citas' });
    }
});

route.get('/citas/:idCita', async (req, res) => {
  const {idCita} = req.params;
  try{
    console.log('Buscando cita');
    const [rows] = await req.dbConnection.query('SELECT * FROM citas where idCita = ?', [idCita]);
    if(rows.length > 0){
      res.json(rows[0]);
    }else{
      res.status(404).json({message: 'Cita no encontrada'});
    }
  }catch(error){
    console.log(500).json({message: "error en el servidor al obtener la cita"});
  }
});

// Crear una nueva cita
route.post('/citas', async (req, res) => {
    const { idMascota, fecha, motivo, diagnostico, peso, altura, largo, pago_total } = req.body;

    try {
        await req.dbConnection.query(`
            SET @opcion = 1, @idCita = NULL, @idMascota = ?, @fecha = ?, 
                @motivo = ?, @diagnostico = ?, @peso = ?, @altura = ?, 
                @largo = ?, @pago_total = ?, @valid = 0, @error = "";
        `, [idMascota, fecha, motivo, diagnostico, peso, altura, largo, pago_total]);

        await req.dbConnection.query('CALL abcc_appointments(@opcion, @idCita, @idMascota, @fecha, @motivo, @diagnostico, @peso, @altura, @largo, @pago_total, @valid, @error)');
        const [results] = await req.dbConnection.query('SELECT @valid AS valid, @error AS error');
        res.json(results[0]);
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Error al crear la cita' });
    }
});

// Eliminar una cita
route.delete('/citas/:idCita', async (req, res) => {
    const { idCita } = req.params;

    try {
        await req.dbConnection.query(`
            SET @opcion = 2, @idCita = ?, @idMascota = NULL, @fecha = NULL, 
                @motivo = NULL, @diagnostico = NULL, @peso = NULL, @altura = NULL, 
                @largo = NULL, @pago_total = NULL, @valid = 0, @error = "";
        `, [idCita]);

        await req.dbConnection.query('CALL abcc_appointments(@opcion, @idCita, @idMascota, @fecha, @motivo, @diagnostico, @peso, @altura, @largo, @pago_total, @valid, @error)');
        const [results] = await req.dbConnection.query('SELECT @valid AS valid, @error AS error');
        res.json(results[0]);
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Error al eliminar la cita' });
    }
});

// Editar una cita
route.put('/citas/:idCita', async (req, res) => {
    const { idCita } = req.params;
    const { idMascota, fecha, motivo, diagnostico, peso, altura, largo, pago_total } = req.body;

    try {
        await req.dbConnection.query(`
            SET @opcion = 3, @idCita = ?, @idMascota = ?, @fecha = ?, 
                @motivo = ?, @diagnostico = ?, @peso = ?, @altura = ?, 
                @largo = ?, @pago_total = ?, @valid = 0, @error = "";
        `, [idCita, idMascota, fecha, motivo, diagnostico, peso, altura, largo, pago_total]);

        await req.dbConnection.query('CALL abcc_appointments(@opcion, @idCita, @idMascota, @fecha, @motivo, @diagnostico, @peso, @altura, @largo, @pago_total, @valid, @error)');
        const [results] = await req.dbConnection.query('SELECT @valid AS valid, @error AS error');
        res.json(results[0]);
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Error al editar la cita' });
    }
});


module.exports = route;
