const express = require("express");
const orcldb = require("oracledb");
const dbconf = require("../config/config").dbconfig;

const router = express.Router();

router.get("/", async (req, res) => {
  const connection = await orcldb.getConnection(dbconf);

  let procedureResult = await connection.execute(
    `BEGIN 
       DB_ADMIN.GET_GENRES(:ret);
     END;`,
    {
      ret: { dir: orcldb.BIND_OUT, type: orcldb.CURSOR },
    }
  );

  let resultSet = procedureResult.outBinds.ret;
  let resultArray = [];
  let row;
  while ((row = await resultSet.getRow())) {
    resultArray.push({
      id: row[0],
      genre: row[1],
    });
  }

  resultSet.close();
  res.json(resultArray);
});

module.exports = router;
