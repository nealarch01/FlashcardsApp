import Database from "../models/database";


async function selectTest() {
    let qstr = `SELECT * FROM user WHERE id=${1};`;
    let result: any = await Database.query(qstr); // 

    console.log(result);
    process.exit(0);
}

async function deleteTest() {
    let qstr = `DELETE FROM user WHERE id=2`;
    let result: any = await Database.query(qstr);
    console.log(result);
    /* Result prints
    ResultSetHeader {
        fieldCount: 0,
        affectedRows: 1,
        insertId: 0,
        info: '',
        serverStatus: 2,
        warningStatus: 0
    } */
    process.exit(0);
}

deleteTest();




// export default queryTest;
