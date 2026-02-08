const cds = require('@sap/cds');
module.exports = cds.service.impl((srv) => {
	srv.before('CREATE', 'Employee', async(req)=>{
        console.log('Entered validation step...Please Wait!'); 
    })
});