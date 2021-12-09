const express = require("express");
const orcldb = require("oracledb");
const dbconf = require("../config/config").dbconfig;

const router = express.Router();

router.get("/", async (req, res) => {
  const connection = await orcldb.getConnection(dbconf);

  let procedureResult = await connection.execute(
    `BEGIN 
       DB_ADMIN.ADMIN_AUTHORS_PKG.GET_AUTHORS(:ret);
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
      name: row[1],
    });
  }

  resultSet.close();
  res.json(resultArray);
});

router.post("/", async (req, res) => {
  const connection = await orcldb.getConnection(dbconf);

  let in_name;

  if (req.body.name === undefined) {
    throw new Error("Bad request");
  } else {
    in_name = req.body.name;
  }

  let procedureResult = await connection.execute(
    `BEGIN 
       DB_ADMIN.ADMIN_AUTHORS_PKG.ADD_AUTHORS(:name, :ret);
     END;`,
    {
      name: in_name,
      ret: { dir: orcldb.BIND_OUT, type: orcldb.NUMBER },
    }
  );

  let result = procedureResult.outBinds.ret;
  let responseBody;

  if (result >= 0) {
    responseBody = {
      id: result,
      name: in_name,
    };
  } else {
    responseBody = { status: "Failed" };
  }

  res.json(responseBody);
});

module.exports = router;
